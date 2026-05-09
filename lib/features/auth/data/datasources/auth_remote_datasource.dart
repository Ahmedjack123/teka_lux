import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

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

final class FirebaseAuthRemoteDatasource implements AuthRemoteDatasource {
  FirebaseAuthRemoteDatasource({
    required FirebaseAuth firebaseAuth,
    required SupabaseClient? supabaseClient,
    required NetworkInfo networkInfo,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _supabaseClient = supabaseClient,
        _networkInfo = networkInfo,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final SupabaseClient? _supabaseClient;
  final NetworkInfo _networkInfo;
  final GoogleSignIn _googleSignIn;

  static const List<String> _roleCandidates = ['customer', 'user'];

  Future<void>? _googleSignInInitialization;

  @override
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.userChanges().map((user) {
      return user == null ? null : UserModel.fromFirebaseUser(user);
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _ensureNetworkConnected();
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final model = _modelFromCredential(credential);

      try {
        await _upsertUserProfile(
          model,
          fullName: model.name,
          phoneNumber: model.phoneNumber,
        );
      } on Object {
        await _signOutAfterProfileSyncFailure();
        rethrow;
      }

      return model;
    } on FirebaseAuthException catch (exception) {
      throw AuthException.fromFirebase(exception);
    } on PostgrestException catch (exception, stackTrace) {
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
    try {
      await _ensureNetworkConnected();
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;

      if (user == null) {
        throw const AuthException(errorCode: AuthErrorCode.unknown);
      }

      await user.updateDisplayName(name.trim());
      await user.reload();

      final model =
          UserModel.fromFirebaseUser(_firebaseAuth.currentUser ?? user);
      try {
        await _upsertUserProfile(
          model,
          fullName: name.trim(),
          phoneNumber: phoneNumber.trim(),
        );
      } on Object {
        await _deleteCreatedUser(user);
        rethrow;
      }

      return model;
    } on FirebaseAuthException catch (exception) {
      throw AuthException.fromFirebase(exception);
    } on PostgrestException catch (exception, stackTrace) {
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
          firebaseCode: 'operation-not-allowed',
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
          firebaseCode: 'invalid-credential',
          debugMessage: 'Google sign-in did not return an idToken.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final firebaseCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final model = _modelFromCredential(firebaseCredential);
      try {
        await _upsertUserProfile(
          model,
          fullName: model.name,
          phoneNumber: model.phoneNumber,
        );
      } on Object {
        await _signOutAfterProfileSyncFailure(includeGoogle: true);
        rethrow;
      }

      return model;
    } on FirebaseAuthException catch (exception) {
      throw AuthException.fromFirebase(exception);
    } on PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    } on GoogleSignInException catch (exception, stackTrace) {
      throw AuthException(
        errorCode: _mapGoogleSignInError(exception),
        firebaseCode: exception.code.name,
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
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (exception) {
      throw AuthException.fromFirebase(exception);
    }
  }

  @override
  Future<void> verifyEmail() async {
    try {
      await _ensureNetworkConnected();
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const AuthException(
          errorCode: AuthErrorCode.userNotFound,
          firebaseCode: 'user-not-found',
        );
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (exception) {
      throw AuthException.fromFirebase(exception);
    }
  }

  @override
  Future<bool> isCurrentUserEmailVerified() async {
    try {
      await _ensureNetworkConnected();
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const AuthException(
          errorCode: AuthErrorCode.userNotFound,
          firebaseCode: 'user-not-found',
        );
      }

      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser;
      final isVerified = refreshedUser?.emailVerified ?? false;

      if (isVerified && refreshedUser != null) {
        await _upsertUserProfile(
          UserModel.fromFirebaseUser(refreshedUser),
          fullName: refreshedUser.displayName,
          phoneNumber: refreshedUser.phoneNumber,
        );
      }

      return isVerified;
    } on FirebaseAuthException catch (exception) {
      throw AuthException.fromFirebase(exception);
    } on PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _ensureGoogleSignInInitialized();
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (exception) {
      throw AuthException.fromFirebase(exception);
    } on GoogleSignInException catch (exception, stackTrace) {
      throw AuthException(
        errorCode: _mapGoogleSignInError(exception),
        firebaseCode: exception.code.name,
        debugMessage: exception.description,
        cause: exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= _googleSignIn.initialize();
  }

  UserModel _modelFromCredential(UserCredential credential) {
    final user = credential.user;

    if (user == null) {
      throw const AuthException(errorCode: AuthErrorCode.unknown);
    }

    return UserModel.fromFirebaseUser(user);
  }

  Future<void> _ensureNetworkConnected() async {
    if (await _networkInfo.isConnected) {
      return;
    }

    throw const AuthException(
      errorCode: AuthErrorCode.networkRequestFailed,
      firebaseCode: 'network-request-failed',
      debugMessage: 'No internet connection is available.',
    );
  }

  Future<void> _upsertUserProfile(
    UserModel model, {
    String? fullName,
    String? phoneNumber,
  }) async {
    final supabase = _supabaseClient;
    if (supabase == null) {
      throw const AuthException(
        errorCode: AuthErrorCode.profileSyncUnavailable,
        firebaseCode: 'profile-sync-unavailable',
        debugMessage:
            'Supabase is not configured. Provide SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }

    final normalizedPhone = (phoneNumber ?? model.phoneNumber)?.trim();
    final payload = <String, dynamic>{
      'id': model.uid,
      'email': model.email.trim().toLowerCase(),
      'full_name': (fullName ?? model.name).trim(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    if (normalizedPhone?.isNotEmpty ?? false) {
      payload['phone_number'] = normalizedPhone;
    }

    await _upsertUserPayload(supabase, payload);
  }

  Future<void> _upsertUserPayload(
    SupabaseClient supabase,
    Map<String, dynamic> payload,
  ) async {
    PostgrestException? invalidRoleException;

    for (final role in _roleCandidates) {
      try {
        await supabase.from('users').upsert({
          ...payload,
          'role': role,
        }, onConflict: 'id');
        return;
      } on PostgrestException catch (exception) {
        if (!SupabaseExceptionMapper.isInvalidRole(exception)) {
          rethrow;
        }

        invalidRoleException = exception;
      }
    }

    try {
      await supabase.from('users').upsert(payload, onConflict: 'id');
    } on PostgrestException catch (exception) {
      if (invalidRoleException != null &&
          SupabaseExceptionMapper.isMissingRole(exception)) {
        throw invalidRoleException;
      }

      rethrow;
    }
  }

  Future<void> _deleteCreatedUser(User user) async {
    try {
      await user.delete();
    } on FirebaseAuthException {
      // Keep the original profile-save error. The next attempt may need cleanup
      // from Firebase Console if this recovery delete fails.
    }
  }

  Future<void> _signOutAfterProfileSyncFailure({
    bool includeGoogle = false,
  }) async {
    try {
      await _firebaseAuth.signOut();
      if (includeGoogle) {
        await _ensureGoogleSignInInitialized();
        await _googleSignIn.signOut();
      }
    } on Object {
      // Keep the original Supabase profile-save error.
    }
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
