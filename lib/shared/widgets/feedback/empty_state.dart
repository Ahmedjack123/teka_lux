import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';
import '../../../core/theming/app_text_styles.dart';
import '../buttons/primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.headline,
    this.message,
    this.illustration,
    this.icon,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String headline;
  final String? message;
  final Widget? illustration;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              illustration ?? _EmptyIcon(icon: icon),
              const SizedBox(height: AppSizes.lg),
              Text(
                headline,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: AppSizes.xs),
                Text(
                  message!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSizes.lg),
                PrimaryButton(
                  label: actionLabel!,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyIcon extends StatelessWidget {
  const _EmptyIcon({this.icon});

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon ?? Icons.shopping_bag_outlined,
        size: 38,
        color: AppColors.primaryDark,
      ),
    );
  }
}
