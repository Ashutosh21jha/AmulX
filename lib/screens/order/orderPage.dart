import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

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
  bool isRefunded = false;

  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;

  @override
  void initState() {
    super.initState();
    fetchId();
    FirebaseFirestore.instance
        .collection('Declined')
        .snapshots()
        .forEach((snapshot) {
      for (var element in snapshot.docs) {
        if (element.id == orderId) {
          if (element.data()['isRefunded'] == true) {
            refundFunction();
          }
          setState(() {
            isDeclined = true;
          });
        }
      }
    });
  }

  void refundFunction() async {
    Get.to(const Mainscreen());
    Get.snackbar(
      'Refund Initiated',
      'Check your account.',
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFA2E8D8),
          AppColors.green,
          Color(0xFF007A52),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      barBlur: 10,
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
    setState(() {
      isRefunded = true;
    });
  }

  void fetchId() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('prepList').get();
    try {
      var filteredDocs = querySnapshot.docs
          .where((doc) =>
              RegExp(r'^ORD-\d+$').hasMatch(doc.id.toString()) &&
              (doc['userId'] == widget.userId) &&
              doc['orderStatus'] != 'Placed')
          .toList();
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

      var filteredDocs = declinedSnapshot.docs
          .where((doc) =>
              RegExp(r'^ORD-\d+$').hasMatch(doc.id.toString()) &&
              doc['orderStatus'] == 'Declined')
          .toList();

      if (filteredDocs.isNotEmpty) {
        setState(() {
          orderId = filteredDocs.toList().elementAt(0).get('orderID');
          calculateTotalAmount(filteredDocs.toList().elementAt(0).get('items'));
          isDeclined = true;
        });
        // listenForRefundStatus();
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
    return Scaffold(
      /*appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blue,
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
      ),*/
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height * 0.16,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.02,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: appColors.onPrimary,
                      )),
                ),

                // SizedBox(width: MediaQuery.of(context).size.width * 0.27),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Orders",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appColors.onPrimary,
                      fontSize: 18,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      height: 0.06,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              surfaceTintColor: Colors.transparent,
              color: appColors.surfaceColor,
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
                                              TextSpan(
                                                text: "ID: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: appColors.blue,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              TextSpan(
                                                text: snapshot.data?['orderID']
                                                        .toString() ??
                                                    '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: appColors.primaryText,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.currency_rupee_outlined,
                                                  color: appColors.green,
                                                  size: 17,
                                                ),
                                              ),
                                              TextSpan(
                                                text: totalAmount.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: appColors.green,
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
                                                  alignment:
                                                      TimelineAlign.manual,
                                                  lineXY: 0.3,
                                                  isFirst: true,
                                                  isLast: false,
                                                  indicatorStyle:
                                                      IndicatorStyle(
                                                    width: 20,
                                                    color: getStepColor(
                                                        0,
                                                        snapshot.data?[
                                                            'orderStatus']),
                                                  ),
                                                  beforeLineStyle: LineStyle(
                                                    color: getStepColor(
                                                        0,
                                                        snapshot.data?[
                                                            'orderStatus']),
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
                                                  alignment:
                                                      TimelineAlign.manual,
                                                  lineXY: 0.3,
                                                  isFirst: false,
                                                  isLast: false,
                                                  indicatorStyle:
                                                      IndicatorStyle(
                                                    width: 40,
                                                    color: getStepColor(
                                                        1,
                                                        snapshot.data?[
                                                            'orderStatus']),
                                                  ),
                                                  beforeLineStyle: LineStyle(
                                                    color: getStepColor(
                                                        1,
                                                        snapshot.data?[
                                                            'orderStatus']),
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
                                                  alignment:
                                                      TimelineAlign.manual,
                                                  lineXY: 0.3,
                                                  isFirst: false,
                                                  isLast: true,
                                                  indicatorStyle:
                                                      IndicatorStyle(
                                                    width: 20,
                                                    color: getStepColor(
                                                        2,
                                                        snapshot.data?[
                                                            'orderStatus']),
                                                  ),
                                                  beforeLineStyle: LineStyle(
                                                    color: getStepColor(
                                                        2,
                                                        snapshot.data?[
                                                            'orderStatus']),
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
                                            height: 50,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Order Declined',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  'Your Code is ${snapshot.data?['code']}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?['items'].length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> map =
                                            snapshot.data?['items'];
                                        final key = map.keys.elementAt(index);
                                        final value = map[key];

                                        return ListTile(
                                            leading: Text(
                                              ' ${map.keys.elementAt(index)} (x${value['count']})',
                                              style: TextStyle(
                                                  color: appColors.primaryText,
                                                  fontSize: 16),
                                            ),
                                            trailing: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '₹ ${value['price']}',
                                                    style: TextStyle(
                                                      color: appColors.green,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " each",
                                                    style: TextStyle(
                                                      color: appColors
                                                          .secondaryText,
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));
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
            ),
          ),
        ],
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
      return Get.isDarkMode ? Colors.white : Colors.grey;
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
