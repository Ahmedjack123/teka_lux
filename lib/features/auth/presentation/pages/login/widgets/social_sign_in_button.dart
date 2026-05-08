import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../../core/theming/app_colors.dart';
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
    return SizedBox(
      width: double.infinity,
      height: compact ? 52 : 54,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.divider, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          ),
          textStyle: AppTextStyles.label.copyWith(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.primary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _GoogleMark(),
                  const SizedBox(width: AppSizes.sm),
                  Flexible(
                    child: Text(
                      label,
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

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 22,
      child: CustomPaint(painter: _GoogleMarkPainter()),
    );
  }
}

class _GoogleMarkPainter extends CustomPainter {
  const _GoogleMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * .36;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final stroke = size.width * .14;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = stroke;

    void arc(Color color, double startDegrees, double sweepDegrees) {
      paint.color = color;
      canvas.drawArc(
        rect,
        startDegrees * math.pi / 180,
        sweepDegrees * math.pi / 180,
        false,
        paint,
      );
    }

    arc(const Color(0xFFEA4335), 205, 105);
    arc(const Color(0xFFFBBC05), 150, 58);
    arc(const Color(0xFF34A853), 48, 102);
    arc(const Color(0xFF4285F4), -38, 86);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = stroke;
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(size.width * .86, center.dy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
