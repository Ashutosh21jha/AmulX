import 'package:amul/Utils/AppColors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AmulXSnackBars {
  static final List<Color> successColors = [
    const Color(0xFFA2E8D8),
    AppColors.green,
    const Color(0xFF007A52),
  ];

  static final List<Color> errorColors = [
    const Color(0xFFF98181),
    AppColors.red,
    const Color(0xFF850000),
  ];

  static final List<Color> infoColors = [
    const Color(0xFF00084B),
    const Color(0xFF2E55C0),
    const Color(0xFF148BFA),
  ];

  static const double barBlur = 5;

  static const Color darkModeBackgroundColor = Colors.black38;
  static const Color lightModeBackgroundColor = Colors.black87;

  static const Duration duration = Duration(seconds: 3);

  static final icon = Image.asset(
    'assets/images/icon.png',
    width: 24,
    height: 24,
  );

  static void showAuthSuccessSnackBar(String title, String message) {
    Get.snackbar(title, message,
        barBlur: barBlur,
        colorText: Colors.white,
        backgroundColor:
            Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
        backgroundGradient: LinearGradient(
          colors: successColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        duration: duration,
        icon: icon);
  }

  static void showEmptyCartPleaseAddItemSnackbar() {
    Get.snackbar(
      'Cart is Empty',
      'Please add items to the cart first',
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: errorColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void showNameSuccessfullyChangedSnackbar() {
    Get.snackbar(
      'Success',
      'Name Updated',
      colorText: Colors.white,
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      backgroundGradient: LinearGradient(
        colors: successColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void showProfileImageSuccessfullyChangedSnackbar() {
    Get.snackbar(
      'Success',
      'Profile Image Updated',
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: successColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void showAuthErrorSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: errorColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void onPasswordResetAccountNotFoundSnackbar() {
    Get.snackbar(
      'You do not have account yet!',
      'Sign Up using Nsut credentials',
      backgroundGradient: LinearGradient(
        colors: infoColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      icon: icon,
    );
  }

  static void showPasswordResetLinkSendSnackbar() {
    Get.snackbar(
      'Password Reset link Sent!',
      'Thank You for using Amul',
      backgroundGradient: LinearGradient(
        colors: infoColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      icon: icon,
    );
  }

  static void showPaymentOrderSuccessSnackbar() {
    Get.snackbar(
      'Payment Successful',
      'Thank You for using Amul',
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      backgroundGradient: LinearGradient(
        colors: successColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      barBlur: barBlur,
      colorText: Colors.white,
      icon: icon,
    );
  }

  static void showManualOrderCreationFailedSnackbar() {
    Get.snackbar(
      'Order creation failed',
      'please contact AMULX',
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: errorColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void showPaymentOrderFailureSnackbar() {
    Get.snackbar(
      'Payment Failed',
      'Please Try Again',
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: errorColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void showPaymentOrderPendingSnackbar() {
    Get.snackbar(
      'Payment Pending',
      'Please wait for the payment to be processed',
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: successColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void showItemOutOfStockSnackbar(List<String> items) {
    items = items.map((item) => "'$item'").toList();
    Get.snackbar(
      'Stock Exceeded',
      'Reduce quantity for ${items.join(', ')}',
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: errorColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }

  static void showErrorSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      barBlur: barBlur,
      backgroundColor:
          Get.isDarkMode ? darkModeBackgroundColor : lightModeBackgroundColor,
      colorText: Colors.white,
      backgroundGradient: LinearGradient(
        colors: errorColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: duration,
      icon: icon,
    );
  }
}
