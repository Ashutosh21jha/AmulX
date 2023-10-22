import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_items.dart';
import 'payment_success.dart';
import 'order_icons.dart';

class OrderReviewPage extends StatelessWidget {
  final RxList<CartItem> cartItems;

  OrderReviewPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: const Text(
                'Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
          OrderStatusIcons(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 300,
              padding: EdgeInsets.all(20),
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
                  SizedBox(height: 10),
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
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ), // Item name with count
                          Text(
                            '\₹.${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ), // Item price
                        ],
                      );
                    },
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Spacer(),
                          Text(
                            '\₹${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              //upi
              Get.to(() => PaymentSuccessScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: EdgeInsets.symmetric(horizontal: 130, vertical: 20),
              textStyle: TextStyle(fontSize: 20),
            ),
            child: Text('Pay via UPI'),
          ),
        ],
      ),
    );
  }
}
