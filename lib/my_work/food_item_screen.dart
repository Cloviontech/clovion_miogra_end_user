import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/food/models_foods/my_food_data.dart';
import 'package:miogra/my_work/check_out_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/colors.dart';

class FoodItemScreen extends StatefulWidget {
  FoodItemScreen({super.key, required this.categoryName, required this.foodId});

  final String categoryName;
  final String foodId;

  @override
  State<FoodItemScreen> createState() => _FoodItemScreenState();
}

class _FoodItemScreenState extends State<FoodItemScreen> {
  List<dynamic> products = [];
  List<dynamic> Restarunt = [];
  String cartTotal = '';
  String userId = '';
  int globalIndexLength = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  //  fetchCartTotal();
    fetchMyFoodData1(widget.foodId);
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


  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response") ?? '';
    try {
      final response = await http.get(Uri.parse(
          'https://${ApiServices.ipAddress}/food_get_products/${widget.foodId}'));
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(
              json.decode(response.body).map((product) {
            product['quantity'] = 0; // Initialize quantity
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

  Future<void> fetchRestaruntData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response") ?? '';
    try {
      final response = await http.get(Uri.parse(
          'https://${ApiServices.ipAddress}/my_food_data/${widget.foodId}'));
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(
              json.decode(response.body).map((product) {
            //     product['quantity'] = 1; // Initialize quantity
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





  late MyFoodData myFoodData;

  void fetchMyFoodData1(String foodId) async {
    final response = await http.get(
        Uri.parse('https://${ApiServices.ipAddress}/my_food_data/$foodId'));

    debugPrint('https://${ApiServices.ipAddress}/my_food_data/$foodId');

    if (response.statusCode == 200) {
      setState(() {
        myFoodData = MyFoodData.fromJson(jsonDecode(response.body));
        //loadingFetchMyFoodData = false;
      });
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff870081),
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xff870081),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  color: const Color(0xff870081),
                ),
                Column(
                  children: [
                    Container(
                      height: 100,
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 70,
                                ),
                                Text(
                                  myFoodData.businessName.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  // snapshot.data!.streetName
                                  //     .toString(),

                                  myFoodData.streetName.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 3,
                                    right: 1,
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Color(0xff870081),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "4.3",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        width: .5,
                                      ),
                                      Icon(Icons.star,
                                          size: 13, color: Colors.white),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                        text: 'Delivery within ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                      text: '${10} min',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                        text: ' to',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: ' ${20} min',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500))
                                  ]),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(
                                  thickness: BorderSide.strokeAlignCenter,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),

                          // foodItemBox(),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 50,
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        image: DecorationImage(
                          image: NetworkImage(
                            myFoodData.profile.toString(),
                          ),

                          // fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Food Items',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xE6434343)),
              ),
            ),
            Column(
              children: [
                //  Text('data'),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: products.length,
                  controller: ScrollController(),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 15,
                      childAspectRatio: 2.1),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    globalIndexLength = index + 1;

                    return Container(
                      // padding: const EdgeInsets.only(top: 7),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        // image: AssetImage(
                                        //     'assets/images/appliances.jpeg'),

                                        image: NetworkImage(
                                          // foods![index]
                                          product["product"]['primary_image']
                                                  .toString() ??
                                              '',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () { _decrementQuantity(index);_removeFromCart(index);},
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xff870081),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              ),
                                            ),
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "-",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff870081))),
                                          child: Text(
                                            product['quantity'].toString(),
                                            style: const TextStyle(
                                                color: Color(0xff870081),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _incrementQuantity(index);
                                            addToCart(
                                                product['product']['product_id']
                                                    .toString(),
                                                'food',
                                                1);
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Color(0xff870081),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                )),
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "+",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  // flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // "Chiken Manchurian",
                                        product["product"]['brand'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 19,
                                          color: Color(0xE6434343),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        // "₹150",
                                        '₹ ${product["product"]['selling_price'].toString()}/-',
                                        style: const TextStyle(
                                            fontSize: 19,
                                            color: Color(0xE6434343)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child: Column(
                                                      children: [
                                                        // temperory used for description
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Image.network(
                                                              product["product"]
                                                                          [
                                                                          'primary_image']
                                                                      .toString() ??
                                                                  ''),
                                                        ),
                                                        const SizedBox(
                                                          height: 50,
                                                        ),
                                                        Text(
                                                            '${product["product"]['product_description'].toString()}')
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text(
                                          // temperory used for description

                                          '${product["product"]['product_description'].toString()}',

                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xE6434343)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // const Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Text(userId),
              ],
            ),
          ],
        ),
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
                // '₹$rate',
                'Total Price: ₹$cartTotal',
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
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
              onPressed: () {
                // log(cartList.toString());

                showModalBottomSheet(
                  showDragHandle: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                globalIndexLength = index + 1;
                                return Row(
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
                                                // Image.network(imageUrl.toString()),
                                                Image.network(product["product"]
                                                                [
                                                                'primary_image']
                                                            .toString() ??
                                                        ''

                                                    // categoryBasedFood[index]
                                                    //     .product!
                                                    //     .primaryImage
                                                    //     .toString()

                                                    ),
                                          ),
                                        ),
                                        Row(children: [
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
                                            child: Text(
                                                product['quantity'].toString()
                                                // quantityOfItems[index]
                                                //   .toString(),

                                                ),
                                          ),
                                        ]),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            // productName
                                            product["product"]['brand'] ?? '',
                                            // categoryBasedFood[index]
                                            //     .product!
                                            //     .modelName
                                            //     .toString(),
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          // '₹$sellingPrice',
                                          'Total Price: ₹$cartTotal'

                                          // '${productsCartMain2[index][1]}'
                                          ,

                                          // categoryBasedFood[index]
                                          //     .product!
                                          //     .price
                                          //     .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            // color: Colors.amber,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        'Price Details',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text('Price :'),
                                      Text('₹${cartTotal}'),

                                      // Text('$quantityOfItems')
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Text('Delivery Fees :'),
                                      Text('₹50/-'),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Order Total :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text('₹${(double.parse(cartTotal) + 50).toStringAsFixed(2)}/-'),
                                    ],
                                  ),

