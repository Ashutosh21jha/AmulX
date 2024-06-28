import 'dart:async';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/items_controller.dart';
import 'package:amul/models/items_model.dart';
import 'package:amul/screens/cartPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/utils/item_card.dart';
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
  final RxList<ItemsModel> availableItems = <ItemsModel>[].obs;
  final RxList<ItemsModel> unavailableItems = <ItemsModel>[].obs;
  final RxList<ItemsModel> mergedList = <ItemsModel>[].obs;
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;
  RxList<ItemsModel> defaultOrder = <ItemsModel>[].obs;
  RxList<ItemsModel> searchResults = <ItemsModel>[].obs;

  String get userId => auth.currentUser?.email ?? '';
  final RxInt selected = 0.obs;

  final TextEditingController _searchController = TextEditingController();

  void separateItems() {
    for (ItemsModel itemData in widget.itemList) {
      bool available = itemData.availability;
      ItemsModel item = ItemsModel(
        id: itemData.id,
        price: itemData.price,
        type: itemData.type,
        availability: itemData.availability,
        imageUrl: itemData.imageUrl,
        stock: itemData.stock,
      );
      if (available == true) {
        availableItems.add(item);
      } else {
        unavailableItems.add(item);
      }
    }
    mergedList.clear();
    defaultOrder.addAll(widget.itemList);
    print(defaultOrder);
    mergedList.addAll(availableItems);
    mergedList.addAll(unavailableItems);

    searchResults.clear();
    searchResults.addAll(mergedList);
  }

  void _showDefaultOrder() {
    print('Before : $mergedList');
    mergedList.clear();
    mergedList.addAll(defaultOrder);
    print(mergedList);
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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Store is Closed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.red,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget openStoreContent() {
    int index1 = 0;
    int index2 = 1;
    int index3 = 2;
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
                  onChanged: (value) {
                    searchResults.clear();
                    searchResults.addAll(mergedList.where((item) =>
                        item.id!.toLowerCase().contains(value.toLowerCase())));
                  },
                ),
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
                      onTap: () {
                        selected.value = index1;
                        print(selected.value);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 160,
                          decoration: BoxDecoration(
                            color: selected.value == index1
                                ? AppColors.blue
                                : Colors.white,
                            border: Border.all(
                              color: const Color(0xFF2546A9),
                              width: 1, // Border width
                            ),
                            borderRadius:
                                BorderRadius.circular(32.0), // Border radius
                          ),
                          child: Center(
                            child: Text(
                              "Most Popular",
                              style: TextStyle(
                                color: selected.value == index1
                                    ? Colors.white
                                    : AppColors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selected.value = index2;
                        availableItems.sort(
                          (a, b) =>
                              int.parse(a.price).compareTo(int.parse(b.price)),
                        );
                        mergedList.clear();
                        mergedList.addAll(availableItems);
                        mergedList.addAll(unavailableItems);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 240,
                          decoration: BoxDecoration(
                            color: selected.value == index2
                                ? AppColors.blue
                                : (Get.isDarkMode
                                    ? const Color(0xFFE6E6E6)
                                    : Colors.white),
                            border: Border.all(
                              color: const Color(0xFF2546A9), // Border color
                              width: 1, // Border width
                            ),
                            borderRadius:
                                BorderRadius.circular(32.0), // Border radius
                          ),
                          child: Center(
                            child: Text(
                              "Price: Lowest - Highest",
                              style: TextStyle(
                                color: selected.value == index2
                                    ? Colors.white
                                    : AppColors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selected.value = index3;
                        availableItems.sort(
                          (a, b) =>
                              int.parse(b.price).compareTo(int.parse(a.price)),
                        );
                        mergedList.clear();
                        mergedList.addAll(availableItems);
                        mergedList.addAll(unavailableItems);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 240,
                          decoration: BoxDecoration(
                            color: selected.value == index3
                                ? AppColors.blue
                                : (Get.isDarkMode
                                    ? const Color(0xFFE6E6E6)
                                    : Colors.white),
                            border: Border.all(
                              color: const Color(0xFF2546A9), // Border color
                              width: 1, // Border width
                            ),
                            borderRadius:
                                BorderRadius.circular(32.0), // Border radius
                          ),
                          child: Center(
                            child: Text(
                              "Price: Highest - Lowest",
                              style: TextStyle(
                                color: selected.value == index3
                                    ? Colors.white
                                    : AppColors.blue,
                              ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 95),
                child: Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _searchController.text.isEmpty
                        ? mergedList.length
                        : searchResults.length,
                    itemBuilder: (context, index) {
                      ItemsModel itemData = _searchController.text.isEmpty
                          ? mergedList[index]
                          : searchResults[index];
                      bool available = itemData.availability;
                      bool unavailable = !available;

                      bool isOutOfStock = available && itemData.stock == 0;

                      String? itemname = itemData.id;

                      if (_searchController.text.isNotEmpty &&
                          !itemname!
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase())) {
                        return Container();
                      }

                      return ItemCard(
                        itemData: itemData,
                        isOutOfStock: isOutOfStock,
                        unavailable: unavailable,
                        index: index,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await Get.to(
            () => CartPage(true),
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
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/cartlogo.svg",
                        ),
                        const SizedBox(width: 60),
                        const Text(
                          'View Cart',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
  void initState() {
    super.initState();

    separateItems();
    ItemController.to.fetchItems();
    CartController.to.tappedList = List.filled(mergedList.length, false);
    CartController.to.countList = List.filled(mergedList.length, 0);
    selected.value = 0;
    defaultOrder();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('menu').doc('today menu').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: FutureBuilder(
              future: Future.delayed(const Duration(
                  seconds: 2)), // Add your desired delay duration
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return loadingShimmer();
                    },
                  );
                } else {
                  // Once the delay is over, continue with the actual content
                  final sessionData = snapshot.data;
                  final bool isStoreOpen = sessionData?['session'] ?? false;

                  return isStoreOpen
                      ? openStoreContent()
                      : closedStoreMessage();
                }
              },
            ),
          );
        }

        final sessionData = snapshot.data;
        final bool isStoreOpen = sessionData?['session'] ?? false;

        return Scaffold(
          body: isStoreOpen ? openStoreContent() : closedStoreMessage(),
        );
      },
    );
  }
}
