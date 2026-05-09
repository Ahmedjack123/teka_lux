import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../core/utils/device_helper.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../../../shared/widgets/buttons/secondary_button.dart';

class VerifyEmailScaffold extends StatelessWidget {
  const VerifyEmailScaffold({
    required this.isResending,
    required this.resendSecondsRemaining,
    required this.onResend,
    required this.onBackToLogin,
    this.message,
    this.errorMessage,
    super.key,
  });

  final bool isResending;
  final int resendSecondsRemaining;
  final VoidCallback onResend;
  final VoidCallback onBackToLogin;
  final String? message;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);
    final canResend = !isResending && resendSecondsRemaining == 0;
    final resendLabel = resendSecondsRemaining > 0
        ? l10n.emailVerificationResendCountdown(resendSecondsRemaining)
        : l10n.emailVerificationResend;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: AppSizes.xl,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: DeviceHelper.value(
                  context: context,
                  phone: AppBreakpoints.phoneMaxContentWidth,
                  tablet: 560,
                  desktop: 600,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.emailVerificationTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      l10n.emailVerificationDescription,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textBody,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),
                    if (message != null) ...[
                      _StatusText(message!, color: AppColors.success),
                      const SizedBox(height: AppSizes.md),
                    ],
                    if (errorMessage != null) ...[
                      _StatusText(errorMessage!, color: AppColors.error),
                      const SizedBox(height: AppSizes.md),
                    ],
                    PrimaryButton(
                      label: resendLabel,
                      onPressed: canResend ? onResend : null,
                      isLoading: isResending,
                    ),
                    const SizedBox(height: AppSizes.md),
                    SecondaryButton(
                      label: l10n.emailVerificationBackToLogin,
                      onPressed: onBackToLogin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(color: color, height: 1.35),
    );
  }
}
