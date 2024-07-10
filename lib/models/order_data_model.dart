class OrderDataModel {
  final String createdAt;
  final double orderAmount;
  final String orderID;
  final String paymentSessionId;
  final String orderExpiryTime;
  final String orderStatus;
  final String cfOrderId;
  final Map<String, dynamic> customerDetails;
  final String entity;
  final String orderCurrency;
  final Map<String, dynamic> orderMeta;

  OrderDataModel({
    required this.createdAt,
    required this.orderAmount,
    required this.orderID,
    required this.paymentSessionId,
    required this.orderExpiryTime,
    required this.orderStatus,
    required this.cfOrderId,
    required this.customerDetails,
    required this.entity,
    required this.orderCurrency,
    required this.orderMeta,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) {
    return OrderDataModel(
      createdAt: json['created_at'],
      orderAmount: json['order_amount'],
      orderID: json['order_id'],
      paymentSessionId: json['payment_session_id'],
      orderExpiryTime: json['order_expiry_time'],
      orderStatus: json['order_status'],
      cfOrderId: json['cf_order_id'],
      customerDetails: json['customer_details'],
      entity: json['entity'],
      orderCurrency: json['order_currency'],
      orderMeta: json['order_meta'],
    );
  }
}
