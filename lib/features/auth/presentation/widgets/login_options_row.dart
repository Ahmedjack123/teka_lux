import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../../l10n/generated/app_localizations.dart';

class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
    super.key,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        SizedBox.square(
          dimension: 28,
          child: Checkbox(
            value: rememberMe,
            onChanged: (value) => onRememberChanged(value ?? false),
            shape: const CircleBorder(),
            side: const BorderSide(
              color: AppColors.divider,
              width: 1.6,
            ),
            activeColor: AppColors.primaryDark,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            l10n.rememberMe,
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.textStrong,
            ),
          ),
        ),
        TextButton(
          onPressed: onForgotPassword,
          style: AppButtonStyles.ghost(),
          child: Text(
            l10n.forgotPassword,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primaryDark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
