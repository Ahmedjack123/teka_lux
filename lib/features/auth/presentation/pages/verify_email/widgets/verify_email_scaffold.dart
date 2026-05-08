import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../core/utils/device_helper.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../../../shared/widgets/buttons/secondary_button.dart';

class VerifyEmailScaffold extends StatelessWidget {
  const VerifyEmailScaffold({
    required this.isResending,
    required this.isVerified,
    required this.resendSecondsRemaining,
    required this.onResend,
    required this.onBackToLogin,
    required this.onNextToHome,
    this.message,
    this.errorMessage,
    super.key,
  });

  final bool isResending;
  final bool isVerified;
  final int resendSecondsRemaining;
  final VoidCallback onResend;
  final VoidCallback onBackToLogin;
  final VoidCallback onNextToHome;
  final String? message;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);
    final canResend =
        !isResending && !isVerified && resendSecondsRemaining == 0;
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: isVerified
                      ? _VerificationSuccess(onNext: onNextToHome)
                      : Column(
                          key: const ValueKey('verify-email-form'),
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
                              _StatusText(errorMessage!,
                                  color: AppColors.error),
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
      ),
    );
  }
}

class _VerificationSuccess extends StatelessWidget {
  const _VerificationSuccess({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      key: const ValueKey('verify-email-success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: .78, end: 1),
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.primaryDark,
              size: 54,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        Text(
          l10n.emailVerificationSuccessTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(color: AppColors.textStrong),
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          l10n.emailVerificationSuccessDescription,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textBody,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        PrimaryButton(
          label: l10n.emailVerificationNext,
          icon: Icons.arrow_forward_rounded,
          onPressed: onNext,
        ),
      ],
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
