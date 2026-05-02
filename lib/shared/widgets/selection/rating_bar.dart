import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';

class RatingBar extends StatelessWidget {
  const RatingBar({
    required this.rating,
    this.itemCount = 5,
    this.iconSize = 20,
    this.reviewCount,
    this.showValue = false,
    super.key,
  });

  final double rating;
  final int itemCount;
  final double iconSize;
  final int? reviewCount;
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    final clampedRating = rating.clamp(0, itemCount).toDouble();
    final ratingLabel = clampedRating.toStringAsFixed(1);

    return Semantics(
      label: AppLocalizations.of(context).ratingSemanticsLabel(
        ratingLabel,
        itemCount,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < itemCount; index++)
            Icon(
              _iconFor(index, clampedRating),
              size: iconSize,
              color: AppColors.warning,
            ),
          if (showValue || reviewCount != null) ...[
            const SizedBox(width: AppSizes.xs),
            Text(
              [
                if (showValue) ratingLabel,
                if (reviewCount != null) '($reviewCount)',
              ].join(' '),
              style: AppTextStyles.caption,
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconFor(int index, double value) {
    final starValue = index + 1;
    if (value >= starValue) {
      return Icons.star_rounded;
    }
    if (value > index && value < starValue) {
      return Icons.star_half_rounded;
    }
    return Icons.star_border_rounded;
  }
}
