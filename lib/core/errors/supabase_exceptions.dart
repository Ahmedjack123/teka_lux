import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import 'auth_error_code.dart';
import 'exceptions.dart';

final class SupabaseExceptionMapper {
  const SupabaseExceptionMapper._();

  static AuthException toAuthException(
    PostgrestException exception,
    StackTrace stackTrace,
  ) {
    final errorCode = _mapPostgrestError(exception);

    return AuthException(
      errorCode: errorCode,
      firebaseCode: exception.code ?? errorCode.firebaseCode,
      debugMessage: exception.message,
      cause: exception,
      stackTrace: stackTrace,
    );
  }

  static bool isInvalidRole(PostgrestException exception) {
    final text = _exceptionText(exception);
    return exception.code == '22P02' &&
        (text.contains('user_role') ||
            text.contains('invalid input value for enum'));
  }

  static bool isMissingRole(PostgrestException exception) {
    final text = _exceptionText(exception);
    return exception.code == '23502' && text.contains('role');
  }

  static AuthErrorCode _mapPostgrestError(PostgrestException exception) {
    if (_isPermissionException(exception)) {
      return AuthErrorCode.profileSyncPermissionDenied;
    }

    if (_isSchemaException(exception)) {
      return AuthErrorCode.profileSyncInvalidSchema;
    }

    return AuthErrorCode.profileSyncUnavailable;
  }

  static bool _isPermissionException(PostgrestException exception) {
    final text = _exceptionText(exception);
    return exception.code == '42501' ||
        text.contains('row-level security') ||
        text.contains('permission denied');
  }

  static bool _isSchemaException(PostgrestException exception) {
    final text = _exceptionText(exception);
    return exception.code == '22P02' ||
        exception.code == '23502' ||
        exception.code == '42703' ||
        text.contains('invalid input value for enum') ||
        text.contains('violates not-null constraint') ||
        text.contains('column');
  }

  static String _exceptionText(PostgrestException exception) {
    return [
      exception.message,
      exception.code,
      exception.details,
      exception.hint,
    ].whereType<Object>().join(' ').toLowerCase();
  }
}
