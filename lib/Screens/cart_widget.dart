import 'package:flutter/material.dart';
import 'cart_items.dart';
import 'cart_action.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  CartItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('\Rs.${item.price.toStringAsFixed(2)}'),
      trailing: CartAction(item: item),
    );
  }
}
