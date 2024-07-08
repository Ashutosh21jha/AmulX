import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/cart_components/cartItem_model.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
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
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.08,
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.centerLeft,
          //       end: Alignment.centerRight,
          //       colors: [
          //         Color(0xFF00084B),
          //         Color(0xFF2E55C0),
          //         Color(0xFF148BFA),
          //       ],
          //     ),
          //   ),
          // ),
          const AmulXAppBar(title: "Orders"),

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
                        child: Center(
                          child: CircularProgressIndicator(
                            color: appColors.blue,
                          ),
                        ),
                      ),
                    );
                  }

                  List<Map<String, dynamic>> orders = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  orders = orders.map((Map<String, dynamic> order) {
                    order['orders'] =
                        (order['orders'] as List<dynamic>).map((perOrder) {
                      late final DateTime orderTime;
                      dynamic time = perOrder['time'];

                      try {
                        orderTime = (time as Timestamp).toDate();
                      } catch (e) {
                        orderTime =
                            DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time);
                      }

                      perOrder['time'] = orderTime;

                      return perOrder;
                    }).toList();

                    return order;
                  }).toList();

                  orders.sort((order1, order2) {
                    return order2['orders'][0]['time']
                        .compareTo(order1['orders'][0]['time']);
                  });

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

                          // print(orderItem['time']);

                          final DateTime orderTime = orderItem['time'];

                          // try {
                          //   orderTime =
                          //       (orderItem['time'] as Timestamp).toDate();
                          // } catch (e) {
                          //   orderTime = DateFormat("yyyy-MM-dd'T'HH:mm:ssxxx")
                          //       .parse(orderItem['time']);
                          // }

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
