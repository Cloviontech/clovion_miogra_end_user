import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/freshCuts/presentation/pages/fresh_cut_details.dart';
import 'package:miogra/features/jewellery/presentation/pages/jewl_details.dart';
import 'package:miogra/features/pharmacy/presentation/pages/pharmacy_product_details.dart';
import 'package:miogra/features/shopping/presentation/pages/go_to_order.dart';
import 'package:miogra/features/shopping/presentation/pages/product_details.dart';
import 'package:miogra/my_work/check_out_screen.dart';
import 'package:miogra/widgets/square_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> products = [];
  String cartTotal = '';
  String userId = '';
  int globalIndexLength = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCartTotal();
  }
  String getSellingPrice(Map<String, dynamic> product) {
    return product['shop_product']?['product']?['selling_price']?.toString() ??
        product['food_product']?['product']?['selling_price']?.toString() ??
        product['jewel_product']?['product']?['selling_price']?.toString() ??
        product['freshcut_product']?['product']?['selling_price']?.toString() ??
        product['d_origin_product']?['product']?['selling_price']?.toString() ??
        product['dailymio_product']?['product']?['selling_price']?.toString() ??
        product['pharmacy_product']?['product']?['selling_price']?.toString() ?? '';
  }
  String shopId(Map<String, dynamic> product) {
    return product['shop_product']?['product']?['shop_id']?.toString() ??
        product['food_product']?['product']?['food_id']?.toString() ??
        product['jewel_product']?['product']?['jewel_id']?.toString() ??
        product['freshcut_product']?['product']?['fresh_id']?.toString() ??
        product['d_origin_product']?['product']?['shop_id']?.toString() ??
        product['dailymio_product']?['product']?['shop_id']?.toString() ??
        product['pharmacy_product']?['product']?['pharm_id']?.toString() ?? '';
  }
  String getproductid(Map<String, dynamic> product) {
    return product['shop_product']?['product_id']?.toString() ??
        product['food_product']?['product_id']?.toString() ??
        product['jewel_product']?['product_id']?.toString() ??
        product['freshcut_product']?['product_id']?.toString() ??
        product['d_origin_product']?['product_id']?.toString() ??
        product['dailymio_product']?['product_id']?.toString() ??
        product['pharmacy_product']?['product_id']?.toString() ?? '';
  }
  String getcategory(Map<String, dynamic> product) {
    return product['shop_product']?['category']?.toString() ??
        product['food_product']?['category']?.toString() ??
        product['jewel_product']?['category']?.toString() ??
        product['freshcut_product']?['category']?.toString() ??
        product['d_origin_product']?['category']?.toString() ??
        product['dailymio_product']?['category']?.toString() ??
        product['pharmacy_product']?['category']?.toString() ?? '';
  }
  String getBrand(Map<String, dynamic> product) {
    return product['shop_product']?['product']?['brand'] ??
        product['food_product']?['product']?['brand'] ??
        product['jewel_product']?['product']?['brand'] ??
        product['freshcut_product']?['product']?['brand'] ??
        product['d_origin_product']?['product']?['brand'] ??
        product['dailymio_product']?['product']?['brand'] ??
        product['pharmacy_product']?['product']?['brand'] ?? '';
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response") ?? '';
    try {
      final response = await http
          .get(Uri.parse('https://miogra.clovion.org/cartlist/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(
              json.decode(response.body).map((product) {
            product['quantity'] = 1; // Initialize quantity
            return product;
          }));
        });
        updateCartTotal();
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> fetchCartTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response") ?? '';
    try {
      final response = await http.get(
          Uri.parse('https://miogra.clovion.org/cart_total_amount/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          cartTotal = json.decode(response.body).toString();
        });
      } else {
        print('Failed to load cart total: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading cart total: $e');
    }
  }

  void _incrementQuantity(int index) async {
    setState(() {
      products[index]['quantity']++;
    });
    await _updateProductQuantity(index);
  }

  void _decrementQuantity(int index) async {
    if (products[index]['quantity'] > 1) {
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
        updateCartTotal();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update quantity'),
          ),
        );
        log('Failed to update quantity: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while updating quantity: $e');
    }
  }

  void _removeFromCart(int index) async {
    String url =
        'https://miogra.clovion.org/cartremove/$userId/${products[index]['cart_id']}/';

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
        updateCartTotal();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to remove item'),
          ),
        );
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
      if (product['total'] != null && product['quantity'] != null) {
        total += product['total'] * product['quantity'];
      }
    }
    setState(() {
      cartTotal = total.toString();
    });
  }

  Future<dynamic> alertBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure want to delete carted item? '),
          actions: [
            ElevatedButton(
              style: const ButtonStyle(),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: const ButtonStyle(),
              onPressed: () async {
                Navigator.pop(context);

                Timer(const Duration(milliseconds: 2), () {
                  setState(() {}); // Directly call setState to update the UI
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  String getPrimaryImage(Map<String, dynamic> product) {
    if (product['shop_product'] != null) {
      return product['shop_product']["product"]['primary_image'] ?? '';
    } else if (product['food_product'] != null) {
      return product['food_product']["product"]['primary_image'] ?? '';
    } else if (product['jewel_product'] != null) {
      return product['jewel_product']["product"]['primary_image'] ?? '';
    } else if (product['freshcut_product'] != null) {
      return product['freshcut_product']["product"]['primary_image'] ?? '';
    } else if (product['d_origin_product'] != null) {
      return product['d_origin_product']["product"]['primary_image'] ?? '';
    } else if (product['dailymio_product'] != null) {
      return product['dailymio_product']["product"]['primary_image'] ?? '';
    } else if (product['pharmacy_product'] != null) {
      return product['pharmacy_product']["product"]['primary_image'] ?? '';
    }
    return ''; // Default or fallback value if none of the conditions are met
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          globalIndexLength = index + 1;
          return GestureDetector(
            onTap: (){
              if(getcategory(product) == 'shopping'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }else if(getcategory(product) == 'fresh_cuts'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FreshCutProductDetails(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }else if(getcategory(product) == 'food'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoToOrder(
                      link: getPrimaryImage(product).toString(),
                      productId: getproductid(product), // Replace with your product ID
                   // Replace with your shop ID
                      category:getcategory(product), shopId: shopId(product), uId: userId, // Replace with your category
                    ),
                  ),
                );
              }
              else if(getcategory(product) == 'jewellery'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>   JewlProductsDetails(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }
              else if(getcategory(product) == 'pharmacy'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>    PharmacyProducDetails(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }

            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SquareImage(
                              width: 85,
                              height: 85,
                              image: getPrimaryImage(product)
                                 ,
                              title: 'Product Name',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getBrand(product),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '₹ ${getSellingPrice(product)}/-',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                _decrementQuantity(index),
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                product['quantity'].toString()),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _incrementQuantity(index),
                                            icon: const Icon(Icons.add),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () => _removeFromCart(index),
                                            child: Container(
                                              height: 30,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Remove',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: products.isNotEmpty
          ? SizedBox(
              height: 110,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Price: ₹$cartTotal',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          backgroundColor:
                              MaterialStatePropertyAll(primaryColor),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          final images = products
                              .map((product) => getPrimaryImage(product))
                              .toList();
                          final singleProducts = products
                              .map((product) =>
                          product['shop_product']?['product']?['selling_price'] ??
                              product['food_product']?['product']?['selling_price'] ??
                              product['jewel_product']?['product']?['selling_price'] ??
                              product['freshcut_product']?['product']?['selling_price'] ??
                              product['d_origin_product']?['product']?['selling_price'] ??
                              product['dailymio_product']?['product']?['selling_price'] ??
                              product['pharmacy_product']?['product']?['selling_price'] ?? '')
                              .toList();
                          final productIds = products
                              .map((product) =>
                          product['shop_product']?['product_id'] ??
                              product['food_product']?['product_id'] ??
                              product['jewel_product']?['product_id'] ??
                              product['freshcut_product']?['product_id'] ??
                              product['d_origin_product']?['product_id'] ??
                              product['dailymio_product']?['product_id'] ??
                              product['pharmacy_product']?['product_id'] ?? '')
                              .toList();
                          final categories = products
                              .map((product) =>
                          product['shop_product']?['category'] ??
                              product['food_product']?['category'] ??
                              product['jewel_product']?['category'] ??
                              product['freshcut_product']?['category'] ??
                              product['d_origin_product']?['category'] ??
                              product['dailymio_product']?['category'] ??
                              product['pharmacy_product']?['category'] ??
                              '')
                              .toList();
                          final brandNames = products
                              .map((product) => getBrand(product))
                              .toList();
                          final totalQuantities = products
                              .map((product) => product['quantity'])
                              .toList();
                          final discountPercentages = products
                              .map((product) =>
                          product['shop_product']?['product']?['discount'] ??
                              product['food_product']?['product']?['discount'] ??
                              product['jewel_product']?['product']?['discount'] ??
                              product['freshcut_product']?['product']?['discount'] ??
                              product['d_origin_product']?['product']?['discount'] ??
                              product['dailymio_product']?['product']?['discount'] ??
                              product['pharmacy_product']?['product']?['discount'] ??
                              '')
                              .toList();
                          final discountPrices = products
                              .map((product) =>
                          product['shop_product']?['product']?['discount_price'] ??
                              product['food_product']?['product']?['discount_price'] ??
                              product['jewel_product']?['product']?['discount_price'] ??
                              product['freshcut_product']?['product']?['discount_price'] ??
                              product['d_origin_product']?['product']?['discount_price'] ??
                              product['dailymio_product']?['product']?['discount_price'] ??
                              product['pharmacy_product']?['product']?['discount_price'] ??
                              '')
                              .toList();
                          final shopId = products
                              .map((product) =>
                          product['shop_product']?['shop_id'] ??
                              product['food_product']?['shop_id'] ??
                              product['jewel_product']?['shop_id'] ??
                              product['freshcut_product']?['shop_id'] ??
                              product['d_origin_product']?['shop_id'] ??
                              product['dailymio_product']?['shop_id'] ??
                              product['pharmacy_product']?['shop_id'] ?? '')
                              .toList()
                              .join(','); // Assuming a single shop ID

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckOutPage(
                                image: images,
                                singleProduct: singleProducts,
                                price: cartTotal,
                                shopId: shopId,
                                productId: productIds,
                                userId: userId,
                                category: categories,
                                brandName: brandNames,
                                totalQuantity: totalQuantities,
                                discountPercentage: discountPercentages,
                                discountPrice: discountPrices,
                              ),
                            ),
                          );
                        },
                        child: const Text('Confirm'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: 110,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Price: ₹0',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {},
                        child: const Text('Your Cart is Empty'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

}
