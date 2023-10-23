import 'cart_items.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get to => Get.put(CartController());
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  void addItem(CartItem item) {
    final existingItem = cartItems.firstWhere(
      (element) => element.name == item.name,
      orElse: () => CartItem(name: '', price: 0.0, quantity: 0),
    );

    if (existingItem.name.isNotEmpty) {
      existingItem.incrementQuantity();
    } else {
      cartItems.add(item);
    }
    update();
  }

  void removeItem(CartItem item) {
    if (item.quantity > 1) {
      item.decrementQuantity();
    } else {
      cartItems.remove(item);
    }
    update();
  }

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}
