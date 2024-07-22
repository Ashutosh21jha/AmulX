import 'package:amul/controllers/items_controller.dart';
import 'package:amul/screens/cart_components/cartItem_model.dart';
import 'package:flutter/material.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';

import '../../Utils/AppColors.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({super.key, required this.item});
  final CartItem item;
  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;
  late final int? availableStock = ItemController.to.Items
      .where((e) => e.id == widget.item.name)
      .first
      .stock;

  bool tap = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: appColors.secondaryText, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Transform.translate(
                offset: const Offset(0, 22),
                child: Text(
                  widget.item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '\₹${widget.item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(top: 11),
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: appColors.surfaceColor, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: tap == false
                                ? (appColors.primaryText)
                                : Colors.grey,
                          ),
                          iconSize: 18,
                          onPressed: tap == false
                              ? () async {
                                  setState(() {
                                    tap = true;
                                  });
                                  await CartController.to
                                      .removeItem(widget.item);
                                  await CartController.to
                                      .fetchCart()
                                      .then((value) {
                                    setState(() {
                                      tap = false;
                                    });
                                  });
                                  // await CartController.to.reloadCart().then((value){
                                  //   setState(() {
                                  //     tap=false;
                                  //   });
                                  // });
                                  /* updateItemCount();*/
                                }
                              : () {}),
                      Text(
                        widget.item.quantity.toString(),
                        style: TextStyle(
                          color: appColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: tap == false
                              ? (appColors.primaryText)
                              : Colors.grey,
                        ),
                        iconSize: 18,
                        onPressed: tap == false
                            ? () async {
                                if (availableStock != null &&
                                    widget.item.quantity >= availableStock!) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Exceeded Limit'),
                                        titlePadding: const EdgeInsets.only(
                                            top: 16, bottom: 8, left: 24),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 4),
                                        shape: const ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        content: const Text(
                                            'You have reached the maximum limit of this item.'),
                                        actionsPadding:
                                            const EdgeInsets.only(bottom: 0),
                                        actions: [
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }

                                setState(() {
                                  tap = true;
                                });
                                await CartController.to.addItem(widget.item);
                                await CartController.to
                                    .fetchCart()
                                    .then((value) {
                                  setState(() {
                                    tap = false;
                                  });
                                });
                                // await CartController.to.reloadCart().then((value) {
                                //   setState(() {
                                //     tap=false;
                                //   });
                                // });
                                /*updateItemCount();*/
                              }
                            : () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
