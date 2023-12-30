import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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

                  var order = latestOrders.last;
                  var itemsMap = order['items'] as Map<String, dynamic>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.3,
                              isFirst: true,
                              isLast: false,
                              indicatorStyle: IndicatorStyle(
                                width: 20,
                                color: getStepColor(0, order['orderStatus']),
                              ),
                              beforeLineStyle: LineStyle(
                                color: getStepColor(0, order['orderStatus']),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                ),
                                child: Center(
                                  child: Text(
                                    'Placed',
                                    style: TextStyle(
                                      color:
                                          getStepColor(0, order['orderStatus']),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.3,
                              isFirst: false,
                              isLast: false,
                              indicatorStyle: IndicatorStyle(
                                width: 40,
                                color: getStepColor(1, order['orderStatus']),
                              ),
                              beforeLineStyle: LineStyle(
                                color: getStepColor(1, order['orderStatus']),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                ),
                                child: Center(
                                  child: Text(
                                    'Preparing',
                                    style: TextStyle(
                                      color:
                                          getStepColor(1, order['orderStatus']),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.3,
                              isFirst: false,
                              isLast: true,
                              indicatorStyle: IndicatorStyle(
                                width: 20,
                                color: getStepColor(2, order['orderStatus']),
                              ),
                              beforeLineStyle: LineStyle(
                                color: getStepColor(2, order['orderStatus']),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                ),
                                child: Center(
                                  child: Text(
                                    'Ready',
                                    style: TextStyle(
                                      color:
                                          getStepColor(2, order['orderStatus']),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Order ID: ${order['orderID']}',
                          style: TextStyle(color: Colors.indigo, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Status: ${order['orderStatus']}',
                          style: TextStyle(color: Colors.indigo, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Items: ',
                        style: TextStyle(color: Colors.indigo, fontSize: 20),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemsMap.entries.length,
                        itemBuilder: (context, index) {
                          var entry = itemsMap.entries.elementAt(index);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}:',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 20),
                              ),
                              Text(
                                '${entry.value['count']} items, ₹${entry.value['price']} each',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 20),
                              ),
                              // Add a SizedBox to create a gap between items
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Color getStepColor(int stepIndex, String orderStatus) {
    if (stepIndex == 0) {
      return Colors.green;
    } else if (getActiveStep(orderStatus) >= stepIndex) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  int getActiveStep(String orderStatus) {
    if (orderStatus == 'Preparing') {
      return 1; // Active step for 'Preparing'
    } else if (orderStatus == 'Ready') {
      return 2; // Active step for 'Ready'
    } else {
      return 0; // Default active step
    }
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
        print('Filtered Docs: $filteredDocs');

        var ordersWithStatus = filteredDocs
            .where((doc) => doc['orderStatus'] != 'preparing')
            .toList();
        print('Orders with Status: $ordersWithStatus');

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
