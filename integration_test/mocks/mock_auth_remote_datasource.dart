import 'dart:async';

import 'package:teka_luxe/core/errors/auth_error_code.dart';
import 'package:teka_luxe/core/errors/exceptions.dart';
import 'package:teka_luxe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:teka_luxe/features/auth/data/models/user_model.dart';

/// In-memory mock datasource that simulates the full auth flow
/// without requiring Firebase or Supabase connections.
class MockAuthRemoteDatasource implements AuthRemoteDatasource {
  MockAuthRemoteDatasource({
    this.autoVerifyEmail = false,
    this.verificationDelay = const Duration(seconds: 1),
  });

  /// If true, email verification succeeds automatically after [verificationDelay].
  final bool autoVerifyEmail;

  /// Delay before auto-verifying email (if [autoVerifyEmail] is true).
  final Duration verificationDelay;

  // ── In-memory store ──
  final Map<String, _MockUser> _users = {};
  String? _currentUserId;
  final _authStateController = StreamController<UserModel?>.broadcast();

  Timer? _autoVerifyTimer;

  // ── Test helpers ──

  /// Directly set the current user (useful for pre-authenticating).
  void setCurrentUser(UserModel user) {
    _currentUserId = user.uid;
    _users[user.uid] = _MockUser(
      uid: user.uid,
      email: user.email,
      password: '',
      name: user.name,
      phoneNumber: user.phoneNumber ?? '',
      emailVerified: user.emailVerified,
    );
    _emitAuthState();
  }

  /// Clear all users and sign out.
  void reset() {
    _users.clear();
    _currentUserId = null;
    _autoVerifyTimer?.cancel();
    _emitAuthState();
  }

  /// Manually verify the current user's email (for test control).
  void verifyCurrentUserEmail() {
    final id = _currentUserId;
    if (id == null) return;
    final user = _users[id];
    if (user == null) return;
    _users[id] = user.copyWith(emailVerified: true);
    _emitAuthState();
  }

  // ── AuthRemoteDatasource implementation ──

  @override
  Stream<UserModel?> authStateChanges() => _authStateController.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    final id = _currentUserId;
    if (id == null) return null;
    return _users[id]?.toModel();
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = _users.values.firstWhere(
      (u) => u.email.toLowerCase() == normalizedEmail,
      orElse: () => throw const AuthException(
        errorCode: AuthErrorCode.userNotFound,
        firebaseCode: 'user-not-found',
      ),
    );

    if (user.password != password) {
      throw const AuthException(
        errorCode: AuthErrorCode.wrongPassword,
        firebaseCode: 'wrong-password',
      );
    }

    _currentUserId = user.uid;
    _emitAuthState();
    return user.toModel();
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (_users.values.any((u) => u.email.toLowerCase() == normalizedEmail)) {
      throw const AuthException(
        errorCode: AuthErrorCode.emailAlreadyInUse,
        firebaseCode: 'email-already-in-use',
      );
    }

    final uid = 'mock-uid-${_users.length + 1}';
    final user = _MockUser(
      uid: uid,
      email: normalizedEmail,
      password: password,
      name: name.trim(),
      phoneNumber: phoneNumber.trim(),
      emailVerified: false,
    );

    _users[uid] = user;
    _currentUserId = uid;
    _emitAuthState();

    if (autoVerifyEmail) {
      _autoVerifyTimer?.cancel();
      _autoVerifyTimer = Timer(verificationDelay, () {
        verifyCurrentUserEmail();
      });
    }

    return user.toModel();
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    throw const AuthException(
      errorCode: AuthErrorCode.operationNotAllowed,
      firebaseCode: 'operation-not-allowed',
      debugMessage: 'Google sign-in is not supported in integration tests.',
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!_users.values.any((u) => u.email.toLowerCase() == normalizedEmail)) {
      throw const AuthException(
        errorCode: AuthErrorCode.userNotFound,
        firebaseCode: 'user-not-found',
      );
    }
  }

  @override
  Future<void> verifyEmail() async {
    final id = _currentUserId;
    if (id == null) {
      throw const AuthException(
        errorCode: AuthErrorCode.userNotFound,
        firebaseCode: 'user-not-found',
      );
    }
    // In mock, verification email is "sent" successfully.
    // Actual verification happens via check or auto-verify.
  }

  @override
  Future<bool> isCurrentUserEmailVerified() async {
    final id = _currentUserId;
    if (id == null) {
      throw const AuthException(
        errorCode: AuthErrorCode.userNotFound,
        firebaseCode: 'user-not-found',
      );
    }
    final user = _users[id];
    return user?.emailVerified ?? false;
  }

  @override
  Future<void> signOut() async {
    _currentUserId = null;
    _emitAuthState();
  }

  void _emitAuthState() {
    final id = _currentUserId;
    if (id == null) {
      _authStateController.add(null);
      return;
    }
    final user = _users[id];
    _authStateController.add(user?.toModel());
  }

  void dispose() {
    _autoVerifyTimer?.cancel();
    _authStateController.close();
  }
}

class _MockUser {
  const _MockUser({
    required this.uid,
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.emailVerified,
  });

  final String uid;
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final bool emailVerified;

  _MockUser copyWith({bool? emailVerified}) => _MockUser(
        uid: uid,
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        emailVerified: emailVerified ?? this.emailVerified,
      );

  UserModel toModel() => UserModel(
        uid: uid,
        email: email,
        name: name,
        emailVerified: emailVerified,
        phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
      );
}
