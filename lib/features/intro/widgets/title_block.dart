import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class TitleBlock extends StatelessWidget {
  /// 0 → 1: opacity of the "blinkit" label (easeOut).
  final double blinkitOpacity;

  /// 0 → 1: opacity of the "MONEY" label (easeOut).
  /// Kept separate from [moneyScale] so each curve can differ.
  final double moneyFade;

  /// 0 → 1 (elasticOut — may briefly exceed 1.0): scale of "MONEY".
  /// Clamp before using as opacity; allow overshoot for the scale transform.
  final double moneyScale;

  const TitleBlock({
    super.key,
    required this.blinkitOpacity,
    required this.moneyFade,
    required this.moneyScale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: blinkitOpacity.clamp(0.0, 1.0),
          child: const Text('blinkit', style: AppTextStyles.brandSmall),
        ),
        const SizedBox(height: 6),
        Opacity(
          opacity: moneyFade.clamp(0.0, 1.0),
          child: Transform.scale(
            // Allow up to 1.4× overshoot so the elasticOut bounce reads.
            scale: moneyScale.clamp(0.0, 1.4),
            child: const Text('MONEY', style: AppTextStyles.brandLarge),
          ),
        ),
      ],
    );
  }
}
