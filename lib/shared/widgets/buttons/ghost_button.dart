import 'package:flutter/material.dart';

import '../../../core/theming/theming.dart';

class GhostButton extends StatelessWidget {
  const GhostButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppSizes.touchTarget,
      child: TextButton(
        onPressed: onPressed,
        style: AppButtonStyles.ghost(),
        child: Row(
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
        ),
      ),
    );
  }
}
