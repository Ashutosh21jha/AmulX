import 'package:flutter/material.dart';

class AppColors2 extends ThemeExtension<AppColors2> {
  AppColors2({
    required this.backgroundColor,
    required this.surfaceColor,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.primaryText,
    required this.secondaryText,
    required this.blue,
    required this.green,
  });

  final Color backgroundColor;
  final Color surfaceColor;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color primaryText;
  final Color secondaryText;
  final Color blue;
  final Color green;

  @override
  AppColors2 copyWith() {
    return AppColors2(
      backgroundColor: backgroundColor,
      surfaceColor: surfaceColor,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      primaryText: primaryText,
      secondaryText: secondaryText,
      blue: blue,
      green: green,
    );
  }

  @override
  AppColors2 lerp(ThemeExtension<AppColors2>? other, double t) {
    if (other is! AppColors2) {
      return this;
    }
    return AppColors2(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      green: Color.lerp(green, other.green, t)!,
    );
  }
}

class AppColors {
  static const Color blue = Color(0xFF2546A9);
  static const Color green = Color(0xFF18AE86);
  static const Color blackbase = Color(0xFF414042);
  static const Color red = Color(0xFFDD4040);
  static const Color blacklighter = Color(0xFF929497);
  static const Color yellow = Color(0xFFFBBC04);
}

class DarkAppColors {
  static const Color blue = Color(0xFF2546A9);
  static const Color green = Color(0xFF18AE86);
  static const Color blackbase = Color(0xFF414042);
  static const Color red = Color(0xFFDD4040);
  static const Color blacklighter = Color(0xFF929497);
  static const Color yellow = Color(0xFFFBBC04);
}
