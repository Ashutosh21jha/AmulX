import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/cart_components/cartItem_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../widgets/item.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final auth = FirebaseAuth.instance;
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;

  String get userId => auth.currentUser?.email ?? '';

  CollectionReference get historyCollection =>
      FirebaseFirestore.instance.collection('User/$userId/history');

  Stream<ImageProvider> getProfilePicture() async* {
    FirebaseStorage storage = FirebaseStorage.instance;

    var ref = storage.ref('user/pp_$userId.jpg');
    var metadata = await ref.getMetadata().onError((error, stackTrace) {
      return Future.value(null);
    });

    String downloadURL = await ref.getDownloadURL();
    yield NetworkImage(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: appColors.backgroundColor,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF00084B),
                  Color(0xFF2E55C0),
                  Color(0xFF148BFA),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF00084B),
                  Color(0xFF2E55C0),
                  Color(0xFF148BFA),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.27),
                  const Text(
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
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<QuerySnapshot>(
                stream: historyCollection.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: Get.width * 0.5,
                        height: Get.height * 0.3,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    );
                  }

                  List<Map<String, dynamic>> orders = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                  orders.sort((order1, order2) =>
                      (order2['orders'][0]['time'] as Timestamp)
                          .compareTo(order1['orders'][0]['time'] as Timestamp));

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> order = orders[index];
                      List<dynamic> orderList = order['orders'];

                      return Column(
                        children: orderList.map((orderItem) {
                          Map<String, dynamic> items =
                              Map<String, dynamic>.from(orderItem['items']);
                          double totalAmount = 0.0;

                          for (var entry in items.entries) {
                            Map<String, dynamic> item =
                                Map<String, dynamic>.from(entry.value);
                            totalAmount += (item['price']) * (item['count']);
                          }

                          List<CartItem> historyItems = items.entries
                              .map((item) => CartItem(
                                  name: item.key,
                                  price: item.value['price'],
                                  quantity: item.value['count']))
                              .toList();
                          String orderName = orderItem['orderID'];
                          DateTime orderTime =
                              (orderItem['time'] as Timestamp).toDate();

                          return ListItem(
                            id: snapshot.data!.docs[index].id,
                            items: historyItems,
                            orderStatus: orderItem['orderStatus'],
                            timestamp: orderTime,
                            orderID: orderName,
                            totalAmount: totalAmount.toDouble(),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
