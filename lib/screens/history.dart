import 'package:amul/Utils/AppColors.dart';
import 'package:amul/Utils/enums.dart';
import 'package:amul/models/cart_item_model.dart';
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
import 'package:lottie/lottie.dart';
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
          const AmulXAppBar(
            title: "Orders",
            // rightIcon: IconButton( onPressed: () => Get.showOverlay(
            //         asyncFunction: AmulxFirebaseAPI.checkAndUpdateRefundsStatus,
            //         loadingWidget:
            //             const Center(child: CircularProgressIndicator())),
            //     icon: Icon(
            //       Icons.refresh,
            //       color: appColors.onPrimary,
            //     )),
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

                  // orders = orders.map((Map<String, dynamic> order) {
                  //   order['orders'] =
                  //       (order['orders'] as List<dynamic>).map((perOrder) {
                  //     late final DateTime orderTime;
                  //     dynamic time = perOrder['time'];

                  //     try {
                  //       orderTime = (time as Timestamp).toDate();
                  //     } catch (e) {
                  //       orderTime =
                  //           DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time);
                  //     }

                  //     perOrder['time'] = orderTime;

                  //     return perOrder;
                  //   }).toList();

                  //   return order;
                  // }).toList();

                  orders.sort((order1, order2) {
                    final DateTime order1Time =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                            .parse(order1['orders'][0]['time']);
                    final DateTime order2Time =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                            .parse(order2['orders'][0]['time']);

                    return order2Time.compareTo(order1Time);
                  });

                  return orders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "No Orders to show!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Lottie.asset(
                                "assets/raw/noHistory.json",
                                height: 300,
                                width: double.infinity,
                                repeat: false,
                                frameRate: FrameRate(30),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> order = orders[index];
                            List<dynamic> orderList = order['orders'];

                            return Column(
                              children: orderList.map((orderItem) {
                                Map<String, dynamic> items =
                                    Map<String, dynamic>.from(
                                        orderItem['items']);
                                double totalAmount = 0.0;

                                for (var entry in items.entries) {
                                  Map<String, dynamic> item =
                                      Map<String, dynamic>.from(entry.value);
                                  totalAmount +=
                                      (item['price']) * (item['count']);
                                }

                                List<CartItem> historyItems = items.entries
                                    .map((item) => CartItem(
                                        name: item.key,
                                        price: double.parse(
                                            (item.value['price']).toString()),
                                        quantity: item.value['count']))
                                    .toList();
                                String orderName = orderItem['orderID'];

                                final DateTime orderTime =
                                    DateFormat("yyyy-MM-dd'T'HH:mm")
                                        .parse(orderItem['time']);

                                final FirebaseOrderStatus firebaseOrderStatus =
                                    FirebaseOrderStatus.fromString(
                                        orderItem['orderStatus']);
                                final RefundStatus? refundStatus =
                                    orderItem['refundStatus'] != null
                                        ? RefundStatus.fromString(
                                            orderItem['refundStatus'])
                                        : null;

                                return ListItem(
                                  id: orderItem['time'],
                                  items: historyItems,
                                  orderStatus: firebaseOrderStatus,
                                  refundStatus: refundStatus,
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
