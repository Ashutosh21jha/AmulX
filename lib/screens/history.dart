import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../widgets/item.dart';

class History extends StatelessWidget {
  History({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  String get userId => auth.currentUser?.email ?? '';

  CollectionReference get historyCollection =>
      FirebaseFirestore.instance.collection('User/$userId/history');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    Stream<ImageProvider> getProfilePicture() async* {
      FirebaseStorage storage = FirebaseStorage.instance;
      while (true) {
        try {
          String downloadURL =
          await storage.ref('user/pp_$userId.jpg').getDownloadURL();
          yield NetworkImage(downloadURL);
        } catch (e) {
          // The file doesn't exist
          yield const AssetImage('assets/images/avatar.png');
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00084B),
                  Color(0xFF2E55C0),
                  Color(0xFF148BFA),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Orders",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: historyCollection.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                                width: Get.width * 0.5,
                                height: Get.height * 0.3,
                                child: const CircularProgressIndicator()));
                      }

                      List<Map<String, dynamic>> orders = snapshot.data!.docs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();

                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> order = orders[index];
                          List<dynamic> orderList = order['orders'];

                          return Column(
                            children: orderList.map((orderItem) {
                              Map<String, dynamic> items =
                                  Map<String, dynamic>.from(orderItem['items']);
                              String itemsString = items.entries.map((e) {
                                Map<String, dynamic> item =
                                    Map<String, dynamic>.from(e.value);
                                return '${item['count']} x ${e.key}: ₹${item['price']}';
                              }).join('\n');

                              String orderName = orderItem['orderID'];

                              return ListItem(
                                id: snapshot.data!.docs[index].id,
                                items: itemsString,
                                orderStatus: orderItem['orderStatus'],
                                timestamp: orderItem['time'],
                                orderID: orderName,
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
