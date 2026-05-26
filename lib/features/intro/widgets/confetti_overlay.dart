import 'package:flutter/material.dart';
import '../../../painters/confetti_painter.dart';
import '../../../painters/particle.dart';

/// Full-screen confetti layer. Completely non-interactive (IgnorePointer
/// is applied by the parent Stack so hit-testing is never reached here).
class ConfettiOverlay extends StatelessWidget {
  final List<Particle> particles;
  final double t; // elapsed seconds from confetti controller

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
