import 'package:amul/screens/foodPage.dart';
import 'package:amul/screens/home.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.indigo,
                  size: 100.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          const Text(
            'A receipt will be sent directly to your email.',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 40.0),
          ElevatedButton(
            onPressed: () {
              // Navigate back to the menu page.
              Get.offAll(() => const Mainscreen());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.indigo,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
