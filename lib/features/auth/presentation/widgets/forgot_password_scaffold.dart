import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';
import 'forgot_password_backdrop.dart';
import 'forgot_password_card.dart';

class ForgotPasswordScaffold extends StatelessWidget {
  const ForgotPasswordScaffold({
    required this.onSubmit,
    required this.onBackToLogin,
    super.key,
  });

  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: Stack(
        children: [
          const Positioned.fill(child: ForgotPasswordBackdrop()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 720;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: compact ? AppSizes.lg : AppSizes.xxl,
                  ),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: DeviceHelper.value(
                            context: context,
                            phone: AppBreakpoints.phoneMaxContentWidth,
                            tablet: 560,
                            desktop: 600,
                          ),
                        ),
                        child: ForgotPasswordCard(
                          onSubmit: onSubmit,
                          onBackToLogin: onBackToLogin,
                          compact: compact,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
