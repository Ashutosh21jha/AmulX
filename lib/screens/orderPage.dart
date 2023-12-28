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
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
              if (latestOrders.isEmpty) {
                return Text('No orders found.');
              }

              var order = latestOrders.first;
              var itemsMap = order['items'] as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${order['orderID']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Order Status: ${order['orderStatus']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Items:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: itemsMap.entries
                        .map(
                          (entry) => Text(
                            '${entry.key}: ${entry.value['count']} items, ₹${entry.value['price']} each',
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackingPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            padding: EdgeInsets.symmetric(vertical: 28, horizontal: 85),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            textStyle: TextStyle(fontSize: 20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text('Track Order'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
