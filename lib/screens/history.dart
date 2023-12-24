import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00074B),
                  Color(0xFF2D55C0),
                  Color(0xFF2D55C0),
                  Color(0xFF138BF9)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Past Orders",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w700,
                            height: 0.06,
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: historyCollection.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      List<Map<String, dynamic>> orders = snapshot.data!.docs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();

                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> order = orders[index];
                          Map<String, dynamic> items =
                              Map<String, dynamic>.from(order['items']);
                          String itemsString = items.entries
                              .map((e) => '${e.key}: ${e.value}')
                              .join('\n');
                          return ListItem(
                            id: snapshot.data!.docs[index].id,
                            items: itemsString,
                            orderStatus: order['orderStatus'],
                            timestamp: order['timestamp'],
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
