import 'package:flutter/material.dart';

import '../../../core/theming/theming.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.height,
    this.radius,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppButtonStyles.primary(radius: radius ?? AppSizes.radiusLg),
        child: _ButtonContent(
          label: label,
          icon: icon,
          isLoading: isLoading,
          loadingColor: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.loadingColor,
    this.icon,
  });

  final String label;
  final bool isLoading;
  final Color loadingColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox.square(
        dimension: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: loadingColor,
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
