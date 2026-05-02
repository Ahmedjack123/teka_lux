import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/forms/app_text_field.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const fieldPadding = EdgeInsets.symmetric(
      horizontal: AppSizes.lg,
      vertical: 22,
    );

    return Column(
      children: [
        AppTextField(
          hint: l10n.emailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          borderRadius: AppSizes.radiusXl,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
        const SizedBox(height: AppSizes.md),
        AppTextField(
          hint: l10n.passwordHint,
          obscureText: true,
          textInputAction: TextInputAction.done,
          borderRadius: AppSizes.radiusXl,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
      ],
    );
  }
}
