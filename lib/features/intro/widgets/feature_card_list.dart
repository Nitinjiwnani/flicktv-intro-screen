import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'feature_card.dart';

class FeatureCardList extends StatelessWidget {
  const FeatureCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FeatureCard(
          icon: Icons.touch_app_outlined,
          iconColor: AppColors.textPrimary,
          title: 'Single tap payments',
          subtitle: 'Enjoy seamless payments without the wait for OTPs',
        ),
        SizedBox(height: 12),
        FeatureCard(
          icon: Icons.signal_cellular_alt,
          iconColor: AppColors.textPrimary,
          title: 'Zero failures',
          subtitle: 'Zero payment failures ensure you never miss an order',
        ),
        SizedBox(height: 12),
        FeatureCard(
          icon: Icons.currency_rupee,
          iconColor: AppColors.walletGold,
          title: 'Real-time refunds',
          subtitle:
              'No need to wait for refunds. blinkit Money refunds are instant!',
        ),
      ],
    );
  }
}
