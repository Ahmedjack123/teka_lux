import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    this.width,
    this.height = 16,
    this.radius = AppSizes.radiusMd,
    super.key,
  });

  const SkeletonLoader.circle({
    required double size,
    super.key,
  })  : width = size,
        height = size,
        radius = AppSizes.radiusPill;

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
