import 'package:flutter/material.dart';
import '../core/constants/confetti_constants.dart';
import 'particle.dart';

class ConfettiPainter extends CustomPainter {
  final List<Particle> particles;
  final double t; // elapsed seconds

  const ConfettiPainter({required this.particles, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final dt = (t - p.startDelay).clamp(0.0, ConfettiConstants.lifespan);
      if (dt <= 0) continue;

      final opacity =
          (1.0 - dt / ConfettiConstants.lifespan).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      final x = p.startX * size.width + p.vx * dt;
      final y = p.startY * size.height +
          p.vy * dt +
          0.5 * ConfettiConstants.gravity * dt * dt;

      if (y > size.height + 20 || x < -20 || x > size.width + 20) continue;

      paint.color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation0 + p.rotationSpeed * dt);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.width,
          height: p.height,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter old) => old.t != t;

  @override
  bool? hitTest(Offset position) => false;
}

// Draws a single confetti piece as a rounded rect for variety.
class ConfettiCirclePainter extends CustomPainter {
  final List<Particle> particles;
  final double t;

  const ConfettiCirclePainter({required this.particles, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rrPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final dt = (t - p.startDelay).clamp(0.0, ConfettiConstants.lifespan);
      if (dt <= 0) continue;

      final opacity =
          (1.0 - dt / ConfettiConstants.lifespan).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      final x = p.startX * size.width + p.vx * dt;
      final y = p.startY * size.height +
          p.vy * dt +
          0.5 * ConfettiConstants.gravity * dt * dt;

      if (y > size.height + 20 || x < -20 || x > size.width + 20) continue;

      final color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation0 + p.rotationSpeed * dt);

      // Alternate between rect and circle shapes for variety
      if (i.isEven) {
        paint.color = color;
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.width,
            height: p.height,
          ),
          paint,
        );
      } else {
        rrPaint.color = color;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.width * 0.8,
            height: p.height * 0.8,
          ),
          rrPaint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiCirclePainter old) => old.t != t;

  @override
  bool? hitTest(Offset position) => false;
}
