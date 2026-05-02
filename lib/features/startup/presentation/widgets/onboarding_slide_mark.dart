import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theming/theming.dart';

class OnboardingSlideMark extends StatelessWidget {
  const OnboardingSlideMark({
    required this.index,
    super.key,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return const Icon(
        LucideIcons.scissors,
        color: AppColors.primary,
        size: 46,
      );
    }

    return const SizedBox.shrink();
  }
}