                                  Text('5'),

                                  // myList.where((element) => element is int).fold(0, (sum, element) => sum + element)

                                  const Spacer(),

                                  InkWell(
                                    onTap: () {
                                      // Filter products with quantity greater than 0
                                      var filteredProducts = products
                                          .where((product) =>
                                              product['quantity'] > 0)
                                          .toList();

                                      if (filteredProducts.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                            image:
                                                filteredProducts.map((product) {
                                              return product["product"]
                                                  ['primary_image'];
                                            }).toList(),
                                            singleProduct: products.map((product) {
                                              return product["product"]['selling_price'].toString();
                                            }).toList(),
                                            price: cartTotal,
                                            shopId:
                                                filteredProducts.map((product) {
                                              return product['shop_id'];
                                            }).toString(),
                                            productId:
                                                filteredProducts.map((product) {
                                              return product['product_id'];
                                            }).toList(),
                                            userId: userId,
                                            category:
                                                filteredProducts.map((product) {
                                              return product['category'];
                                            }).toList(),
                                            brandName:
                                                filteredProducts.map((product) {
                                              return product["product"]
                                                  ['brand'];
                                            }).toList(),
                                            totalQuantity:
                                                filteredProducts.map((product) {
                                              return product['quantity'];
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: const Text(
                                        'Proceed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
}

bottomDetailsScreen({
  required BuildContext context,
  required int qtyB,
  required int priceB,
  required int deliveryB,
}) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Details',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price ($qtyB Items)',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Text(' : '),
                    Text(
                      '₹ $priceB',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Fees)',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Text(' : '),
                    Text(
                      '₹ $deliveryB',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order Total',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Text(' : '),
                    Text(
                      '₹ ${priceB + deliveryB}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
