import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({
    required this.onSubmit,
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
  final TextEditingController emailController;
  final ValueChanged<String> onEmailChanged;
  final String? emailError;
  final String? errorMessage;
  final String? successMessage;
  final bool isSubmitting;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onChanged: onEmailChanged,
          enabled: !isSubmitting,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: compact ? 16 : 18,
            height: 1.35,
          ),
          decoration: InputDecoration(
            hintText: l10n.emailAddressHint,
            errorText: emailError,
            hintStyle: AppTextStyles.bodyLg.copyWith(
              color: AppColors.textSecondary,
              fontSize: compact ? 16 : 18,
            ),
            filled: true,
            fillColor: AppColors.surfaceElevated,
            contentPadding: EdgeInsets.symmetric(
              horizontal: compact ? AppSizes.lg : AppSizes.xl,
              vertical: compact ? 16 : 18,
            ),
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(
              const BorderSide(color: AppColors.primary, width: 1.2),
            ),
          ),
        ),
        SizedBox(height: compact ? AppSizes.lg : AppSizes.xl),
        if (errorMessage != null) ...[
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.error,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
        if (successMessage != null) ...[
          Text(
            successMessage!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
        SizedBox(
          width: double.infinity,
          height: compact ? 54 : 58,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onSubmit,
            style: AppButtonStyles.filledPill(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
              fontSize: compact ? 14 : 15,
              letterSpacing: .2,
            ).copyWith(
              elevation: WidgetStateProperty.all(1),
              shadowColor: WidgetStateProperty.all(
                AppColors.primary.withValues(alpha: .2),
              ),
            ),
            child: isSubmitting
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColors.textInverse,
                    ),
                  )
                : Text(l10n.sendResetLink),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border([BorderSide? side]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      borderSide: side ?? const BorderSide(color: AppColors.divider, width: 1),
    );
  }
}
