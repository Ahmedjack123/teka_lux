import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({
    required this.onSubmit,
    this.compact = false,
    super.key,
  });

  final VoidCallback onSubmit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: compact ? 16 : 18,
            height: 1.35,
          ),
          decoration: InputDecoration(
            hintText: l10n.emailAddressHint,
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
        SizedBox(
          width: double.infinity,
          height: compact ? 54 : 58,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: AppButtonStyles.filledPill(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.textInverse,
              fontSize: compact ? 14 : 15,
              letterSpacing: 1.6,
            ).copyWith(
              elevation: WidgetStateProperty.all(0),
              shadowColor: WidgetStateProperty.all(
                AppColors.primaryDark.withValues(alpha: .16),
              ),
            ),
            child: Text(l10n.sendResetLink),
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
