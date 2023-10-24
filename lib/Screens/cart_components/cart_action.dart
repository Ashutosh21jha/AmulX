import 'package:amul/Screens/cart_components/cart_controller.dart';
import 'package:amul/Screens/cart_components/cart_items.dart';
import 'package:flutter/material.dart';

class CartAction extends StatelessWidget {
  final CartItem item;
  final Function() onUpdateItemCount;

  CartAction({required this.item, required this.onUpdateItemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            CartController.to.removeItem(item);
            onUpdateItemCount();
          },
        ),
        Text(item.quantity.toString()), // Display the quantity
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            CartController.to.addItem(item); // Increase the quantity
            onUpdateItemCount();
          },
        ),
      ],
    );
  }
}
