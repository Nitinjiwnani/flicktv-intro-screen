import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'animation/intro_animation_controller.dart';
import 'widgets/add_money_button.dart';
import 'widgets/background_dots.dart';
import 'widgets/bottom_tagline.dart';
import 'widgets/confetti_overlay.dart';
import 'widgets/feature_card_list.dart';
import 'widgets/gift_card_row.dart';
import 'widgets/title_block.dart';
import 'widgets/wallet_widget.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late final IntroAnimationController _anim;

  // Scroll is locked during the 8-second animation and unlocked once the
  // master controller completes — only needed as overflow safety on small
  // devices, not as the primary interaction.
  bool _scrollEnabled = false;

  // ── App bar title reveal ───────────────────────────────────────────────────
  // A lightweight scroll listener flips _showTitle when the offset crosses
  // 120 px. setState is only called on a boolean change (never per-pixel),
  // so this never adds rebuild pressure during a smooth scroll.
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  void _onScroll() {
    final shouldShow = _scrollController.offset > 120.0;
    if (shouldShow != _showTitle) setState(() => _showTitle = shouldShow);
  }

  @override
  void initState() {
    super.initState();
    _anim = IntroAnimationController(vsync: this);
    _anim.master.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // 100 ms delay lets the final frame settle before the physics switch,
        // preventing any visual jump from the NeverScrollable → Clamping change.
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _scrollEnabled = true);
        });
      }
    });
    _scrollController.addListener(_onScroll);
    // Wait one frame so the first layout is complete before starting.
    WidgetsBinding.instance.addPostFrameCallback((_) => _anim.start());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_anim.master, _anim.wobble]),
      builder: (context, _) {
        // headerShiftY: starts at +180 (group pushed down, appears centred),
        // animates to 0 (final layout position) during interval 0.38–0.52.
        final headerShiftY = (1.0 - _anim.headerShift.value) * 130.0;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Background dots — must not capture scroll/tap gestures.
              const Positioned.fill(
                child: IgnorePointer(child: BackgroundDots()),
              ),

              // ── Confetti layer ─────────────────────────────────────────
              // Isolated in its own AnimatedBuilder so the main tree
              // (master + wobble) is never rebuilt by confetti ticks.
              // RepaintBoundary keeps the confetti on its own GPU layer.
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _anim.confetti,
                      builder: (context, _) => ConfettiOverlay(
                        particles: _anim.particles,
                        t: _anim.confettiTime,
                      ),
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    _TopBar(showTitle: _showTitle),
                    Expanded(
                      child: ShaderMask(
                        // Fade the top ~60 px of the scroll viewport so content
                        // dissolves as it scrolls up rather than hard-clipping.
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.white],
                          stops: [0.0, 0.08],
                        ).createShader(bounds),
                        blendMode: BlendMode.dstIn,
                        child: SingleChildScrollView(
                        // Only overflow safety on small devices — not the
                        // intended interaction pattern.
                        // ClampingScrollPhysics after unlock: allows overflow
                        // scrolling on small devices without the spring-force
                        // bounce that would cause a visual jump on unlock.
                        controller: _scrollController,
                        physics: _scrollEnabled
                            ? const ClampingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            // ── Header group ──────────────────────────────
                            // Wallet + title shift upward together from their
                            // initial centred position to the final top slot.
                            Transform.translate(
                              offset: Offset(0, headerShiftY),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  WalletWidget(
                                    entranceProgress:
                                        _anim.walletEntrance.value,
                                    wobbleValue: _anim.walletWobble.value,
                                  ),
                                  const SizedBox(height: 8),
                                  TitleBlock(
                                    blinkitOpacity: _anim.blinkitFade.value,
                                    moneyFade: _anim.moneyFade.value,
                                    moneyScale: _anim.moneyScale.value,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // ── Feature cards (staggered) ─────────────────
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: FeatureCardList(
                                card1Progress: _anim.card1Slide.value,
                                card2Progress: _anim.card2Slide.value,
                                card3Progress: _anim.card3Slide.value,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── CTA button ────────────────────────────────
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: AddMoneyButton(
                                revealProgress: _anim.buttonReveal.value,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ── Gift card row ─────────────────────────────
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: GiftCardRow(
                                revealProgress: _anim.giftCardReveal.value,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ── Ghost tagline ─────────────────────────────
                            BottomTagline(
                              fadeProgress: _anim.taglineFade.value,
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool showTitle;
  const _TopBar({required this.showTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Buttons stay in their fixed positions — Stack does not disturb them.
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(icon: Icons.arrow_back_ios_new),
              _CircleButton(icon: Icons.settings_outlined),
            ],
          ),

          // Title floats centred above the button row; fades on scroll threshold.
          AnimatedOpacity(
            opacity: showTitle ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Text(
              'Blinkit Money',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  const _CircleButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 18),
    );
  }
}
