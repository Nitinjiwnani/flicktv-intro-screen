import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class BottomTagline extends StatelessWidget {
  const BottomTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enjoy seamless', style: AppTextStyles.tagline),
          Text('one tap payments', style: AppTextStyles.tagline),
        ],
      ),
    );
  }
}
