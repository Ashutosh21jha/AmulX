import 'dart:convert';
import 'package:amul/models/order_data_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupi.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupipayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderPaymentController extends GetxController {
  final String backendURL = 'http://192.168.40.15:3000';
  final environment = CFEnvironment.SANDBOX;

  final cfPaymentGateway = CFPaymentGatewayService();

  OrderDataModel? orderData;

  OrderPaymentController() {
    cfPaymentGateway.setCallback(onClientOrderSuccess, (p0, p1) {
      print(p0.getMessage());
      print("XXXXXXX PAYMENT ERROR");
    });
  }

  Future<void> onClientOrderSuccess(String p0) async {
    final bool orderVerified = await verfiyOrder();

    if (orderVerified) {
      Get.snackbar("Order Success", "Order has been placed successfully",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Order Failed", "Order has been failed",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> verfiyOrder() async {
    final http.Response res = await http.get(
      Uri.tryParse("$backendURL/payment/verify_order/${orderData!.orderID}")!,
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(res.body);

      if (jsonBody['status'] == 'PAID') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<OrderDataModel?> getOrderIdAndSession(
      double orderAmount, String customerId, String customerEmail) async {
    final http.Response res = await http.post(
        Uri.tryParse('http://192.168.40.15:3000/payment/create_order')!,
        body: {
          "orderAmount": orderAmount.toString(),
          "customerId": customerId,
          "customerEmail": customerEmail
        });

    if (res.statusCode != 200) {
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
