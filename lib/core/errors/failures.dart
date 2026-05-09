import '../../l10n/generated/app_localizations.dart';
import 'auth_error_code.dart';

abstract class Failure {
  const Failure({
    this.debugMessage,
    this.cause,
    this.stackTrace,
  });

  final String? debugMessage;
  final Object? cause;
  final StackTrace? stackTrace;

  String localizedMessage(AppLocalizations l10n);
}

final class AuthFailure extends Failure {
  const AuthFailure({
    required this.errorCode,
    this.authCode,
    super.debugMessage,
    super.cause,
    super.stackTrace,
  });

  factory AuthFailure.fromCode(
    String? code, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return AuthFailure(
      errorCode: AuthErrorCode.fromCode(code),
      authCode: code,
      debugMessage: debugMessage,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  final AuthErrorCode errorCode;
  final String? authCode;

  @override
  String localizedMessage(AppLocalizations l10n) {
    return errorCode.localizedMessage(l10n);
  }

  @override
  String toString() {
    return 'AuthFailure(authCode: ${authCode ?? errorCode.code})';
  }
}
