import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';

class AuthDividerLabel extends StatelessWidget {
  const AuthDividerLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Text(
            l10n.dividerOr,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 3,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
