import 'dart:math';

import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/profile.dart';
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

String generateRandomOrderID() {
  // Generate a random number between 1000 and 9999
  int randomOrderNumber = Random().nextInt(9000) + 1000;
  // Combine it with a prefix, if needed
  return 'ORD-$randomOrderNumber';
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  late int count;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    priceFetch();
    fetch();
  }

  void fetch() async {
    await FirebaseFirestore.instance
        .collection('orderID')
        .doc('IDCount')
        .get()
        .then((value) {
      count = value.get('ID');
    });
    FirebaseFirestore.instance.collection('orderID').doc('IDCount').update({
      'ID': ++count,
    });
  }

  Future<void> addBackStock(List<CartItem> cartItems) async {
    try {
      await db.runTransaction((transaction) async {
        final availableCollection =
            db.collection('menu').doc('today menu').collection('available');

        for (final cartItem in cartItems) {
          final itemDoc = await availableCollection.doc(cartItem.name).get();

          if (itemDoc.exists) {
            final currentStock = itemDoc['stock'] ?? 0;
            final newStock = currentStock + cartItem.quantity;

            // Update the stock
            transaction.update(
              availableCollection.doc(cartItem.name),
              {'stock': newStock},
            );
            if (newStock == 0) {
              transaction.update(
                availableCollection.doc(cartItem.name),
                {'availability': false},
              );
            }
            if (itemDoc['availability'] == false) {
              if (newStock > 0) {
                transaction.update(
                  availableCollection.doc(cartItem.name),
                  {'availability': true},
                );
              }
            }
          }
        }
      });
      CartController.to.deleteCart();
    } catch (error) {
      print('Error adding back stock: $error');
      // Handle the error as needed
    }
    CartController.to.reloadCart();
  }

  Future<String> getUserName(String userId) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      if (userDoc.exists) {
        return userDoc['name'];
      } else {
        return '';
      }
    } catch (error) {
      print('Error getting user name: $error');
      return '';
    }
  }

  void handlePaymentSuccessResponse(
      PaymentSuccessResponse response, CartController cartController) async {
    try {
      final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final historyCollection =
          FirebaseFirestore.instance.collection('User/$userId/history');

      final prepListCollection =
          FirebaseFirestore.instance.collection('prepList');

      String orderID = generateRandomOrderID();
      final orderData = {
        'orders': FieldValue.arrayUnion([
          {
            'items': cartController.cartItems.fold<Map<String, dynamic>>({},
                (map, item) {
              map[item.name] = {
                'count': item.quantity,
                'price': item.price,
              };
              return map;
            }),
            'orderID': 'ORD-$count',
            'time': DateTime.now(),
            'orderStatus': 'Placed',
          }
        ]),
      };

      final itemsMap = cartController.cartItems.fold<Map<String, dynamic>>(
        {},
        (map, item) {
          map[item.name] = {
            'count': item.quantity,
            'price': item.price,
          };
          return map;
        },
      );

      final prepListOrderData = {
        'userId': userId,
        'items': itemsMap,
        'orderID': 'ORD-$count',
        'orderStatus': 'Placed',
        'name': await getUserName(userId),
        'time': DateTime.now(),
      };

      final docSnapshot = await historyCollection.doc(formattedDate).get();

      if (docSnapshot.exists) {
        // Document exists, update it
        await historyCollection.doc(formattedDate).update(orderData);
      } else {
        // Document doesn't exist, create it
        await historyCollection.doc(formattedDate).set(orderData);
      }

      await prepListCollection.doc('ORD-$count').set(prepListOrderData);

      // Listen for changes in prepList document
      prepListCollection.doc('ORD-$count').snapshots().listen((event) async {
        // Check if the orderStatus field has changed
        final newOrderStatus = event['orderStatus'];
        if (newOrderStatus != 'Placed') {
          await historyCollection.doc(formattedDate).update({
            'orders': FieldValue.arrayUnion([
              {
                'items': cartController.cartItems.fold<Map<String, dynamic>>({},
                    (map, item) {
                  map[item.name] = {
                    'count': item.quantity,
                    'price': item.price,
                  };
                  return map;
                }),
                'orderID': 'ORD-$count',
                'time': DateTime.now(),
                'orderStatus': newOrderStatus,
              }
            ]),
          });
        }
      });

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
      await CartController.to.deleteCart();
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('Error handling payment success: $error');
      setState(() {
        isLoading = false;
      });
    }
    Get.offAll(() => const Mainscreen());
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
    CartController.to.deleteCart();
    setState(() {
      isLoading = false;
    });
    addBackStock(CartController.to.cartItems);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    setState(() {
      isLoading = false;
    });
  }

  void showsnackBar(List item) {
    Get.snackbar(
      'Stock Exceeded',
      'Reduce quantity for ${item.join(', ')}',
      colorText: Colors.indigo,
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> navigateToPayment() async {
    print('Inside navigateToPayment');
    final exceededItems = <String>[];

    // Check if the quantity exceeds stock for each item
    for (final item in widget.cartItems) {
      final stock = await getStockFromMenu(item.name);
      if (item.quantity > stock) {
        exceededItems.add(item.name);
        print('${item.name} quantity exceeds stock: ${item.quantity} > $stock');
      }
    }

    if (exceededItems.isNotEmpty) {
      print('Stock Exceeded for items: ${exceededItems.join(', ')}');
      showsnackBar(exceededItems);
      setState(() {
        isLoading = false;
      });
      // Get.back();
    } else {
      print("Stock check passed");
      final cartItems = widget.cartItems;
      double totalAmount = 0.0;
      for (var item in cartItems) {
        totalAmount += item.price * item.quantity;
      }
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
        'prefill': {'contact': '8178600597', 'email': 'devcomm.nsut@nsut.ac.in'}
      };

      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
        handlePaymentSuccessResponse(response, CartController.to);
      });
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      razorpay.open(options);
    }
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

  // final cartItems = widget.cartItems;
  double totalAmount = 0.0;

  void priceFetch() {
    for (var item in widget.cartItems) {
      totalAmount += item.price * item.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  SizedBox(width: Get.width * 0.26),
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
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
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
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
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              navigateToPayment();
              await CartController.to
                  .updateStockOnPay(CartController.to.cartItems);
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
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: isLoading
                  ? const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: Colors.white,
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
    );
  }
}
