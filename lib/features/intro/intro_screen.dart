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
    // Wait one frame so the first layout is complete before starting.
    WidgetsBinding.instance.addPostFrameCallback((_) => _anim.start());
  }

  @override
  void dispose() {
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
                    const _TopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        // Only overflow safety on small devices — not the
                        // intended interaction pattern.
                        // ClampingScrollPhysics after unlock: allows overflow
                        // scrolling on small devices without the spring-force
                        // bounce that would cause a visual jump on unlock.
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
                                  const SizedBox(height: 28),
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

                            const SizedBox(height: 10),

                            // ── Ghost tagline ─────────────────────────────
                            BottomTagline(
                              fadeProgress: _anim.taglineFade.value,
                            ),

                            const SizedBox(height: 24),
                          ],
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
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _CircleButton(icon: Icons.arrow_back_ios_new),
          _CircleButton(icon: Icons.settings_outlined),
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
