import 'dart:convert';

import 'package:amul/Utils/enums.dart';
import 'package:amul/models/order_data_model.dart';
import 'package:amul/services/remote_config_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';

enum OrderPaymentStatus {
  SUCCESS("SUCCESS"),
  NOT_ATTEMPTED("NOT_ATTEMPTED"),
  FAILED("FAILED"),
  USER_DROPPED("USER_DROPPED"),
  VOID("VOID"),
  CANCELLED("CANCELLED"),
  PENDING("PENDING"),
  UNKNOWN("UNKNOWN"); // NOT PRIMITIVE, DOES NOT EXIST IN CASHFREE

  final String value;
  const OrderPaymentStatus(this.value);

  static OrderPaymentStatus fromString(String status) {
    switch (status) {
      case 'SUCCESS':
        return SUCCESS;
      case 'NOT_ATTEMPTED':
        return NOT_ATTEMPTED;
      case 'FAILED':
        return FAILED;
      case 'USER_DROPPED':
        return USER_DROPPED;
      case 'VOID':
        return VOID;
      case 'CANCELLED':
        return CANCELLED;
      case 'PENDING':
        return PENDING;
      case 'UNKNOWN':
        return UNKNOWN;
      default:
        throw Exception('Invalid OrderPaymentStatus');
    }
  }
}

enum OrderStatus {
  PAID,
  ACTIVE,
  EXPIRED,
  TERMINATED,
  TERMINATED_REQUESTED;

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'PAID':
        return PAID;
      case 'ACTIVE':
        return ACTIVE;
      case 'EXPIRED':
        return EXPIRED;
      case 'TERMINATED':
        return TERMINATED;
      case 'TERMINATED_REQUESTED':
        return TERMINATED_REQUESTED;
      default:
        throw Exception('Invalid OrderPaymentStatus');
    }
  }
}

class CashfreeGatewayApi {
  static const String baseUrl = 'https://sandbox.cashfree.com/pg';

  static final RemoteConfigService _remoteConfigService =
      Get.find<RemoteConfigService>();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );

  static Future<OrderDataModel?> createNewOrderWithOrderID(
      String orderID,
      double orderAmount,
      String customerId,
      String customerName,
      String customerEmail) async {
    try {
      final Map<String, String> headers = {
        'x-client-id': _remoteConfigService.cashfreeApi,
        'x-client-secret': _remoteConfigService.cashfreeSecret,
        'x-api-version': _remoteConfigService.cashfreeApiVersion,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final DateTime dateTime = DateTime.now().add(const Duration(days: 1));

      final String orderExpiryTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss+05:30").format(dateTime);

      final Map<String, dynamic> data = {
        "order_amount": orderAmount.toStringAsFixed(2),
        "order_currency": "INR",
        "order_id": orderID,
        "customer_details": {
          "customer_id": customerId,
          "customer_name": customerName,
          "customer_email": customerEmail,
          "customer_phone": "9999999999"
        },
        "order_expiry_time": orderExpiryTime
      };

      const url = '/orders';

      final res = await _dio.post(url,
          options: Options(
              headers: headers,
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5)),
          data: jsonEncode(data));
      final status = res.statusCode;

      if (status != 200) {
        throw Exception(
            'http.post error: statusCode= $status message: ${res.data}');
      }

      final Map<String, dynamic> body = res.data;

      return OrderDataModel.fromJson(body);
    } catch (e) {
      if (e is DioException) {
        Get.find<Logger>().e(e.response?.data ?? e.message);
      }
      return null;
    }
  }

  static Future<OrderPaymentStatus?> getOrderStatus(String orderID) async {
    try {
      final headers = {
        'accept': 'application/json',
        'x-api-version': _remoteConfigService.cashfreeApiVersion,
        'x-client-id': _remoteConfigService.cashfreeApi,
        'x-client-secret': _remoteConfigService.cashfreeSecret,
      };

      final url = '/orders/$orderID/payments';

      final res = await _dio.get(
        url,
        options: Options(
            headers: headers,
            sendTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5)),
      );

      final status = res.statusCode;
      if (status != 200) {
        throw Exception(
            'http.get error: statusCode= $status message: ${res.data}');
      }

      final List<dynamic> payments = res.data;

      if (payments.isEmpty) {
        return OrderPaymentStatus.NOT_ATTEMPTED;
      }

      if (payments.length != 1) {
        try {
          payments.sort((a, b) {
            final aTime = DateTime.parse(a['payment_time']);
            final bTime = DateTime.parse(b['payment_time']);
            return bTime.compareTo(aTime);
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      bool isAnyPaymentSuccessfull =
          payments.any((element) => element['payment_status'] == 'SUCCESS');

      if (isAnyPaymentSuccessfull) {
        return OrderPaymentStatus.SUCCESS;
      }

      final OrderPaymentStatus latestPaymentStatus =
          OrderPaymentStatus.fromString(payments.first['payment_status']);

      return latestPaymentStatus;
    } catch (e) {
      if (e is DioException) {
        Get.find<Logger>().e(e.response?.data ?? e.message);
      }
      return null;
    }
  }

  static Future<RefundStatus?> getRefundStatus(String orderID) async {
    try {
      final Map<String, String> headers = {
        'accept': 'application/json',
        'x-api-version': _remoteConfigService.cashfreeApiVersion,
        'x-client-id': _remoteConfigService.cashfreeApi,
        'x-client-secret': _remoteConfigService.cashfreeSecret,
      };

      final String url = '/orders/$orderID/refunds/$orderID-refund';

      final res = await _dio.get(url,
          options: Options(
              headers: headers,
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5)));

      final status = res.statusCode;
      if (status != 200) {
        throw Exception('http.post error: statusCode= $status');
      }

      return RefundStatus.fromString(res.data['refund_status']);
    } catch (e) {
      if (e is DioException) {
        Get.find<Logger>().e(e.response?.data ?? e.message);
      }
      return null;
    }
  }
}
