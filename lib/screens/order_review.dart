import 'package:amul/Screens/profile.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/emailverification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_components/cart_controller.dart';
import 'cart_components/cartItem_model.dart';
import 'mainscreen.dart';
import 'order_icons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';

class OrderReviewPage extends StatefulWidget {
  OrderReviewPage({super.key, required this.cartItems});
  String get userId => auth.currentUser?.email ?? '';
  final auth = FirebaseAuth.instance;

  final RxList<CartItem> cartItems;

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

void handlePaymentSuccessResponse(
    PaymentSuccessResponse response, CartController cartController) async {
  try {
    final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final historyCollection =
        FirebaseFirestore.instance.collection('User/$userId/history');

    final orderData = {
      'orders': FieldValue.arrayUnion([
        {
          'items': cartController.cartItems.fold<Map<String, dynamic>>({},
              (map, item) {
            map[item.name] = {
              'count': item.quantity,
              'price': item.price,
              'time': DateTime.now(),
            };
            return map;
          }),
        }
      ]),
      'orderStatus': 'Placed',
      'time': FieldValue.serverTimestamp(),
    };

    final docSnapshot = await historyCollection.doc(formattedDate).get();

    if (docSnapshot.exists) {
      // Document exists, update it
      await historyCollection.doc(formattedDate).update(orderData);
    } else {
      // Document doesn't exist, create it
      await historyCollection.doc(formattedDate).set(orderData);
    }
    CartController.to.deleteCart();

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
        'assets/images/devcommlogo.png',
        width: 24,
        height: 24,
      ),
    );

    Get.offAll(() => const Mainscreen());
    await CartController.to.deleteCart();
  } catch (error) {
    print('Error handling payment success: $error');
  }
}

void handlePaymentErrorResponse(PaymentFailureResponse response) {
  Get.snackbar(
    'Payment decline',
    'Provide valid credentials',
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
      'assets/images/devcommlogo.png',
      width: 24,
      height: 24,
    ),
  );
  Get.offAll(() => const Mainscreen());
}

void handleExternalWalletSelected(ExternalWalletResponse response) {}

class _OrderReviewPageState extends State<OrderReviewPage> {
/*
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }*/

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cartItems;
    double totalAmount = 0.0;
    for (var item in cartItems) {
      totalAmount += item.price * item.quantity;
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60),
            child: const Center(
              child: Text(
                'Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          OrderStatusIcons(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.name} (${item.quantity} items)',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ), // Item name with count
                          Text(
                            '\₹${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ), // Item price
                        ],
                      );
                    },
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const Spacer(),
                          Text(
                            '\₹${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              //upi
              /* Get.to(() => PaymentSuccessScreen());*/

              Razorpay razorpay = Razorpay();

              var options = {
                /*          'key': 'rzp_test_Hy9f4oAIXRyJIw',*/
                'key': 'rzp_test_Hy9f4oAIXRyJIw',
                'amount': (totalAmount * 100).toInt(),
                'name': 'Amul powered by Devcomm',
                'image': 'https://example.com/your_image.png',
                'description': 'Amul Nsut',
                'timeout': 90,
                'currency': 'INR',
                'retry': {'enabled': true, 'max_count': 1},
                'send_sms_hash': true,
                'external': {
                  'wallets': ['paytm']
                },
                'prefill': {
                  'contact': '8178600597',
                  'email': 'devcomm.nsut@nsut.ac.in'
                }
              };

              razorpay.on(
                  Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
                handlePaymentSuccessResponse(response, CartController.to);
              });
              razorpay.on(
                  Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
              razorpay.open(options);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Pay',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
