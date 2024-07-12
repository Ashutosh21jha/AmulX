import 'package:amul/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/models/items_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../Utils/AppColors.dart';
import '../cart_components/cartItem_model.dart';

class ItemCard extends StatefulWidget {
  ItemsModel itemData;
  bool unavailable;
  bool isOutOfStock;
  int index;

  ItemCard(
      {super.key,
      required this.itemData,
      required this.isOutOfStock,
      required this.unavailable,
      required this.index});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  //Remove tapped and count list use added and count variables for changing the Add button
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool added = false;
  int count = 0;
  bool tap = false;
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void stockCheck() {
    //count<=stock(item)?count++:Message(not enough stock)
  }

  void fetch() {
    try {
      FirebaseFirestore.instance
          .collection('User')
          .doc(_auth.currentUser!.email)
          .collection('cart')
          .doc(widget.itemData.id)
          .get()
          .then((value) {
        try {
          if (value.get('count') != null) {
            setState(() {
              added = true;
              print("fetched from cart collection");
            });
            setState(() {
              count = value.get('count');
              // localcount=value.get('count');
              print("updated count from from cart collection");
            });
          }
        } catch (e) {
          print("Count field does not exist");
        }
      });
    } catch (e) {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
      child: Opacity(
        opacity: widget.unavailable ? .4 : 1.0,
        child: Card(
            elevation: 2,
            color: appColors.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  widget.itemData.imageUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            widget.itemData.imageUrl,
                            fit: BoxFit.fill,
                            height: 64,
                            width: 64,
                          ),
                        )
                      : const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemData.id!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹ ${widget.itemData.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  widget.unavailable
                      ? const Text(
                          "Out of Stock",
                          style: TextStyle(
                            color: Color(0xFFDD4040),
                          ),
                        )
                      : added
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                  ),
                                  color: tap == false
                                      ? AppColors.blue
                                      : Colors.grey,
                                  onPressed: tap == false
                                      ? () async {
                                          setState(() {
                                            tap = true;
                                          });
                                          if (count == 1) {
                                            setState(() {
                                              added = false;
                                              count--;
                                            });
                                            await FirebaseFirestore.instance
                                                .collection('User')
                                                .doc(_auth.currentUser!.email)
                                                .collection('cart')
                                                .doc(widget.itemData.id)
                                                .delete();
                                            setState(() {
                                              tap = false;
                                            });
                                          }
                                          if (count > 1) {
                                            await FirebaseFirestore.instance
                                                .collection('User')
                                                .doc(_auth.currentUser!.email)
                                                .collection('cart')
                                                .doc(widget.itemData.id)
                                                .update({
                                              'count': FieldValue.increment(-1),
                                            });
                                            setState(() {
                                              count--;
                                              tap = false;
                                            });
                                          }
                                          // if (CartController.to.countList[widget.index] ==
                                          //     1) {
                                          //   CartController.to.tappedList[widget.index] =
                                          //   false;
                                          // } else if (CartController.to.countList[
                                          // widget.index] >
                                          //     1) {
                                          //   CartController.to.countList[widget.index]--;
                                          // }
                                          // CartController.to
                                          //     .removeItem(
                                          //     CartItem(
                                          //       name: widget.itemData.id!,
                                          //       price: double.parse(
                                          //           widget.itemData.price),
                                          //     ));
                                        }
                                      : () {},
                                ),
                                Text(
                                  "$count",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.green),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  color: tap == false
                                      ? AppColors.blue
                                      : Colors.grey,
                                  onPressed: tap == false
                                      ? () async {
                                          setState(() {
                                            tap = true;
                                          });

                                          if (count == 1) {
                                            setState(() {
                                              added = true;
                                              // tap=false;
                                            });
                                          }
                                          await FirebaseFirestore.instance
                                              .collection('User')
                                              .doc(_auth.currentUser!.email)
                                              .collection('cart')
                                              .doc(widget.itemData.id)
                                              .update({
                                            'count': FieldValue.increment(1),
                                          });
                                          setState(() {
                                            count++;
                                            // tap=false;
                                          });
                                          setState(() {
                                            tap = false;
                                          });

                                          // CartController.to.countList[widget.index]++;
                                          // CartController.to
                                          //     .addItem(CartItem(
                                          //   name: widget.itemData.id!,
                                          //   price: double.parse(
                                          //       widget.itemData.price),
                                          // ));
                                        }
                                      : () {},
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (added == false) {
                                  print("name");
                                  print(widget.itemData.id);
                                  await FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(_auth.currentUser!.email)
                                      .collection('cart')
                                      .doc(widget.itemData.id)
                                      .set({
                                    'name': widget.itemData.id,
                                    'count': 0,
                                    'price': widget.itemData.price,
                                  });
                                  setState(() {
                                    added = true;
                                    count++;
                                  });
                                }
                                print(
                                    "Item: ${widget.itemData.id}, Stock: ${widget.itemData.stock}");
                                if (widget.itemData.stock > 0 &&
                                    !widget.unavailable) {
                                  // setState(() {
                                  //   CartController.to.tappedList[widget.index] =
                                  //       !CartController
                                  //           .to.tappedList[widget.index];
                                  //   CartController.to.countList[widget.index] =
                                  //       1;
                                  // });
                                  CartController.to.addItem(CartItem(
                                    name: widget.itemData.id!,
                                    price: widget.itemData.price.toDouble(),
                                  ));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Out of Stock'),
                                        content: const Text(
                                            'Sorry, this item is out of stock.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                width: 90,
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFD1D2D3),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                ],
              ),
            )),
      ),
    );
  }
}
