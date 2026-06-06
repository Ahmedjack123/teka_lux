import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class SignUpLoginPrompt extends StatelessWidget {
  const SignUpLoginPrompt({
    required this.onSignIn,
    this.compact = false,
    super.key,
  });

  final VoidCallback onSignIn;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppAuthPalette.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: AppTextStyles.bodyLg.copyWith(
            color: palette.muted,
            fontSize: compact ? 15 : 17,
            height: 1.35,
            letterSpacing: .8,
          ),
        ),
        TextButton(
          onPressed: onSignIn,
          style: AppButtonStyles.ghost(),
          child: Text(
            l10n.signIn,
            style: AppTextStyles.label.copyWith(
              color: palette.text,
              fontSize: compact ? 15 : 17,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
              decoration: TextDecoration.underline,
              decorationColor: palette.text,
              decorationThickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
