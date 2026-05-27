import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AddMoneyButton extends StatelessWidget {
  /// 0 → 1 (easeOut): simultaneous fade-in + slide up from 30 px below.
  final double revealProgress;

  const AddMoneyButton({super.key, required this.revealProgress});

  @override
  Widget build(BuildContext context) {
    final opacity = revealProgress.clamp(0.0, 1.0);
    final translateY = (1.0 - revealProgress) * 30.0;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text('Add Money', style: AppTextStyles.buttonLabel),
          ),
        ),
      ),
    );
  }
}
