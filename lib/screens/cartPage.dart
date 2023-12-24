import 'dart:async';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amul/screens/order_review.dart';
import 'package:lottie/lottie.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /* int itemCount = 0;
  void updateItemCount() {
    setState(() {
      itemCount =
          CartController.to.calculateItemCount(CartController.to.cartItems);
    });pub
  }*/

  @override
  void initState() {
    super.initState();
    /* itemCount = calculateItemCount(); // Initialized item count
    updateItemCount();*/
    CartController.to.fetchCart();
    CartController.to.reloadFetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: CartController.to.isCartEmpty
          ? Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Your Cart is Empty!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Lottie.asset(
                    "assets/raw/emptycart.json",
                    height: 300,
                    width: double.infinity,
                    repeat: false,
                    frameRate: FrameRate(30),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 45),
                const Center(
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
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
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
                                        fontSize: 16,
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
                                    color: AppColors.green,
                                    fontSize: 14,
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
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            iconSize: 18,
                                            onPressed: () {
                                              cartController.removeItem(item);
                                              /* updateItemCount();*/
                                            },
                                          ),
                                          Text(
                                            item.quantity.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            iconSize: 18,
                                            onPressed: () {
                                              cartController.addItem(item);
                                              /*updateItemCount();*/
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
                      const Text(
                        'Summary',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        final cartController = CartController.to;
                        return Column(
                          children: cartController.cartItems
                              .map((item) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item.quantity} ${item.name}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '\₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 14),
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Total Amount',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Obx(() {
                            final cartController = CartController.to;
                            return Text(
                              '\₹ ${cartController.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
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
                                borderRadius: BorderRadius.circular(48),
                              ),
                            ),
                            child: const Text(
                              'Order Now',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
