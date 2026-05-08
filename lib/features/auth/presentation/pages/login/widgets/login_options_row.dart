import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
    this.compact = false,
    super.key,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: InkWell(
            onTap: () => onRememberChanged(!rememberMe),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: compact ? 24 : 26,
                  child: Checkbox(
                    value: rememberMe,
                    onChanged: (value) => onRememberChanged(value ?? false),
                    shape: const CircleBorder(),
                    side: const BorderSide(
                      color: AppColors.divider,
                      width: 1.6,
                    ),
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: AppSizes.xs),
                Flexible(
                  child: Text(
                    l10n.rememberMe,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.textStrong,
                      fontSize: compact ? 11 : 12,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 0,
          child: TextButton(
            onPressed: onForgotPassword,
            style: AppButtonStyles.ghost().copyWith(
              minimumSize: WidgetStateProperty.all(Size.zero),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              l10n.forgotPassword,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(
                color: AppColors.primary,
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: .2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
