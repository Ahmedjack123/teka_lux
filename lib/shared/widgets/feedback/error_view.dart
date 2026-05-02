import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../buttons/secondary_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    this.title,
    this.actionLabel,
    this.onRetry,
    super.key,
  });

  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resolvedTitle = title ?? l10n.genericErrorTitle;
    final resolvedActionLabel = actionLabel ?? l10n.retryAction;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 44,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              resolvedTitle,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.lg),
              SecondaryButton(label: resolvedActionLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
