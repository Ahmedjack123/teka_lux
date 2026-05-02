import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/onboarding_slide.dart';
import 'onboarding_slide_mark.dart';

class OnboardingSlideCopy extends StatelessWidget {
  const OnboardingSlideCopy({
    required this.slide,
    required this.index,
    this.alignLeft = false,
    super.key,
  });

  final OnboardingSlide slide;
  final int index;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alignment =
        alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    final textAlign = alignLeft ? TextAlign.left : TextAlign.center;
    final copy = _LocalizedOnboardingCopy.from(l10n, slide.copy);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 540),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (index == 0) ...[
            OnboardingSlideMark(index: index),
            const SizedBox(height: AppSizes.lg),
          ],
          Text(
            copy.title,
            textAlign: textAlign,
            softWrap: true,
            style: AppTextStyles.display.copyWith(
              color: AppColors.textStrong,
              fontSize: 42,
              height: 1.12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            copy.description,
            textAlign: textAlign,
            softWrap: true,
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.textBody,
              fontSize: 18,
              height: 1.58,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalizedOnboardingCopy {
  const _LocalizedOnboardingCopy({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  factory _LocalizedOnboardingCopy.from(
    AppLocalizations l10n,
    OnboardingCopyKey copy,
  ) {
    return switch (copy) {
      OnboardingCopyKey.craft => _LocalizedOnboardingCopy(
          title: l10n.onboardingCraftTitle,
          description: l10n.onboardingCraftDescription,
        ),
      OnboardingCopyKey.atelier => _LocalizedOnboardingCopy(
          title: l10n.onboardingAtelierTitle,
          description: l10n.onboardingAtelierDescription,
        ),
      OnboardingCopyKey.luxe => _LocalizedOnboardingCopy(
          title: l10n.onboardingLuxeTitle,
          description: l10n.onboardingLuxeDescription,
        ),
    };
  }
}
