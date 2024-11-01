import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/profile/pages/order_track.dart';
import 'package:miogra/models/profile/single_users_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../shopping/presentation/widgets/ratings.dart';

class DeleveredProductList extends StatefulWidget {
  const DeleveredProductList({super.key});

  @override
  State<DeleveredProductList> createState() => _DeleveredProductListState();
}

class _DeleveredProductListState extends State<DeleveredProductList> {
  Future<dynamic> fetchDataFromListJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response").toString();
    log(userId);
    // log(userId);
    String url = 'https://${ApiServices.ipAddress}/enduser_order_list/$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      // log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log(url.toString());
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
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  List<String> title = [
    'Trendy Women Dress',
    'Legal and Policies',
    'About Us',
    'Logout'
  ];

  //  late Future<List<SingleUsersData>> futureSingleUsersdata;
  List<User> singleUsersData = [];

  // late String userId;

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

    fetchDataFromListJson();
    getUserIdInSharedPreferences();
  }

  final TextEditingController _comment = TextEditingController();
  final TextEditingController _rating = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        // leading: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //       size: 34,
        //     )),
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
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
            // List<Map<String,dynamic>>=newData;

            List<String> productNames = [];
            List<String> images = [];
            List<String> expectedDates = [];
            List<String> deleveryType = [];
            List<String> statusOfOrder = [];
            List<String> productsIds = [];
            List<double> ratingsOfProduct = [];
            List<String> orderIds = [];
            List<dynamic> prices = [];

            if (data != null) {
              if (data is List) {
                for (var dataMap in data) {
                  String? name;
                  String? image;
                  String? expDate;
                  String? delTyp;
                  String? status;
                  String? rating;
                  String? productId;
                  String? orderId;
                  dynamic price;
                  // Check shop product first
                  if (dataMap.containsKey("shop_product")) {
                    name = dataMap["shop_product"]?["product"]?["model_name"];
                    productId = dataMap["shop_product"]?["product_id"];
                    image =
                        dataMap["shop_product"]?["product"]?["primary_image"];
                    price =
                        dataMap["shop_product"]?["product"]?["selling_price"];

                    rating = dataMap["shop_product"]?["rating"];

                    expDate = dataMap?["expected_deliverydate"];
                    delTyp = dataMap?["delivery_type"];
                    status = dataMap?["status"];
                    orderId = dataMap?["order_id"];
                  }

                  if (name == null && dataMap.containsKey("food_product")) {
                    name = dataMap["food_product"]?["product"]?["model_name"];
                    productId = dataMap["food_product"]?["product_id"];
                    price =
                        dataMap["food_product"]?["product"]?["selling_price"];
                    image =
                        dataMap["food_product"]?["product"]?["primary_image"];
                    rating = dataMap["food_product"]?["rating"];
                    expDate = dataMap?["expected_deliverydate"];
                    delTyp = dataMap?["delivery_type"];
                    status = dataMap?["status"];
                    orderId = dataMap?["order_id"];
                  }

                  if (name == null && dataMap.containsKey("jewel_product")) {
                    name = dataMap["jewel_product"]?["product"]?["model_name"];
                    price =
                        dataMap["jewel_product"]?["product"]?["selling_price"];

                    productId = dataMap["jewel_product"]?["product_id"];
                    image =
                        dataMap["jewel_product"]?["product"]?["primary_image"];
                    rating = dataMap["jewel_product"]?["rating"];
                    expDate = dataMap?["expected_deliverydate"];
                    delTyp = dataMap?["delivery_type"];
                    status = dataMap?["status"];
                    orderId = dataMap?["order_id"];
                  }

                  if (name == null && dataMap.containsKey("dmio_product")) {
                    name = dataMap["dmio_product"]?["product"]?["model_name"];
                    price =
                        dataMap["dmio_product"]?["product"]?["selling_price"];
                    productId = dataMap["dmio_product"]?["product_id"];
                    image =
                        dataMap["dmio_product"]?["product"]?["primary_image"];
                    rating = dataMap["dmio_product"]?["rating"];
                    expDate = dataMap?["expected_deliverydate"];
                    delTyp = dataMap?["delivery_type"];
                    status = dataMap?["status"];
                    orderId = dataMap?["order_id"];
                  }

                  if (name == null && dataMap.containsKey("pharmacy_product")) {
                    name =
                        dataMap["pharmacy_product"]?["product"]?["model_name"];
                    price = dataMap["pharmacy_product"]?["product"]
                        ?["selling_price"];
                    productId = dataMap["pharmacy_product"]?["product_id"];
                    image = dataMap["pharmacy_product"]?["product"]
                        ?["primary_image"];
                    rating = dataMap["pharmacy_product"]?["rating"];
                    expDate = dataMap?["expected_deliverydate"];
                    delTyp = dataMap?["delivery_type"];
                    status = dataMap?["status"];
                    orderId = dataMap?["order_id"];
                  }

                  if (name == null &&
                      dataMap.containsKey("d_original_product")) {
                    name = dataMap["d_original_product"]?["product"]
                        ?["model_name"];

                    price = dataMap["d_original_product"]?["product"]
                        ?["selling_price"];
                    productId = dataMap["d_original_product"]?["product_id"];
                    image = dataMap["d_original_product"]?["product"]
                        ?["primary_image"];

                    rating = dataMap["d_original_product"]?["rating"];
                    expDate = dataMap?["expected_deliverydate"];
                    delTyp = dataMap?["delivery_type"];
                    status = dataMap?["status"];
                    orderId = dataMap?["order_id"];
                  }

                  if (name == null && dataMap.containsKey("freshcut_product")) {
                    name =
                        dataMap["freshcut_product"]?["product"]?["model_name"];

                    price = dataMap["freshcut_product"]?["product"]
                        ?["selling_price"];
                    productId = dataMap["freshcut_product"]?["product_id"];
                    image = dataMap["freshcut_product"]?["product"]
                        ?["primary_image"];
                    rating = dataMap["freshcut_product"]?["rating"];
                    expDate = dataMap?["expected_deliverydate"];
                    delTyp = dataMap?["delivery_type"];
                    status = dataMap?["status"];
                    orderId = dataMap?["order_id"];
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
                  if (delTyp != null) {
                    deleveryType.add(delTyp);
                  }
                  if (status != null) {
                    statusOfOrder.add(status);
                  }
                  if (orderId != null) {
                    orderIds.add(orderId);
                  }

                  if (productId != null) {
                    productsIds.add(productId);
                  }
                  if (price != null) {
                    prices.add(price);
                  }
                  if (rating != null) {
                    double number = double.parse(rating);
                    ratingsOfProduct.add(number);
                  }
                  log('Order Ids are');

                  log(orderId.toString());
                }
              } else {
                log('Data is not a list');
              }
            } else {
              log('Data is null');
            }

            // log('data loading...');
            // log('Data Loading Successfully...');
            // int dataLength = 0;

            if (data != null) {
              if (data is List) {
                // dataLength = data.length;
                // log(dataLength.toString());
              } else {
                log('Data is not a list');
              }
            } else {
              log('Data is null');
            }

            if (data != null) {
              return ListView.separated(
                separatorBuilder: (context, index) => Container(
                  height: 3,
                  color: Colors.grey[300],
                ),
                itemCount: productNames.length ,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        // color: Color.fromARGB(255, 243, 228, 246),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.network(images[index]),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productNames[index].toString()),
                                Text(
                                  '${deleveryType[index]} Delevery',
                                  style: const TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  'Delevery Expected by ${expectedDates[index]}'
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     log(ratingsOfProduct.toString());
                                //   },
                                //   child: const Text('Check Ratings...'),
                                // ),
                                // Text(
                                //   statusOfOrder[index].toString(),
                                //   style: const TextStyle(
                                //     color: primaryColor,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 25,
                                  // width: ,
                                  child: starRating(0.0),
                                ),

                                TextButton(
                                  // onPressed: showBottomSheet(context)(){},
                                  onPressed: () {
                                    // Scaffoldmessange
                                    log('Products Id are ${productsIds[index]}');

                                    showMyModalBottomSheet(
                                      context,
                                      productsIds[index],
                                    );
                                  },
                                  child: const Text(
                                    'Post your review',
                                    style: TextStyle(
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderTrackPage(
                                      image: images[index],
                                      orderId: orderIds[index],
                                      productName: productNames[index],
                                      productId: productsIds[index],
                                      price: prices[index],

                                      userId: userId,
                                     
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );

                  // return null;
                },
              );
            } else {
              // Handle the case where data is null
              return const Scaffold(
                body: Center(
                  child: Text('No data found'),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void showMyModalBottomSheet(BuildContext context, productId) {
    showModalBottomSheet<void>(
      // enableDrag: true,

      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sent your review',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _comment,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Type here',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: primaryColor,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  double myDoubleValue = rating;
                  _rating.text = myDoubleValue.toString();

                  // print(rating);
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    // side: MaterialStatePropertyAll(BorderSide(width: 2)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
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
                    sendPostRequestreview(context, productId);
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void sendPostRequestreview(context, productId) async {
    String url =
        'https://${ApiServices.ipAddress}/create_reviews_for_delivered_products/$userId/$productId/';

    log('productId..............$productId');
    log('userId..............$userId');
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

      request.fields['comment'] = _comment.text;
      request.fields['rating'] = _rating.text;

      var response = await request.send();

      if (response.statusCode == 201) {
        log('Address add successfully ');
        log(response.statusCode.toString());

        String responseBody = await response.stream.bytesToString();
        responseBody = responseBody.trim().replaceAll('"', '');

        Navigator.pop(context);
        Navigator.pop(context);

        log(_rating.text.toString());

        log('Data Sent successfully');

        // Navigator.pop(context);

        showSuccessrMsg();
      } else {
        Navigator.pop(context);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Please fill both field'),
          ),
        );

        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  showErrorMsg() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(10),
        // width: 300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.red,
        content: Center(
          child: Text('Please Enter All Feilds'),
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  showSuccessrMsg() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(10),
        // width: 300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.yellow,
        content: Center(
          child: Text(
            'Thanks for share your reviews',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }
}
