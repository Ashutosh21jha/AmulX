import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsModel {
  final String? id;
  final double price;
  final String imageUrl;
  final String type;
  final bool availability;
  final int stock;

  ItemsModel({
    this.id,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.availability,
    required this.stock,
  });

  /*factory ItemsModel. fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data() ?? {};
    return ItemsModel(
      id: snapshot.id,
      price: data['price'] ?? '',
      type: data['type'] ?? '',
      availability: data['availability'] as bool? ?? false,
      imageUrl: data['imageUrl'] ?? '',
    );
  }*/

/*  static Future<List<ItemsModel>> fetchAvailableItems() async {
    try {
      final db = FirebaseFirestore.instance;
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

          return availableSnapshot.docs
              .map((DocumentSnapshot<Map<String, dynamic>> doc) {
            return ItemsModel.fromSnapshot(doc);
          }).toList();
        }
      }

      return [];
    } catch (e) {
      print("Error fetching available items: $e");
      return [];
    }
  }*/
}
