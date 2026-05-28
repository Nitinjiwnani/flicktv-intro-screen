/// Tuning constants for the confetti particle system.
/// Adjust these to taste during the polish pass.
class ConfettiConstants {
  ConfettiConstants._();

  static const int particleCount = 80;
  static const double gravity = 380.0; // px/s²
  static const double minSize = 3.5;  // was 5.0  — ~30 % finer
  static const double maxSize = 8.5;  // was 12.0 — ~30 % finer
  static const double minHorizontalVelocity = -120.0;
  static const double maxHorizontalVelocity = 120.0;
  static const double minVerticalVelocity = 40.0;
  static const double maxVerticalVelocity = 180.0;
  static const double minRotationSpeed = -4.0; // rad/s
  static const double maxRotationSpeed = 4.0;
  static const double lifespan = 2.8; // seconds
  static const double spawnAreaHeightFraction = 0.15; // top 15% of screen
}