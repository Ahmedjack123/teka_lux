import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSizes.lg : AppSizes.xl,
        vertical: compact ? AppSizes.xl : AppSizes.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(compact ? 42 : 48),
        border: Border.all(color: AppColors.divider.withValues(alpha: .74)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textStrong.withValues(alpha: .035),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
      ),
    );
  }
}
