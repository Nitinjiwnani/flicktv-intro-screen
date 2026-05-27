import 'package:flutter/material.dart';

/// Orchestrates the 8-second intro animation.
///
/// Owns two controllers:
///   master  — 8 000 ms one-shot entrance sequence.
///   wobble  — 2 800 ms repeating tilt for the wallet icon.
///
/// Every Animation(double) is derived from [master] via an Interval +
/// named curve. The screen holds one AnimatedBuilder listening to
/// Listenable.merge([master, wobble]) and passes plain .value doubles
/// down to dumb child widgets — no Animation objects leak into the UI.
///
/// Confetti controller intentionally omitted from this step.
/// TODO(feature/confetti): add a third controller + particle system here.
class IntroAnimationController {
  // ── Controllers ────────────────────────────────────────────────────────────

  final AnimationController master;
  final AnimationController wobble;

  // ── Entrance animations — driven by master ─────────────────────────────────

  /// Wallet icon drops in from above (0.00 – 0.20, easeOutBack).
  /// Value drives: translateY + opacity.
  late final Animation<double> walletEntrance;

  /// "blinkit" label materialises (0.25 – 0.35, easeOut).
  /// Value drives: opacity only.
  late final Animation<double> blinkitFade;

  /// "MONEY" opacity (0.30 – 0.45, easeOut).
  /// Keep separate from [moneyScale] so each curve can differ.
  late final Animation<double> moneyFade;

  /// "MONEY" scale-in with overshoot (0.30 – 0.45, elasticOut).
  /// Value may briefly exceed 1.0 — clamp before using as opacity.
  late final Animation<double> moneyScale;

  /// Wallet + title group slides up to its final header position
  /// (0.38 – 0.52, easeInOut).
  /// Value 0 → 1: translateY offset shrinks from +[headerShiftPx] to 0.
  late final Animation<double> headerShift;

  /// Feature card 1 slides up and fades in (0.50 – 0.62, easeOutCubic).
  late final Animation<double> card1Slide;

  /// Feature card 2 slides up and fades in (0.58 – 0.70, easeOutCubic).
  late final Animation<double> card2Slide;

  /// Feature card 3 slides up and fades in (0.66 – 0.78, easeOutCubic).
  late final Animation<double> card3Slide;

  /// "Add Money" button fades + slides in (0.76 – 0.86, easeOut).
  late final Animation<double> buttonReveal;

  /// Gift card row fades + slides in (0.82 – 0.92, easeOut).
  late final Animation<double> giftCardReveal;

  /// Ghost tagline fades in last (0.88 – 1.00, easeIn).
  late final Animation<double> taglineFade;

  // ── Continuous wobble — driven by wobble controller ────────────────────────

  /// Oscillates 0 → 1 → 0 (repeat reverse, easeInOut).
  /// Widget maps this to ± rotation offset on top of the base tilt.
  late final Animation<double> walletWobble;

  // ── Constructor ────────────────────────────────────────────────────────────

  IntroAnimationController({required TickerProvider vsync})
      : master = AnimationController(
          duration: const Duration(milliseconds: 8000),
          vsync: vsync,
        ),
        wobble = AnimationController(
          duration: const Duration(milliseconds: 2800),
          vsync: vsync,
        ) {
    _setupAnimations();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  void _setupAnimations() {
    // Stage 1 – wallet entrance
    walletEntrance = CurvedAnimation(
      parent: master,
      curve: const Interval(0.00, 0.20, curve: Curves.easeOutBack),
    );

    // Stage 2 – title reveal
    blinkitFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.25, 0.35, curve: Curves.easeOut),
    );
    moneyFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.30, 0.45, curve: Curves.easeOut),
    );
    moneyScale = CurvedAnimation(
      parent: master,
      curve: const Interval(0.30, 0.45, curve: Curves.elasticOut),
    );

    // Stage 3 – header group slides up
    headerShift = CurvedAnimation(
      parent: master,
      curve: const Interval(0.38, 0.52, curve: Curves.easeInOut),
    );

    // Stage 4 – staggered feature cards
    card1Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.50, 0.62, curve: Curves.easeOutCubic),
    );
    card2Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.58, 0.70, curve: Curves.easeOutCubic),
    );
    card3Slide = CurvedAnimation(
      parent: master,
      curve: const Interval(0.66, 0.78, curve: Curves.easeOutCubic),
    );

    // Stage 5 – CTA + bottom row
    buttonReveal = CurvedAnimation(
      parent: master,
      curve: const Interval(0.76, 0.86, curve: Curves.easeOut),
    );
    giftCardReveal = CurvedAnimation(
      parent: master,
      curve: const Interval(0.82, 0.92, curve: Curves.easeOut),
    );
    taglineFade = CurvedAnimation(
      parent: master,
      curve: const Interval(0.88, 1.00, curve: Curves.easeIn),
    );

    // Continuous wobble
    walletWobble = CurvedAnimation(
      parent: wobble,
      curve: Curves.easeInOut,
    );
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once from [State.initState] (inside a post-frame callback).
  void start() {
    wobble.repeat(reverse: true);
    master.forward();
  }

  void dispose() {
    master.dispose();
    wobble.dispose();
  }
}
