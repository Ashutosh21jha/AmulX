// import 'package:amul/Screens/profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:im_stepper/stepper.dart';
// import 'package:intl/intl.dart';
//
// class TrackingPage extends StatelessWidget {
//   const TrackingPage({Key? key}) : super(key: key);
//   CollectionReference get prepListCollection =>
//       FirebaseFirestore.instance.collection('prepList');
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime currentDate = DateTime.now();
//     String formattedDate = DateFormat('EEE, d MMMM').format(currentDate);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Padding(
//             padding: EdgeInsets.all(1.0),
//             child: Text(
//               'Track Order',
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             size: 32,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 16, top: 16),
//             child: Text(
//               formattedDate,
//               style: const TextStyle(color: Colors.indigo, fontSize: 20),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: getLatestOrders(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: Container(child: CircularProgressIndicator()),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data == null) {
//                   return Text('No orders found.');
//                 } else {
//                   List<Map<String, dynamic>> latestOrders = snapshot.data!;
//                   if (latestOrders.isEmpty) {
//                     return Text('No orders found.');
//                   }
//
//                   var order = latestOrders.first;
//                   var itemsMap = order['items'] as Map<String, dynamic>;
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(top: 8),
//                         child: Text(
//                           'Order ID: ${order['orderID']}',
//                           style: TextStyle(color: Colors.indigo, fontSize: 20),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         'Orders:',
//                         style: TextStyle(color: Colors.indigo, fontSize: 20),
//                       ),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: itemsMap.entries.length,
//                         itemBuilder: (context, index) {
//                           var entry = itemsMap.entries.elementAt(index);
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${entry.key}:',
//                                 style: TextStyle(color: Colors.indigo, fontSize: 20),
//                               ),
//                               Text(
//                                 '${entry.value['count']} items, ₹${entry.value['price']} each',
//                                 style: TextStyle(color: Colors.indigo, fontSize: 20),
//                               ),
//                               // Add a SizedBox to create a gap between items
//                               const SizedBox(height: 10),
//                             ],
//                           );
//                         },
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
//           Container(
//             alignment: Alignment.centerLeft,
//             height: MediaQuery.of(context).size.height / 2,
//             width: MediaQuery.of(context).size.width / 6,
//             child: IconStepper(
//               direction: Axis.vertical,
//               enableNextPreviousButtons: false,
//               activeStepBorderColor: Colors.white,
//               activeStepBorderWidth: 0.0,
//               lineColor: Colors.redAccent,
//               stepColor: Colors.green,
//               lineLength: 70.0,
//               lineDotRadius: 2.0,
//               stepRadius: 18.0,
//               icons: const [
//                 Icon(
//                   Icons.radio_button_checked,
//                   color: Colors.green,
//                 ),
//                 Icon(
//                   Icons.check_sharp,
//                   color: Colors.white,
//                 ),
//                 Icon(
//                   Icons.check,
//                   color: Colors.white,
//                 ),
//                 Icon(
//                   Icons.check,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Future<List<Map<String, dynamic>>> getLatestOrders() async {
//     try {
//       print('Fetching orders for userId: $userId');
//       QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('prepList').get();
//       if (querySnapshot.docs.isNotEmpty) {
//         print('Fetching orders for userId: $userId');
//         var filteredDocs = querySnapshot.docs
//             .where((doc) =>
//         RegExp(r'^ORD-\d{3}$').hasMatch(doc.id.toString()) &&
//             (doc['userId'] == userId) &&
//             doc['orderStatus'] != 'Placed')
//             .toList();
//         print('Filtered Docs: $filteredDocs');
//
//         var ordersWithStatus = filteredDocs
//             .where((doc) => doc['orderStatus'] != 'Placed')
//             .toList();
//         print('Orders with Status: $ordersWithStatus');
//
//         if (filteredDocs.isNotEmpty) {
//           // Return the latest orders
//           return filteredDocs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();
//         }
//       }
//     } catch (e) {
//       print('Error fetching latest orders: $e');
//     }
//
//     return [];
//   }
// }
