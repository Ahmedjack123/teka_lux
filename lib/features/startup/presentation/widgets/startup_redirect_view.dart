import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';

class StartupRedirectView extends StatelessWidget {
  const StartupRedirectView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox.expand(),
    );
  }
}
