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

  Stream<List<CartItem>> get cartItemsStream {
    final userCartCollection =
        _firestore.collection('User').doc(userId).collection('cart');

    return userCartCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartItem(
          name: data['name'] ?? '',
          price: 0.0,
          quantity: data['count'] ?? 0,
        );
      }).toList();
    });
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
        // Item exists, update the quantity
        final docId = cartItemDoc.docs.first.id;
        await userCartCollection.doc(docId).update({
          'count': FieldValue.increment(1),
        });
      } else {
        // Item does not exist, create a new document
        await userCartCollection.add({
          'name': item.name,
          'count': 1,
        });
      }

      // Update the local cart
      final existingItemIndex =
          cartItems.indexWhere((element) => element.name == item.name);

      if (existingItemIndex != -1) {
        // Item already exists, update the quantity
        cartItems[existingItemIndex].incrementQuantity();
      } else {
        // Item does not exist, add it to the local cart
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
        // Item exists, update or delete
        final docId = cartItemDoc.docs.first.id;
        final existingQuantity = cartItemDoc.docs.first['count'] as int;

        if (existingQuantity > 1) {
          // Update the quantity
          await userCartCollection.doc(docId).update({
            'count': FieldValue.increment(-1),
          });
        } else {
          // Delete the document if the quantity is 1
          await userCartCollection.doc(docId).delete();
        }
      }

      // Update the local cart
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

  Future<void> fetchCartItems() async {
    try {
      final userCartCollection =
          _firestore.collection('User').doc(userId).collection('cart');
      final cartSnapshot = await userCartCollection.get();

      cartItems.assignAll(cartSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartItem(
          name: data['name'] ?? '',
          price: 0.0,
          quantity: data['count'] ?? 0,
        );
      }).toList());
    } catch (e) {
      print('Error fetching cart items from Firestore: $e');
    }
    update();
  }
}
