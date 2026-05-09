import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application title.
  ///
  /// In en, this message translates to:
  /// **'Teka Luxe'**
  String get appTitle;

  /// No description provided for @onboardingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save onboarding progress.'**
  String get onboardingSaveError;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingNextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get onboardingNextStep;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingCraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Crafted with Purpose'**
  String get onboardingCraftTitle;

  /// No description provided for @onboardingCraftDescription.
  ///
  /// In en, this message translates to:
  /// **'From premium fabrics to tailored fits, every detail is thoughtfully designed to bring effortless elegance.'**
  String get onboardingCraftDescription;

  /// No description provided for @onboardingAtelierTitle.
  ///
  /// In en, this message translates to:
  /// **'Refined Everyday Essentials'**
  String get onboardingAtelierTitle;

  /// No description provided for @onboardingAtelierDescription.
  ///
  /// In en, this message translates to:
  /// **'Timeless pieces designed with precision, crafted for comfort, and made to elevate your everyday wardrobe.'**
  String get onboardingAtelierDescription;

  /// No description provided for @onboardingLuxeTitle.
  ///
  /// In en, this message translates to:
  /// **'Elevate Your Style'**
  String get onboardingLuxeTitle;

  /// No description provided for @onboardingLuxeDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover a curated collection of modern essentials that blend simplicity, quality, and confidence.'**
  String get onboardingLuxeDescription;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @dividerOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get dividerOr;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Your Luxe Wardrobe'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to save favorites and checkout faster.'**
  String get registerSubtitle;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameHint;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated with your account, and we’ll send you a link to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressHint;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'SEND RESET LINK'**
  String get sendResetLink;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'BACK TO LOGIN'**
  String get backToLogin;

  /// No description provided for @authErrorAccountExistsWithDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with a different sign-in method.'**
  String get authErrorAccountExistsWithDifferentCredential;

  /// No description provided for @authErrorCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get authErrorCancelled;

  /// No description provided for @authErrorCredentialAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is already connected to another account.'**
  String get authErrorCredentialAlreadyInUse;

  /// No description provided for @authErrorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Try signing in instead.'**
  String get authErrorEmailAlreadyInUse;

  /// No description provided for @authErrorExpiredActionCode.
  ///
  /// In en, this message translates to:
  /// **'This reset link has expired. Request a new one and try again.'**
  String get authErrorExpiredActionCode;

  /// No description provided for @authErrorInvalidActionCode.
  ///
  /// In en, this message translates to:
  /// **'This reset link is invalid or has already been used.'**
  String get authErrorInvalidActionCode;

  /// No description provided for @authErrorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get authErrorInvalidCredential;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorInvalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code is invalid.'**
  String get authErrorInvalidVerificationCode;

  /// No description provided for @authErrorInvalidVerificationId.
  ///
  /// In en, this message translates to:
  /// **'The verification session is invalid. Please try again.'**
  String get authErrorInvalidVerificationId;

  /// No description provided for @authErrorMissingEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to continue.'**
  String get authErrorMissingEmail;

  /// No description provided for @authErrorNetworkRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get authErrorNetworkRequestFailed;

  /// No description provided for @authErrorOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not available right now.'**
  String get authErrorOperationNotAllowed;

  /// No description provided for @authErrorProfileSyncInvalidSchema.
  ///
  /// In en, this message translates to:
  /// **'The users table does not match the app profile data.'**
  String get authErrorProfileSyncInvalidSchema;

  /// No description provided for @authErrorProfileSyncPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Supabase is blocking profile saves. Check the users table RLS policies.'**
  String get authErrorProfileSyncPermissionDenied;

  /// No description provided for @authErrorProfileSyncUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not save your profile right now. Please try again.'**
  String get authErrorProfileSyncUnavailable;

  /// No description provided for @authErrorProviderAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is already linked to your account.'**
  String get authErrorProviderAlreadyLinked;

  /// No description provided for @authErrorRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again before making this change.'**
  String get authErrorRequiresRecentLogin;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Contact support for help.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find an account with that email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a stronger password to continue.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is incorrect.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'We could not complete the request. Please try again.'**
  String get authErrorUnknown;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name.'**
  String get validationNameRequired;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a Libyan mobile number starting with 091, 092, 093, or 094.'**
  String get validationPhoneInvalid;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get validationPasswordMinLength;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password.'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordsDoNotMatch;

  /// No description provided for @emailVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get emailVerificationTitle;

  /// No description provided for @emailVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to your email. Open it, then return here and we’ll continue automatically.'**
  String get emailVerificationDescription;

  /// No description provided for @emailVerificationChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking verification status...'**
  String get emailVerificationChecking;

  /// No description provided for @emailVerificationResend.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get emailVerificationResend;

  /// No description provided for @emailVerificationResendCountdown.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String emailVerificationResendCountdown(int seconds);

  /// No description provided for @emailVerificationBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get emailVerificationBackToLogin;

  /// No description provided for @emailVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent.'**
  String get emailVerificationSent;

  /// No description provided for @emailVerificationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Verified'**
  String get emailVerificationSuccessTitle;

  /// No description provided for @emailVerificationSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account is active. Continue to Teka Luxe.'**
  String get emailVerificationSuccessDescription;

  /// No description provided for @emailVerificationNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get emailVerificationNext;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent.'**
  String get passwordResetEmailSent;

  /// No description provided for @passwordResetResendCountdown.
  ///
  /// In en, this message translates to:
  /// **'Send again in {seconds}s'**
  String passwordResetResendCountdown(int seconds);

  /// No description provided for @homePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePlaceholderTitle;

  /// No description provided for @homePlaceholderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Teka Luxe shop experience will appear here.'**
  String get homePlaceholderSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericErrorTitle;

  /// No description provided for @retryAction.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryAction;

  /// No description provided for @colorOptionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Color option'**
  String get colorOptionTooltip;

  /// No description provided for @addToWishlistTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to wishlist'**
  String get addToWishlistTooltip;

  /// No description provided for @removeFromWishlistTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get removeFromWishlistTooltip;

  /// Accessibility label for a product card.
  ///
  /// In en, this message translates to:
  /// **'{title}, {price}'**
  String productCardSemanticsLabel(String title, String price);

  /// Accessibility label for a size selection pill.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String sizeSemanticsLabel(String size);

  /// Accessibility label for a star rating display.
  ///
  /// In en, this message translates to:
  /// **'Rating {rating} out of {count}'**
  String ratingSemanticsLabel(String rating, int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
