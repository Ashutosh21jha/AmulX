import 'dart:async';
import 'dart:collection';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/items_controller.dart';
import 'package:amul/models/items_model.dart';
import 'package:amul/screens/cartPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:amul/screens/cart_components/cartItem_model.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/utils/item_card.dart';
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
  late final Timer _timer;

  void separateItems() {
    /*Filterlist.values.forEach((rxList) => rxList.clear());*/
    for (ItemsModel itemData in widget.itemList) {
      bool available = itemData.availability;
      ItemsModel item = ItemsModel(
          id: itemData.id,
          price: itemData.price,
          type: itemData.type,
          availability: itemData.availability,
          imageUrl: itemData.imageUrl,
          stock: itemData.stock);
      if (available == true) {
        availableItems.add(item);
      } else {
        unavailableItems.add(item);
      }
    }
    mergedList.clear();
    mergedList.addAll(availableItems);
    mergedList.addAll(unavailableItems);
  }

  /*RxMap<String, RxList<Map<String, dynamic>>> Filterlist = {
    'availableItems': <Map<String, dynamic>>[].obs,
    'unavailableItems': <Map<String, dynamic>>[].obs,
  }.obs;*/

  /*Future<void> getUpdateCount() async {
    try {
      final RxList<CartItem> cartItems = CartController.to.cartItems;
      final List<Map<String, dynamic>>? availableItems =
          Filterlist['availableItems'];

      for (final Item in cartItems) {
        final matchingItem = availableItems?.firstWhere(
          (availableItem) => availableItem['name'] == Item.name,
        );
        if (matchingItem != null) {
          Item.quantity = matchingItem['count'];
        }
      }
    } catch (e) {
      print("Error updating item count: $e");
    }
  }*/

  /* RxList<Map<String, dynamic>> perfectlist() {
    RxList availableItems = Filterlist['availableItems'] ?? [].obs;
    RxList unavailableItems = Filterlist['unavailableItems'] ?? [].obs;

    */ /*Set<String> uniqueKeys = Set<String>();

    availableItems.removeWhere((item) => !uniqueKeys.add(item['name']));
    unavailableItems.removeWhere((item) => !uniqueKeys.add(item['name']));*/ /*

    RxList<Map<String, dynamic>> result = <Map<String, dynamic>>[].obs;
    result.addAll(availableItems as Iterable<Map<String, dynamic>>);
    result.addAll(unavailableItems as Iterable<Map<String, dynamic>>);

    return result;
  }
*/
  /* Set<String> uniqueKeys = Set<String>();

  availableItems.removeWhere((item) => !uniqueKeys.add(item['name']));
  unavailableItems.removeWhere((item) => !uniqueKeys.add(item['name']));

  return [...availableItems, ...unavailableItems];
*/

  void _sortListByPriceLowestToHighest() {
    setState(() {
      availableItems?.sort(
        (a, b) => a.price.compareTo(b.price),
      );
      mergedList.clear();
      mergedList.addAll(availableItems);
      mergedList.addAll(unavailableItems);
    });
  }

  void _sortListByPriceHighestToLowest() {
    setState(() {
      availableItems?.sort(
        (a, b) => b.price.compareTo(a.price),
      );
      mergedList.clear();
      mergedList.addAll(availableItems);
      mergedList.addAll(unavailableItems);
    });
  }

  /*void _showDefaultOrder() {
    setState(() {
      mergedList.clear();
      mergedList.addAll(widget.itemList);
    });
  }*/

  Future<void> reloadFetchData() async {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      ItemController.to.fetchItems();
    });
  }

  String get userId => auth.currentUser?.email ?? '';

  int selected = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    separateItems();
    /*   _defaultOrder = List<F
    oodItem>.from(_foodItems);*/
    /*_showDefaultOrder();*/
    ItemController.to.fetchItems();
    reloadFetchData();
    CartController.to.tappedList = List.filled(mergedList.length, false);
    CartController.to.countList = List.filled(mergedList.length, 0);
    selected = 0;
  }

  @override
  Widget build(BuildContext context) {
    int index1 = 0;
    int index2 = 1;
    int index3 = 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.cat,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
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
                    // Adjust the vertical padding as needed
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: const Color(0xFFE6E6E6),
                    filled: true,
                  ),
                  onChanged: (value) {
                    // Filter the list based on the search input
                    setState(() {
                      /* _foodItems = _defaultOrder
                          .where((item) => item.name
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();*/
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = index1;
                        /*  _showDefaultOrder();*/
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: selected == index1
                              ? const Color(0xFF2546A9)
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
                            color: selected == index1
                                ? Colors.white
                                : const Color(0xFF2546A9),
                          ),
                          //style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = index2;
                        _sortListByPriceLowestToHighest();
                      });
                    },
                    /* onTap: () {
                      setState(() {
                        selected = index2;
                        _isSortedByPriceLowestToHighest =
                            !_isSortedByPriceLowestToHighest;
                        _isSortedByPriceHighestToLowest =
                            !_isSortedByPriceHighestToLowest;
                        if (_isSortedByPriceLowestToHighest) {
                          _foodItems.sort((a, b) =>
                              a.price.compareTo(b.price)); // Ascending order
                        }
                      });
                    },*/
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                          color: selected == index2
                              ? const Color(0xFF2546A9)
                              : Colors.white,
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
                            color: selected == index2
                                ? Colors.white
                                : const Color(0xFF2546A9),
                          ),
                          // style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = index3;
                        _sortListByPriceHighestToLowest();
                      });
                    },
                    /*onTap: () {
                      setState(() {
                        selected = index3;
                        if (_isSortedByPriceHighestToLowest) {
                          _foodItems.sort((a, b) => b.price.compareTo(a.price));
                        }
                        _isSortedByPriceHighestToLowest =
                            !_isSortedByPriceHighestToLowest;
                        _isSortedByPriceLowestToHighest =
                            !_isSortedByPriceLowestToHighest;
                      });
                    },*/
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                          color: selected == index3
                              ? const Color(0xFF2546A9)
                              : Colors.white,
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
                            color: selected == index3
                                ? Colors.white
                                : const Color(0xFF2546A9),
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
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
                    itemCount: mergedList.length,
                    itemBuilder: (context, index) {
                      ItemsModel itemData = mergedList[index];
                      bool available = itemData.availability;
                      bool unavailable = !available;

                      bool isOutOfStock = available && itemData.stock == 0;

                      String? itemname = itemData.id;
                      // String itemprice = itemData.price;
                      // String itemimage = itemData.imageUrl;

                      if (_searchController.text.isNotEmpty &&
                          !itemname!.toLowerCase().contains(
                                _searchController.text.toLowerCase(),
                              )) {
                        return Container();
                      }

                      return ItemCard(itemData: itemData, isOutOfStock: isOutOfStock, unavailable: unavailable, index: index);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(() => CartPage());
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: SizedBox(
            height: 85,
            child: Card(
              elevation: 10, // You can adjust the elevation for the card
              color: const Color(0xFF2546A9),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30), // Customize the border radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Align items at each end of the row
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
}
