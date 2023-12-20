import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_components/cart_controller.dart';
import 'cart_components/cart_items.dart';
import 'mainscreen.dart';
import 'order_icons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderReviewPage extends StatefulWidget {
  const OrderReviewPage({super.key, required this.cartItems});

  final RxList<CartItem> cartItems;

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
  Get.offAll(() => Mainscreen());
}

void handlePaymentErrorResponse(PaymentFailureResponse response) {}

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
              height: 300,
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
                  const SizedBox(height: 10),
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
          const SizedBox(height: 20),
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
              razorpay.on(
                  Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
              razorpay.on(
                  Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
              razorpay.open(options);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Text('Pay via UPI'),
          ),
        ],
      ),
    );
  }
}
