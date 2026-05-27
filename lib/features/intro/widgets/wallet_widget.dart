import 'package:flutter/material.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.18, // ~10° counter-clockwise tilt to match reference
      child: Image.asset(
        'assets/images/wallet.png',
        width: 130,
        height: 130,
        fit: BoxFit.contain,
      ),
    );
  }
}
