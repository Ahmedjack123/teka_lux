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
  String get onboardingSkipIntroduction => 'Skip Introduction';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingExploreCollection => 'Explore Collection';

  @override
  String get onboardingCraftEyebrow => 'CRAFT';

  @override
  String get onboardingCraftTitle => 'Crafted with Purpose';

  @override
  String get onboardingCraftDescription =>
      'From premium fabrics to tailored fits, every detail is thoughtfully designed to bring effortless elegance.';

  @override
  String get onboardingAtelierEyebrow => 'ATELIER';

  @override
  String get onboardingAtelierTitle => 'Refined Everyday Essentials';

  @override
  String get onboardingAtelierDescription =>
      'Timeless pieces designed with precision, crafted for comfort, and made to elevate your everyday wardrobe.';

  @override
  String get onboardingLuxeEyebrow => 'TEKA LUXE';

  @override
  String get onboardingLuxeTitle => 'Elevate Your Style';

  @override
  String get onboardingLuxeDescription =>
      'Discover a curated collection of modern essentials that blend simplicity, quality, and confidence.';

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginSubtitle => 'Please sign in to continue';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get dividerOr => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get registerTitle => 'Create account';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

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
