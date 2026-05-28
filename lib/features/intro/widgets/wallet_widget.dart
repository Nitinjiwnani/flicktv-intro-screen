import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';

class WalletWidget extends StatelessWidget {
  /// 0 → 1 (easeOutBack — may briefly exceed 1.0).
  /// Drives opacity, scale, and a 15px settle. HeaderShift owns the 130px travel.
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

    // Scale 0.6→1.0; ceiling 1.4 keeps the easeOutBack overshoot visible.
    final scale = (0.6 + entranceProgress * 0.4).clamp(0.0, 1.4);

    // 15px settle hint; the 130px travel is owned by the headerShift parent.
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
                AppAssets.wallet,
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
