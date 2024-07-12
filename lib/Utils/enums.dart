enum FirebaseOrderStatus {
  PLACED('PLACED'),
  NOT_PLACED('NOT PLACED'),
  DECLINED("DECLINED");

  static FirebaseOrderStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PLACED':
        return PLACED;
      case 'NOT PLACED':
        return NOT_PLACED;
      case 'DECLINED':
        return DECLINED;
      default:
        throw Exception('Invalid FirebaseOrderStatus');
    }
  }

  final String value;
  const FirebaseOrderStatus(this.value);
}

enum RefundStatus {
  SUCCESS,
  PENDING,
  CANCELLED,
  ONHOLD;

  static RefundStatus fromString(String status) {
    switch (status) {
      case 'SUCCESS':
        return SUCCESS;
      case 'PENDING':
        return PENDING;
      case 'CANCELLED':
        return CANCELLED;
      case 'ONHOLD':
        return ONHOLD;
      default:
        throw Exception('Invalid RefundStatus');
    }
  }
}
