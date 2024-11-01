// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/profile/pages/add_address_page.dart';
import 'package:miogra/features/shopping/presentation/pages/go_to_order.dart';
import 'package:miogra/my_work/check_out_screen.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api_services.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../../../core/product_box.dart';
import '../../../../home_page/cart_payment_screen.dart';
import '../../../shopping/presentation/pages/product_details.dart';

class ShopeProductViewPage extends StatefulWidget {
  const ShopeProductViewPage(
      {super.key, required this.subCategoryName, required this.categoryName});

  final String subCategoryName;
  final String categoryName;

  @override
  State<ShopeProductViewPage> createState() => _ShopeProductViewPageState();
}

class _ShopeProductViewPageState extends State<ShopeProductViewPage> {
  //  final _fetchData = fetchDataFromListJson(); // Assuming your data fetching function
  final _cartItems = <String, dynamic>{};
  List data = [];
  int globalIndexLength = 0;

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("uid");
    log(userId.toString());
    final String apiUrl = 'https://${ApiServices
        .ipAddress}/category_based_food/${widget.subCategoryName}';
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

  List<Map<String, dynamic>> cartList = [];

  static final Map<String, Product> _products = {
    // ... map product IDs to Product objects
  };

  // double get totalPrice {
  //   double total = 0.0;
  //   _cartItems.forEach((productId, quantity) {
  //     final price = getProductPrice(productId); // Use defined method
  //     total += price * quantity;
  //   });
  //   return total;
  // }

  double get totalPrice {
    double total = 0.0;
    _cartItems.forEach((productId, quantity) {
      // Assuming you have a function to get product price by ID
      final price = getProductPrice(productId);
      total += price * quantity;
    });
    return total;
  }

  dynamic rate = 0.0;

  // double get totalPrice {
  //   double total = 0.0;
  //   _cartItems.forEach((productId, quantity) {
  //     // Assuming you have a function to get product price by ID
  //     final price = getProductPrice(productId);
  //     total += price * quantity;
  //   });
  //   return total;
  // }
  //   double getProductPrice(String productId) {
  //   // Logic to find price based on product data
  //   // (e.g., from the `data` obtained in `FutureBuilder`)
  //   final product = data.firstWhere((item) => item['product']['product_id'] == productId);
  //   if (product != null) {
  //     return double.parse(product['product']['selling_price'].toString());
  //   } else {
  //     // Handle case where product not found (optional)
  //     return 0.0; // Or throw an exception
  //   }
  // }

  static double getProductPrice(String productId) {
    final product = _products[productId];
    if (product != null) {
      return product.price;
    } else {
      // Handle case where product not found (optional)
      return 0.0; // Or throw an exception
    }
  }

  Future<dynamic> fetchDataFromListJson() async {
    String url =
        'https://${ApiServices.ipAddress}/category_based_food/${widget
        .subCategoryName}';
    log(url);
    try {
      final response = await http.get(Uri.parse(url));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log('Featching Data');
        final data = json.decode(response.body);
        if (data is List) {
          final jsonData = data;
          log('Data fetched successfully');
          return jsonData;
        } else {
          log('Unexpected data structure: ${data.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load data from URL: $url (Status code: ${response
                .statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  double price = 0.0;

  String userId = '';

  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserIdInSharedPreferences();
    fetchDataFromListJson();
    fetchData();
  }

  // List orderedFoods = [];
  // List<int> qty = [];
  // void updateValueInc(int index1) {
  //   log('update quantity');
  //   setState(() {
  //     // Increment the value at the specified index
  //     if (qty.isNotEmpty && index1 >= 0 && index1 < qty.length) {
  //       qty[index1] = qty[index1] + 1;

  //       qty[index1]++;

  //       if (!(orderedFoods.any((list) =>
  //           list.toString() ==
  //           [product[index1].foodId, product[index1].productId].toString()))) {
  //         setState(() {
  //           orderedFoods.insert(
  //               index1, [product[index1].foodId, product[index1].productId]);

  //           log(orderedFoods.toString());
  //         });
  //       }
  //     }
  //   });
  //   log(qty.toString());
  //   log(qty.length.toString());
  //   log(qty[index1].toString());
  //   log('${index1 + 1}');
  // }

  // void updateValueDec(int index1) {
  //   if (qty[index1] >= 1) {
  //     setState(() {
  //       qty[index1]--;
  //     });
  //   } else {}

  //   if (qty[index1] == 0) {
  //     setState(() {
  //       orderedFoods.removeAt(
  //         index1,

  //         //  [
  //         //   product[index1].foodId,
  //         //   product[index1].productId
  //         // ]
  //       );

  //       log('orderedFoods remove : $orderedFoods');
  //     });
  //   }
  // }

  // List<int> totalQtyBasedPrice = [];

  // List<int> totalqty = [];

  // int totalQtyBasedPrice1 = 0;

  // int totalqty1 = 0;

  // calcTotalPriceWithResQty() {
  //   setState(() {
  //     totalQtyBasedPrice1 = 0;
  //     totalQtyBasedPrice = [];
  //     totalqty1 = 0;
  //     totalqty = [];
  //   });
  //   // totalQuantity = 0;
  //   // for (var i = 0; i < product.length; i++) {
  //   //   log(product[i].product.sellingPrice);
  //   //   setState(() {
  //   //     totalQtyBasedPrice
  //   //         .add(product[i].product.sellingPrice.toInt() * qty[i]);

  //   //     totalqty.add(qty[i]);
  //   //   });
  //   // }

  //   setState(() {
  //     totalQtyBasedPrice1 =
  //         totalQtyBasedPrice.reduce((value, element) => value + element);

  //     totalqty1 = totalqty.reduce((value, element) => value + element);
  //   });

  //   log('totalQtyBasedPrice1 $totalQtyBasedPrice1');
  // }

  // List<int>? count = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.subCategoryName.toUpperCase()),
            // Text(product.length.toString()),
            Text(widget.categoryName.toUpperCase()),
          ],
        ),
        backgroundColor: const Color(0xff870081),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<dynamic>(
        future: fetchDataFromListJson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
              ),
            );
          } else {
            final data = snapshot.data;
            if (data != null && data is List && data.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                itemCount: data.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  globalIndexLength = index + 1;
                  final imageUrl =
                  data[index]['product']['primary_image']?.toString();
                  final productName = data[index]['product']['model_name']
                      .toString()
                      .toUpperCase();
                  final sellingPrice = data[index]['product']['selling_price'];
                  dynamic myString = sellingPrice;
                  if (myString == String) {
                    double myDouble = double.parse(myString);
                    price = myDouble + price;
                  } else if (myString == int) {
                    price = sellingPrice + price;
                  }
                  final productid = data[index]['product']['product_id'];
                  final shopeid = data[index]['product']['food_id'];
                  final category = data[index]['category'];
                  final description =
                  data[index]['product']['product_description'];

                  // final quantity = ValueNotifier<int>(1);
                  final quantity =
                  ValueNotifier<int>(_cartItems[productid] ?? 0);

                  // void addToCarts(int quantity) {
                  //   setState(() {
                  //     _cartItems[productid] =
                  //         quantity; // Update quantity in the map
                  //   });
                  // }

                  void addToCarts(int quantity) {
                    setState(() {
                      cartList.add(data[index]);
                      _cartItems[productid] = quantity;
                      rate = sellingPrice * quantity;
                    });
                  }

                  void removeFromCart(int quantity) {
                    setState(() {
                      if (_cartItems.containsKey(data[index])) {
                        // final quantity = _cartItems[productId];
                        _cartItems.remove(data[index]);
                        rate = rate - sellingPrice;
                        // Update total price here (if implemented)
                      }
                    });
                  }

                  // Function to handle increment button press
                  void incrementQuantity() {
                    quantity.value++;
                    // addToCarts(productid);
                    // Update the product quantity in your map (if applicable)
                    // ... (your logic to update the map)
                    addToCarts(quantity.value);
                  }

                  void decrementQuantity() async {
                    if (quantity.value >= 1) {
                      // Decrement quantity
                      quantity.value--;
                      rate = rate - sellingPrice;
                      // Trigger a rebuild of the widget
                      removeFromCart(index);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GoToOrder(
                                  uId: userId,
                                  category: category,
                                  link: imageUrl,
                                  productId: productid,
                                  shopId: shopeid,
                                  totalPrice: sellingPrice,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 249, 227, 253),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
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
                                      // color: const Color.fromARGB(
                                      //     255, 249, 227, 253),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                        Image.network(imageUrl.toString()),
                                      ),
                                    ),
                                    Row(children: [
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
                                          onPressed: decrementQuantity,
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: quantity,
                                        builder: (context, value, child) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: primaryColor,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 30,
                                            child: Text(
                                              value.toString(),
                                            ),
                                          );
                                        },
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
                                          onPressed: incrementQuantity,
                                          icon: const Icon(
                                            Icons.add,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.5,
                                      child: Text(
                                        productName,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '₹$sellingPrice',
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
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: IconButton(
                                //     onPressed: () async {
                                //       await PersistentShoppingCart().addToCart(
                                //         PersistentShoppingCartItem(
                                //           productId: productid,
                                //           productName: productName,
                                //           productDescription: description,
                                //           unitPrice: price,
                                //           productThumbnail: imageUrl,
                                //           quantity: 1,
                                //         ),
                                //       );
                                //       addToCart(productid, category);
                                //     },
                                //     icon: SvgPicture.asset(
                                //       'assets/icons/cart.svg',
                                //       height: 30,
                                //       color: primaryColor,
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    onPressed: () {
                                      showDetailsOfFood(
                                        description,
                                        imageUrl.toString(),
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
              );
            } else {
              // Handle the case where data is null
              return const Scaffold(
                body: Center(
                  child: Text('No Product found'),
                ),
              );
            }
          }
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
                    )),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                setState(() {});
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const OrderSuccess()));

                // bottomDetailsScreen(
                //     context: context,
                //     qtyB: totalqty1,
                //     priceB: totalQtyBasedPrice1,
                //     deliveryB: 0);
              },
              child:
              // Text(
              //   '$totalqty1 Items | ₹ ${totalQtyBasedPrice1}',
              //   style: TextStyle(color: Colors.purple, fontSize: 18),
              // ),

              AutoSizeText(
                '₹$rate',
                // '$totalqty1 Items | ₹ ${totalQtyBasedPrice1 + (totalQtyBasedPrice1 == 0 ? 0 : 0)}',
                minFontSize: 18,
                maxFontSize: 24,
                maxLines: 1,
                // Adjust this value as needed
                overflow: TextOverflow.ellipsis,
                // Handle overflow text
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
                    )),
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              onPressed: () {
                log(cartList.toString());

                // GoToOrder(shopId: shopId, uId: uId, category: category)

                //   Navigator.push(
                //       context,
                //        MaterialPageRoute(
                //       builder: (context) => AddAddressPage(
                //          userId: userId, edit: false, food: true),
                //   ));
                /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  AddAddressPage(
                userId: userId,
                edit: false,
                food: true,
                shopId:'shopId' ,
                productId: [],
                totalPrice:'50' ,
                pincode: "629001" ,
                foodcategory: "food",
                totalQuantity:'1' ,
                )));
              */
                /*
            CartPaymentScreen(
                        productData: cartList,
                        address: '',
                        category:['food'],
                        pinCode: '629001',
                        productId: [ '1RGQW5Y5VPY'],
                        shopId: '',
                        totalPrice: rate,
                        userId: userId,
                        actualPrice: '15',
                        discounts: '',
                        totalQuantity: '1',
                      ),
             */
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => OrderingFor(
                //               totalPrice: totalQtyBasedPrice1,
                //               totalQty: totalqty1,
                //               selectedFoods: orderedFoods,
                //               qty: qty,
                //               productCategory: 'food',
                //               noOfProd: 'single',
                //             )));
               /*
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    CheckOutPage(image: data[0]['product']['primary_image'],
                        price: data[0]['product']['selling_price'],
                        shopId: data[0]['product']['food_id']['product']['food_id'],
                        productId: data[0]['product']['product_id'],
                        userId: userId,
                        category: data[0]['category'],
                        brandName: data[0]['product']['model_name'])));
                */
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (data.isNotEmpty) {
                        final product = data[0]['product'];
                        final imageUrl = product['primary_image'];
                        final sellingPrice = product['selling_price'];
                        final shopId = product['food_id'];
                        final productId = product['product_id'];
                        final category = data[0]['category'];

                        return CheckOutPage(
                          image: imageUrl,
                          price: sellingPrice,
                          shopId: shopId,
                          productId: productId,
                          userId: userId,
                          category: category,
                          brandName: product['model_name'],
                        );
                      } else {
                        return Scaffold(
                          body: Center(
                            child: Text('No data available'),
                          ),
                        );
                      }
                    },
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
      builder: (context) =>
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(20)),
                        color: Colors.grey[300],
                        image: DecorationImage(
                          image: NetworkImage(
                            imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: double.infinity - 50,
                      height: MediaQuery
                          .of(context)
                          .size
                          .width - 50,
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

  addToCart(productid, category) async {
    String url =
        'https://${ApiServices
        .ipAddress}/cart_product/$userId/$productid/$category/';

    // log(widget.userId);
    log(productid);
    log(category);
    log(userId);
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['quantity'] = '1';

      var response = await request.send();

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        log('Item Added to Cart');

        Navigator.pop(context);

        cartAdded();
      } else {
        Navigator.pop(context);
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

  void cartAdded() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Item added to cart'),
      ),
    );
  }
}

class Product {
  final String id;
  final double price;

  // ... other product details

  Product({required this.id, required this.price});
}

class CartManager {
  final _cartItems = <int, int>{}; // Map product ID to quantity

  void addToCart(int productId, int quantity) {
    _cartItems[productId] = quantity;
    // Update total price here (if implemented)
  }
}
