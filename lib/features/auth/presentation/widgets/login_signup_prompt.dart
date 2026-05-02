import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';

class LoginSignupPrompt extends StatelessWidget {
  const LoginSignupPrompt({
    required this.onSignUp,
    super.key,
  });

  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.noAccount,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: onSignUp,
          style: AppButtonStyles.ghost(),
          child: Text(
            l10n.signUp,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primaryDark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
