import 'package:firebase_auth/firebase_auth.dart';

import '../../l10n/generated/app_localizations.dart';
import 'auth_error_code.dart';
import 'failures.dart';

abstract class AppException implements Exception {
  const AppException({
    this.debugMessage,
    this.cause,
    this.stackTrace,
  });

  final String? debugMessage;
  final Object? cause;
  final StackTrace? stackTrace;

  String localizedMessage(AppLocalizations l10n);
}

final class AuthException extends AppException {
  const AuthException({
    required this.errorCode,
    this.firebaseCode,
    super.debugMessage,
    super.cause,
    super.stackTrace,
  });

  factory AuthException.fromFirebase(FirebaseAuthException exception) {
    return AuthException(
      errorCode: AuthErrorCode.fromFirebaseCode(exception.code),
      firebaseCode: exception.code,
      debugMessage: exception.message,
      cause: exception,
      stackTrace: exception.stackTrace,
    );
  }

  factory AuthException.fromCode(
    String? code, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return AuthException(
      errorCode: AuthErrorCode.fromFirebaseCode(code),
      firebaseCode: code,
      debugMessage: debugMessage,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  final AuthErrorCode errorCode;
  final String? firebaseCode;

  @override
  String localizedMessage(AppLocalizations l10n) {
    return errorCode.localizedMessage(l10n);
  }

  @override
  String toString() {
    return 'AuthException(firebaseCode: ${firebaseCode ?? errorCode.firebaseCode})';
  }

  AuthFailure toFailure() {
    return AuthFailure(
      errorCode: errorCode,
      debugMessage: debugMessage,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
