import 'package:flutter/material.dart';

/// Centralized color palette for the intro screen.
/// Values eyeballed from the Blinkit Money reference, tuned for our app.
class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFF1A1A1A);
  static const Color backgroundDeep = Color(0xFF0F0F0F);

  // Cards
  static const Color cardBackground = Color(0xFF2A2A2A);
  static const Color cardIconBackground = Color(0xFF1F1F1F);

  // Brand
  static const Color walletGold = Color(0xFFE5B53A);
  static const Color walletGreen = Color(0xFF4A6B2A);
  static const Color primaryGreen = Color(0xFF2BB673);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textGhost = Color(0xFF555555);

  // Confetti palette
  static const List<Color> confettiColors = [
    Color(0xFFFF4D6D), // pink
    Color(0xFF4D9EFF), // blue
    Color(0xFFFFD93D), // yellow
    Color(0xFF6BCB77), // green
    Color(0xFFFF9F45), // orange
    Color(0xFFB983FF), // purple
    Color(0xFF00C9A7), // teal
  ];
}