import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';

class RegisterLoginPrompt extends StatelessWidget {
  const RegisterLoginPrompt({
    required this.onSignIn,
    this.compact = false,
    super.key,
  });

  final VoidCallback onSignIn;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: compact ? 14 : 15,
            height: 1.35,
          ),
        ),
        TextButton(
          onPressed: onSignIn,
          style: AppButtonStyles.ghost(),
          child: Text(
            l10n.signIn,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primaryDark,
              fontSize: compact ? 14 : 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
