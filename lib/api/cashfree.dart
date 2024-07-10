import 'dart:convert';

import 'package:amul/models/order_data_model.dart';
import 'package:dio/dio.dart';

enum OrderPaymentStatus {
  SUCCESS("SUCCESS"),
  NOT_ATTEMPTED("NOT_ATTEMPTED"),
  FAILED("FAILED"),
  USER_DROPPED("USER_DROPPED"),
  VOID("VOID"),
  CANCELLED("CANCELLED"),
  PENDING("PENDING");

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

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );

  static Future<OrderDataModel> createNewOrderWithOrderID(
      String orderID,
      double orderAmount,
      String customerId,
      String customerName,
      String customerEmail) async {
    final Map<String, String> headers = {
      'x-client-id': 'TEST102440183c3125107d983f09d55c81044201',
      'x-client-secret':
          'cfsk_ma_test_2f4e1dee5061fc679e5abe8369f84496_a5e8d5e9',
      'x-api-version': '2023-08-01',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final Map<String, dynamic> data = {
      "order_amount": orderAmount.toString(),
      "order_currency": "INR",
      "order_id": orderID,
      "customer_details": {
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_phone": "9999999999"
      },
      "order_expiry_time": "2024-07-18T10:20:12+05:30"
    };

    const url = '/orders';

    final res = await _dio.post(url,
        options: Options(headers: headers), data: jsonEncode(data));
    final status = res.statusCode;

    if (status != 200) {
      throw Exception('http.post error: statusCode= $status');
    }

    final Map<String, dynamic> body = res.data;

    return OrderDataModel.fromJson(body);
  }

  static Future<OrderPaymentStatus?> getOrderStatus(String orderID) async {
    final headers = {
      'accept': 'application/json',
      'x-api-version': '2023-08-01',
      'x-client-id': 'TEST102440183c3125107d983f09d55c81044201',
      'x-client-secret':
          'cfsk_ma_test_2f4e1dee5061fc679e5abe8369f84496_a5e8d5e9',
    };

    final url = '/orders/$orderID/payments';

    final res = await _dio.get(url, options: Options(headers: headers));
    final status = res.statusCode;
    if (status != 200) throw Exception('http.get error: statusCode= $status');

    print(res.data);

    final List<dynamic> payments = res.data;

    if (payments.isEmpty) {
      return OrderPaymentStatus.NOT_ATTEMPTED;
    }

    payments.sort((a, b) {
      final aTime = DateTime.parse(a['payment_time']);
      final bTime = DateTime.parse(b['payment_time']);
      return bTime.compareTo(aTime);
    });

    bool isAnyPaymentSuccessfull =
        payments.any((element) => element['payment_status'] == 'SUCCESS');

    if (isAnyPaymentSuccessfull) {
      return OrderPaymentStatus.SUCCESS;
    }

    final OrderPaymentStatus latestPaymentStatus =
        OrderPaymentStatus.fromString(payments.first['payment_status']);

    return latestPaymentStatus;
  }
}
