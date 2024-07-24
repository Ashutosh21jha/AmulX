import 'dart:async';

import 'package:amul/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _auth = FirebaseAuth.instance;
final _db = FirebaseFirestore.instance;

class CartController extends GetxController {
  static CartController get to => Get.put(CartController());
  late List<bool> tappedList;
  late List<int> countList;
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  bool isCartEmpty = false;
  bool currentOrder = false;

  String get userId => _auth.currentUser?.email ?? '';

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
      return null;
    }
    return null;
  }

  CartItem? getCartItem(String name) {
    final cartItem = cartItems.where((element) => element.name == name);

    if (cartItem.isEmpty) {
      return null;
    }

    return cartItem.first;
  }

  Future<void> addItem(CartItem item) async {
    try {
      final userCartCollection =
          _db.collection('User').doc(userId).collection('cart');

      // Check if the item exists
      final cartItemDoc = await userCartCollection
          .where('name', isEqualTo: item.name)
          .limit(1)
          .get();

      if (cartItemDoc.docs.isEmpty) {
        await userCartCollection.doc(item.name).set({
          'name': item.name,
          'count': 1,
          'price': item.price,
        });
      }

      final docId = cartItemDoc.docs.first.id;

      await userCartCollection.doc(docId).update({
        'count': FieldValue.increment(1),
      });

      cartItems.value = cartItems.map((element) {
        if (element.name != item.name) {
          return element;
        }

        return CartItem(
          name: element.name,
          price: element.price,
          quantity: element.quantity + 1,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error adding item to Firestore: $e');
    }
    update();
  }

  Future<void> removeItem(CartItem item) async {
    try {
      final userCartCollection =
          _db.collection('User').doc(userId).collection('cart');

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

      cartItems.value = cartItems.map((element) {
        if (element.name != item.name) {
          return element;
        }

        return CartItem(
          name: element.name,
          price: element.price,
          quantity: element.quantity == 1 ? 0 : element.quantity - 1,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error removing item from Firestore: $e');
    }
    update();
  }

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  Future<void> fetchCart() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> cartref =
          await _db.collection('User').doc(userId).get();

      if (cartref.exists) {
        QuerySnapshot<Map<String, dynamic>> cartdoc =
            await _db.collection('User').doc(userId).collection('cart').get();

        /*final cartRef = user.collection('cart');
          final cart = await cartRef.get();
*/
        if (cartdoc.docs.isNotEmpty) {
          cartItems.clear();
          cartItems.addAll(cartdoc.docs.map((doc) {
            return CartItem(
              name: doc['name'] ?? '',
              price: doc['price'],
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
      await _db
          .collection('User')
          .doc(userId)
          .collection('cart')
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print("Error deleting cart: $e");
    }
  }

  Future<List<String>> updateStockOnPay(List<CartItem> cartItems) async {
    final List<String> itemsOutOfStock = [];

    try {
      await _db.runTransaction((transaction) async {
        final availableCollection =
            _db.collection('menu').doc('today menu').collection('available');

        for (final cartItem in cartItems) {
          final itemDoc = await availableCollection.doc(cartItem.name).get();

          if (itemDoc.exists) {
            final int currentStock = itemDoc['stock'] ?? 0;
            final int newStock = currentStock - cartItem.quantity;

            if (newStock > 0) {
              // Update the stock
              transaction.update(
                availableCollection.doc(cartItem.name),
                {'stock': newStock},
              );
            } else if (newStock == 0) {
              transaction.update(
                availableCollection.doc(cartItem.name),
                {'availability': false, 'stock': newStock},
              );
            } else {
              itemsOutOfStock.add(cartItem.name);
            }
          }
        }
      });
    } catch (error) {
      debugPrint('Error updating stock on pay: $error');
      // Handle the error as needed
    }
    return itemsOutOfStock;
  }

  Future<void> addBackStock(List<CartItem> cartItems) async {
    try {
      await _db.runTransaction((transaction) async {
        final availableCollection =
            _db.collection('menu').doc('today menu').collection('available');

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
  }
}
