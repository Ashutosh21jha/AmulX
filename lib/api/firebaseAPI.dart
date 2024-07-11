import 'package:amul/api/cashfree.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AmulxFirebaseAPI {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static UserController user = Get.find<UserController>();

  static Future<void> checkAndUpdateRefundsStatus() async {
    try {
      final snapshot = await _firestore
          .collection('User')
          .doc(user.email.value)
          .collection('history')
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];

      for (final doc in snapshot.docs) {
        docs.add(doc);
      }

      docs = docs.where((doc) {
        final data = doc.data()['orders'][0];

        if (!(data.containsKey('refundStatus'))) return false;

        final String refundStatus = data['refundStatus'];

        if (refundStatus == "SUCCESS") {
          return false;
        } else {
          return true;
        }
      }).toList();

      for (final doc in docs) {
        final data = doc.data()['orders'][0];
        print(data['orderID']);
        final RefundStatus? refundStatus =
            await CashfreeGatewayApi.getRefundStatus(data['orderID']);

        if (refundStatus == null) {
          continue;
        }

        if (refundStatus.name == data['refundStatus']) {
          continue;
        }

        data['refundStatus'] = refundStatus.name;

        await _firestore
            .collection('User')
            .doc(user.email.value)
            .collection('history')
            .doc(doc.id)
            .update({
          'orders': [data]
        });
      }
    } catch (e) {
      return;
    }
  }
}
