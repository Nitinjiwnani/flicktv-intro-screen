import 'dart:ui';

class Particle {
  final double startX; // fractional (0.0–1.0) of screen width
  final double startY; // fractional (0.0–1.0) of screen height
  final double vx; // px/s, horizontal
  final double vy; // px/s, vertical (negative = upward)
  final double rotation0; // initial rotation in radians
  final double rotationSpeed; // rad/s
  final double width;
  final double height;
  final Color color;
  final double startDelay; // seconds before this particle activates

  const Particle({
    required this.startX,
    required this.startY,
    required this.vx,
    required this.vy,
    required this.rotation0,
    required this.rotationSpeed,
    required this.width,
    required this.height,
    required this.color,
    required this.startDelay,
  });
}
