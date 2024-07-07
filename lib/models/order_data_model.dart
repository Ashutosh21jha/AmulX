class OrderDataModel {
  const OrderDataModel(
      {required this.createdAt,
      required this.orderAmount,
      required this.orderID,
      required this.paymentSessionId,
      required this.orderExpiryTime,
      required this.orderStatus});

  final String createdAt;
  final double orderAmount;
  final String orderID;
  final String paymentSessionId;
  final String orderExpiryTime;
  final String orderStatus;

  factory OrderDataModel.fromJson(Map<String, dynamic> json) {
    json = json['orderData'];

    return OrderDataModel(
        createdAt: json['createdAt'] as String,
        orderAmount: (json['orderAmount']).toDouble(),
        orderID: json['orderID'] as String,
        paymentSessionId: json['paymentSessionId'] as String,
        orderExpiryTime: json['orderExpiryTime'] as String,
        orderStatus: json['orderStatus'] as String);
  }
}
