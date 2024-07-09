import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AmulXSnackBars {
  static void showPaymentOrderSuccessSnackbar() {
    Get.snackbar(
      'Payment Successful',
      'Thank You for using Amul',
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFA2E8D8),
          AppColors.green,
          Color(0xFF007A52),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      barBlur: 10,
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showPaymentOrderFailureSnackbar() {
    Get.snackbar(
      'Payment Failed',
      'Please Try Again',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFF98181),
          AppColors.red,
          Color(0xFF850000),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showItemOutOfStockSnackbar() {
    Get.snackbar(
      'Some item is out of stock',
      'Please remove that item from cart',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFF98181),
          AppColors.red,
          Color(0xFF850000),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }
}
