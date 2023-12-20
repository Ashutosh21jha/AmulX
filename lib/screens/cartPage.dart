import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amul/screens/order_review.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int itemCount = 0;

  // Method to update item count
  void updateItemCount() {
    setState(() {
      itemCount =
          CartController.to.calculateItemCount(CartController.to.cartItems);
    });
  }

  int calculateItemCount() {
    return CartController.to.cartItems
        .map((item) => item.quantity)
        .fold(0, (prev, current) => prev + current);
  }

  @override
  void initState() {
    super.initState();
    itemCount = calculateItemCount(); // Initialized item count
    updateItemCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SizedBox(height: 45),
          Center(
            child: Text(
              'Cart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Obx(() {
              final cartController = CartController.to;
              return ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Container(
                    height: 90,
                    width: 100,
                    margin:
                        const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Transform.translate(
                              offset: const Offset(0, 22),
                              child: Text(
                                item.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\₹${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 11),
                              child: Container(
                                height: 35,
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      iconSize: 18,
                                      onPressed: () {
                                        cartController.removeItem(item);
                                        updateItemCount();
                                      },
                                    ),
                                    Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 18,
                                      onPressed: () {
                                        cartController.addItem(item);
                                        updateItemCount();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Obx(() {
                  final cartController = CartController.to;
                  return Column(
                    children: cartController.cartItems
                        .map((item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item.name} (${item.quantity} items)',
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  '\₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 17),
                                ), // Item price
                              ],
                            ))
                        .toList(),
                  );
                }),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Total Amount',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(() {
                      final cartController = CartController.to;
                      return Text(
                        '\₹ ${cartController.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final cartController = CartController.to;
                        if (cartController.cartItems.isNotEmpty) {
                          Get.to(OrderReviewPage(
                            cartItems: cartController.cartItems,
                          ));
                        } else {
                          Get.snackbar(
                            'Cart is Empty',
                            'Please add items to the cart first',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 22),
                        backgroundColor: const Color(0xFF2546A9),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Order Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
