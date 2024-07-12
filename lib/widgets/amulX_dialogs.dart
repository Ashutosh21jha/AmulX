import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AmulXDialogs {
  static void showPaymentIfPaymentStatusCheckFailed() {
    Get.dialog(
      AlertDialog(
        title: const Text('Payment Status Check Failed'),
        content: const Text(
            'If you have already paid, go to history section and check'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
