import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  static const TextStyle brandSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700, // Inter-Bold — slightly stronger than before
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle brandLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 50,           // 44 → 50: more dominant presence
    fontWeight: FontWeight.w800, // Inter-ExtraBold (heaviest loaded weight)
    color: AppColors.textPrimary,
    letterSpacing: 6,       // 4 → 6: wide tracked, premium feel
    height: 1.0,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle tagline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.textGhost,
    letterSpacing: -0.5,
    height: 1.15,
  );

  /// App bar title — fades in when the user scrolls past the hero header.
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Muted watermark — small "blinkit" label beneath the greyscale wallet.
  static const TextStyle watermarkSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
    letterSpacing: 0.2,
  );

  /// Muted watermark — large "MONEY" label beneath the greyscale wallet.
  static const TextStyle watermarkLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Colors.white70,
    letterSpacing: 3.0,
    height: 1.0,
  );
}
