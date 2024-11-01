import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:miogra/features/shopping/presentation/pages/go_to_order.dart';
import 'package:miogra/my_work/check_out_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../core/api_services.dart';
import '../core/colors.dart';

class ShowFoodScreen extends StatefulWidget {
  ShowFoodScreen({
    Key? key,
    required this.subCategoryName,
    required this.categoryName,
  }) : super(key: key);

  final String subCategoryName;
  final String categoryName;

  @override
  State<ShowFoodScreen> createState() => _ShowFoodScreenState();
}

class _ShowFoodScreenState extends State<ShowFoodScreen> {
  List<dynamic> products = [];
  String cartTotal = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  addToCart(String productId, String subCategory, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });

    debugPrint('userId : $userId');
    debugPrint('productId : $productId');
    debugPrint('subCategory : $subCategory');
    debugPrint('quantity : $quantity');

    var headers = {
      'Context-Type': 'application/json',
    };

    var requestBody = {
      "quantity": quantity.toString(),
    };

    try {
      var response = await http.post(
        Uri.parse(
            "https://${ApiServices.ipAddress}/cart_product/$userId/$productId/$subCategory/"),
        headers: headers,
        body: requestBody,
      );
      debugPrint(
          "https://${ApiServices.ipAddress}/cart_product/$userId/$productId/$subCategory/}");
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        print(response.statusCode);
        debugPrint(response.body);
        print('Product Added To Cart Successfully');
        // Update local cart total after adding to cart
        updateCartTotal();
      } else {
        print('status code : ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response") ?? '';
    try {
      final response = await http.get(Uri.parse(
          'https://${ApiServices.ipAddress}/category_based_food/${widget.subCategoryName}'));
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(
              json.decode(response.body).map((product) {
                product['quantity'] = 0; // Initialize quantity
                return product;
              }));
          // Calculate initial cart total after fetching products
          updateCartTotal();
        });
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void _incrementQuantity(int index) async {
    setState(() {
      products[index]['quantity']++;
    });
    await _updateProductQuantity(index);
  }

  void _decrementQuantity(int index) async {
    if (products[index]['quantity'] > 0) {
      setState(() {
        products[index]['quantity']--;
      });
      await _updateProductQuantity(index);
    }
  }

  Future<void> _updateProductQuantity(int index) async {
    String url =
        'https://miogra.clovion.org/cartupdate/${products[index]['cart_id'].toString()}';
    log(url);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['quantity'] = products[index]['quantity'].toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        log('Quantity updated: $responseBody');
        // Update cart total after updating quantity
        updateCartTotal();
      } else {
        log('Failed to update quantity: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while updating quantity: $e');
    }
  }

  void _removeFromCart(int index) async {
    String url =
        'https://miogra.clovion.org/cartremove/$userId/${products[index]['cart_id']}';

    log(url);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['quantity'] = '1';

      var response = await request.send();
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        removed();
        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        log('Item removed from Wish List');

        setState(() {
          products.removeAt(index);
        });
        // Update cart total after removing item
        updateCartTotal();
      } else {
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  void removed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text('Item removed from cart'),
      ),
    );
  }

  void updateCartTotal() {
    double total = 0;
    for (var product in products) {
      total += product['product']['selling_price'] * product['quantity'];
    }
    setState(() {
      cartTotal = total.toStringAsFixed(2); // Format to two decimal places
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.subCategoryName.toUpperCase()),
            Text(widget.categoryName.toUpperCase()),
          ],
        ),
        backgroundColor: const Color(0xff870081),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        itemCount: products.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          final product = products[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoToOrder(
                      uId: userId,
                      category: product['category'],
                      link: product["product"]['primary_image'].toString(),
                      productId: product['product']['product_id'],
                      shopId: product['product']['food_id'],
                      totalPrice: product['product']['selling_price'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                    product["product"]['primary_image']),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _decrementQuantity(index);
                                      _removeFromCart(index);
                                    },
                                    icon: const Icon(
                                      Icons.remove,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: primaryColor,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  height: 30,
                                  width: 30,
                                  child:
                                  Text(product['quantity'].toString()),
                                ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _incrementQuantity(index);
                                      addToCart(
                                          product['product']['product_id']
                                              .toString(),
                                          'food',
                                          1);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                product["product"]['brand'],
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Text(
                              '₹${product["product"]['selling_price']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              showDetailsOfFood(
                                product["product"]['product_description'],
                                product['product']['primary_image'],
                              );
                            },
                            icon: const Icon(
                              Icons.info,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {},
              child: AutoSizeText(
                'Total Price: ₹$cartTotal',
                minFontSize: 18,
                maxFontSize: 24,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              onPressed: () {
                var filteredProducts = products
                    .where((product) => product['quantity'] > 0)
                    .toList();

                if (filteredProducts.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'No items with quantity greater than 0 in the cart'),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckOutPage(
                      image: filteredProducts
                          .map((product) => product["product"]['primary_image'])
                          .toList(),
                      singleProduct: filteredProducts
                          .map((product) =>
                          product["product"]['selling_price'].toString())
                          .toList(),
                      price: cartTotal,
                      shopId: filteredProducts
                          .map((product) => product['shop_id'])
                          .toString(),
                      productId: filteredProducts
                          .map((product) => product['product_id'])
                          .toList(),
                      userId: userId,
                      category: filteredProducts
                          .map((product) => product['category'])
                          .toList(),
                      brandName: filteredProducts
                          .map((product) => product["product"]['brand'])
                          .toList(),
                      totalQuantity: filteredProducts
                          .map((product) => product['quantity'])
                          .toList(),
                    ),
                  ),
                );
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showDetailsOfFood(String details, String imageUrl) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: NetworkImage(
                        imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity - 50,
                  height: MediaQuery.of(context).size.width - 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      details,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
