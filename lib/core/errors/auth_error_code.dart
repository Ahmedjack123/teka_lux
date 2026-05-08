import '../../l10n/generated/app_localizations.dart';

enum AuthErrorCode {
  accountExistsWithDifferentCredential(
    'account-exists-with-different-credential',
  ),
  cancelled('cancelled'),
  credentialAlreadyInUse('credential-already-in-use'),
  emailAlreadyInUse('email-already-in-use'),
  expiredActionCode('expired-action-code'),
  invalidActionCode('invalid-action-code'),
  invalidCredential('invalid-credential'),
  invalidEmail('invalid-email'),
  invalidVerificationCode('invalid-verification-code'),
  invalidVerificationId('invalid-verification-id'),
  missingEmail('missing-email'),
  networkRequestFailed('network-request-failed'),
  operationNotAllowed('operation-not-allowed'),
  profileSyncInvalidSchema('profile-sync-invalid-schema'),
  profileSyncPermissionDenied('profile-sync-permission-denied'),
  profileSyncUnavailable('profile-sync-unavailable'),
  providerAlreadyLinked('provider-already-linked'),
  requiresRecentLogin('requires-recent-login'),
  tooManyRequests('too-many-requests'),
  userDisabled('user-disabled'),
  userNotFound('user-not-found'),
  weakPassword('weak-password'),
  wrongPassword('wrong-password'),
  unknown('unknown');

  const AuthErrorCode(this.firebaseCode);

  final String firebaseCode;

  static AuthErrorCode fromFirebaseCode(String? code) {
    return switch (code) {
      'account-exists-with-different-credential' =>
        AuthErrorCode.accountExistsWithDifferentCredential,
      'canceled' || 'cancelled' => AuthErrorCode.cancelled,
      'credential-already-in-use' => AuthErrorCode.credentialAlreadyInUse,
      'email-already-in-use' => AuthErrorCode.emailAlreadyInUse,
      'expired-action-code' => AuthErrorCode.expiredActionCode,
      'invalid-action-code' => AuthErrorCode.invalidActionCode,
      'invalid-credential' => AuthErrorCode.invalidCredential,
      'invalid-email' => AuthErrorCode.invalidEmail,
      'invalid-verification-code' => AuthErrorCode.invalidVerificationCode,
      'invalid-verification-id' => AuthErrorCode.invalidVerificationId,
      'missing-email' => AuthErrorCode.missingEmail,
      'network-request-failed' => AuthErrorCode.networkRequestFailed,
      'operation-not-allowed' => AuthErrorCode.operationNotAllowed,
      'profile-sync-invalid-schema' => AuthErrorCode.profileSyncInvalidSchema,
      'profile-sync-permission-denied' =>
        AuthErrorCode.profileSyncPermissionDenied,
      'profile-sync-unavailable' => AuthErrorCode.profileSyncUnavailable,
      'provider-already-linked' => AuthErrorCode.providerAlreadyLinked,
      'requires-recent-login' => AuthErrorCode.requiresRecentLogin,
      'too-many-requests' => AuthErrorCode.tooManyRequests,
      'user-disabled' => AuthErrorCode.userDisabled,
      'user-not-found' => AuthErrorCode.userNotFound,
      'weak-password' => AuthErrorCode.weakPassword,
      'wrong-password' => AuthErrorCode.wrongPassword,
      _ => AuthErrorCode.unknown,
    };
  }

  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      AuthErrorCode.accountExistsWithDifferentCredential =>
        l10n.authErrorAccountExistsWithDifferentCredential,
      AuthErrorCode.cancelled => l10n.authErrorCancelled,
      AuthErrorCode.credentialAlreadyInUse =>
        l10n.authErrorCredentialAlreadyInUse,
      AuthErrorCode.emailAlreadyInUse => l10n.authErrorEmailAlreadyInUse,
      AuthErrorCode.expiredActionCode => l10n.authErrorExpiredActionCode,
      AuthErrorCode.invalidActionCode => l10n.authErrorInvalidActionCode,
      AuthErrorCode.invalidCredential => l10n.authErrorInvalidCredential,
      AuthErrorCode.invalidEmail => l10n.authErrorInvalidEmail,
      AuthErrorCode.invalidVerificationCode =>
        l10n.authErrorInvalidVerificationCode,
      AuthErrorCode.invalidVerificationId =>
        l10n.authErrorInvalidVerificationId,
      AuthErrorCode.missingEmail => l10n.authErrorMissingEmail,
      AuthErrorCode.networkRequestFailed => l10n.authErrorNetworkRequestFailed,
      AuthErrorCode.operationNotAllowed => l10n.authErrorOperationNotAllowed,
      AuthErrorCode.profileSyncInvalidSchema =>
        l10n.authErrorProfileSyncInvalidSchema,
      AuthErrorCode.profileSyncPermissionDenied =>
        l10n.authErrorProfileSyncPermissionDenied,
      AuthErrorCode.profileSyncUnavailable =>
        l10n.authErrorProfileSyncUnavailable,
      AuthErrorCode.providerAlreadyLinked =>
        l10n.authErrorProviderAlreadyLinked,
      AuthErrorCode.requiresRecentLogin => l10n.authErrorRequiresRecentLogin,
      AuthErrorCode.tooManyRequests => l10n.authErrorTooManyRequests,
      AuthErrorCode.userDisabled => l10n.authErrorUserDisabled,
      AuthErrorCode.userNotFound => l10n.authErrorUserNotFound,
      AuthErrorCode.weakPassword => l10n.authErrorWeakPassword,
      AuthErrorCode.wrongPassword => l10n.authErrorWrongPassword,
      AuthErrorCode.unknown => l10n.authErrorUnknown,
    };
  }
}
