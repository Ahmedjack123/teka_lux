import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';

class AuthPlaceholderView extends StatelessWidget {
  const AuthPlaceholderView({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: DeviceHelper.maxContentWidth(context),
            ),
            child: Padding(
              padding: EdgeInsets.all(DeviceHelper.horizontalPadding(context)),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
