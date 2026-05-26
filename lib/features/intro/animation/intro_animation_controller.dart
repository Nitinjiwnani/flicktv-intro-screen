import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/confetti_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../painters/particle.dart';

/// Owns all three AnimationControllers for the intro screen:
///   master   - 4 500 ms one-shot entrance sequence
///   wobble   - 2 800 ms repeating wallet tilt
///   confetti - timed to lifespan of the particle burst
///
/// All Animation values are derived here via Interval curves.
/// The intro screen builds one AnimatedBuilder on
/// Listenable.merge and reads .value from each animation.
/// Widgets receive plain doubles, not Animation objects.
class IntroAnimationController {
  final AnimationController master;
  final AnimationController wobble;
  final AnimationController confetti;

  late final List<Particle> particles;

  // ── Entrance animations (driven by master) ──────────────────────────────
  late final Animation<double> walletDrop;
  late final Animation<double> blinkitFade;
  late final Animation<double> moneyScale;
  late final Animation<double> card1Slide;
  late final Animation<double> card2Slide;
  late final Animation<double> card3Slide;
  late final Animation<double> buttonReveal;
  late final Animation<double> giftCardReveal;
  late final Animation<double> taglineFade;

  // ── Continuous wobble (driven by wobble controller) ──────────────────────
  late final Animation<double> walletWobble;

  double get confettiTime =>
      confetti.value * ConfettiConstants.lifespan;

  IntroAnimationController({required TickerProvider vsync})
      : master = AnimationController(
          duration: const Duration(milliseconds: 8000),
          vsync: vsync,
        ),
        wobble = AnimationController(
          duration: const Duration(milliseconds: 2800),
          vsync: vsync,
        ),
        confetti = AnimationController(
          duration: Duration(
            milliseconds: (ConfettiConstants.lifespan * 1000).round(),
          ),
          vsync: vsync,
        ) {
    _setupAnimations();
    _spawnParticles();
  }

  void _setupAnimations() {
    walletDrop = CurvedAnimation(
      parent: master,
      curve: const Interval(0.00, 0.20, curve: Curves.easeOutBack),
    );
    blinkitFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.22, 0.32, curve: Curves.easeOut),
    );
    moneyScale = CurvedAnimation(
      parent: master,
      curve: const Interval(0.28, 0.42, curve: Curves.elasticOut),
    );
    card1Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.42, 0.55, curve: Curves.easeOutCubic),
    );
    card2Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.50, 0.63, curve: Curves.easeOutCubic),
    );
    card3Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.58, 0.71, curve: Curves.easeOutCubic),
    );
    buttonReveal = CurvedAnimation(
      parent: master,
      curve: const Interval(0.72, 0.82, curve: Curves.easeOutBack),
    );
    giftCardReveal = CurvedAnimation(
      parent: master,
      curve: const Interval(0.78, 0.88, curve: Curves.easeOut),
    );
    taglineFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.88, 1.00, curve: Curves.easeIn),
    );
    walletWobble = CurvedAnimation(
      parent: wobble,
      curve: Curves.easeInOut,
    );
  }

  void _spawnParticles() {
    final rng = math.Random(42); // seeded → deterministic burst
    final colors = AppColors.confettiColors;
    final list = <Particle>[];

    for (int i = 0; i < ConfettiConstants.particleCount; i++) {
      final color = colors[rng.nextInt(colors.length)];

      // Spawn from top-center area of screen
      final startX = 0.25 + rng.nextDouble() * 0.50; // 25 %–75 % width
      final startY =
          rng.nextDouble() * ConfettiConstants.spawnAreaHeightFraction;

      // Horizontal spread
      final vx = ConfettiConstants.minHorizontalVelocity +
          rng.nextDouble() *
              (ConfettiConstants.maxHorizontalVelocity -
                  ConfettiConstants.minHorizontalVelocity);

      // Mix of upward and downward initial vertical velocity for burst effect
      final speed = ConfettiConstants.minVerticalVelocity +
          rng.nextDouble() *
              (ConfettiConstants.maxVerticalVelocity -
                  ConfettiConstants.minVerticalVelocity);
      final vy = rng.nextBool() ? -speed : speed * 0.3;

      final rotSpeed = ConfettiConstants.minRotationSpeed +
          rng.nextDouble() *
              (ConfettiConstants.maxRotationSpeed -
                  ConfettiConstants.minRotationSpeed);
      final rotation0 = rng.nextDouble() * 2 * math.pi;

      final size = ConfettiConstants.minSize +
          rng.nextDouble() *
              (ConfettiConstants.maxSize - ConfettiConstants.minSize);

      // Small stagger so the burst unfolds rather than appearing all at once
      final startDelay = rng.nextDouble() * 0.35;

      list.add(Particle(
        startX: startX,
        startY: startY,
        vx: vx,
        vy: vy,
        rotation0: rotation0,
        rotationSpeed: rotSpeed,
        width: size,
        height: size * (0.45 + rng.nextDouble() * 0.55),
        color: color,
        startDelay: startDelay,
      ));
    }

    particles = list;
  }

  void start() {
    wobble.repeat(reverse: true);
    master.forward();
    master.addListener(_checkConfettiStart);
  }

  void _checkConfettiStart() {
    if (master.value >= 0.10 &&
        !confetti.isAnimating &&
        confetti.value == 0.0) {
      master.removeListener(_checkConfettiStart);
      confetti.forward();
    }
  }

  void dispose() {
    master.removeListener(_checkConfettiStart);
    master.dispose();
    wobble.dispose();
    confetti.dispose();
  }
}
