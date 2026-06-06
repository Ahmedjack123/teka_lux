import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/forms/archive_text_field.dart';

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
    final palette = AppAuthPalette.of(context);

    return Column(
      children: [
        ArchiveTextField(
          controller: emailController,
          label: l10n.emailHint,
          hint: l10n.emailAddressHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onChanged: onEmailChanged,
          enabled: !isSubmitting,
          errorText: emailError,
          boxed: true,
        ),
        SizedBox(height: compact ? AppSizes.lg : AppSizes.xl),
        if (errorMessage != null) ...[
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: palette.error,
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
              color: palette.success,
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
              backgroundColor: palette.accent,
              foregroundColor: palette.onAccent,
              fontSize: compact ? 20 : 24,
              letterSpacing: 1.4,
            ).copyWith(
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
            ),
            child: isSubmitting
                ? SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: palette.onAccent,
                    ),
                  )
                : Text(l10n.sendResetLink),
          ),
        ),
      ],
    );
  }
}
