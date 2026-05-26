import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Subtle halftone dot pattern at the top of the screen,
/// fading out toward the middle. Drives the "premium / festive" feel.
class BackgroundDots extends StatelessWidget {
  const BackgroundDots({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BackgroundDotsPainter(), size: Size.infinite);
  }
}

class _BackgroundDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const spacing = 14.0;
    final patternHeight = size.height * 0.32;

    for (double y = 0; y < patternHeight; y += spacing) {
      // Stagger every other row by half-spacing for a halftone feel.
      final rowOffset = (y / spacing).floor().isEven ? 0.0 : spacing / 2;
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        final dx = x + rowOffset;
        final t = 1.0 - (y / patternHeight); // fade top → bottom
        final opacity = (t * 0.45).clamp(0.0, 1.0);
        final dotSize = 1.2 + (1.4 * t);
        paint.color = AppColors.walletGold.withValues(alpha: opacity);
        canvas.drawCircle(Offset(dx, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundDotsPainter oldDelegate) => false;
}
