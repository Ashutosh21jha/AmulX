import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'cart_components/cart_controller.dart';
import 'cart_components/cart_items.dart';
import 'package:amul/Screens/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class FoodItem {
  String name;
  int price;
  String imageAsset;
  int itemCount;

  FoodItem(this.name, this.price, this.imageAsset, {this.itemCount = 1});

  void incrementItemCount() {
    itemCount++;
  }

  void decrementItemCount() {
    if (itemCount > 1) {
      itemCount--;
    }
  }
}

class FoodPage extends StatefulWidget {
  FoodPage({Key? key, required this.cat}) : super(key: key);
  String cat;

  @override
  State<StatefulWidget> createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> {
  final List<FoodItem> _cartItems = [];
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

  String get userId => auth.currentUser?.email ?? '';

  int selected = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _defaultOrder = List<FoodItem>.from(_foodItems);
    _sortListByDefaultOrder();
    selected = 0;
  }

  // Function to add a cart item to Firestore
  Future<void> _addToFirestore(FoodItem item, int itemCount) async {
    String documentId = userId; // Use user's email as document ID
    CollectionReference cartCollection =
        db.collection('User').doc(documentId).collection('cart');

    // Generate a random document ID for each cart entry
    String cartEntryId = cartCollection.doc().id;

    // Create a map for the cart entry
    Map<String, dynamic> cartEntry = {
      'name': item.name,
      'price': item.price,
      'count': itemCount,
    };

    // Create a map for the cart item (using a random document ID)
    Map<String, dynamic> cartItem = {
      'cartEntryId': cartEntryId,
      'item': cartEntry,
    };

    // Add the cart item to Firestore
    await cartCollection.doc(cartEntryId).set(cartItem);
  }

  void _addToCart(FoodItem item) {
    int itemCount = item.itemCount; // Store the initial count

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[300],
              title: const Text('Add to Cart'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'Item: ${item.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Price: ₹${item.price}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  const Text('Enter the item count:'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        color: Colors.indigo,
                        onPressed: () {
                          setState(() {
                            if (itemCount > 1) {
                              itemCount--;
                            }
                          });
                        },
                      ),
                      Text(
                        '$itemCount',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.indigo,
                        onPressed: () {
                          setState(() {
                            itemCount++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.indigo, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _addToFirestore(item, itemCount);
                    for (int i = 0; i < itemCount; i++) {
                      CartController.to.addItem(CartItem(
                        name: item.name,
                        price: item.price.toDouble(),
                      ));
                    }
                    // Close the dialog
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.indigo, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _viewCart() {
    Get.to(CartPage());
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
                      _foodItems = _defaultOrder
                          .where((item) => item.name
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
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
                      _sortListByDefaultOrder(); // Sort by default order
                      setState(() {
                        selected = index1;
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
                              child: SizedBox(
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
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(CartPage());
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
