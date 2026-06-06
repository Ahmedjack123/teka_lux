import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class AuthDividerLabel extends StatelessWidget {
  const AuthDividerLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppAuthPalette.of(context);

    return Row(
      children: [
        Expanded(child: Divider(color: palette.line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Text(
            l10n.dividerOr,
            style: AppTextStyles.label.copyWith(
              color: palette.faint,
              fontSize: 13,
              letterSpacing: 2.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: palette.line)),
      ],
    );
  }
}
