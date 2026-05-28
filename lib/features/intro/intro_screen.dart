import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'animation/intro_animation_controller.dart';
import 'widgets/add_money_button.dart';
import 'widgets/background_dots.dart';
import 'widgets/bottom_tagline.dart';
import 'widgets/confetti_overlay.dart';
import 'widgets/feature_card_list.dart';
import 'widgets/gift_card_row.dart';
import 'widgets/intro_top_bar.dart';
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

  bool _scrollEnabled = false;
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
        // 100ms delay lets the final frame settle before switching physics,
        // preventing a visual jump on the NeverScrollable → Clamping change.
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _scrollEnabled = true);
        });
      }
    });
    _scrollController.addListener(_onScroll);
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
        final headerShiftY = (1.0 - _anim.headerShift.value) * 130.0;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              const Positioned.fill(
                child: IgnorePointer(child: BackgroundDots()),
              ),

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
                    IntroTopBar(showTitle: _showTitle),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.white],
                          stops: [0.0, 0.08],
                        ).createShader(bounds),
                        blendMode: BlendMode.dstIn,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          // ClampingScrollPhysics avoids the spring-force
                          // bounce that would cause a visual jump on unlock.
                          physics: _scrollEnabled
                              ? const ClampingScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),

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

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: AddMoneyButton(
                                  revealProgress: _anim.buttonReveal.value,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: GiftCardRow(
                                  revealProgress: _anim.giftCardReveal.value,
                                ),
                              ),

                              const SizedBox(height: 28),

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
