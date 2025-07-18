import 'dart:async';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/amul_status_controller.dart';
import 'package:amul/controllers/items_controller.dart';
import 'package:amul/models/items_model.dart';
import 'package:amul/screens/cartPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:amul/screens/utils/item_card.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class FoodPage extends StatefulWidget {
  FoodPage({Key? key, required this.cat, required this.itemList})
      : super(key: key);
  String cat;
  RxList<ItemsModel> itemList = <ItemsModel>[].obs;

  @override
  State<StatefulWidget> createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> {
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;
  late final RxBool storeOpen = Get.find<AmulXStatusController>().open;

  RxList<ItemsModel> filteredResults = <ItemsModel>[].obs;

  final RxInt selected = 0.obs;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    filteredResults.value = widget.itemList.value;

    filteredResults.value = filteredResults.toList()
      ..sort(foodItemSortFunction);

    // separateItems();
    ItemController.to.fetchItems();
    selected.value = 4;
  }

  int sortPriceLowToHighFxn(ItemsModel a, ItemsModel b) {
    return a.price.compareTo(b.price);
  }

  int sortPriceHighToLowFxn(ItemsModel a, ItemsModel b) {
    return b.price.compareTo(a.price);
  }

  int sortAccordingToStockFxn(ItemsModel a, ItemsModel b) {
    return a.stock.compareTo(b.stock);
  }

  int foodItemSortFunction(ItemsModel a, ItemsModel b) {
    if (!(a.availability ^ b.availability)) {
      if (selected.value == 0) {
        if (a.availability && !b.availability) {
          return -1;
        } else {
          return 1;
        }
      } else if (selected.value == 1) {
        // MOST POPULAR
        return sortAccordingToStockFxn(a, b);
      } else if (selected.value == 2) {
        return sortPriceLowToHighFxn(a, b);
      } else if (selected.value == 3) {
        return sortPriceHighToLowFxn(a, b);
      } else {
        return sortAccordingToStockFxn(a, b);
      }
    } else {
      if (a.availability && !b.availability) {
        return -1;
      } else {
        return 1;
      }
    }
  }

  Future<void> filterResults(String query) async {
    if (query.isEmpty) {
      filteredResults.value = widget.itemList;
    } else {
      filteredResults.value = widget.itemList
          .where((element) =>
              element.id!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    filteredResults.value = filteredResults.toList()
      ..sort(foodItemSortFunction);
  }

  void handleFilterSelection(int filterNum) {
    if (selected.value == filterNum) {
      selected.value = 0;
      filteredResults.value = widget.itemList;
    } else {
      selected.value = filterNum;
    }

    filteredResults.value = filteredResults.toList()
      ..sort(foodItemSortFunction);
  }

  Widget openStoreContent() {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        toolbarHeight: 70,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.cat,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: TextFormField(
                    cursorColor: Colors.black,
                    style: const TextStyle(
                        color: Colors.black, decorationColor: Colors.black),
                    controller: _searchController,
                    textAlign: TextAlign.justify,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                      ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Color(0xFF57585B)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: const Color(0xFFE6E6E6),
                      filled: true,
                    ),
                    onChanged: filterResults),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: Obx(() {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    GestureDetector(
                      onTap: () => handleFilterSelection(1),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: selected.value == 1
                              ? appColors.blue
                              : appColors.surfaceColor,
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.white70
                                : const Color(0xFF2546A9),
                            width: 1, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(32.0), // Border radius
                        ),
                        child: Center(
                          child: Text(
                            "Most Popular",
                            style: TextStyle(
                              color: selected.value == 1
                                  ? appColors.onPrimary
                                  : appColors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => handleFilterSelection(2),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: selected.value == 2
                              ? appColors.blue
                              : appColors.surfaceColor,
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.white70
                                : const Color(0xFF2546A9),
                            width: 1, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(32.0), // Border radius
                        ),
                        child: Center(
                          child: Text(
                            "Price: Lowest - Highest",
                            style: TextStyle(
                              color: selected.value == 2
                                  ? appColors.onPrimary
                                  : appColors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => handleFilterSelection(3),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: selected.value == 3
                              ? appColors.blue
                              : appColors.surfaceColor,
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.white70
                                : const Color(0xFF2546A9),
                            width: 1, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(32.0), // Border radius
                        ),
                        child: Center(
                          child: Text(
                            "Price: Highest - Lowest",
                            style: TextStyle(
                              color: selected.value == 3
                                  ? appColors.onPrimary
                                  : appColors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 95),
                  child: ListView.builder(
                    // key: Key(filteredResults.fold<String>(
                    //     '',
                    //     (previousValue, element) =>
                    //         previousValue + element.id!)),

                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      ItemsModel itemData = filteredResults[index];

                      return ItemCard(
                        key: Key(itemData.id!),
                        itemData: itemData,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await Get.to(
            const CartPage(fromFoodPage: true),
          );

          /* await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartPage(true)))
              .then((value) {
            if (value == true) {
              setState(() {});
            }
          });*/
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: SizedBox(
            height: 85,
            child: Card(
              elevation: 10,
              color: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/images/cartlogo.svg",
                    ),
                    const Text(
                      'View Cart',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => storeOpen.value ? openStoreContent() : closedStoreMessage(),
    ));
  }

  Widget loadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget closedStoreMessage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        toolbarHeight: 70,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.cat,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: LottieBuilder.asset('assets/raw/store_closed.json')),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
