import 'package:flutter/material.dart';

import '../../../core/theming/app_sizes.dart';
import 'skeleton_loader.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({this.itemCount = 6, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.md),
      itemBuilder: (_, __) {
        return const SkeletonLoader(height: 92);
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
      itemCount: itemCount,
    );
  }
}
