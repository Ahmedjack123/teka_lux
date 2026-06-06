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
    final palette = AppAuthPalette.of(context);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppButtonStyles.secondary(radius: 0).copyWith(
          foregroundColor: WidgetStateProperty.all(palette.text),
          side: WidgetStateProperty.all(
            BorderSide(color: palette.text, width: 1.2),
          ),
        ),
        child: _SecondaryButtonContent(
          label: label,
          icon: icon,
          isLoading: isLoading,
          loadingColor: palette.accent,
        ),
      ),
    );
  }
}

class _SecondaryButtonContent extends StatelessWidget {
  const _SecondaryButtonContent({
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
