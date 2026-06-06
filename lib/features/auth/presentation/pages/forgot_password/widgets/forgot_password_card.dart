import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import 'forgot_password_back_button.dart';
import 'forgot_password_form.dart';
import 'forgot_password_header.dart';

class ForgotPasswordCard extends StatelessWidget {
  const ForgotPasswordCard({
    required this.onSubmit,
    required this.onBackToLogin,
    required this.emailController,
    required this.onEmailChanged,
    this.emailError,
    this.errorMessage,
    this.successMessage,
    this.isSubmitting = false,
    this.compact = false,
    super.key,
  });

  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;
  final TextEditingController emailController;
  final ValueChanged<String> onEmailChanged;
  final String? emailError;
  final String? errorMessage;
  final String? successMessage;
  final bool isSubmitting;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = AppAuthPalette.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: compact ? 210 : 260,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(color: palette.text, width: 1),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppAssets.resetPassword, fit: BoxFit.cover),
              ColoredBox(color: Colors.black.withValues(alpha: .18)),
              Center(
                child: Text(
                  l10n.resetPasswordAccessLabel,
                  style: AppTextStyles.h3.copyWith(
                    color: palette.accent,
                    fontSize: compact ? 28 : 34,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? AppSizes.xl : 54),
        ForgotPasswordHeader(compact: compact),
        SizedBox(height: compact ? AppSizes.xl : AppSizes.xxl),
        ForgotPasswordForm(
          onSubmit: onSubmit,
          emailController: emailController,
          onEmailChanged: onEmailChanged,
          emailError: emailError,
          errorMessage: errorMessage,
          successMessage: successMessage,
          isSubmitting: isSubmitting,
          compact: compact,
        ),
        SizedBox(height: compact ? AppSizes.xl : AppSizes.xxl),
        ForgotPasswordBackButton(
          onPressed: onBackToLogin,
          compact: compact,
        ),
      ],
    );
  }
}
