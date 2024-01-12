import 'package:amul/screens/cart_components/cartItem_model.dart';
import 'package:flutter/material.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';

import '../../Utils/AppColors.dart';

class CartItemCard extends StatefulWidget {
  CartItemCard({super.key,required this.item});
  final CartItem item;
  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  bool tap=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 100,
      margin: const EdgeInsets.symmetric(
          vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Transform.translate(
                offset: const Offset(0, 22),
                child: Text(
                  widget.item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                    border: Border.all(
                        color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove,color:tap==false? Colors.black:Colors.grey,),
                        iconSize: 18,
                        onPressed:tap==false?() async{
                          setState(() {
                            tap=true;
                          });
                          await CartController.to.removeItem(widget.item);
                          await CartController.to.fetchCart().then((value){
                            setState(() {
                              tap=false;
                            });
                          });
                          // await CartController.to.reloadCart().then((value){
                          //   setState(() {
                          //     tap=false;
                          //   });
                          // });
                          /* updateItemCount();*/
                        }:(){}
                      ),
                      Text(
                        widget.item.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add,color:tap==false? Colors.black:Colors.grey,),
                        iconSize: 18,
                        onPressed:tap==false? () async {
                          setState(() {
                            tap=true;
                          });
                          await CartController.to.addItem(widget.item);
                          await CartController.to.fetchCart().then((value){
                            setState(() {
                              tap=false;
                            });
                          });
                          // await CartController.to.reloadCart().then((value) {
                          //   setState(() {
                          //     tap=false;
                          //   });
                          // });
                          /*updateItemCount();*/
                        }:(){},
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
