import 'package:flutter/material.dart';

import '../../../../../../core/theming/theming.dart';
import '../../../../../../l10n/generated/app_localizations.dart';

class SignUpTermsAgreement extends StatelessWidget {
  const SignUpTermsAgreement({
    required this.accepted,
    required this.onChanged,
    this.errorText,
    this.compact = false,
    super.key,
  });

  final bool accepted;
  final ValueChanged<bool> onChanged;
  final String? errorText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppAuthPalette.of(context);
    final baseStyle = AppTextStyles.bodyLg.copyWith(
      color: palette.text,
      fontSize: compact ? 15 : 17,
      height: 1.45,
      fontWeight: FontWeight.w500,
    );
    final linkStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w900,
      decoration: TextDecoration.underline,
      decorationColor: palette.text,
      decorationThickness: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: compact ? 24 : 28,
              child: Checkbox(
                value: accepted,
                onChanged: (value) => onChanged(value ?? false),
                shape: const RoundedRectangleBorder(),
                side: BorderSide(color: palette.text, width: 1.2),
                checkColor: palette.onAccent,
                activeColor: palette.accent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onChanged(!accepted),
                child: RichText(
                  text: TextSpan(
                    style: baseStyle,
                    children: [
                      TextSpan(text: '${l10n.agreeToTermsPrefix} '),
                      TextSpan(
                        text: l10n.termsAndConditions,
                        style: linkStyle,
                      ),
                      TextSpan(text: ' ${l10n.andThe} '),
                      TextSpan(
                        text: l10n.privacyPolicy,
                        style: linkStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSizes.xs),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              errorText!,
              style: AppTextStyles.caption.copyWith(
                color: palette.error,
                height: 1.3,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
