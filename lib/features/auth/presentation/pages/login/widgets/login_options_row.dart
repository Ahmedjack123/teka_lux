import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({
    required this.rememberMe,
    required this.onRememberChanged,
    this.compact = false,
    super.key,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppAuthPalette.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => onRememberChanged(!rememberMe),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: compact ? 23 : 25,
                child: Checkbox(
                  value: rememberMe,
                  onChanged: (value) => onRememberChanged(value ?? false),
                  shape: const RoundedRectangleBorder(),
                  side: BorderSide(
                    color: palette.text,
                    width: 1.2,
                  ),
                  checkColor: palette.onAccent,
                  activeColor: palette.accent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                l10n.rememberMe,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: AppTextStyles.bodyLg.copyWith(
                  color: palette.text,
                  fontSize: compact ? 14 : 15,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
