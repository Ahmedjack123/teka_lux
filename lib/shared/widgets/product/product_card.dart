import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_sizes.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.currencySymbol = r'$',
    this.subtitle,
    this.rating,
    this.reviewCount,
    this.isFavorite = false,
    this.onTap,
    this.onFavoritePressed,
    super.key,
  });

  final String title;
  final num price;
  final String imageUrl;
  final String currencySymbol;
  final String? subtitle;
  final double? rating;
  final int? reviewCount;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final formattedPrice = '$currencySymbol${price.toStringAsFixed(2)}';

    return Semantics(
      button: onTap != null,
      label: AppLocalizations.of(context).productCardSemanticsLabel(
        title,
        formattedPrice,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: .82,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ProductImage(imageUrl: imageUrl),
                      if (onFavoritePressed != null)
                        Positioned(
                          top: AppSizes.xs,
                          right: AppSizes.xs,
                          child: _FavoriteButton(
                            isFavorite: isFavorite,
                            onPressed: onFavoritePressed,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSizes.xxs),
                        Text(
                          subtitle!,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppSizes.xs),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formattedPrice,
                              style: AppTextStyles.priceLg,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (rating != null)
                            _CompactRating(
                              rating: rating!,
                              reviewCount: reviewCount,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const ColoredBox(
        color: AppColors.divider,
        child: Icon(Icons.image_outlined, color: AppColors.textSecondary),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) {
        return const ColoredBox(color: AppColors.divider);
      },
      errorWidget: (_, __, ___) {
        return const ColoredBox(
          color: AppColors.divider,
          child: Icon(Icons.broken_image_outlined),
        );
      },
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return IconButton.filled(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: .78),
        foregroundColor: isFavorite ? AppColors.error : AppColors.textPrimary,
      ),
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      tooltip: isFavorite
          ? l10n.removeFromWishlistTooltip
          : l10n.addToWishlistTooltip,
    );
  }
}

class _CompactRating extends StatelessWidget {
  const _CompactRating({
    required this.rating,
    this.reviewCount,
  });

  final double rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
        const SizedBox(width: AppSizes.xxs),
        Text(
          reviewCount == null
              ? rating.toStringAsFixed(1)
              : '$rating ($reviewCount)',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
