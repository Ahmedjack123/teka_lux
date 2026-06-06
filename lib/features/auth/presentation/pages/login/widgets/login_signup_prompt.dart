import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class LoginSignupPrompt extends StatelessWidget {
  const LoginSignupPrompt({
    required this.onSignUp,
    this.compact = false,
    super.key,
  });

  final VoidCallback onSignUp;
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
          l10n.noAccount,
          style: AppTextStyles.bodyLg.copyWith(
            color: palette.muted,
            fontSize: compact ? 15 : 17,
            height: 1.35,
            letterSpacing: .9,
          ),
        ),
        TextButton(
          onPressed: onSignUp,
          style: AppButtonStyles.ghost(),
          child: Text(
            l10n.signUp,
            style: AppTextStyles.label.copyWith(
              color: palette.text,
              fontSize: compact ? 15 : 17,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
              decoration: TextDecoration.underline,
              decorationColor: palette.accent,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}
