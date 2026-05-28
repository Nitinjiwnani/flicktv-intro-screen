import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/confetti_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../painters/particle.dart';

/// Orchestrates the 8-second intro animation.
///
/// Owns three controllers:
///   master   — 8 000 ms one-shot entrance sequence.
///   wobble   — 2 800 ms repeating tilt for the wallet icon.
///   confetti — 2 800 ms one-shot particle burst, started when
///              master crosses 0.08 (~640 ms into the sequence).
///
/// Every Animation(double) is derived from [master] via an Interval +
/// named curve. The screen holds one AnimatedBuilder listening to
/// Listenable.merge([master, wobble]) and passes plain .value doubles
/// down to dumb child widgets — no Animation objects leak into the UI.
///
/// The confetti layer has its own isolated AnimatedBuilder listening
/// only to [confetti], wrapped in RepaintBoundary, so the main tree
/// is never rebuilt by confetti ticks.
class IntroAnimationController {
  // ── Controllers ────────────────────────────────────────────────────────────

  final AnimationController master;
  final AnimationController wobble;

  /// Drives the particle physics clock: confettiTime = value × lifespan.
  final AnimationController confetti;

  // ── Entrance animations — driven by master ─────────────────────────────────

  /// Wallet icon drops in from above (0.00 – 0.12, easeOutBack).
  late final Animation<double> walletEntrance;

  /// "blinkit" label materialises (0.10 – 0.20, easeOut). Opacity only.
  late final Animation<double> blinkitFade;

  /// "MONEY" opacity (0.16 – 0.30, easeOut).
  late final Animation<double> moneyFade;

  /// "MONEY" scale-in with overshoot (0.16 – 0.30, elasticOut).
  /// Value may briefly exceed 1.0 — clamp before using as opacity.
  late final Animation<double> moneyScale;

  /// Wallet + title group slides up to its final header position
  /// (0.28 – 0.42, easeInOut).
  late final Animation<double> headerShift;

  /// Feature card 1 slides up and fades in (0.38 – 0.50, easeOutCubic).
  late final Animation<double> card1Slide;

  /// Feature card 2 slides up and fades in (0.45 – 0.57, easeOutCubic).
  late final Animation<double> card2Slide;

  /// Feature card 3 slides up and fades in (0.52 – 0.64, easeOutCubic).
  late final Animation<double> card3Slide;

  /// "Add Money" button fades + slides in (0.60 – 0.70, easeOut).
  late final Animation<double> buttonReveal;

  /// Gift card row fades + slides in (0.66 – 0.76, easeOut).
  late final Animation<double> giftCardReveal;

  /// Ghost tagline fades in last (0.72 – 0.84, easeIn).
  late final Animation<double> taglineFade;

  // ── Continuous wobble — driven by wobble controller ────────────────────────

  /// Oscillates 0 → 1 → 0 (repeat reverse, easeInOut).
  late final Animation<double> walletWobble;

  // ── Confetti particle system ───────────────────────────────────────────────

  /// Pre-spawned at construction time (seeded random → deterministic).
  /// Immutable after creation — the painter derives positions from [confettiTime].
  late final List<Particle> particles;

  /// Elapsed seconds for the particle physics simulation (0.0 → lifespan).
  double get confettiTime => confetti.value * ConfettiConstants.lifespan;

  // ── Constructor ────────────────────────────────────────────────────────────

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

  // ── Private ────────────────────────────────────────────────────────────────

