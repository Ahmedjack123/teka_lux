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
    final palette = AppAuthPalette.of(context);
    final horizontalPadding = DeviceHelper.horizontalPadding(context);
    final canResend =
        !isResending && !isVerified && resendSecondsRemaining == 0;
    final resendLabel = resendSecondsRemaining > 0
        ? l10n.emailVerificationResendCountdown(resendSecondsRemaining)
        : l10n.emailVerificationResend;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: AppSizes.lg,
            ),
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: DeviceHelper.value(
                  context: context,
                  phone: AppBreakpoints.phoneMaxContentWidth,
                  tablet: 560,
                  desktop: 600,
                ),
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
                            l10n.brandShort,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h2.copyWith(
                              color: palette.text,
                              fontSize: 36,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xxl),
                          Text(
                            l10n.emailVerificationTitle,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.display.copyWith(
                              color: palette.text,
                              fontSize: 48,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          Container(
                            width: 120,
                            height: 8,
                            alignment: Alignment.centerLeft,
                            color: palette.accent,
                          ),
                          const SizedBox(height: AppSizes.lg),
                          Text(
                            l10n.emailVerificationDescription,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.bodyLg.copyWith(
                              color: palette.muted,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xl),
                          if (message != null) ...[
                            _StatusText(message!, color: palette.success),
                            const SizedBox(height: AppSizes.md),
                          ],
                          if (errorMessage != null) ...[
                            _StatusText(errorMessage!, color: palette.error),
                            const SizedBox(height: AppSizes.md),
                          ],
                          PrimaryButton(
                            label: resendLabel,
                            onPressed: canResend ? onResend : null,
                            isLoading: isResending,
                            height: 56,
                            radius: 0,
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

class _VerificationSuccess extends StatelessWidget {
  const _VerificationSuccess({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppAuthPalette.of(context);

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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: palette.accent,
              shape: BoxShape.rectangle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: palette.onAccent,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        Text(
          l10n.emailVerificationSuccessTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(
            color: palette.text,
            fontSize: 42,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          l10n.emailVerificationSuccessDescription,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: palette.muted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        PrimaryButton(
          label: l10n.emailVerificationNext,
          icon: Icons.arrow_forward_rounded,
          onPressed: onNext,
          radius: 0,
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
      style: AppTextStyles.label.copyWith(color: color, height: 1.35),
    );
  }
}
