import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

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
    final doc = await db.collection("User").doc(email.value).get();
    Map<String, dynamic>? userData = doc.data();

    if (userData != null) {
      userName.value = (userData['name'] as String).capitalizeFirst ?? '';
      studentId.value = userData['student id'] ?? '';
      email.value = userData['email'] ?? '';
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
      print(e);
    }
  }
}
