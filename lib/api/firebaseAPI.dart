import 'package:amul/Utils/enums.dart';
import 'package:amul/api/cashfree.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/controllers/cart_controller.dart';
import 'package:amul/services/notification_service.dart';
import 'package:amul/widgets/amulX_snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AmulxFirebaseAPI {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static UserController user = Get.find<UserController>();

  static Future<void> checkPaymentStatusAndPlaceOrder(
      String docID, String orderID) async {
    final OrderPaymentStatus? orderPaymentStatus =
        await CashfreeGatewayApi.getOrderStatus(orderID);

    if (orderPaymentStatus == null) {
      return;
    }

    try {
      if (orderPaymentStatus == OrderPaymentStatus.SUCCESS ||
          orderPaymentStatus == OrderPaymentStatus.PENDING) {
        // ADD ITEM TO PREPLIST
        {
          final UserController userController = Get.find<UserController>();
          final CartController cartController = Get.find<CartController>();
          final NotificationService notificationService =
              Get.find<NotificationService>();

          final prepListCollection =
              FirebaseFirestore.instance.collection('prepList');

          final itemsMap = cartController.cartItems.fold<Map<String, dynamic>>(
            {},
            (map, item) {
              map[item.name] = {
                'count': item.quantity,
                'price': item.price,
              };
              return map;
            },
          );

          final prepListOrderData = {
            'userId': userController.userId.value,
            'items': itemsMap,
            'orderID': orderID,
            'orderStatus': 'Preparing',
            'paymentStatus': orderPaymentStatus.value,
            'email': userController.email.value,
            'name': userController.userName.value,
            'userImageUrl': userController.imageUrl.value,
            'time': docID,
            'token': notificationService.deviceToken,
          };

          await prepListCollection.doc(orderID).set(prepListOrderData);
        }

        // SET USER ORDER STATUS TO PLACED
        {
          final doc = await _firestore
              .collection('User')
              .doc(user.email.value)
              .collection('history')
              .doc(docID)
              .get();

          final Map<String, dynamic> data = doc.data()!['orders'][0];

          data['orderStatus'] = "Placed";

          await _firestore
              .collection('User')
              .doc(user.email.value)
              .collection('history')
              .doc(docID)
              .update({
            'orders': [data]
          });
        }

        orderPaymentStatus == OrderPaymentStatus.SUCCESS
            ? AmulXSnackBars.showPaymentOrderSuccessSnackbar()
            : AmulXSnackBars.showPaymentOrderPendingSnackbar();
      } else {
        AmulXSnackBars.showPaymentOrderFailureSnackbar();
      }
    } catch (e) {
      AmulXSnackBars.showPaymentOrderFailureSnackbar();
    }
  }

  static Future<void> checkAndUpdateRefundStatus(String docID) async {
    try {
      final doc = await _firestore
          .collection('User')
          .doc(user.email.value)
          .collection('history')
          .doc(docID)
          .get();

      final data = doc.data()!['orders'][0];

      final RefundStatus? refundStatus =
          await CashfreeGatewayApi.getRefundStatus(data['orderID']);

      if (refundStatus == null) {
        return;
      }

      if (refundStatus.name == data['refundStatus']) {
        return;
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
    } catch (e) {
      return;
    }
  }
}
