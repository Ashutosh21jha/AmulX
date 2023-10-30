import 'package:flutter_svg/svg.dart';

import 'cart_components/cart_controller.dart';
import 'cart_components/cart_items.dart';
import 'package:amul/Screens/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';

class FoodItem {
  String name;
  int price;
  String imageAsset;

  FoodItem(this.name, this.price, this.imageAsset);
}

class FoodPage extends StatefulWidget {
  FoodPage({Key? key,required this.cat}) : super(key: key);
  String cat;

  @override
  State<StatefulWidget> createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> {
  List<FoodItem> _cartItems = [];
  FoodItem? _selectedItem;
  List<FoodItem> _defaultOrder = [];
  List<FoodItem> _foodItems = [
    FoodItem('Masala\nMaggi', 40, 'assets/images/masalamaggi.jpg'),
    FoodItem('Plain Maggi', 30, 'assets/images/maggi2.jpg'),
    FoodItem('Egg Maggi', 35, 'assets/images/eggmaggie.jpg'),
    FoodItem('2 Egg Maggi', 50, 'assets/images/eggmaggie.jpg'),
    FoodItem('Chocolate\nBrownie', 55, 'assets/images/brownie.jpg'),
    FoodItem('Masala\nMaggi', 40, 'assets/images/masalamaggi.jpg'),
    FoodItem('Plain Maggi', 30, 'assets/images/maggi2.jpg'),
    FoodItem('Egg Maggi', 35, 'assets/images/eggmaggie.jpg'),
    FoodItem('2 Egg Maggi', 50, 'assets/images/eggmaggie.jpg'),
    FoodItem('Chocolate\nBrownie', 55, 'assets/images/brownie.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    _defaultOrder = List<FoodItem>.from(_foodItems);
    _sortListByDefaultOrder();
  }

  void _addToCart(FoodItem item) {
    setState(() {
      _selectedItem = item;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Item Added to Cart'),
          content: Text('${item.name} - ₹${item.price}'),
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

  void _viewCart() {
    Get.to(CartPage());
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CartPage(cartItems: _cartItems),
    //   ),
    // );
  }

  bool _isSortedByPriceLowestToHighest = false;
  bool _isSortedByPriceHighestToLowest = false;

  void _sortListByDefaultOrder() {
    setState(() {
      _foodItems = List<FoodItem>.from(_defaultOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(
                context);
          },
        ),
        centerTitle: true,
        title:Text(
          widget.cat,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  GestureDetector(
                    onTap: () {
                      _sortListByDefaultOrder(); // Sort by default order
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD1D2D3), // Border color
                            width: 1, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(32.0), // Border radius
                        ),
                        child: const Center(
                            child: Text(
                          "Most Popular",
                          //style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSortedByPriceLowestToHighest =
                            !_isSortedByPriceLowestToHighest;
                        _isSortedByPriceHighestToLowest =
                            !_isSortedByPriceHighestToLowest;
                        if (_isSortedByPriceLowestToHighest) {
                          _foodItems.sort((a, b) =>
                              a.price.compareTo(b.price)); // Ascending order
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD1D2D3), // Border color
                            width: 1, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(32.0), // Border radius
                        ),
                        child: const Center(
                            child: Text(
                          "Price: Lowest - Highest",
                          // style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_isSortedByPriceHighestToLowest) {
                          _foodItems.sort((a, b) => b.price.compareTo(a.price));
                        }
                        _isSortedByPriceHighestToLowest =
                            !_isSortedByPriceHighestToLowest;
                        _isSortedByPriceLowestToHighest =
                            !_isSortedByPriceLowestToHighest;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD1D2D3), // Border color
                            width: 1, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(32.0), // Border radius
                        ),
                        child: const Center(
                            child: Text("Price: Highest - Lowest")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _foodItems[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                    child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 70,
                              height: 70,
                              child: Image.asset(
                                foodItem.imageAsset,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(
                            foodItem.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '₹${foodItem.price.toString()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              CartController.to.addItem(CartItem(
                                  name: foodItem.name,
                                  price: foodItem.price.toDouble()));
                              _addToCart(foodItem);
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
                          ),
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(CartPage());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
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
