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
    final palette = AppAuthPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            l10n.brandShort,
            style: AppTextStyles.h2.copyWith(
              color: palette.text,
              fontSize: compact ? 32 : 38,
              letterSpacing: 0,
            ),
          ),
        ),
        SizedBox(height: compact ? AppSizes.lg : AppSizes.xxl),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.loginTitle,
            textAlign: TextAlign.start,
            style: AppTextStyles.display.copyWith(
              color: palette.text,
              fontSize: compact ? 48 : 56,
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: compact ? AppSizes.sm : AppSizes.md),
        Text(
          l10n.loginSubtitle,
          textAlign: TextAlign.start,
          style: AppTextStyles.bodyLg.copyWith(
            color: palette.muted,
            fontSize: compact ? 15 : 17,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
