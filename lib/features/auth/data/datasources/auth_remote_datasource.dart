import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/config/supabase_config.dart';
import '../../../../core/errors/auth_error_code.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/supabase_exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  Stream<UserModel?> authStateChanges();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> verifyEmail();

  Future<bool> isCurrentUserEmailVerified();

  Future<void> signOut();
}

final class SupabaseAuthRemoteDatasource implements AuthRemoteDatasource {
  SupabaseAuthRemoteDatasource({
    required supabase.SupabaseClient? supabaseClient,
    required NetworkInfo networkInfo,
    required GoogleSignIn googleSignIn,
  })  : _supabaseClient = supabaseClient,
        _networkInfo = networkInfo,
        _googleSignIn = googleSignIn;

  final supabase.SupabaseClient? _supabaseClient;
  final NetworkInfo _networkInfo;
  final GoogleSignIn _googleSignIn;

  static const List<String> _roleCandidates = ['customer', 'user'];

  String? _pendingVerificationEmail;
  String? _pendingVerificationName;
  String? _pendingVerificationPhoneNumber;
  Future<void>? _googleSignInInitialization;

  @override
  Stream<UserModel?> authStateChanges() {
    final client = _supabaseClient;
    if (client == null) {
      return Stream<UserModel?>.value(null);
    }

    return client.auth.onAuthStateChange.map((state) {
      final user = state.session?.user ?? client.auth.currentUser;
      return user == null ? null : UserModel.fromSupabaseUser(user);
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _supabaseClient?.auth.currentUser;
    return user == null ? null : UserModel.fromSupabaseUser(user);
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      await _ensureNetworkConnected();
      final client = _requireSupabaseClient();
      final response = await client.auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );
      final model = _modelFromSupabaseUser(response.user);

      await _upsertUserProfile(model);

      return model;
    } on supabase.AuthException catch (exception, stackTrace) {
      if (_isEmailNotConfirmed(exception)) {
        _setPendingVerificationEmail(email: normalizedEmail);
        return UserModel.pendingEmailVerification(email: normalizedEmail);
      }

      throw SupabaseExceptionMapper.fromAuthException(exception, stackTrace);
    } on supabase.PostgrestException catch (exception, stackTrace) {
      await _signOutAfterProfileSyncFailure();
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedName = name.trim();
    final normalizedPhoneNumber = phoneNumber.trim();

    try {
      await _ensureNetworkConnected();
      final client = _requireSupabaseClient();
      final response = await client.auth.signUp(
        email: normalizedEmail,
        password: password,
        emailRedirectTo: SupabaseConfig.authRedirectUrl,
        data: <String, dynamic>{
          'full_name': normalizedName,
          'phone_number': normalizedPhoneNumber,
        },
      );
      final model = _modelFromSupabaseUser(
        response.user,
        nameOverride: normalizedName,
        phoneNumberOverride: normalizedPhoneNumber,
      );

      _setPendingVerificationEmail(
        email: normalizedEmail,
        name: normalizedName,
        phoneNumber: normalizedPhoneNumber,
      );

      try {
        await _upsertUserProfile(model);
      } on Object {
        await _signOutAfterProfileSyncFailure();
        rethrow;
      }

      return model;
    } on supabase.AuthException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.fromAuthException(exception, stackTrace);
    } on supabase.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await _ensureNetworkConnected();
      await _ensureGoogleSignInInitialized();

      if (!_googleSignIn.supportsAuthenticate()) {
        throw const AuthException(
          errorCode: AuthErrorCode.operationNotAllowed,
          authCode: 'operation-not-allowed',
          debugMessage:
              'Interactive Google sign-in is not supported on this platform.',
        );
      }

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthException(
          errorCode: AuthErrorCode.invalidCredential,
          authCode: 'invalid-credential',
          debugMessage: 'Google sign-in did not return an idToken.',
        );
      }

