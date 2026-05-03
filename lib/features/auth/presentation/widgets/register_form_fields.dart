import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/forms/app_text_field.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({
    this.compact = false,
    super.key,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fieldPadding = EdgeInsets.symmetric(
      horizontal: AppSizes.lg,
      vertical: compact ? 14 : 16,
    );
    final fieldGap = SizedBox(height: compact ? AppSizes.sm : AppSizes.md);

    return Column(
      children: [
        AppTextField(
          hint: l10n.fullNameHint,
          textInputAction: TextInputAction.next,
          borderRadius: AppSizes.radiusLg,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
        fieldGap,
        AppTextField(
          hint: l10n.emailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          borderRadius: AppSizes.radiusLg,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
        fieldGap,
        AppTextField(
          hint: l10n.passwordHint,
          obscureText: true,
          textInputAction: TextInputAction.next,
          borderRadius: AppSizes.radiusLg,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
        fieldGap,
        AppTextField(
          hint: l10n.confirmPasswordHint,
          obscureText: true,
          textInputAction: TextInputAction.done,
          borderRadius: AppSizes.radiusLg,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
      ],
    );
  }
}
