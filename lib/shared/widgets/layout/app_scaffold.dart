import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.md),
    this.safeArea = true,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: body);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: safeArea ? SafeArea(child: content) : content,
    );
  }
}
