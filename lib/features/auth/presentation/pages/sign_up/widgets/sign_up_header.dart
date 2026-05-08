import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({
    this.compact = false,
    super.key,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Text(
          l10n.registerTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(
            color: AppColors.textStrong,
            fontSize: compact ? 32 : 36,
            height: 1.12,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: compact ? AppSizes.xs : AppSizes.sm),
        Text(
          l10n.registerSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: compact ? 14 : 15,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