      final client = _requireSupabaseClient();
      final response = await client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: idToken,
      );
      final model = _modelFromSupabaseUser(response.user);

      try {
        await _upsertUserProfile(model);
      } on Object {
        await _signOutAfterProfileSyncFailure(includeGoogle: true);
        rethrow;
      }

      return model;
    } on supabase.AuthException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.fromAuthException(exception, stackTrace);
    } on supabase.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    } on GoogleSignInException catch (exception, stackTrace) {
      throw AuthException(
        errorCode: _mapGoogleSignInError(exception),
        authCode: exception.code.name,
        debugMessage: exception.description,
        cause: exception,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _ensureNetworkConnected();
      await _requireSupabaseClient().auth.resetPasswordForEmail(
            email.trim().toLowerCase(),
            redirectTo: SupabaseConfig.passwordRecoveryRedirectUrl,
          );
    } on supabase.AuthException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.fromAuthException(exception, stackTrace);
    }
  }

  @override
  Future<void> verifyEmail() async {
    try {
      await _ensureNetworkConnected();
      final email = _verificationEmail;

      if (email == null) {
        throw const AuthException(
          errorCode: AuthErrorCode.missingEmail,
          authCode: 'missing-email',
        );
      }

      await _requireSupabaseClient().auth.resend(
            email: email,
            type: supabase.OtpType.signup,
            emailRedirectTo: SupabaseConfig.authRedirectUrl,
          );
    } on supabase.AuthException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.fromAuthException(exception, stackTrace);
    }
  }

  @override
  Future<bool> isCurrentUserEmailVerified() async {
    try {
      await _ensureNetworkConnected();
      final client = _requireSupabaseClient();

      if (client.auth.currentSession == null) {
        return false;
      }

      final response = await client.auth.getUser();
      final user = response.user;

      if (user == null) {
        return false;
      }

      final model = UserModel.fromSupabaseUser(
        user,
        nameOverride: _pendingVerificationName,
        phoneNumberOverride: _pendingVerificationPhoneNumber,
      );
      final isVerified = model.emailVerified;

      if (isVerified) {
        await _upsertUserProfile(model);
        _clearPendingVerificationEmail();
      }

      return isVerified;
    } on supabase.AuthException catch (exception, stackTrace) {
      if (exception is supabase.AuthSessionMissingException) {
        return false;
      }

      throw SupabaseExceptionMapper.fromAuthException(exception, stackTrace);
    } on supabase.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final client = _supabaseClient;
      if (client != null) {
        await client.auth.signOut();
      }
      await _ensureGoogleSignInInitialized();
      await _googleSignIn.signOut();
      _clearPendingVerificationEmail();
    } on supabase.AuthException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.fromAuthException(exception, stackTrace);
    } on GoogleSignInException catch (exception, stackTrace) {
      throw AuthException(
        errorCode: _mapGoogleSignInError(exception),
        authCode: exception.code.name,
        debugMessage: exception.description,
        cause: exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= _googleSignIn.initialize();
  }

  supabase.SupabaseClient _requireSupabaseClient() {
    final client = _supabaseClient;
    if (client != null) {
      return client;
    }

    throw const AuthException(
      errorCode: AuthErrorCode.profileSyncUnavailable,
      authCode: 'supabase-not-configured',
      debugMessage: 'Supabase is not configured.',
    );
  }

  UserModel _modelFromSupabaseUser(
    supabase.User? user, {
    String? nameOverride,
    String? phoneNumberOverride,
  }) {
    if (user == null) {
      throw const AuthException(errorCode: AuthErrorCode.unknown);
    }

    return UserModel.fromSupabaseUser(
      user,
      nameOverride: nameOverride,
      phoneNumberOverride: phoneNumberOverride,
    );
  }

  Future<void> _ensureNetworkConnected() async {
    if (await _networkInfo.isConnected) {
      return;
    }

    throw const AuthException(
      errorCode: AuthErrorCode.networkRequestFailed,
      authCode: 'network-request-failed',
      debugMessage: 'No internet connection is available.',
    );
  }

  Future<void> _upsertUserProfile(UserModel model) async {
    final client = _requireSupabaseClient();
    await _upsertUserPayload(client, model.toSupabaseProfile());
  }

  Future<void> _upsertUserPayload(
    supabase.SupabaseClient supabaseClient,
    Map<String, dynamic> payload,
  ) async {
    supabase.PostgrestException? invalidRoleException;

    for (final role in _roleCandidates) {
      try {
        await supabaseClient.from('users').upsert({
          ...payload,
          'role': role,
        }, onConflict: 'id');
        return;
      } on supabase.PostgrestException catch (exception) {
        if (!SupabaseExceptionMapper.isInvalidRole(exception)) {
          rethrow;
        }

        invalidRoleException = exception;
      }
    }

    try {
      await supabaseClient.from('users').upsert(payload, onConflict: 'id');
    } on supabase.PostgrestException catch (exception) {
      if (invalidRoleException != null &&
          SupabaseExceptionMapper.isMissingRole(exception)) {
        throw invalidRoleException;
      }

      rethrow;
    }
  }

  Future<void> _signOutAfterProfileSyncFailure({
    bool includeGoogle = false,
  }) async {
    try {
      final client = _supabaseClient;
      if (client != null) {
        await client.auth.signOut();
      }
      if (includeGoogle) {
        await _ensureGoogleSignInInitialized();
        await _googleSignIn.signOut();
      }
    } on Object {
      // Keep the original Supabase profile-save error.
    }
  }

  bool _isEmailNotConfirmed(supabase.AuthException exception) {
    return exception.code == 'email_not_confirmed' ||
        exception.message.toLowerCase().contains('email not confirmed');
  }

  String? get _verificationEmail {
    final currentEmail = _supabaseClient?.auth.currentUser?.email;
    if (currentEmail?.trim().isNotEmpty == true) {
      return currentEmail!.trim().toLowerCase();
    }

    final pendingEmail = _pendingVerificationEmail;
    if (pendingEmail?.trim().isNotEmpty == true) {
      return pendingEmail!.trim().toLowerCase();
    }

    return null;
  }

  void _setPendingVerificationEmail({
    required String email,
    String? name,
    String? phoneNumber,
  }) {
    _pendingVerificationEmail = email.trim().toLowerCase();
    _pendingVerificationName = name?.trim();
    _pendingVerificationPhoneNumber = phoneNumber?.trim();
  }

  void _clearPendingVerificationEmail() {
    _pendingVerificationEmail = null;
    _pendingVerificationName = null;
    _pendingVerificationPhoneNumber = null;
  }

  AuthErrorCode _mapGoogleSignInError(GoogleSignInException exception) {
    return switch (exception.code) {
      GoogleSignInExceptionCode.canceled => AuthErrorCode.cancelled,
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError =>
        AuthErrorCode.operationNotAllowed,
      GoogleSignInExceptionCode.uiUnavailable =>
        AuthErrorCode.operationNotAllowed,
      _ => AuthErrorCode.unknown,
    };
  }
}
