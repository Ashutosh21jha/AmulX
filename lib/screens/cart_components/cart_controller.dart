import 'package:amul/screens/cart_components/cart_items.dart';
import 'package:amul/screens/emailverification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get to => Get.put(CartController());
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => auth.currentUser?.email ?? '';

  int calculateItemCount(List<CartItem> cartItems) {
    return cartItems
        .map((item) => item.quantity)
        .fold(0, (prev, current) => prev + current);
  }

  Future<void> addItem(CartItem item) async {
    try {
      final userCartCollection =
          _firestore.collection('User').doc(userId).collection('cart');

      // Check if the item already exists
      final cartItemDoc = await userCartCollection
          .where('name', isEqualTo: item.name)
          .limit(1)
          .get();

      if (cartItemDoc.docs.isNotEmpty) {
        final docId = cartItemDoc.docs.first.id;
        await userCartCollection.doc(docId).update({
          'count': FieldValue.increment(1),
        });
      } else {
        await userCartCollection.add({
          'name': item.name,
          'count': 1,
        });
      }

      final existingItemIndex =
          cartItems.indexWhere((element) => element.name == item.name);

      if (existingItemIndex != -1) {
        //update the quantity
        cartItems[existingItemIndex].incrementQuantity();
      } else {
        cartItems.add(item);
      }
    } catch (e) {
      print('Error adding item to Firestore: $e');
    }
    update();
  }

  Future<void> removeItem(CartItem item) async {
    try {
      final userCartCollection =
          _firestore.collection('User').doc(userId).collection('cart');

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

      final existingItem = cartItems.firstWhere(
        (element) => element.name == item.name,
        orElse: () => CartItem(name: '', price: 0.0, quantity: 0),
      );

      if (existingItem.name.isNotEmpty) {
        existingItem.decrementQuantity();
        if (existingItem.quantity <= 0) {
          cartItems.remove(existingItem);
        }
      }
    } catch (e) {
      print('Error removing item from Firestore: $e');
    }
    update();
  }

  Future<void> updateItemQuantity(CartItem item) async {
    try {
      final userCartCollection =
          _firestore.collection('User').doc(userId).collection('cart');

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
}
