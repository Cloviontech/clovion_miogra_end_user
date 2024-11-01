import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';

import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_services.dart';
// import '../widgets/square_image.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../widgets/square_image.dart';
import 'cart_payment_screen.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    fetchCartListData();
    fetchData();
  }
  List data = [];
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("uid");
    log(userId.toString());
    final String apiUrl = 'https://${ApiServices.ipAddress}/cartlist/$userId';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body); // Store JSON response
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:$e');
    }
  }
  @override
  Widget build(BuildContext context) {
    List categories = [];
    List productIds = [];
    // Retrieve cart data and total price
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];
    double totalPriceFromData = cartData['totalPrice'];

    // String name = cartData['cartItems'];
    // log(name);
var test;
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

      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: fetchCartListData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'You need to login first',
                ),
              );
            } else {
              final data = snapshot.data;
           //   test = data;
              int dataLength = 0;

              List<String> productNames = [];
              List<String> images = [];
              List<String> expectedDates = [];

              List<String> statusOfOrder = [];
              List<String> cartIds = [];
              List<dynamic> priceOfProducts = [];
              List<String> categoriesList = [];
              List<String> productsIdList = [];

              if (data != null) {
                if (data is List) {
                  dataLength = data.length;
                  for (var dataMap in data) {
                    String? name;
                    String? image;
                    String? expDate;
                    String? category;
                    String? status;
                    dynamic price;
                    String? cartId;
                    String? productId;

                    // Check shop product first
                    if (dataMap.containsKey("shop_product")) {
                      name = dataMap["shop_product"]?["product"]?["model_name"];
                      cartId = dataMap["cart_id"];
                      image =
                          dataMap["shop_product"]?["product"]?["primary_image"];
                      price =
                          dataMap["shop_product"]?["product"]?['selling_price'];
                      category = dataMap["shop_product"]?["category"];

                      expDate = dataMap?["expected_deliverydate"];

                      status = dataMap?["status"];
                      productId = dataMap?['shop_product']['product_id'];
                      categories.add(category);
                      productIds.add(productId);

                    }

                    if (name == null && dataMap.containsKey("food_product")) {
                      name = dataMap["food_product"]?["product"]?["model_name"];
                      cartId = dataMap["cart_id"];
                      image =
                          dataMap["food_product"]?["product"]?["primary_image"];
                      price =
                          dataMap["food_product"]?["product"]?['selling_price'];
                      category = dataMap["shop_product"]?["category"];
                      expDate = dataMap?["expected_deliverydate"];

                      status = dataMap?["status"];
                      productId = dataMap?['food_product']['product_id'];
                      setState(() {
                        categories.add(category);
                        productIds.add(productId);
                      });
                    }

                    if (name == null && dataMap.containsKey("jewel_product")) {
                      name =
                          dataMap["jewel_product"]?["product"]?["model_name"];

                      cartId = dataMap["cart_id"];
                      image = dataMap["jewel_product"]?["product"]
                          ?["primary_image"];
                      category = dataMap["shop_product"]?["category"];
                      price = dataMap["jewel_product"]?["product"]
                          ?['selling_price'];
                      expDate = dataMap?["expected_deliverydate"];

                      status = dataMap?["status"];
                      productId = dataMap?['jewel_product']['product_id'];
                      setState(() {
                        categories.add(category);
                        productIds.add(productId);
                      });
                    }

                    if (name == null && dataMap.containsKey("dmio_product")) {
                      name = dataMap["dmio_product"]?["product"]?["model_name"];
                      cartId = dataMap["cart_id"];
                      image =
                          dataMap["dmio_product"]?["product"]?["primary_image"];
                      category = dataMap["shop_product"]?["category"];
                      price =
                          dataMap["dmio_product"]?["product"]?['selling_price'];
                      expDate = dataMap?["expected_deliverydate"];

                      status = dataMap?["status"];

                      productId = dataMap?['dmio_product']['product_id'];
                      setState(() {
                        categories.add(category);
                        productIds.add(productId);
                      });
                    }

                    if (name == null &&
                        dataMap.containsKey("pharmacy_product")) {
                      name = dataMap["pharmacy_product"]?["product"]
                          ?["model_name"];
                      cartId = dataMap["cart_id"];
                      image = dataMap["pharmacy_product"]?["product"]
                          ?["primary_image"];
                      category = dataMap["shop_product"]?["category"];
                      price = dataMap["pharmacy_product"]?["product"]
                          ?['selling_price'];
                      expDate = dataMap?["expected_deliverydate"];

                      status = dataMap?["status"];

                      productId = dataMap?['pharmacy_product']['product_id'];
                      setState(() {
                        categories.add(category);
                        productIds.add(productId);
                      });
                    }

                    if (name == null &&
                        dataMap.containsKey("d_original_product")) {
                      name = dataMap["d_original_product"]?["product"]
                          ?["model_name"];
                      cartId = dataMap["cart_id"];
                      image = dataMap["d_original_product"]?["product"]
                          ?["primary_image"];
                      category = dataMap["shop_product"]?["category"];

                      price = dataMap["d_original_product"]?["product"]
                          ?['selling_price'];
                      expDate = dataMap?["expected_deliverydate"];
                      status = dataMap?["status"];
                      productId = dataMap?['d_original_product']['product_id'];

                      setState(() {
                        categories.add(category);
                        productIds.add(productId);
                      });
                    }

                    if (name == null &&
                        dataMap.containsKey("freshcut_product")) {
                      name = dataMap["freshcut_product"]?["product"]
                          ?["model_name"];
                      cartId = dataMap["cart_id"];
                      image = dataMap["freshcut_product"]?["product"]
                          ?["primary_image"];
                      category = dataMap["shop_product"]?["category"];
                      price = dataMap["freshcut_product"]?["product"]
                          ?['selling_price'];
                      expDate = dataMap?["expected_deliverydate"];
                      status = dataMap?["status"];
                      productId = dataMap?['freshcut_product']['product_id'];

                      setState(() {
                        categories.add(category);
                        productIds.add(productId);
                      });
                    }

                    if (name != null) {
                      productNames.add(name);
                    }
                    if (image != null) {
                      images.add(image);
                    }
                    if (expDate != null) {
                      expectedDates.add(expDate);
                    }
                    if (category != null) {
                      categoriesList.add(category);
                    }
                    if (status != null) {
                      statusOfOrder.add(status);
                    }

                    if (cartId != null) {
                      cartIds.add(cartId);
                    }
                    if (productId != null) {
                      productsIdList.add(productId);
                    }
                    if (price != null) {
                      // double number = double.parse(price);
                      priceOfProducts.add(price);
                    }
                  }
                } else {
                  log('Data is not a list');
                }
              } else {
                log('Data is null');
              }

              if (data != null) {
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    itemCount: PersistentShoppingCart().getCartItemCount(),
                    itemBuilder: (context, index) {
                      // String? productName = cartItems[index].productName;
                      // String? productPrice =
                      //     cartItems[index].unitPrice.toString();
                      // // String? producDetails =
                      // //     cartItems[index].productDescription;
                      // String? producImage =
                      //     cartItems[index].productThumbnail;
                      // String? productId = productsIds[index];
                      String? productId = cartItems[index].productId;
                      int? quantity = cartItems[index].quantity;
                  //    int itemCount = PersistentShoppingCart().getCartItemCount();

                      return Card(
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
                                        image: images[index],
                                        title: 'Product Name',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productNames[index],
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          '₹ ${priceOfProducts[index]}/-',
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          // width: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          decriment(productId);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.remove,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        quantity.toString(),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          increament(productId);
                                                        });
                                                      },
                                                      icon:
                                                          const Icon(Icons.add),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        removeFromCart(
                                                            cartIds[index]);

                                                        // setState(() {
                                                        //   // dataLength;
                                                        // });
                                                        setState(() {
                                                          PersistentShoppingCart()
                                                              .removeFromCart(
                                                            productId,
                                                          );
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Remove',
                                                            style: Theme.of(
                                                                    context)
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
                      );
                    });

                // ListView.builder(
                //   itemCount: dataLength,
                //   itemBuilder: (context, index) {
                //     return Card(
                //       elevation: 2,
                //       child: ListTile(
                //         leading: Image.network(images[index]),
                //         title: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(productNames[index]),
                //             Text(priceOfProducts[index]),
                //             Row(
                //               mainAxisAlignment:
                //                   MainAxisAlignment.spaceBetween,
                //               children: [
                //                 InkWell(
                //                   onTap: () {
                //                     // addToCart(productsIds[index],
                //                     //     categoriesList[index]);
                //                     // removeFromWishList(productsIds[index]);
                //                     setState(() {});
                //                   },
                //                   child: Container(
                //                     decoration: BoxDecoration(
                //                       borderRadius:
                //                           BorderRadius.circular(10),
                //                       border:
                //                           Border.all(color: Colors.blue),
                //                     ),
                //                     child: const Padding(
                //                       padding: EdgeInsets.all(4.0),
                //                       child: Text(
                //                         'Add to Cart',
                //                         style: TextStyle(
                //                             color: Colors.green),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 InkWell(
                //                   onTap: () {
                //                     // removeFromWishList(productsIds[index]);
                //                     // removed();
                //                     setState(() {});
                //                   },
                //                   child: Row(
                //                     children: [
                //                       Icon(
                //                         Icons.delete,
                //                         color: Colors.grey[700],
                //                         size: 20,
                //                       ),
                //                       const SizedBox(
                //                         width: 10,
                //                       ),
                //                       const Text(
                //                         'Remove',
                //                         style: TextStyle(
                //                           color: Colors.grey,
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ],
                //         ),
                //         // trailing: Icon(Icons.edit),
                //         tileColor: Colors.white,
                //       ),
                //     );
                //   },
                // );
              } else {
                // Handle the case where data is null//
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'No data found',
                    ),
                  ),
                );
              }
            }
          },
        ),
        // :
      ),

      bottomNavigationBar:
      cartItems.isNotEmpty ?
      SizedBox(
        height: 110,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Price ₹${totalPriceFromData.toString()}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      primaryColor,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPaymentScreen(
                          address: 'fhf',
                          category: categories,
                          pinCode: '629001',
                          productId: productIds,
                          shopId: 'grg',
                          totalPrice: totalPriceFromData,
                          userId: userId,
                          actualPrice: 'eg',
                          discounts: 'eg',
                          totalQuantity: '2',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Conform',
                  ),
                ),
              ),
            ),
          ],
        ),
      ): SizedBox(
        height: 110,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Price ₹${totalPriceFromData.toString()}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.grey,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {


                  },
                  child: const Text(
                    'Your Cart is Empty',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

                PersistentShoppingCart().clearCart();

                Timer(const Duration(milliseconds: 2), () {
                  updateUI();
                });
              },
              child: const Text('Conform'),
            ),
          ],
        );
      },
    );
  }

  String userId = '';

  Future<dynamic> fetchCartListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response").toString();

    String url = 'https://${ApiServices.ipAddress}/cartlist/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          return jsonData;
        } else {
          log('Unexpected data structure: ${data.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load data from URL: $url (Status code: ${response.statusCode})');
      }
      // Navigator.of(context).pop();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  updateUI() => setState(() {});

  void increament(productId) async {
    await PersistentShoppingCart().incrementCartItemQuantity(productId);
  }

  void decriment(productId) async {
    await PersistentShoppingCart().decrementCartItemQuantity(productId);
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

  // removeFromCart(productId) async {
  //   String urls =
  //       'https://${ApiServices.ipAddress}/cartremove/$userId/$productId/';
  //   log(urls);

  //   log(productId);
  //   log(userId);

  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(urls));

  //     request.fields['quantity'] = '1';

  //     var response = await request.send();

  //     log(response.statusCode.toString());

  //     if (response.statusCode == 200) {
  //       String responseBody = await response.stream.bytesToString();
  //       removed();

  //       responseBody = responseBody.trim().replaceAll('"', '');

  //       log('userId $responseBody');
  //       log('Item removed from to Wish List');

  //       // Navigator.pop(context);
  //     } else {
  //       // Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Check The datas'),
  //         ),
  //       );
  //       log('Failed to post data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     log('Exception while posting data: $e');
  //   }
  // }

  removeFromCart(cartId) async {
    String url = 'https://${ApiServices.ipAddress}/cartremove/$userId/$cartId/';

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
        log('Item removed from to Wish List');

        // Navigator.pop(context);
      } else {
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check The datas'),
          ),
        );
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

}

