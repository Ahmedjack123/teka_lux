import 'package:flutter/material.dart';

import '../../../core/theming/theming.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppButtonStyles.secondary(),
        child: _SecondaryButtonContent(
          label: label,
          icon: icon,
          isLoading: isLoading,
        ),
      ),
    );
  }
}

class _SecondaryButtonContent extends StatelessWidget {
  const _SecondaryButtonContent({
    required this.label,
    required this.isLoading,
    this.icon,
  });

  final String label;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.square(
        dimension: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: AppColors.primary,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppSizes.xs),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
