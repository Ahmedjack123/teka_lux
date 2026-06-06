import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/forms/archive_text_field.dart';

class SignUpFormFields extends StatelessWidget {
  const SignUpFormFields({
    required this.nameController,
    required this.phoneNumberController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNameChanged,
    required this.onPhoneNumberChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    this.nameError,
    this.phoneNumberError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.enabled = true,
    this.compact = false,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final String? nameError;
  final String? phoneNumberError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool enabled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fieldGap = SizedBox(height: compact ? AppSizes.lg : AppSizes.xl);

    return Column(
      children: [
        ArchiveTextField(
          controller: nameController,
          label: l10n.fullNameLabel,
          hint: l10n.fullNameHint,
          textInputAction: TextInputAction.next,
          errorText: nameError,
          onChanged: onNameChanged,
          enabled: enabled,
        ),
        fieldGap,
        ArchiveTextField(
          controller: phoneNumberController,
          label: l10n.phoneNumberLabel,
          hint: l10n.phoneNumberHint,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          errorText: phoneNumberError,
          onChanged: onPhoneNumberChanged,
          enabled: enabled,
        ),
        fieldGap,
        ArchiveTextField(
          controller: emailController,
          label: l10n.emailHint,
          hint: l10n.registerEmailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: emailError,
          onChanged: onEmailChanged,
          enabled: enabled,
        ),
        fieldGap,
        ArchiveTextField(
          controller: passwordController,
          label: l10n.passwordHint,
          hint: l10n.passwordPlaceholder,
          obscureText: true,
          textInputAction: TextInputAction.next,
          errorText: passwordError,
          onChanged: onPasswordChanged,
          enabled: enabled,
        ),
        fieldGap,
        ArchiveTextField(
          controller: confirmPasswordController,
          label: l10n.confirmPasswordHint,
          hint: l10n.passwordPlaceholder,
          obscureText: true,
          textInputAction: TextInputAction.done,
          errorText: confirmPasswordError,
          onChanged: onConfirmPasswordChanged,
          enabled: enabled,
        ),
      ],
    );
  }
}
