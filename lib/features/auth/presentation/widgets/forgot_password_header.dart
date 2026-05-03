import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({
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
          l10n.forgotPasswordTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(
            color: AppColors.textStrong,
            fontSize: compact ? 32 : 38,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: compact ? AppSizes.md : AppSizes.lg),
        Text(
          l10n.forgotPasswordDescription,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textBody,
            fontSize: compact ? 15 : 17,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
