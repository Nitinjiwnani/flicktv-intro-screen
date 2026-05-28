import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'feature_card.dart';

class FeatureCardList extends StatelessWidget {
  final double card1Progress;
  final double card2Progress;
  final double card3Progress;

  const FeatureCardList({
    super.key,
    required this.card1Progress,
    required this.card2Progress,
    required this.card3Progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeatureCard(
          icon: Icons.touch_app_outlined,
          iconColor: AppColors.textPrimary,
          title: 'Single tap payments',
          subtitle: 'Enjoy seamless payments without the wait for OTPs',
          slideProgress: card1Progress,
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.signal_cellular_alt,
          iconColor: AppColors.textPrimary,
          title: 'Zero failures',
          subtitle: 'Zero payment failures ensure you never miss an order',
          slideProgress: card2Progress,
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.currency_rupee,
          iconColor: AppColors.walletGold,
          title: 'Real-time refunds',
          subtitle:
              'No need to wait for refunds. blinkit Money refunds are instant!',
          slideProgress: card3Progress,
        ),
      ],
    );
  }
}
