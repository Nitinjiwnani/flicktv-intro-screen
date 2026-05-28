import 'package:flutter/material.dart';
import '../../../painters/confetti_painter.dart';
import '../../../painters/particle.dart';

/// Full-screen confetti layer. Non-interactive — [IgnorePointer] is applied by the parent.
class ConfettiOverlay extends StatelessWidget {
  final List<Particle> particles;
  final double t;

  const ConfettiOverlay({
    super.key,
    required this.particles,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ConfettiCirclePainter(particles: particles, t: t),
      size: Size.infinite,
    );
  }
}
