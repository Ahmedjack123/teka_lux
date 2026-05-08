import '../../l10n/generated/app_localizations.dart';

class Validators {
  const Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final RegExp _libyanMobileRegExp = RegExp(r'^09[1-4][0-9]{7}$');

  static bool isValidEmail(String value) {
    return _emailRegExp.hasMatch(value.trim());
  }

  static bool isValidPassword(String value) {
    return value.length >= 6;
  }

  static String? name(String value, AppLocalizations l10n) {
    return value.trim().length < 2 ? l10n.validationNameRequired : null;
  }

  static String? email(String value, AppLocalizations l10n) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return l10n.validationEmailRequired;
    }

    return isValidEmail(trimmed) ? null : l10n.validationEmailInvalid;
  }

  static String? phoneNumber(String value, AppLocalizations l10n) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return l10n.validationPhoneRequired;
    }

    return _libyanMobileRegExp.hasMatch(trimmed)
        ? null
        : l10n.validationPhoneInvalid;
  }

  static String? password(String value, AppLocalizations l10n) {
    if (value.isEmpty) {
      return l10n.validationPasswordRequired;
    }

    if (!isValidPassword(value)) {
      return l10n.validationPasswordMinLength;
    }

    return null;
  }

  static String? confirmPassword(
    String value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value.isEmpty) {
      return l10n.validationConfirmPasswordRequired;
    }

    return value == password ? null : l10n.validationPasswordsDoNotMatch;
  }
}
