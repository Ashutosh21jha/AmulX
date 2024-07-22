import 'cartItem_model.dart';
import 'package:flutter/material.dart';

class CartItemReviewWidget extends StatelessWidget {
  final CartItem item;

  const CartItemReviewWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      trailing: Text('\₹${item.price.toStringAsFixed(2)}'),
    );
  }
}
