import 'package:amul/screens/profile.dart';
import 'package:amul/screens/trackingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPage extends StatelessWidget {
  final String userId;
  const OrderPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 84.0),
          child: const Text(
            'Your Order',
            style: TextStyle(color: Colors.indigo),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.indigo,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getLatestOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No orders found.');
                  } else {
                    List<Map<String, dynamic>> latestOrders = snapshot.data!;
                    return ListView.builder(
                      itemCount: latestOrders.length,
                      itemBuilder: (context, index) {
                        var order = latestOrders[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text('Order ID: ${order['orderID']}'),
                            subtitle:
                                Text('Order Status: ${order['orderStatus']}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackingPage(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getLatestOrders() async {
    try {
      print('Fetching orders for userId: $userId');
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('prepList').get();
      if (querySnapshot.docs.isNotEmpty) {
        print('Fetching orders for userId: $userId');
        var filteredDocs = querySnapshot.docs
            .where((doc) =>
                RegExp(r'^ORD-\d{3}$').hasMatch(doc.id.toString()) &&
                (doc['userId'] == userId) &&
                doc['orderStatus'] != 'Placed')
            .toList();

        if (filteredDocs.isNotEmpty) {
          // Return the latest orders
          return filteredDocs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching latest orders: $e');
    }

    return [];
  }
}
