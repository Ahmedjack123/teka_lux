import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({
    required this.tag,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    super.key,
  });

  final String tag;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = imageUrl != null && imageUrl!.isNotEmpty
        ? FadeInImage.assetNetwork(
            placeholder: 'assets/images/placeholder.png',
            image: imageUrl!,
            fit: fit,
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 250),
            imageErrorBuilder: (_, __, ___) => _placeholder(),
          )
        : _placeholder();

    final child = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: image,
    );

    return Hero(
      tag: tag,
      child: child,
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
