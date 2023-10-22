import 'cart_items.dart';
import 'package:flutter/material.dart';

class CartItemReviewWidget extends StatelessWidget {
  final CartItem item;

  CartItemReviewWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      trailing: Text('\Rs.${item.price.toStringAsFixed(2)}'),
    );
  }
}
