import '../../l10n/generated/app_localizations.dart';
import 'auth_error_code.dart';

sealed class Failure {
  const Failure();

  String localizedMessage(AppLocalizations l10n);
}

final class AuthFailure extends Failure {
  const AuthFailure({
    required this.errorCode,
    this.debugMessage,
    this.cause,
    this.stackTrace,
  });

  final AuthErrorCode errorCode;
  final String? debugMessage;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String localizedMessage(AppLocalizations l10n) {
    return errorCode.localizedMessage(l10n);
  }
}
