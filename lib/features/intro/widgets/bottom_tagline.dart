import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';

class BottomTagline extends StatelessWidget {
  /// 0 → 1 (easeIn): fades in the ghost tagline and the watermark together.
  final double fadeProgress;

  const BottomTagline({super.key, required this.fadeProgress});

  @override
  Widget build(BuildContext context) {
    final clamped = fadeProgress.clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: clamped,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enjoy seamless', style: AppTextStyles.tagline),
                Text('one tap payments', style: AppTextStyles.tagline),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Opacity(
          opacity: clamped * 0.18,
          child: Container(
            height: 0.5,
            margin: const EdgeInsets.symmetric(horizontal: 48),
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        Opacity(
          opacity: clamped * 0.25,
          child: const _BottomWatermark(),
        ),

        const SizedBox(height: 14),
      ],
    );
  }
}

class _BottomWatermark extends StatelessWidget {
  const _BottomWatermark();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wallet asset desaturated to full greyscale via luminance matrix.
        ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            // R'  G'  B'  A   offset
            0.2126, 0.7152, 0.0722, 0, 0, // R
            0.2126, 0.7152, 0.0722, 0, 0, // G
            0.2126, 0.7152, 0.0722, 0, 0, // B
            0, 0, 0, 1, 0, //              // A
          ]),
          child: Image.asset(
            AppAssets.wallet,
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 8),

        const Text('blinkit', style: AppTextStyles.watermarkSmall),

        const SizedBox(height: 3),

        const Text('MONEY', style: AppTextStyles.watermarkLarge),
      ],
    );
  }
}
