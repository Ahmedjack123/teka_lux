import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theming/app_auth_palette.dart';
import '../../../../../../core/theming/app_sizes.dart';
import '../../../../../../core/theming/app_text_styles.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = AppAuthPalette.of(context);
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: compact ? 46 : 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: palette.text,
          side: BorderSide(color: palette.text, width: 1.2),
          shape: const RoundedRectangleBorder(),
          textStyle: AppTextStyles.label.copyWith(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: palette.accent,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    isDark ? AppAssets.googleDark : AppAssets.googleLight,
                    width: compact ? 20 : 22,
                    height: compact ? 20 : 22,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Flexible(
                    child: Text(
                      label.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
