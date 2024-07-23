import 'package:amul/controllers/user_controller.dart';
import 'package:amul/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amul/controllers/cart_controller.dart';
import 'package:amul/models/items_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../Utils/AppColors.dart';
import '../../models/cart_item_model.dart';

class ItemCard extends StatefulWidget {
  ItemsModel itemData;

  ItemCard({
    super.key,
    required this.itemData,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  //Remove tapped and count list use added and count variables for changing the Add button
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool tap = false;
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;

  int quantity = 1;

  @override
  void initState() {
    super.initState();
    // fetch();
  }

  void stockCheck() {
    //count<=stock(item)?count++:Message(not enough stock)
  }

  // void fetch() {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('User')
  //         .doc(_auth.currentUser!.email)
  //         .collection('cart')
  //         .doc(widget.itemData.id)
  //         .get()
  //         .then((value) {
  //       try {
  //         if (value.get('count') != null) {
  //           setState(() {
  //             print("fetched from cart collection");
  //           });
  //           setState(() {
  //             count = value.get('count');
  //             // localcount=value.get('count');
  //             print("updated count from from cart collection");
  //           });
  //         }
  //       } catch (e) {
  //         print("Count field does not exist");
  //       }
  //     });
  //   } catch (e) {
  //     print('Error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
      child: Opacity(
        opacity: widget.itemData.availability ? 1.0 : 0.4,
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
                          color: AppColors.blue,
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
                  widget.itemData.availability
                      ? ItemCartTrailingWidget(
                          itemData: widget.itemData,
                        )
                      : const Text(
                          "Out of Stock",
                          style: TextStyle(
                            color: Color(0xFFDD4040),
                          ),
                        )
                ],
              ),
            )),
      ),
    );
  }
}

class ItemCartTrailingWidget extends StatefulWidget {
  const ItemCartTrailingWidget({
    super.key,
    required this.itemData,
  });

  final ItemsModel itemData;

  @override
  State<ItemCartTrailingWidget> createState() => _ItemCartTrailingWidgetState();
}

class _ItemCartTrailingWidgetState extends State<ItemCartTrailingWidget> {
  late final email = Get.find<UserController>().email.value;
  late final unavailable = !widget.itemData.availability;
  late RxInt quantity =
      CartController.to.getCartItem(widget.itemData.id!)?.quantity.obs ?? 0.obs;
  RxBool tap = false.obs;

  void showStockExceedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exceeded Limit'),
          titlePadding: const EdgeInsets.only(top: 16, bottom: 8, left: 24),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: const Text(
              "You have reached the maximum stock limit for this item."),
          actionsPadding: const EdgeInsets.only(bottom: 0),
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
  }

  Future<void> increaseQuantityInCart() async {
    await CartController.to.addItem(
      CartItem(
        name: widget.itemData.id!,
        price: widget.itemData.price.toDouble(),
      ),
    );
  }

  Future<void> decreaseQuantityInCart() async {
    await CartController.to.removeItem(
      CartItem(
        name: widget.itemData.id!,
        price: widget.itemData.price.toDouble(),
      ),
    );
  }

  void handleOnAdd() async {
    if (quantity >= widget.itemData.stock) {
      showStockExceedDialog();
      return;
    }

    tap.value = true;

    try {
      await increaseQuantityInCart();
      quantity.value++;
    } finally {
      tap.value = false;
    }
  }

  void handleOnRemove() async {
    if (quantity.value <= 0) {
      return;
    }

    tap.value = true;

    try {
      await decreaseQuantityInCart();
      quantity.value--;
    } finally {
      tap.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (quantity.value <= 0) {
        return GestureDetector(
          onTap: handleOnAdd,
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
        );
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.remove,
            ),
            color: tap.value == false ? AppColors.blue : Colors.grey,
            onPressed: handleOnRemove,
          ),
          Text(
            "$quantity",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.green),
          ),
          IconButton(
              icon: const Icon(Icons.add),
              color: tap.value == false ? AppColors.blue : Colors.grey,
              onPressed: handleOnAdd)
        ],
      );
    });
  }
}
