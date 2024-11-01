import 'dart:convert';
import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/widgets.dart';
// import 'package:miogra/controllers/profile/fetch_single_users_data.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';

// import 'package:miogra/core/data.dart';
// import 'package:miogra/features/profile/widgets/account_widgets.dart';
import 'package:miogra/models/profile/single_users_data.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Wishlist1 extends StatefulWidget {
  const Wishlist1({super.key});

  @override
  State<Wishlist1> createState() => _Wishlist1State();
}

class _Wishlist1State extends State<Wishlist1> {
  List<String> title = [
    'Trendy Women Dress',
    'Legal and Policies',
    'About Us',
    'Logout'
  ];

  //  late Future<List<SingleUsersData>> futureSingleUsersdata;
  List<User> singleUsersData = [];

  late String userId;

  // fetchsingleUsersData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   userId = prefs.getString("api_response").toString();

  //   final response = await http.get(
  //       Uri.parse('http://${ApiServices.ipAddress}/single_users_data/$userId'));

  //   if (response.statusCode == 200) {
  //     // final jsonResponse = json.decode(response.body);
  //     // return singleUsersData.map((json1) => SingleUsersData.fromJson(json1)).toList();
  //     log(response.statusCode.toString());
  //     log('this is status code');
  //     log(userId);
  //     setState(() {
  //       // singleUsersData =
  //       //     jsonResponse.map((data) => User.fromJson(data)).toList();

  //       // _isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  // fetchWishListData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getString("api_response").toString();

  //   final response = await http
  //       .get(Uri.parse('http://${ApiServices.ipAddress}/all_wishlist/$userId'));

  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     // return singleUsersData.map((json1) => SingleUsersData.fromJson(json1)).toList();
  //     log(response.statusCode.toString());
  //     log('this is status code');
  //     log(userId);
  //     setState(() {});
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  Future<dynamic> fetchWishListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response").toString();
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );

    String url = 'https://${ApiServices.ipAddress}/all_wishlist/$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      // CircularProgressIndicator();

      // log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log(url.toString());
        // log('Featching Data');
        final data = json.decode(response.body);

        // Navigator.of(context).pop();

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

// static List<SmAllClientsDataModel> _smAllClientsDataModel = [];

//   // AdProAllUsersDataModel _smAllClientsDataModel = AdProAllUsersDataModel();

//   Future<void> _fetchSmClientsData() async {
//     late String ad_pro_user_id;

//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     ad_pro_user_id = preferences.getString("uid2").toString();

//     final response = await http
//         .get(Uri.parse("http://${ApiService.ipAddress}/all_client_data"));

//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = jsonDecode(response.body);
//       setState(() {
//         _smAllClientsDataModel = jsonResponse
//             .map((data) => SmAllClientsDataModel.fromJson(data))
//             .toList();

//         _isLoading = false;
//       });

//       debugPrint(_smAllClientsDataModel[0].email);
//       debugPrint(_smAllClientsDataModel[0].phoneNumber);
//       debugPrint(_smAllClientsDataModel[1].clientLocation);
//       debugPrint(_smAllClientsDataModel[1].googleMap);

