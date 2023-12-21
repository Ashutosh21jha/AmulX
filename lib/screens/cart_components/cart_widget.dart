import 'package:flutter/material.dart';
import 'package:amul/screens/cart_components/cartItem_model.dart';
import 'package:amul/screens/cart_components/cart_action.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function() onUpdateItemCount; // Pass the callback function

  CartItemWidget({required this.item, required this.onUpdateItemCount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('₹\${item.price.toStringAsFixed(2)}'),
      trailing: CartAction(
        item: item,
        onUpdateItemCount: onUpdateItemCount,
      ),
    );
  }
}
