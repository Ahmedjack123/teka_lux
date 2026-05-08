import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
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
          l10n.loginTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(
            color: AppColors.textStrong,
            fontSize: compact ? 38 : 42,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: compact ? AppSizes.xxs : AppSizes.xs),
        Text(
          l10n.loginSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: compact ? 15 : 16,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
