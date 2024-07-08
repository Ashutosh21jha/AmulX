import 'dart:convert';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/models/order_data_model.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:amul/widgets/amulX_snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupi.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupipayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

class OrderPaymentController extends GetxController {
  final String backendURL = 'http://192.168.40.15:3000';
  final environment = CFEnvironment.SANDBOX;

  final cfPaymentGateway = CFPaymentGatewayService();

  OrderDataModel? orderData;

  OrderPaymentController() {
    cfPaymentGateway.setCallback(onClientOrderSuccess, onClientOrderFailure);
  }

  Future<void> onClientOrderSuccess(String p0) async {
    final bool orderVerified = await verfiyOrder();

    if (orderVerified) {
      await handlePaymentSuccess();
    } else {
      await handlePaymentError();
    }
  }

  Future<void> onClientOrderFailure(
      CFErrorResponse cfErrorResponse, String error) async {
    await handlePaymentError();

    Get.find<Logger>().e(
        "Error: PAYMENT FAILED: ${cfErrorResponse.getCode()} - ${cfErrorResponse.getMessage()}\n status: ${cfErrorResponse.getStatus()}\n error: $error");
  }

  Future<void> addOrderToPrepList() async {
    final UserController userController = Get.find<UserController>();
    final firebaseMessaging = FirebaseMessaging.instance;
    final CartController cartController = Get.find<CartController>();

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
      'orderID': orderData!.orderID,
      'orderStatus': 'Preparing',
      'name': userController.userName.value,
      'time': DateTime.now(),
      'token': await firebaseMessaging.getToken(),
    };

    await prepListCollection.doc(orderData!.orderID).set(prepListOrderData);
  }

  Future<void> handlePaymentError() async {
    await CartController.to.addBackStock(CartController.to.cartItems);

    AmulXSnackBars.showPaymentOrderFailureSnackbar();
  }

  Future<void> handlePaymentSuccess() async {
    final formattedDate = orderData!.createdAt;
    final UserController userController = Get.find<UserController>();

    await userController.addOrderToUserHistrory(
        formattedDate, orderData!.orderID);

    await addOrderToPrepList();

    await CartController.to.deleteCart();

    await userController.updateUserOrderStatusTo(false);

    AmulXSnackBars.showPaymentOrderSuccessSnackbar();

    Get.offAll(() => const Mainscreen());
  }

  Future<bool> verfiyOrder() async {
    if (orderData == null) {
      Get.find<Logger>().e("Error: ORDER DATA IS NULL");
      return false;
    }

    final http.Response res = await http.get(
      Uri.tryParse("$backendURL/payment/verify_order/${orderData!.orderID}")!,
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(res.body);

      if (jsonBody['status'] == 'PAID') {
        return true;
      } else if (jsonBody['status'] == 'ACTIVE') {
        // TODO IMPLEMENT WHAT TO DO IF ORDER IS ACTIVE

        return false;
      } else if (jsonBody['status'] == 'EXPIRED') {
        // TODO IMPLEMENT WHAT TO DO IF ORDER IS EXPIRED

        return false;
      } else if (jsonBody['status'] == 'TERMINATED') {
        // TODO IMPLEMENT WHAT TO DO IF ORDER IS TERMINATED

        return false;
      } else if (jsonBody['status'] == 'TERMINATION_REQUESTED') {
        // TODO IMPLEMENT WHAT TO DO IF ORDER IS TERMINATED_REQUESTED

        return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<OrderDataModel?> getOrderIdAndSession(double orderAmount,
      String customerId, String customerEmail, String orderID) async {
    final http.Response res = await http
        .post(Uri.tryParse('$backendURL/payment/create_order')!, body: {
      "orderAmount": orderAmount.toString(),
      "orderID": orderID,
      "customerId": customerId,
      "customerEmail": customerEmail
    });

    if (res.statusCode != 200) {
      Get.find<Logger>().e("Error: ERROR IN GETTING ORDER ID AND SESSION");

      return null;
    } else {
      final Map<String, dynamic> jsonBody = jsonDecode(res.body);

      final OrderDataModel orderDataModel = OrderDataModel.fromJson(jsonBody);

      orderData = orderDataModel;
      return orderDataModel;
    }
  }

  Future<CFSession?> getSession() async {
    CFSession? session;

    try {
      session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderData!.orderID)
          .setPaymentSessionId(orderData!.paymentSessionId)
          .build();
    } on CFException catch (e) {
      print(e.message);
    }

    return session;
  }

  Future<void> payWithUpi(CFSession session) async {
    final upi = CFUPIBuilder()
        .setChannel(CFUPIChannel.INTENT)
        .setUPIID("testsuccess@gocash")
        .build();
    final upiPayment =
        CFUPIPaymentBuilder().setSession(session).setUPI(upi).build();
    // final cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session).build();
    await cfPaymentGateway.doPayment(upiPayment);
  }
}
