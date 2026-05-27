import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class BottomTagline extends StatelessWidget {
  /// 0 → 1 (easeIn): fade in only — no translate, just materialises.
  final double fadeProgress;

  const BottomTagline({super.key, required this.fadeProgress});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fadeProgress.clamp(0.0, 1.0),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enjoy seamless', style: AppTextStyles.tagline),
            Text('one tap payments', style: AppTextStyles.tagline),
          ],
        ),
      ),
    );
  }
}
