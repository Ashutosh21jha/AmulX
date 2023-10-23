import 'cart_controller.dart';
import 'cart_items.dart';
import 'package:flutter/material.dart';

class CartAction extends StatelessWidget {
  final CartItem item;

  CartAction({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            CartController.to.removeItem(item);
          },
        ),
        Text(item.quantity.toString()), // Display the quantity
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            CartController.to.addItem(item); // Increase the quantity
          },
        ),
      ],
    );
  }
}
