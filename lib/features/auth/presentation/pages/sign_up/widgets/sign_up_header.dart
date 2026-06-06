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
    final palette = AppAuthPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.registerTitle,
            textAlign: TextAlign.start,
            style: AppTextStyles.display.copyWith(
              color: palette.text,
              fontSize: compact ? 44 : 52,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Container(
          width: compact ? 100 : 140,
          height: 8,
          color: palette.accent,
        ),
        if (l10n.registerSubtitle.isNotEmpty) ...[
          SizedBox(height: compact ? AppSizes.xs : AppSizes.sm),
          Text(
            l10n.registerSubtitle,
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyLg.copyWith(
              color: palette.muted,
              fontSize: compact ? 13 : 14,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
