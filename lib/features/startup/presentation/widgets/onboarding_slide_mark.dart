import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theming/theming.dart';

class OnboardingSlideMark extends StatelessWidget {
  const OnboardingSlideMark({
    required this.index,
    required this.eyebrow,
    super.key,
  });

  final int index;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return const Icon(
        LucideIcons.scissors,
        color: AppColors.primary,
        size: 46,
      );
    }

    return Text(
      eyebrow,
      style: AppTextStyles.h2.copyWith(
        color: AppColors.textStrong,
        fontSize: 24,
        fontStyle: FontStyle.italic,
        letterSpacing: 6,
      ),
    );
  }
}
