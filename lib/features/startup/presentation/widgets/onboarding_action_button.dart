import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';

class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final foreground =
        isSecondary ? AppColors.textStrong : AppColors.textInverse;
    final background =
        isSecondary ? AppColors.surfaceElevated : AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: AppSizes.largeButtonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppButtonStyles.filledPill(
          backgroundColor: background,
          foregroundColor: foreground,
          letterSpacing: .2,
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: foreground,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: AppSizes.md),
                    Icon(icon, size: 24),
                  ],
                ],
              ),
      ),
    );
  }
}