//       debugPrint(response.statusCode.toString());
//       // debugPrint(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

  @override
  void initState() {
    super.initState();
    // singleUsersData = fetchsingleUsersData();
    // fetchsingleUsersData();
    fetchWishListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(10),
        //         bottomRight: Radius.circular(10))),

        backgroundColor: primaryColor,
        foregroundColor: Colors.white,

        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<dynamic>(
        future: fetchWishListData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
              ),
            );
          } else {
            final data = snapshot.data;
            int dataLength = 0;
            List<String> productNames = [];
            List<String> images = [];
            List<String> expectedDates = [];

            List<String> statusOfOrder = [];
            List<String> productsIds = [];
            List<dynamic> priceOfProducts = [];
            List<String> categoriesList = [];

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
                  String? productId;

                  // Check shop product first
                  if (dataMap.containsKey("shop_product")) {
                    name = dataMap["shop_product"]?["product"]?["model_name"];
                    productId = dataMap["shop_product"]?["product_id"];
                    image =
                        dataMap["shop_product"]?["product"]?["primary_image"];
                    price =
                        dataMap["shop_product"]?["product"]?['selling_price'];
                    category = dataMap["shop_product"]?["category"];

                    expDate = dataMap?["expected_deliverydate"];

                    status = dataMap?["status"];
                  }

                  if (name == null && dataMap.containsKey("food_product")) {
                    name = dataMap["food_product"]?["product"]?["model_name"];
                    productId = dataMap["food_product"]?["product_id"];
                    image =
                        dataMap["food_product"]?["product"]?["primary_image"];
                    price =
                        dataMap["food_product"]?["product"]?['selling_price'];
                    category = dataMap["shop_product"]?["category"];
                    expDate = dataMap?["expected_deliverydate"];

                    status = dataMap?["status"];
                  }

                  if (name == null && dataMap.containsKey("jewel_product")) {
                    name = dataMap["jewel_product"]?["product"]?["model_name"];

                    productId = dataMap["jewel_product"]?["product_id"];
                    image =
                        dataMap["jewel_product"]?["product"]?["primary_image"];
                    category = dataMap["shop_product"]?["category"];
                    price =
                        dataMap["jewel_product"]?["product"]?['selling_price'];
                    expDate = dataMap?["expected_deliverydate"];

                    status = dataMap?["status"];
                  }

                  if (name == null && dataMap.containsKey("dmio_product")) {
                    name = dataMap["dmio_product"]?["product"]?["model_name"];
                    productId = dataMap["dmio_product"]?["product_id"];
                    image =
                        dataMap["dmio_product"]?["product"]?["primary_image"];
                    category = dataMap["shop_product"]?["category"];
                    price =
                        dataMap["dmio_product"]?["product"]?['selling_price'];
                    expDate = dataMap?["expected_deliverydate"];

                    status = dataMap?["status"];
                  }

                  if (name == null && dataMap.containsKey("pharmacy_product")) {
                    name =
                        dataMap["pharmacy_product"]?["product"]?["model_name"];
                    productId = dataMap["pharmacy_product"]?["product_id"];
                    image = dataMap["pharmacy_product"]?["product"]
                        ?["primary_image"];
                    category = dataMap["shop_product"]?["category"];
                    price = dataMap["pharmacy_product"]?["product"]
                        ?['selling_price'];
                    expDate = dataMap?["expected_deliverydate"];

                    status = dataMap?["status"];
                  }

                  if (name == null &&
                      dataMap.containsKey("d_original_product")) {
                    name = dataMap["d_original_product"]?["product"]
                        ?["model_name"];
                    productId = dataMap["d_original_product"]?["product_id"];
                    image = dataMap["d_original_product"]?["product"]
                        ?["primary_image"];
                    category = dataMap["shop_product"]?["category"];

                    price = dataMap["d_original_product"]?["product"]
                        ?['selling_price'];
                    expDate = dataMap?["expected_deliverydate"];
                    status = dataMap?["status"];
                  }

                  if (name == null && dataMap.containsKey("freshcut_product")) {
                    name =
                        dataMap["freshcut_product"]?["product"]?["model_name"];
                    productId = dataMap["freshcut_product"]?["product_id"];
                    image = dataMap["freshcut_product"]?["product"]
                        ?["primary_image"];
                    category = dataMap["shop_product"]?["category"];
                    price = dataMap["freshcut_product"]?["product"]
                        ?['selling_price'];
                    expDate = dataMap?["expected_deliverydate"];
                    status = dataMap?["status"];
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

                  if (productId != null) {
                    productsIds.add(productId);
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
                itemCount: dataLength,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: SizedBox(
                        width: 80,
                        height: 100,
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productNames[index]),
                          const SizedBox(height: 5),
                          Text('₹${priceOfProducts[index]}/-'),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                /*
                          async {
                                  await PersistentShoppingCart().addToCart(
                                    PersistentShoppingCartItem(
                                      productId: productsIds[index],
                                      productName: productNames[index],
                                      productDescription: '',
                                      unitPrice: priceOfProducts[index],
                                      productThumbnail: images[index],
                                      quantity: 1,
                                    ),
                                  );
                                  addToCart(productsIds[index],
                                      categoriesList[index]);
                                  removeFromWishList(productsIds[index]);
                                  setState(() {});
                           */
                                onTap: () {
                                  addToCart(productsIds[index],
                                      categoriesList[index]);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 28,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    // vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 0, 143, 124)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 143, 124),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  removeFromWishList(productsIds[index]);
                                  removed();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.grey[700],
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      // trailing: Icon(Icons.edit),
                      tileColor: Colors.white,
                    ),
                  );
                },
              );
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
    );
  }

  addToCart(productId, category) async {
    String url =
        'https://${ApiServices.ipAddress}/cart_product/$userId/$productId/$category/';

    // log(widget.userId);
    log(productId);
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
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Item added to cart'),
      ),
    );
  }

  void removed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Item removed from wish list'),
      ),
    );
  }

  removeFromWishList(productId) async {
    String url =
        'https://${ApiServices.ipAddress}/remove_wish/$userId/$productId/';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['quantity'] = '1';

      var response = await request.send();

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

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
