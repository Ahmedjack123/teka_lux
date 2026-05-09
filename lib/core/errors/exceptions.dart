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
    this.authCode,
    super.debugMessage,
    super.cause,
    super.stackTrace,
  });

  factory AuthException.fromCode(
    String? code, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return AuthException(
      errorCode: AuthErrorCode.fromCode(code),
      authCode: code,
      debugMessage: debugMessage,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  final AuthErrorCode errorCode;
  final String? authCode;

  AuthFailure toFailure() {
    return AuthFailure(
      errorCode: errorCode,
      authCode: authCode,
      debugMessage: debugMessage,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  @override
  String localizedMessage(AppLocalizations l10n) {
    return errorCode.localizedMessage(l10n);
  }

  @override
  String toString() {
    return 'AuthException(authCode: ${authCode ?? errorCode.code})';
  }
}
