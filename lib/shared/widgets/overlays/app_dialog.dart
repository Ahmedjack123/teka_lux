import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';
import '../../../core/theming/app_text_styles.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.child,
    this.actions = const [],
    super.key,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    List<Widget> actions = const [],
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) {
        return AppDialog(
          title: title,
          actions: actions,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceElevated,
      insetPadding: const EdgeInsets.all(AppSizes.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppTextStyles.h2),
            const SizedBox(height: AppSizes.md),
            child,
            if (actions.isNotEmpty) ...[
              const SizedBox(height: AppSizes.lg),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
