import 'package:flutter/material.dart';

class OrderStatusIcons extends StatelessWidget {
  const OrderStatusIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.indigo,
            ),
            Text('Accepted'),
          ],
        ),
        Divider(
          color: Colors.black,
          thickness: 2,
          height: 10,
        ),
        Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.indigo,
            ),
            Text('Processed'),
          ],
        ),
        Divider(
          color: Colors.black,
          thickness: 2,
          height: 10,
        ),
        Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.indigo,
            ),
            Text('Enjoy'),
          ],
        ),
      ],
    );
  }
}
