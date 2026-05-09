import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../core/utils/device_helper.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../shared/widgets/buttons/primary_button.dart';

class VerifyEmailSuccessScaffold extends StatelessWidget {
  const VerifyEmailSuccessScaffold({
    required this.onNext,
    super.key,
  });

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

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
              child: _SuccessCard(onNext: onNext),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .08),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SuccessMark(),
          const SizedBox(height: AppSizes.xl),
          const _SuccessCopy(),
          const SizedBox(height: AppSizes.xl),
          _NextButton(onNext: onNext),
        ],
      ),
    );
  }
}

class _SuccessMark extends StatelessWidget {
  const _SuccessMark();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .72, end: 1),
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: .2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: .18),
            width: 1.2,
          ),
        ),
        child: const Icon(
          Icons.check_rounded,
          color: AppColors.primary,
          size: 56,
        ),
      ),
    );
  }
}

class _SuccessCopy extends StatelessWidget {
  const _SuccessCopy();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
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
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PrimaryButton(
      label: l10n.emailVerificationNext,
      icon: Icons.arrow_forward_rounded,
      onPressed: onNext,
    );
  }
}
