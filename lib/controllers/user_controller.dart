import 'dart:io';
import 'package:amul/api/cashfree.dart';
import 'package:amul/controllers/cart_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  RxString userName = ''.obs;
  RxString studentId = ''.obs;
  RxString userId = ''.obs;
  RxString email = ''.obs;
  RxString imageUrl = ''.obs;

  UserController() : super() {
    userId.value = auth.currentUser?.uid ?? '';
    email.value = auth.currentUser?.email ?? '';
  }

  Future<void> getUserData() async {
    email.value = FirebaseAuth.instance.currentUser?.email! ?? '';
    userId.value = FirebaseAuth.instance.currentUser?.uid ?? '';
    final doc = await db.collection("User").doc(email.value).get();
    Map<String, dynamic>? userData = doc.data();

    if (userData != null) {
      userName.value = (userData['name'] as String).capitalizeFirst ?? '';
      studentId.value = userData['student id'] ?? '';
      imageUrl.value = userData['imageUrl'] ?? '';
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    File imageFile = File(image.path);

    try {
      await FirebaseStorage.instance
          .ref('user/pp_$email.jpg')
          .putFile(imageFile);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateUserCurrentOrderStatusTo(bool status) async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(email.value)
        .update({'currentOrder': status});
  }

  Future<void> addOrderToUserHistrory(String formattedDate, String orderID,
      OrderPaymentStatus orderPaymentStatus) async {
    final CartController cartController = Get.find<CartController>();

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
          'orderID': orderID,
          'time': formattedDate,
          'orderStatus': orderPaymentStatus != OrderPaymentStatus.UNKNOWN
              ? 'Placed'
              : "Not Placed",
          'paymentStatus': orderPaymentStatus.value
        }
      ]),
    };

    final historyCollection =
        FirebaseFirestore.instance.collection('User/${email.value}/history');
    final docSnapshot = await historyCollection.doc(formattedDate).get();

    if (docSnapshot.exists) {
      // Document exists, update it
      await historyCollection.doc(formattedDate).update(orderData);
    } else {
      // Document doesn't exist, create it
      await historyCollection.doc(formattedDate).set(orderData);
    }

    await updateUserCurrentOrderStatusTo(true);
  }
}
