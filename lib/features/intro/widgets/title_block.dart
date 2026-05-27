import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class TitleBlock extends StatelessWidget {
  const TitleBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('blinkit', style: AppTextStyles.brandSmall),
        SizedBox(height: 6),
        Text('MONEY', style: AppTextStyles.brandLarge),
      ],
    );
  }
}
