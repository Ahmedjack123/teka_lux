// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Teka Luxe';

  @override
  String get onboardingSaveError => 'Could not save onboarding progress.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingNextStep => 'Next Step';

  @override
  String get onboardingSkip => 'SKIP';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingCraftTitle => 'Crafted with Purpose';

  @override
  String get onboardingCraftDescription =>
      'From premium fabrics to tailored fits, every detail is thoughtfully designed to bring effortless elegance.';

  @override
  String get onboardingAtelierTitle => 'Refined Everyday Essentials';

  @override
  String get onboardingAtelierDescription =>
      'Timeless pieces designed with precision, crafted for comfort, and made to elevate your everyday wardrobe.';

  @override
  String get onboardingLuxeTitle => 'Elevate Your Style';

  @override
  String get onboardingLuxeDescription =>
      'Discover a curated collection of modern essentials that blend simplicity, quality, and confidence.';

  @override
  String get brandShort => 'TEKA';

  @override
  String get loginTitle => 'WELCOME';

  @override
  String get loginSubtitle => 'Sign in to access your exclusive archive.';

  @override
  String get emailHint => 'Email';

  @override
  String get loginEmailHint => 'archive@teka.com';

  @override
  String get registerEmailHint => 'NAME@EXAMPLE.COM';

  @override
  String get passwordHint => 'Password';

  @override
  String get passwordPlaceholder => '••••••••';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot?';

  @override
  String get signIn => 'LOG IN';

  @override
  String get signUp => 'SIGN UP';

  @override
  String get noAccount => 'New to the collective?';

  @override
  String get dividerOr => 'OR CONTINUE WITH';

  @override
  String get continueWithGoogle => 'Google';

  @override
  String get registerTitle => 'CREATE ACCOUNT';

  @override
  String get registerSubtitle => '';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get fullNameHint => 'ENTER YOUR NAME';

  @override
  String get phoneNumberHint => '091XXXXXXX';

  @override
  String get confirmPasswordHint => 'CONFIRM PASSWORD';

  @override
  String get createAccount => 'SIGN UP';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get agreeToTermsPrefix => 'I agree to the';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get andThe => 'and the';

  @override
  String get privacyPolicy => 'Privacy Policy.';

  @override
  String get validationTermsRequired =>
      'Agree to the terms and privacy policy to continue.';

  @override
  String get forgotPasswordTitle => 'RESET PASSWORD';

  @override
  String get forgotPasswordDescription =>
      'Enter your registered email address to receive a secure recovery link for your account.';

  @override
  String get resetPasswordAccessLabel => 'ACCESS';

  @override
  String get emailAddressHint => 'user@teka.studio';

  @override
  String get sendResetLink => 'SEND LINK';

  @override
  String get backToLogin => 'BACK TO LOGIN';

  @override
  String get authErrorAccountExistsWithDifferentCredential =>
      'An account already exists with a different sign-in method.';

  @override
  String get authErrorCancelled => 'Sign-in was cancelled.';

  @override
  String get authErrorCredentialAlreadyInUse =>
      'This sign-in method is already connected to another account.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'This email is already registered. Try signing in instead.';

  @override
  String get authErrorExpiredActionCode =>
      'This reset link has expired. Request a new one and try again.';

  @override
  String get authErrorInvalidActionCode =>
      'This reset link is invalid or has already been used.';

  @override
  String get authErrorInvalidCredential =>
      'The email or password is incorrect.';

  @override
  String get authErrorInvalidEmail => 'Enter a valid email address.';

  @override
  String get authErrorInvalidVerificationCode =>
      'The verification code is invalid.';

  @override
  String get authErrorInvalidVerificationId =>
      'The verification session is invalid. Please try again.';

  @override
  String get authErrorMissingEmail => 'Enter your email address to continue.';

  @override
  String get authErrorNetworkRequestFailed =>
      'Check your internet connection and try again.';

  @override
  String get authErrorOperationNotAllowed =>
      'This sign-in method is not available right now.';

  @override
  String get authErrorProfileSyncInvalidSchema =>
      'The users table does not match the app profile data.';

  @override
  String get authErrorProfileSyncPermissionDenied =>
      'Supabase is blocking profile saves. Check the users table RLS policies.';

  @override
  String get authErrorProfileSyncUnavailable =>
      'Could not save your profile right now. Please try again.';

  @override
  String get authErrorProviderAlreadyLinked =>
      'This sign-in method is already linked to your account.';

  @override
  String get authErrorRequiresRecentLogin =>
      'Please sign in again before making this change.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get authErrorUserDisabled =>
      'This account has been disabled. Contact support for help.';

  @override
  String get authErrorUserNotFound =>
      'We could not find an account with that email.';

  @override
  String get authErrorWeakPassword => 'Choose a stronger password to continue.';

  @override
  String get authErrorWrongPassword => 'The password is incorrect.';

  @override
  String get authErrorUnknown =>
      'We could not complete the request. Please try again.';

  @override
  String get validationNameRequired => 'Enter your full name.';

  @override
  String get validationPhoneRequired => 'Enter your phone number.';

  @override
  String get validationPhoneInvalid =>
      'Enter a Libyan mobile number starting with 091, 092, 093, or 094.';

  @override
  String get validationEmailRequired => 'Enter your email address.';

  @override
  String get validationEmailInvalid => 'Enter a valid email address.';

  @override
  String get validationPasswordRequired => 'Enter your password.';

  @override
  String get validationPasswordMinLength => 'Use at least 6 characters.';

  @override
  String get validationConfirmPasswordRequired => 'Confirm your password.';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String get emailVerificationTitle => 'VERIFY EMAIL';

  @override
  String get emailVerificationDescription =>
      'Open the secure link we sent to your inbox, then return here to activate your account.';

  @override
  String get emailVerificationChecking => 'Checking verification status...';

  @override
  String get emailVerificationResend => 'Resend Email';

  @override
  String emailVerificationResendCountdown(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get emailVerificationBackToLogin => 'Back to Login';

  @override
  String get emailVerificationSent => 'Verification email sent.';

  @override
  String get emailVerificationSuccessTitle => 'Email Verified';

  @override
  String get emailVerificationSuccessDescription =>
      'Your account is active. Continue to Teka Luxe.';

  @override
  String get emailVerificationNext => 'Next';

  @override
  String get passwordResetEmailSent => 'Password reset email sent.';

  @override
  String get homePlaceholderTitle => 'Home';

  @override
  String get homePlaceholderSubtitle =>
      'Your Teka Luxe shop experience will appear here.';

  @override
  String get logout => 'Log Out';

  @override
  String get genericErrorTitle => 'Something went wrong';

  @override
  String get retryAction => 'Try again';

  @override
  String get colorOptionTooltip => 'Color option';

  @override
  String get addToWishlistTooltip => 'Add to wishlist';

  @override
  String get removeFromWishlistTooltip => 'Remove from wishlist';

  @override
  String productCardSemanticsLabel(String title, String price) {
    return '$title, $price';
  }

  @override
  String sizeSemanticsLabel(String size) {
    return 'Size $size';
  }

  @override
  String ratingSemanticsLabel(String rating, int count) {
    return 'Rating $rating out of $count';
  }
}
