import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/forms/archive_text_field.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({
    required this.emailController,
    required this.passwordController,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onForgotPassword,
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
  final VoidCallback onForgotPassword;
  final String? emailError;
  final String? passwordError;
  final bool enabled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        ArchiveTextField(
          controller: emailController,
          label: l10n.emailHint,
          hint: l10n.loginEmailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: emailError,
          onChanged: onEmailChanged,
          enabled: enabled,
        ),
        SizedBox(height: compact ? AppSizes.lg : AppSizes.xl),
        ArchiveTextField(
          controller: passwordController,
          label: l10n.passwordHint,
          hint: l10n.passwordPlaceholder,
          obscureText: true,
          textInputAction: TextInputAction.done,
          errorText: passwordError,
          onChanged: onPasswordChanged,
          enabled: enabled,
          trailingLabel: l10n.forgotPassword,
          onTrailingPressed: onForgotPassword,
        ),
      ],
    );
  }
}