  void _setupAnimations() {
    // Stage 1 – wallet entrance
    walletEntrance = CurvedAnimation(
      parent: master,
      curve: const Interval(0.00, 0.12, curve: Curves.easeOutBack),
    );

    // Stage 2 – title reveal (overlaps tail of wallet entrance)
    blinkitFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.10, 0.20, curve: Curves.easeOut),
    );
    moneyFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.16, 0.30, curve: Curves.easeOut),
    );
    moneyScale = CurvedAnimation(
      parent: master,
      curve: const Interval(0.16, 0.30, curve: Curves.elasticOut),
    );

    // Stage 3 – header group slides up (starts while MONEY is still revealing)
    headerShift = CurvedAnimation(
      parent: master,
      curve: const Interval(0.28, 0.42, curve: Curves.easeInOut),
    );

    // Stage 4 – staggered feature cards
    card1Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.38, 0.50, curve: Curves.easeOutCubic),
    );
    card2Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.45, 0.57, curve: Curves.easeOutCubic),
    );
    card3Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.52, 0.64, curve: Curves.easeOutCubic),
    );

    // Stage 5 – CTA + bottom row
    buttonReveal = CurvedAnimation(
      parent: master,
      curve: const Interval(0.60, 0.70, curve: Curves.easeOut),
    );
    giftCardReveal = CurvedAnimation(
      parent: master,
      curve: const Interval(0.66, 0.76, curve: Curves.easeOut),
    );
    taglineFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.72, 0.84, curve: Curves.easeIn),
    );

    // Continuous wobble
    walletWobble = CurvedAnimation(
      parent: wobble,
      curve: Curves.easeInOut,
    );
  }

  void _spawnParticles() {
    final rng = math.Random(42); // seeded → deterministic burst every run
    final colors = AppColors.confettiColors;
    final list = <Particle>[];

    for (int i = 0; i < ConfettiConstants.particleCount; i++) {
      final color = colors[rng.nextInt(colors.length)];

      // Spawn across the top-centre area of the screen.
      final startX = 0.20 + rng.nextDouble() * 0.60; // 20 %–80 % width
      final startY =
          rng.nextDouble() * ConfettiConstants.spawnAreaHeightFraction;

      // Horizontal spread — full range from constants.
      final vx = ConfettiConstants.minHorizontalVelocity +
          rng.nextDouble() *
              (ConfettiConstants.maxHorizontalVelocity -
                  ConfettiConstants.minHorizontalVelocity);

      // Mix of upward and downward initial vertical velocity for burst feel.
      final speed = ConfettiConstants.minVerticalVelocity +
          rng.nextDouble() *
              (ConfettiConstants.maxVerticalVelocity -
                  ConfettiConstants.minVerticalVelocity);
      final vy = rng.nextBool() ? -speed : speed * 0.25;

      final rotSpeed = ConfettiConstants.minRotationSpeed +
          rng.nextDouble() *
              (ConfettiConstants.maxRotationSpeed -
                  ConfettiConstants.minRotationSpeed);

      final size = ConfettiConstants.minSize +
          rng.nextDouble() *
              (ConfettiConstants.maxSize - ConfettiConstants.minSize);

      // Stagger activations 0–300 ms so the burst unfolds rather than
      // all particles appearing simultaneously.
      final startDelay = rng.nextDouble() * 0.30;

      list.add(Particle(
        startX: startX,
        startY: startY,
        vx: vx,
        vy: vy,
        rotation0: rng.nextDouble() * 2 * math.pi,
        rotationSpeed: rotSpeed,
        width: size,
        height: size * (0.45 + rng.nextDouble() * 0.55),
        color: color,
        startDelay: startDelay,
      ));
    }

    particles = list;
  }

  /// Listener added to master in [start]; fires confetti at the 0.08 mark.
  void _checkConfettiStart() {
    if (master.value >= 0.08 &&
        !confetti.isAnimating &&
        confetti.value == 0.0) {
      master.removeListener(_checkConfettiStart);
      confetti.forward();
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once from [State.initState] (inside a post-frame callback).
  void start() {
    wobble.repeat(reverse: true);
    master.forward();
    master.addListener(_checkConfettiStart);
  }

  void dispose() {
    master.removeListener(_checkConfettiStart); // safety if never triggered
    master.dispose();
    wobble.dispose();
    confetti.dispose();
  }
}
