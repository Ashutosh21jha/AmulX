import 'dart:async';
import 'package:amul/models/items_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  static ItemController get to => Get.put(ItemController());

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String get userId => auth.currentUser?.email ?? '';
  final RxList<ItemsModel> Items = <ItemsModel>[].obs;
  final RxList<ItemsModel> food = <ItemsModel>[].obs;
  final RxList<ItemsModel> drink = <ItemsModel>[].obs;
  final RxList<ItemsModel> munchies = <ItemsModel>[].obs;
  final RxList<ItemsModel> dairy = <ItemsModel>[].obs;

  /* Map<String, RxList<Map<String, dynamic>>> itemsMap = {
    'food': <Map<String, dynamic>>[].obs,
    'drink': <Map<String, dynamic>>[].obs,
    'munchies': <Map<String, dynamic>>[].obs,
    'dairy': <Map<String, dynamic>>[].obs,
  }.obs;*/

  Future<void> fetchItems() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> menuSnapshot =
          await db.collection('menu').doc('today menu').get();
      if (menuSnapshot.exists) {
        bool? session = menuSnapshot.data()?['session'];

        if (session != null && session) {
          QuerySnapshot<Map<String, dynamic>> availableSnapshot = await db
              .collection('menu')
              .doc('today menu')
              .collection('available')
              .get();

          Items.clear();
          Items.addAll(availableSnapshot.docs.map((snapshot) {
            return ItemsModel(
              id: snapshot.id,
              price: snapshot.data()['price'] ?? '',
              type: snapshot.data()['type'] ?? '',
              availability: snapshot.data()['availability'] as bool? ?? false,
              imageUrl: snapshot.data()['imageUrl'] ?? '',
              stock: snapshot.data()['stock'] ?? 0,
            );
          }));

          food.clear();
          dairy.clear();
          munchies.clear();
          drink.clear();

          for (ItemsModel item in Items) {
            String itemType = item.type;

            switch (itemType) {
              case 'food':
                food.add(item);
                break;
              case 'drink':
                drink.add(item);
                break;
              case 'munchies':
                munchies.add(item);
                break;
              case 'dairy':
                dairy.add(item);
                break;
            }
          }
/*

          for (ItemsModel item in Items) {
            String itemType = item.type;
            RxList<ItemsModel> itemData = {
              'name': item.id!,
              'price': item.price,
              'image': item.imageUrl,
              'available': item.availability,
            };
            itemsMap[itemType]!.add(itemData);
          }*/
        }
      }
    } catch (e) {
      print("Error fetching items: $e");
    }
  }
}
