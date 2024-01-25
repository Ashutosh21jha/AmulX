import 'package:flutter/material.dart';

class AppColors2 extends ThemeExtension<AppColors2> {
  AppColors2(
      {required this.text1,
      required this.text2,
      required this.scaffoldBackgroundColor,
      required this.cardColor,
      required this.whiteText,
      required this.borderColor});

  final Color text1;
  final Color text2;
  final Color borderColor;
  final Color cardColor;
  final Color whiteText;
  final Color scaffoldBackgroundColor;

  @override
  AppColors2 copyWith() {
    return AppColors2(
      text1: text1,
      text2: text2,
      cardColor: cardColor,
      whiteText: whiteText,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      borderColor: borderColor,
    );
  }

  @override
  AppColors2 lerp(ThemeExtension<AppColors2>? other, double t) {
    if (other is! AppColors2) {
      return this;
    }
    return AppColors2(
      text1: Color.lerp(text1, other.text1, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      whiteText: Color.lerp(whiteText, other.whiteText, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      scaffoldBackgroundColor: Color.lerp(
          scaffoldBackgroundColor, other.scaffoldBackgroundColor, t)!,
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
