import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/amul_status_controller.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:amul/screens/order/orderPage.dart';
import 'package:amul/screens/profile.dart';
import 'package:amul/screens/utils/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amul/screens/order/order_review.dart';
import 'package:lottie/lottie.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.fromFoodPage});
  final bool fromFoodPage;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;
  late final RxBool storeOpen = Get.find<AmulXStatusController>().open;

  @override
  void initState() {
    super.initState();
    CartController.to.fetchCart();
    CartController.to.reloadFetchData();
    CartController.to.fetchCurrentOrder();
  }

  @override
  void dispose() {
    CartController.to.reloadFetchData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(storeOpen);
    return Obx(() => WillPopScope(
          onWillPop: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Mainscreen()));
            return true;
          },
          child: Scaffold(
              appBar: widget.fromFoodPage
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: appColors.backgroundColor,
                      toolbarHeight: 70,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: appColors.primaryText,
                        ),
                        onPressed: () {
                          Get.to(const Mainscreen());
                        },
                      ),
                      centerTitle: true,
                      title: Text(
                        'Cart',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: appColors.primaryText),
                      ),
                    )
                  : null,
              backgroundColor: appColors.backgroundColor,
              body: storeOpen.value
                  ? (CartController.to.cartItems.isEmpty
                      ? Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                  child: SizedBox(height: Get.height * 0.15)),
                              const Text(
                                "Your Cart is Empty!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Lottie.asset(
                                "assets/raw/emptycart.json",
                                height: 300,
                                width: double.infinity,
                                repeat: false,
                                frameRate: FrameRate(30),
                              ),
                              SizedBox(height: Get.height * 0.15),
                              Visibility(
                                visible: CartController.to.currentOrder,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => OrderPage(
                                          userId: userId,
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 24),
                                    backgroundColor: AppColors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(48),
                                    ),
                                  ),
                                  child: const Text(
                                    'Track Orders',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18, // Increase font size
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(height: widget.fromFoodPage ? 0 : 20),
                            Expanded(
                              child: Obx(() {
                                final cartController = CartController.to;
                                return ListView.builder(
                                  itemCount: cartController.cartItems.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        cartController.cartItems[index];
                                    return CartItemCard(item: item);
                                  },
                                );
                              }),
                            ),
                            Visibility(
                                visible: !CartController.to.currentOrder,
                                replacement: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => OrderPage(
                                            userId: userId,
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 24),
                                      backgroundColor: appColors.blue,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                    ),
                                    child: Text(
                                      'Track Orders',
                                      style: TextStyle(
                                        color: appColors.onPrimary,
                                        fontSize: 18, // Increase font size
                                      ),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: appColors.primaryText,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'Summary',
                                            style: TextStyle(
                                                color: appColors.primaryText,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 10),
                                          Obx(() {
                                            final cartController =
                                                CartController.to;
                                            return Column(
                                              children: cartController.cartItems
                                                  .map((item) => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${item.quantity} ${item.name}',
                                                            style: TextStyle(
                                                                color: appColors
                                                                    .secondaryText,
                                                                fontSize: 14),
                                                          ),
                                                          Text(
                                                            '\₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                                            style: TextStyle(
                                                                color: appColors
                                                                    .secondaryText,
                                                                fontSize: 14),
                                                          ), // Item price
                                                        ],
                                                      ))
                                                  .toList(),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                            ? appColors.backgroundColor
                                            : appColors.surfaceColor,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Get.isDarkMode
                                                  ? Color(0xFF404040)
                                                  : appColors.primaryText,
                                              spreadRadius:
                                                  Get.isDarkMode ? 6 : 3,
                                              blurRadius: 2,
                                              offset: const Offset(0, 3))
                                        ],
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 20),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  'Total Amount',
                                                  style: TextStyle(
                                                    color: AppColors.blue,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Obx(() {
                                                final cartController =
                                                    CartController.to;
                                                return Text(
                                                  '\₹ ${cartController.totalAmount.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color:
                                                        appColors.secondaryText,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  print(
                                                      'pressed order now button');
                                                  final cartController =
                                                      CartController.to;
                                                  if (cartController
                                                      .cartItems.isNotEmpty) {
                                                    if (CartController
                                                            .to.currentOrder ==
                                                        false) {
                                                      print(
                                                          "Navigating to review Screen");
                                                      Get.to(
                                                        () => OrderReviewPage(
                                                          cartItems:
                                                              cartController
                                                                  .cartItems,
                                                        ),
                                                      );
                                                      /*Get.to(OrderReviewPage(
                                                    cartItems:
                                                        cartController.cartItems,
                                                  ));*/
                                                    } else {
                                                      Get.to(
                                                        () => OrderPage(
                                                          userId: userId,
                                                        ),
                                                      );
                                                      /* await  Get.to(() => OrderPage(
                                                        userId: userId,
                                                      ));*/
                                                    }
                                                  } else {
                                                    Get.snackbar(
                                                      'Cart is Empty',
                                                      'Please add items to the cart first',
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      fontSize: 22),
                                                  backgroundColor:
                                                      AppColors.blue,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 24,
                                                    vertical: 10,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            48),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Order Now',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ))
                  : Center(
                      child:
                          LottieBuilder.asset('assets/raw/store_closed.json'))),
        ));
  }
}
