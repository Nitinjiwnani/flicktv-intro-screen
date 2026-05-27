import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WalletWidget extends StatelessWidget {
  /// 0 → 1 (easeOutBack — may briefly exceed 1.0).
  /// Drives opacity, scale, and a tiny 15 px settle.
  /// No large vertical movement — headerShift on the parent group owns
  /// the upward travel to the final header position.
  final double entranceProgress;

  /// 0 → 1 oscillating from the wobble controller (repeat-reverse).
  /// Drives ± rotation offset layered on top of the base tilt.
  final double wobbleValue;

  const WalletWidget({
    super.key,
    required this.entranceProgress,
    required this.wobbleValue,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = entranceProgress.clamp(0.0, 1.0);

    // Scale from 0.6 → 1.0; easeOutBack curve produces the overshoot/bounce
    // settle feel that previously came from a large vertical drop.
    // Clamp ceiling at 1.4 so easeOutBack overshoot stays visible but sane.
    final scale = (0.6 + entranceProgress * 0.4).clamp(0.0, 1.4);

    // Tiny 15 px settle gives a physical "drop" hint without conflicting
    // with the 130 px headerShift applied to the parent group.
    final settleY = (1.0 - entranceProgress) * -15.0;

    // Base tilt (-0.18 rad ≈ 10°) with a gentle ±0.07 rad wobble on top.
    final tilt = -0.18 + (wobbleValue * 2.0 - 1.0) * 0.07;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, settleY),
        child: Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: tilt,
            child: SizedBox(
              width: 140,
              height: 140,
              child: Image.asset(
                'assets/images/wallet.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
