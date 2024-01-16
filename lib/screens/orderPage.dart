import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderPage extends StatefulWidget {
  final String userId;

  const OrderPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String orderId = '';
  late double totalAmount = 0;
  bool isDeclined = false;
  @override
  void initState() {
    super.initState();
    fetchId();
    FirebaseFirestore.instance
        .collection('Declined')
        .snapshots()
        .forEach((element) {
      for (var element in element.docs) {
        if (element.id == orderId) {
          print("$orderId is declined.");
          setState(() {
            isDeclined = true;
          });
        }
      }
    });
  }

  void fetchId() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('prepList').get();
    try {
      print('Fetching orders for userId: ${widget.userId}');
      var filteredDocs = querySnapshot.docs
          .where((doc) =>
              RegExp(r'^ORD-\d+$').hasMatch(doc.id.toString()) &&
              (doc['userId'] == widget.userId) &&
              doc['orderStatus'] != 'Placed')
          .toList();
      print(
          'Filtered Docs: ${filteredDocs.toList().elementAt(0).get('orderID')}');
      setState(() {
        orderId = filteredDocs.toList().elementAt(0).get('orderID');
        calculateTotalAmount(filteredDocs.toList().elementAt(0).get('items'));
      });
    } catch (e) {
      // If no orders are found in 'prepList', check 'Declined'
      QuerySnapshot declinedSnapshot = await FirebaseFirestore.instance
          .collection('Declined')
          .where('email', isEqualTo: widget.userId)
          .where('isRefunded', isEqualTo: false)
          .get();

      print('Declined Collection Documents: ${declinedSnapshot.docs.length}');

      var filteredDocs = declinedSnapshot.docs
          .where((doc) =>
              RegExp(r'^ORD-\d+$').hasMatch(doc.id.toString()) &&
              doc['orderStatus'] == 'Declined')
          .toList();

      print('Filtered Docs Count: ${filteredDocs.length}');
      if (filteredDocs.isNotEmpty) {
        var firstDoc = filteredDocs.first;
        print('First Document ID: ${filteredDocs.first.id}');
        print('First Document Data: ${filteredDocs.first.data()}');
        print(
            'Filtered Docs: ${filteredDocs.toList().elementAt(0).get('orderID')}');
        setState(() {
          orderId = filteredDocs.toList().elementAt(0).get('orderID');
          calculateTotalAmount(filteredDocs.toList().elementAt(0).get('items'));
          isDeclined = true;
        });
      } else {
        print('No matching documents found in Declined collection');
      }
    }
  }

  void calculateTotalAmount(Map<String, dynamic> items) {
    totalAmount = 0;

    items.forEach((key, value) {
      double itemTotal = value['count'] * value['price'];
      totalAmount += itemTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    // StreamBuilder(stream: FirebaseFirestore.instance
    //     .collection('prepList')
    //     .doc(orderId)
    //     .snapshots(), builder:(context,snap){
    //     if(snap.hasError){
    //       setState(() {
    //         isDeclined=true;
    //       });
    //     }
    //     return Container();
    // });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Your Orders',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: orderId == ''
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppColors.blue,
                      ))
                    : StreamBuilder(
                        stream: isDeclined == false
                            ? FirebaseFirestore.instance
                                .collection('prepList')
                                .doc(orderId)
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Declined')
                                .doc(orderId)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                  child: const CircularProgressIndicator()),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Text('No orders found.');
                          } else {
                            if (snapshot.data == null) {
                              return const Text('No orders found.');
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "ID: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.blue,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshot.data?['orderID']
                                                    .toString() ??
                                                '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.currency_rupee_outlined,
                                              color: Colors.green,
                                              size: 17,
                                            ),
                                          ),
                                          TextSpan(
                                            text: totalAmount.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                isDeclined == false
                                    ? SizedBox(
                                        height: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TimelineTile(
                                              axis: TimelineAxis.horizontal,
                                              alignment: TimelineAlign.manual,
                                              lineXY: 0.3,
                                              isFirst: true,
                                              isLast: false,
                                              indicatorStyle: IndicatorStyle(
                                                width: 20,
                                                color: getStepColor(
                                                    0,
                                                    snapshot
                                                        .data?['orderStatus']),
                                              ),
                                              beforeLineStyle: LineStyle(
                                                color: getStepColor(
                                                    0,
                                                    snapshot
                                                        .data?['orderStatus']),
                                              ),
                                              endChild: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  minHeight: 80,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Placed',
                                                    style: TextStyle(
                                                      color: getStepColor(
                                                          0,
                                                          snapshot.data?[
                                                              'orderStatus']),
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
                                                color: getStepColor(
                                                    1,
                                                    snapshot
                                                        .data?['orderStatus']),
                                              ),
                                              beforeLineStyle: LineStyle(
                                                color: getStepColor(
                                                    1,
                                                    snapshot
                                                        .data?['orderStatus']),
                                              ),
                                              endChild: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  minHeight: 80,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Preparing',
                                                    style: TextStyle(
                                                      color: getStepColor(
                                                          1,
                                                          snapshot.data?[
                                                              'orderStatus']),
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
                                                color: getStepColor(
                                                    2,
                                                    snapshot
                                                        .data?['orderStatus']),
                                              ),
                                              beforeLineStyle: LineStyle(
                                                color: getStepColor(
                                                    2,
                                                    snapshot
                                                        .data?['orderStatus']),
                                              ),
                                              endChild: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  minHeight: 80,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Ready',
                                                    style: TextStyle(
                                                      color: getStepColor(
                                                          2,
                                                          snapshot.data?[
                                                              'orderStatus']),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 40,
                                        child: Text(
                                          'Order Declined\nYour Code is ${snapshot.data?['code']}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?['items'].length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> map =
                                          snapshot.data?['items'];
                                      final key = map.keys.elementAt(index);
                                      final value = map[key];
                                      /*return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${map.keys.elementAt(index)}:',
                                      style: const TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      '${value['count']} items, ₹${value['price']} each',
                                      style: const TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 20),
                                    ),
                                    // Add a SizedBox to create a gap between items
                                    const SizedBox(height: 10),
                                  ],
                                );*/

                                      return ListTile(
                                        leading: Text(
                                          ' ${map.keys.elementAt(index)} (x ${value['count']})',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        trailing: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.currency_rupee_outlined,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' ${value['price']}',
                                                style: const TextStyle(
                                                  color: AppColors.green,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: '  each',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Color getStepColor(int stepIndex, String orderStatus) {
    if (stepIndex == 0) {
      return AppColors.green;
    } else if (getActiveStep(orderStatus) >= stepIndex) {
      return AppColors.green;
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
}
