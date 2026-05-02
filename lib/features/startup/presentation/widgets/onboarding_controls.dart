import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'onboarding_action_button.dart';
import 'onboarding_page_indicators.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({
    required this.currentIndex,
    required this.slideCount,
    required this.isLastSlide,
    required this.isSaving,
    required this.onNext,
    required this.onSkip,
    super.key,
  });

  final int currentIndex;
  final int slideCount;
  final bool isLastSlide;
  final bool isSaving;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OnboardingPageIndicators(
          currentIndex: currentIndex,
          count: slideCount,
        ),
        const SizedBox(height: AppSizes.xl),
        if (isLastSlide) ...[
          OnboardingActionButton(
            label: l10n.onboardingGetStarted,
            onPressed: isSaving ? null : onSkip,
            isLoading: isSaving,
          ),
          const SizedBox(height: AppSizes.md),
          OnboardingActionButton(
            label: l10n.onboardingExploreCollection,
            onPressed: isSaving ? null : onSkip,
            isSecondary: true,
          ),
        ] else ...[
          OnboardingActionButton(
            label: currentIndex == 0
                ? l10n.onboardingNext
                : l10n.onboardingNextStep,
            icon: LucideIcons.arrowRight,
            onPressed: isSaving ? null : onNext,
          ),
          const SizedBox(height: AppSizes.sm),
          TextButton(
            onPressed: isSaving ? null : onSkip,
            style: AppButtonStyles.ghost().copyWith(
              foregroundColor: WidgetStateProperty.all(AppColors.textSecondary),
              minimumSize: WidgetStateProperty.all(
                const Size(120, AppSizes.touchTarget),
              ),
              textStyle: WidgetStateProperty.all(
                AppTextStyles.label.copyWith(
                  letterSpacing: currentIndex == 0 ? 3 : 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            child: Text(
              currentIndex == 0
                  ? l10n.onboardingSkip
                  : l10n.onboardingSkipIntroduction,
            ),
          ),
        ],
      ],
    );
  }
}
