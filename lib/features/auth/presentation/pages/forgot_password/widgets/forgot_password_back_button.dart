import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class ForgotPasswordBackButton extends StatelessWidget {
  const ForgotPasswordBackButton({
    required this.onPressed,
    this.compact = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return TextButton.icon(
      onPressed: onPressed,
      style: AppButtonStyles.ghost().copyWith(
        foregroundColor: WidgetStateProperty.all(AppColors.textBody),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(
        Icons.arrow_back,
        size: compact ? 20 : 22,
        color: AppColors.textBody,
      ),
      label: Text(
        l10n.backToLogin,
        style: AppTextStyles.label.copyWith(
          color: AppColors.textBody,
          fontSize: compact ? 13 : 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.2,
        ),
      ),
    );
  }
}
