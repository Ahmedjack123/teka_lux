import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class ColorSwatch extends StatelessWidget {
  const ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
    this.label,
    this.size = 36,
    this.enabled = true,
    super.key,
  });

  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final String? label;
  final double size;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final fallbackLabel = AppLocalizations.of(context).colorOptionTooltip;
    final resolvedLabel = label ?? fallbackLabel;
    final swatch = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryDark : AppColors.divider,
          width: selected ? 2 : 1,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? color : color.withValues(alpha: .28),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withValues(alpha: .06)),
        ),
        child: selected
            ? const Icon(Icons.check, size: 16, color: AppColors.textInverse)
            : null,
      ),
    );

    return Tooltip(
      message: resolvedLabel,
      child: Semantics(
        button: true,
        selected: selected,
        label: resolvedLabel,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: const CircleBorder(),
          child: swatch,
        ),
      ),
    );
  }
}
