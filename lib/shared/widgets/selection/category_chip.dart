import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';
import '../../../core/theming/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: onSelected,
      avatar: icon == null ? null : Icon(icon, size: 16),
      label: Text(label),
      labelStyle: AppTextStyles.label.copyWith(
        color: selected ? AppColors.textInverse : AppColors.textPrimary,
      ),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.divider,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      showCheckmark: false,
    );
  }
}
