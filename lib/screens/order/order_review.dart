import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/order_payment_controller.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:amul/widgets/amulX_snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import '../cart_components/cart_controller.dart';
import '../cart_components/cartItem_model.dart';

class OrderReviewPage extends StatefulWidget {
  OrderReviewPage({super.key, required this.cartItems});

  String get userEmail => auth.currentUser?.email ?? '';
  String get userId => auth.currentUser?.uid ?? '';
  final auth = FirebaseAuth.instance;

  final RxList<CartItem> cartItems;

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  late final logger = Get.find<Logger>();
  late final orderPaymentController = Get.find<OrderPaymentController>();

  late int count;
  bool isLoading = false;
  bool isPaymentInProgress = false;

  @override
  void initState() {
    super.initState();
    priceFetch();
  }

  Future<void> processPayment() async {
    setState(() {
      isPaymentInProgress = true;
      isLoading = true;
    });

    try {
      final bool? itemsOutOfStock =
          await CartController.to.updateStockOnPay(CartController.to.cartItems);

      if (itemsOutOfStock == null || itemsOutOfStock) {
        AmulXSnackBars.showItemOutOfStockSnackbar();
        return;
      }

      final String? orderID = await getAndUpdateOrderIdInFirebase();

      logger.i(orderID);

      if (orderID == null) {
        AmulXSnackBars.showPaymentOrderFailureSnackbar();
        return;
      }

      await orderPaymentController.createNewOrderWithOrderID(
          orderID, totalAmount);

      if (orderPaymentController.orderData.value == null) {
        AmulXSnackBars.showPaymentOrderFailureSnackbar();
        return;
      }

      final cfSession = await orderPaymentController.getSession();

      if (cfSession == null) {
        AmulXSnackBars.showPaymentOrderFailureSnackbar();
        return;
      }

      await orderPaymentController.payWithUpi(cfSession);
    } finally {
      setState(() {
        isLoading = false;
        isPaymentInProgress = false;
      });
    }
  }

  Future<String?> getAndUpdateOrderIdInFirebase() async {
    String? orderID;
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference countRef =
            FirebaseFirestore.instance.collection('orderID').doc('IDCount');

        DocumentSnapshot countSnapshot = await transaction.get(countRef);
        int count = countSnapshot.get('ID');
        transaction.update(countRef, {'ID': ++count});
        orderID = "ORD-$count";
      });
    } catch (error) {
      print('Error updating order count: $error');
    }

    return orderID;
  }

  // Future<void> addBackStock(List<CartItem> cartItems) async {
  //   try {
  //     await db.runTransaction((transaction) async {
  //       final availableCollection =
  //           db.collection('menu').doc('today menu').collection('available');

  //       for (final cartItem in cartItems) {
  //         final itemDoc = await availableCollection.doc(cartItem.name).get();

  //         if (itemDoc.exists) {
  //           final currentStock = itemDoc['stock'] ?? 0;
  //           final newStock = currentStock + cartItem.quantity;

  //           // Update the stock
  //           transaction.update(
  //             availableCollection.doc(cartItem.name),
  //             {'stock': newStock},
  //           );
  //           if (newStock == 0) {
  //             transaction.update(
  //               availableCollection.doc(cartItem.name),
  //               {'availability': false},
  //             );
  //           }
  //           if (itemDoc['availability'] == false) {
  //             if (newStock > 0) {
  //               transaction.update(
  //                 availableCollection.doc(cartItem.name),
  //                 {'availability': true},
  //               );
  //             }
  //           }
  //         }
  //       }
  //     });
  //   } catch (error) {
  //     print('Error adding back stock: $error');
  //     // Handle the error as needed
  //   }
  //   CartController.to.reloadCart();
  // }

  void stockExceedSnackBar(List item) {
    Get.snackbar(
      'Stock Exceeded',
      'Reduce quantity for ${item.join(', ')}',
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

  Future<void> navigateToPayment() async {
    final exceededItems = <String>[];

    // Check if the quantity exceeds stock for each item
    for (final item in widget.cartItems) {
      final stock = await getStockFromMenu(item.name);
      if (item.quantity > stock) {
        exceededItems.add(item.name);
      }
    }

    if (exceededItems.isNotEmpty) {
      setState(() {
        isLoading = false;
      });

      stockExceedSnackBar(exceededItems);
      return;
    }

    processPayment();
  }

  Future<int> getStockFromMenu(String itemName) async {
    final availableCollection = FirebaseFirestore.instance
        .collection('menu')
        .doc('today menu')
        .collection('available');
    final itemDoc = await availableCollection.doc(itemName).get();

    if (itemDoc.exists) {
      return itemDoc['stock'] ?? 0;
    } else {
      return 0;
    }
  }

  double totalAmount = 0.0;

  void priceFetch() {
    for (var item in widget.cartItems) {
      totalAmount += item.price * item.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AmulXAppBar(
              title: "Summary",
              showBackArrow: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        'Order Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            '${item.name} (${item.quantity} ${item.quantity == 1 ? 'item' : 'items'})',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          trailing: Text(
                            '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: ListTile(
                          dense: true,
                          title: const Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          trailing: Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isPaymentInProgress
                  ? null
                  : () async {
                      processPayment();

                      // navigateToPayment();
                      // await CartController.to
                      // .updateStockOnPay(CartController.to.cartItems);
                      // setState(() {
                      // isLoading = false;
                      // });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: isLoading
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          color: AppColors.blue,
                        ),
                      )
                    : const Text(
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
      ),
    );
  }
}
