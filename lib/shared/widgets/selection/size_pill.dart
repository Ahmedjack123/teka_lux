import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';

class SizePill extends StatelessWidget {
  const SizePill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: AppLocalizations.of(context).sizeSemanticsLabel(label),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 40),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected
                  ? AppColors.textInverse
                  : enabled
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
