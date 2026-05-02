import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.child,
    this.title,
    this.showHandle = true,
    super.key,
  });

  final Widget child;
  final Widget? title;
  final bool showHandle;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Widget? title,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AppBottomSheet(title: title, child: builder(context));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLg),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.sm,
          AppSizes.md,
          AppSizes.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showHandle) ...[
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
            ],
            if (title != null) ...[
              title!,
              const SizedBox(height: AppSizes.md),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
