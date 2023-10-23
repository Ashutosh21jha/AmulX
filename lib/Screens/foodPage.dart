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
  const FoodPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> {
  List<FoodItem> _foodItems = [
    FoodItem('Masala Maggi', 40, 'assets/images/maggi2.jpg'),
    FoodItem('Plain Maggi', 30, 'assets/images/maggi2.jpg'),
    FoodItem('Egg Maggi', 35, 'assets/images/eggmaggi.jpg'),
    FoodItem('2 Egg Maggi', 50, 'assets/images/eggmaggi.jpg'),
    FoodItem('Chocolate\nBrownie', 55, 'assets/images/brownie.jpg'),
  ];
  List<FoodItem> _cartItems = [];
  FoodItem? _selectedItem;
  List<FoodItem> _defaultOrder = [];

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
          title: Text('Item Added to Cart'),
          content: Text('${item.name} - ₹${item.price}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ));
          },
        ),
        centerTitle: true,
        title: Text(
          "Foods",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _sortListByDefaultOrder(); // Sort by default order
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(100, 50)),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white), // Default color
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Most Popular',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {
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
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(100, 50)),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white), // Default color
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Price: Lowest-Highest',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
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
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(100, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Price: Highest-Lowest',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _foodItems.length,
            itemBuilder: (context, index) {
              final foodItem = _foodItems[index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 16, bottom: 12),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                foodItem.imageAsset,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      foodItem.name,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10),
                                    child: Text(
                                      '₹${foodItem.price.toString()}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      CartController.to.addItem(CartItem(
                                          name: foodItem.name,
                                          price: foodItem.price.toDouble()));
                                      _addToCart(foodItem);
                                    },
                                    child: Text('Add'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 120),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(CartPage());
        },
        child: Container(
          height: 120,
          child: Card(
            elevation: 20, // You can adjust the elevation for the card
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Customize the border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at each end of the row
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.amber,
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 60),
                      Text(
                        'View Cart',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
