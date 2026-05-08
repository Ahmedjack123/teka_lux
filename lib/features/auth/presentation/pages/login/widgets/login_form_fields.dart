import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/forms/app_text_field.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({
    required this.emailController,
    required this.passwordController,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    this.emailError,
    this.passwordError,
    this.enabled = true,
    this.compact = false,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final String? emailError;
  final String? passwordError;
  final bool enabled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fieldPadding = EdgeInsets.symmetric(
      horizontal: AppSizes.lg,
      vertical: compact ? 15 : 17,
    );

    return Column(
      children: [
        AppTextField(
          controller: emailController,
          hint: l10n.emailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: emailError,
          onChanged: onEmailChanged,
          enabled: enabled,
          borderRadius: AppSizes.radiusLg,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
        SizedBox(height: compact ? AppSizes.sm : AppSizes.md),
        AppTextField(
          controller: passwordController,
          hint: l10n.passwordHint,
          obscureText: true,
          textInputAction: TextInputAction.done,
          errorText: passwordError,
          onChanged: onPasswordChanged,
          enabled: enabled,
          borderRadius: AppSizes.radiusLg,
          fillColor: AppColors.inputFill,
          contentPadding: fieldPadding,
        ),
      ],
    );
  }
}
