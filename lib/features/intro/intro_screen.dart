import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/add_money_button.dart';
import 'widgets/background_dots.dart';
import 'widgets/bottom_tagline.dart';
import 'widgets/feature_card_list.dart';
import 'widgets/gift_card_row.dart';
import 'widgets/title_block.dart';
import 'widgets/wallet_widget.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dots must not capture scroll/tap gestures.
          const Positioned.fill(
            child: IgnorePointer(child: BackgroundDots()),
          ),

          SafeArea(
            child: Column(
              children: [
                const _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    // Only as overflow safety — not the intended interaction.
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: const [
                        SizedBox(height: 20),
                        WalletWidget(),
                        SizedBox(height: 28),
                        TitleBlock(),
                        SizedBox(height: 22),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: FeatureCardList(),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: AddMoneyButton(),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: GiftCardRow(),
                        ),
                        SizedBox(height: 10),
                        _TaglineSlot(),
                        SizedBox(height: 24),
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
  }
}

// Extracted so we can apply Transform without losing the const Column above.
class _TaglineSlot extends StatelessWidget {
  const _TaglineSlot();

  @override
  Widget build(BuildContext context) {
    return const BottomTagline();
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
