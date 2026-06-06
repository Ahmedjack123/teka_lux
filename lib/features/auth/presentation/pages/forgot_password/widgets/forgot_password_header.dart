import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({
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
        Text(
          l10n.forgotPasswordTitle,
          textAlign: TextAlign.start,
          style: AppTextStyles.display.copyWith(
            color: palette.text,
            fontSize: compact ? 54 : 62,
            height: .9,
          ),
        ),
        SizedBox(height: compact ? AppSizes.md : AppSizes.lg),
        Text(
          l10n.forgotPasswordDescription,
          textAlign: TextAlign.start,
          style: AppTextStyles.bodyLg.copyWith(
            color: palette.muted,
            fontSize: compact ? 18 : 20,
            height: 1.38,
          ),
        ),
      ],
    );
  }
}
