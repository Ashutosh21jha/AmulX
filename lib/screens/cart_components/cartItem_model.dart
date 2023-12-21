class CartItem {
  late final String name;
  late final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });

/*  void incrementQuantity() {
    quantity += 1;
  }

  void decrementQuantity() {
    if (quantity > 0) {
      quantity -= 1;
    }
  }*/
}
