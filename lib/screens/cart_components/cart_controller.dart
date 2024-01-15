import 'dart:async';

import 'package:amul/screens/cart_components/cartItem_model.dart';
import 'package:amul/screens/emailverification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get to => Get.put(CartController());
  late List<bool> tappedList;
  late List<int> countList;
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  bool isCartEmpty = false;
  bool currentOrder = false;

  final db = FirebaseFirestore.instance;
  late Timer _timer;

  String get userId => auth.currentUser?.email ?? '';

  int calculateItemCount(List<CartItem> cartItems) {
    return cartItems
        .map((item) => item.quantity)
        .fold(0, (prev, current) => prev + current);
  }

  Future<String?> fetchCurrentOrder() async {
    try {
      String collectionPath = 'User/$userId';
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.doc(collectionPath).get();
      currentOrder = userDoc.get('currentOrder');
    } catch (e) {
      print('Error fetching current order from Firestore: $e');
      return null;
    }
    return null;
  }

  Future<void> addItem(CartItem item) async {
    try {
      final userCartCollection =
          db.collection('User').doc(userId).collection('cart').doc(item.name);

      // Check if the item already exists
      // final cartItemDoc = await userCartCollection
      //     .where('name', isEqualTo: item.name)
      //     .limit(1)
      //     .get();
      try {
        await userCartCollection.get().then((value) {
          try {
            userCartCollection.update({
              'count': FieldValue.increment(1),
            });
          } catch (e) {
            print('Doc does not exist');
          }
        });
      } catch (e) {
        await userCartCollection.set({
          'name': item.name,
          'count': 1,
          'price': item.price,
        });
      }
      /* final existingItemIndex =
            cartItems.indexWhere((element) => element.name == item.name);

        if (existingItemIndex != -1) {
          //update the quantity
          cartItems[existingItemIndex].incrementQuantity();
        } else {
          cartItems.add(item);
        }*/
    } catch (e) {
      print('Error adding item to Firestore: $e');
    }
    update();
  }

  Future<void> updateStockInMenu(String itemName, int changeAmount) async {
    try {
      final availableCollection =
          db.collection('menu').doc('today menu').collection('available');

      await db.runTransaction((transaction) async {
        final itemDoc = await availableCollection.doc(itemName).get();

        if (itemDoc.exists) {
          final currentStock = itemDoc['stock'] ?? 0;
          final newStock = currentStock + changeAmount;

          if (newStock >= 0) {
            // Update the stock
            transaction.update(
              availableCollection.doc(itemName),
              {'stock': newStock},
            );
          } else {
            // Handle out-of-stock case
            print('Item $itemName is out of stock.');
          }
        }
      });
    } catch (error) {
      print('Error updating stock: $error');
      // Handle the error as needed
    }
  }

  Future<void> removeItem(CartItem item) async {
    try {
      final userCartCollection =
          db.collection('User').doc(userId).collection('cart');

      // Check if the item exists
      final cartItemDoc = await userCartCollection
          .where('name', isEqualTo: item.name)
          .limit(1)
          .get();

      if (cartItemDoc.docs.isNotEmpty) {
        final docId = cartItemDoc.docs.first.id;
        final existingQuantity = cartItemDoc.docs.first['count'] as int;

        if (existingQuantity > 1) {
          // Update the quantity
          await userCartCollection.doc(docId).update({
            'count': FieldValue.increment(-1),
          });
        } else {
          await userCartCollection.doc(docId).delete();
        }
      }

      /*final existingItem = cartItems.firstWhere(
        (element) => element.name == item.name,
        orElse: () => CartItem(name: '', price: 0.0, quantity: 0),
      );

      if (existingItem.name.isNotEmpty) {
        existingItem.decrementQuantity();
        if (existingItem.quantity <= 0) {
          cartItems.remove(existingItem);
        }
      }*/
    } catch (e) {
      print('Error removing item from Firestore: $e');
    }
    update();
  }

  Future<void> updateItemQuantity(CartItem item) async {
    try {
      final userCartCollection =
          db.collection('User').doc(userId).collection('cart');

      // Check if the item exists
      final cartItemDoc = await userCartCollection
          .where('name', isEqualTo: item.name)
          .limit(1)
          .get();

      if (cartItemDoc.docs.isNotEmpty) {
        final currentCount = cartItemDoc.docs.first['count'] as int;

        final quantityDifference = item.quantity - currentCount;

        final docId = cartItemDoc.docs.first.id;
        await userCartCollection.doc(docId).update({
          'count': FieldValue.increment(quantityDifference.toDouble()),
        });
      }
    } catch (e) {
      print('Error updating item quantity in Firestore: $e');
    }
    update();
  }

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  Future<void> fetchCart() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> cartref =
          await db.collection('User').doc(userId).get();

      if (cartref.exists) {
        QuerySnapshot<Map<String, dynamic>> cartdoc =
            await db.collection('User').doc(userId).collection('cart').get();

        /*final cartRef = user.collection('cart');
          final cart = await cartRef.get();
*/
        if (cartdoc.docs.isNotEmpty) {
          cartItems.clear();
          cartItems.addAll(cartdoc.docs.map((doc) {
            return CartItem(
              name: doc['name'] ?? '',
              price: double.parse(doc['price'] ?? '0.0'),
              quantity: doc['count'] ?? 0,
            );
          }));
        } else {
          cartItems.clear();
          reloadCart();
        }
      } else {
        print('The user document does not exist.');
      }
    } catch (e) {
      print("Error checking cart collection: $e");
    }
  }

  Future<void> reloadCart() async {
    isCartEmpty = cartItems.isEmpty;
    update();
  }

  Future<void> reloadFetchData() async {
    // _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
    CartController.to.fetchCart();
    CartController.to.reloadCart();
    // });
  }

  Future<void> deleteCart() async {
    try {
      await db
          .collection('User')
          .doc(userId)
          .collection('cart')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      print("Cart deleted successfully!");
    } catch (e) {
      print("Error deleting cart: $e");
    }
  }

  Future<void> updateStockOnPay(List<CartItem> cartItems) async {
    try {
      await db.runTransaction((transaction) async {
        final availableCollection =
            db.collection('menu').doc('today menu').collection('available');

        for (final cartItem in cartItems) {
          final itemDoc = await availableCollection.doc(cartItem.name).get();

          if (itemDoc.exists) {
            final currentStock = itemDoc['stock'] ?? 0;
            final newStock = currentStock - cartItem.quantity;

            if (newStock > 0) {
              // Update the stock
              transaction.update(
                availableCollection.doc(cartItem.name),
                {'stock': newStock},
              );
            }
            if (newStock == 0) {
              transaction.update(
                availableCollection.doc(cartItem.name),
                {'availability': false, 'stock': newStock},
              );
            } else {
              // Handle out-of-stock case
              print('Item ${cartItem.name} is out of stock.');
            }
          }
        }
      });
    } catch (error) {
      print('Error updating stock on pay: $error');
      // Handle the error as needed
    }
  }
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
        }
      }
    });
  } catch (error) {
    print('Error adding back stock: $error');
    // Handle the error as needed
  }
  CartController.to.reloadCart();
}

Future<void> updateStockOnPay(List<CartItem> cartItems) async {
  try {
    await db.runTransaction((transaction) async {
      final availableCollection =
          db.collection('menu').doc('today menu').collection('available');

      for (final cartItem in cartItems) {
        final itemDoc = await availableCollection.doc(cartItem.name).get();

        if (itemDoc.exists) {
          final currentStock = itemDoc['stock'] ?? 0;
          final newStock = currentStock - cartItem.quantity;

          if (newStock >= 0) {
            transaction.update(
              availableCollection.doc(cartItem.name),
              {'stock': newStock},
            );
          } else {
            // Handle out-of-stock case
            print('Item ${cartItem.name} is out of stock.');
          }
        }
      }
    });
  } catch (error) {
    print('Error updating stock on pay: $error');
  }
}
