import 'dart:convert';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/api/cashfree.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/models/order_data_model.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:amul/services/notification_service.dart';
import 'package:amul/widgets/amulX_dialogs.dart';
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
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderPaymentController extends GetxController {
  final String backendURL = 'http://192.168.107.15:3000';
  final environment = CFEnvironment.SANDBOX;

  final cfPaymentGateway = CFPaymentGatewayService();

  Rx<OrderDataModel?> orderData = Rx<OrderDataModel?>(null);

  OrderPaymentController() {
    paymentSuccessCallbackFxn(String _) => Get.showOverlay(
        asyncFunction: () => verifyPayment(_, null),
        loadingWidget: const Center(
            child: CircularProgressIndicator(
          color: AppColors.blue,
        )));
    paymentFailureCallbackFxn(CFErrorResponse cfErrorResponse, String _) =>
        Get.showOverlay(
            asyncFunction: () => verifyPayment(_, cfErrorResponse),
            loadingWidget: const Center(
                child: CircularProgressIndicator(
              color: AppColors.blue,
            )));

    cfPaymentGateway.setCallback(
      paymentSuccessCallbackFxn,
      paymentFailureCallbackFxn,
    );
  }

  Future<void> createNewOrderWithOrderID(
      String orderID, double orderAmount) async {
    final UserController user = Get.find<UserController>();

    orderData.value = await CashfreeGatewayApi.createNewOrderWithOrderID(
        orderID,
        orderAmount,
        user.userId.value,
        user.userName.value,
        user.email.value);
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
    final NotificationService notificationService =
        Get.find<NotificationService>();
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
      'orderID': orderData.value!.orderID,
      'orderStatus': 'Preparing',
      'paymentStatus': orderPaymentStatus.value,
      'email': userController.email.value,
      'name': userController.userName.value,
      'userImageUrl': userController.imageUrl.value,
      'time': orderData.value!.createdAt,
      'token': notificationService.deviceToken,
    };

    await prepListCollection
        .doc(orderData.value!.orderID)
        .set(prepListOrderData);
  }

  Future<void> handlePaymentError() async {
    await CartController.to.addBackStock(CartController.to.cartItems);

    AmulXSnackBars.showPaymentOrderFailureSnackbar();
  }

  Future<void> handlePaymentSuccess(
      OrderPaymentStatus orderPaymentStatus) async {
    final formattedDate = orderData.value!.createdAt;
    final UserController userController = Get.find<UserController>();

    await userController.addOrderToUserHistrory(
        formattedDate, orderData.value!.orderID, orderPaymentStatus);

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

  Future<void> createOrderInFireabseIfPaymentStatusIsUnknown() async {
    final formattedDate = orderData.value!.createdAt;
    final UserController userController = Get.find<UserController>();

    await userController.addOrderToUserHistrory(
        formattedDate, orderData.value!.orderID, OrderPaymentStatus.UNKNOWN);

    // TODO REMOVE LINE BELOW IN PRODUCTION
    await userController.updateUserCurrentOrderStatusTo(false);
    // TODO REMOVE ABOVE LINE IN PRODUCTION

    AmulXDialogs.showPaymentIfPaymentStatusCheckFailed();
  }

  Future<void> verifyPayment(String _, CFErrorResponse? errorResponse) async {
    final OrderPaymentStatus? orderPaymentStatus =
        await CashfreeGatewayApi.getOrderStatus(orderData.value!.orderID);

    if (orderPaymentStatus == null) {
      await createOrderInFireabseIfPaymentStatusIsUnknown();
      return;
    }

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
          .setOrderId(orderData.value!.orderID)
          .setPaymentSessionId(orderData.value!.paymentSessionId)
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
