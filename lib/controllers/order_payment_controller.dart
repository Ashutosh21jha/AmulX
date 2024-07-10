import 'dart:convert';
import 'package:amul/api/cashfree.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/models/order_data_model.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:amul/widgets/amulX_snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupi.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupipayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

class OrderPaymentController extends GetxController {
  final String backendURL = 'http://192.168.107.15:3000';
  final environment = CFEnvironment.SANDBOX;

  final cfPaymentGateway = CFPaymentGatewayService();

  OrderDataModel? orderData;

  OrderPaymentController() {
    cfPaymentGateway.setCallback(
        (
          String _,
        ) =>
            verifyPayment(_, null),
        (CFErrorResponse cfErrorResponse, String _) =>
            verifyPayment(_, cfErrorResponse));
  }

  Future<void> createNewOrderWithOrderID(
      String orderID, double orderAmount) async {
    final UserController user = Get.find<UserController>();

    orderData = await CashfreeGatewayApi.createNewOrderWithOrderID(orderID,
        orderAmount, user.userId.value, user.userName.value, user.email.value);
  }

  // Future<void> onClientOrderFailure(
  //     CFErrorResponse cfErrorResponse, String error) async {
  //   print("XXXXXXXXXXXXXXXXXXXXXXXX");
  //   print("ON CLIENT ORDER FAILURE FXN CALLED");
  //   print("XXXXXXXXXXXXXXXXXXXXXXXX");

  //   await verifyPayment(error, null);

  //   await handlePaymentError();

  //   Get.snackbar(cfErrorResponse.getCode()!, cfErrorResponse.getMessage()!,
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       margin: const EdgeInsets.all(10),
  //       borderRadius: 10,
  //       duration: const Duration(seconds: 5));

  //   Get.find<Logger>().e(
  //       "Error: PAYMENT FAILED: ${cfErrorResponse.getCode()} - ${cfErrorResponse.getMessage()}\n status: ${cfErrorResponse.getStatus()}\n error: $error");
  // }

  Future<void> addOrderToPrepList(OrderPaymentStatus orderPaymentStatus) async {
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
      'paymentStatus': orderPaymentStatus.value,
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

  Future<void> handlePaymentSuccess(
      OrderPaymentStatus orderPaymentStatus) async {
    final formattedDate = orderData!.createdAt;
    final UserController userController = Get.find<UserController>();

    await userController.addOrderToUserHistrory(
        formattedDate, orderData!.orderID, orderPaymentStatus);

    await addOrderToPrepList(orderPaymentStatus);

    await CartController.to.deleteCart();

    // TODO REMOVE LINE BELOW IN PRODUCTION
    await userController.updateUserCurrentOrderStatusTo(false);
    // TODO REMOVE ABOVE LINE IN PRODUCTION

    orderPaymentStatus == OrderPaymentStatus.SUCCESS
        ? AmulXSnackBars.showPaymentOrderSuccessSnackbar()
        : AmulXSnackBars.showPaymentOrderPendingSnackbar();

    Get.offAll(() => const Mainscreen());
  }

  Future<void> verifyPayment(String _, CFErrorResponse? errorResponse) async {
    final OrderPaymentStatus orderPaymentStatus =
        (await CashfreeGatewayApi.getOrderStatus(orderData!.orderID))!;

    if (orderPaymentStatus == OrderPaymentStatus.SUCCESS ||
        orderPaymentStatus == OrderPaymentStatus.PENDING) {
      await handlePaymentSuccess(orderPaymentStatus);
    } else {
      await handlePaymentError();
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
        .setUPIID('testsuccess@gocash')
        .build();
    final upiPayment =
        CFUPIPaymentBuilder().setSession(session).setUPI(upi).build();
    // final cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session).build();
    // await cfPaymentGateway.doPayment(cfWebCheckout);
    await cfPaymentGateway.doPayment(upiPayment);
  }
}
