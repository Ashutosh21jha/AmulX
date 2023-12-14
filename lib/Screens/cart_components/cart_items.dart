class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  void incrementQuantity() {
    quantity += 1;
  }

  void decrementQuantity() {
    if (quantity > 0) {
      quantity -= 1;
    }
  }
}
