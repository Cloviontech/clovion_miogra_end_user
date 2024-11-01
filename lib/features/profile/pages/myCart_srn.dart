// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:miogra/core/api_services.dart';
// import 'package:miogra/core/colors.dart';
// import 'package:miogra/core/widgets/common_widgets.dart';
// import 'package:miogra/models/cart/cartlist_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // ignore: depend_on_referenced_packages
// import 'package:http/http.dart' as http;

// class MyCart extends StatefulWidget {
//   const MyCart({
//     super.key,
//     this.selectedFoods,
//   });

//   final List? selectedFoods;

//   @override
//   State<MyCart> createState() => _MyCartState();
// }

// class _MyCartState extends State<MyCart> {
//   cartUpdate(
//     String cartId,
//     String quantity,
//   ) async {
//     debugPrint('cartUpdate : $cartUpdate');

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString("api_response").toString();

//     final url = Uri.parse("http://${ApiServices.ipAddress}/cartupdate/$cartId");
//     final request = http.MultipartRequest('POST', url);

//     request.fields['quantity'] = quantity;

//     try {
//       final send = await request.send();
//       final response = await http.Response.fromStream(send);
//       log(response.statusCode.toString());
//       // print(response.body);

//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(
//           msg: "Cart Updated Successfully...!",
//           // backgroundColor: ColorConstant.deepPurpleA200,
//           textColor: Colors.white,
//           toastLength: Toast.LENGTH_SHORT,
//         );
//         fetchcartlist();
//       } else {
//         debugPrint(response.statusCode.toString());
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "$e...!",
//         // backgroundColor: ColorConstant.deepPurpleA200,
//         textColor: Colors.white,
//         toastLength: Toast.LENGTH_SHORT,
//       );
//     }
//   }

//   cartRemoveProduct(
//     String cartId,
//   ) async {
//     debugPrint('cartUpdate : $cartUpdate');

//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     userId = prefs.getString("api_response").toString();

//     final url =
//         Uri.parse("http://${ApiServices.ipAddress}/cartremove/$userId/$cartId");
//     final request = http.MultipartRequest('POST', url);

//     // request.fields['quantity'] = quantity;

//     try {
//       final send = await request.send();
//       final response = await http.Response.fromStream(send);
//       print(response.statusCode);
//       // print(response.body);

//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(
//           msg: "Product Removed From Cart Successfully...!",
//           // backgroundColor: ColorConstant.deepPurpleA200,
//           textColor: Colors.white,
//           toastLength: Toast.LENGTH_SHORT,
//         );
//         fetchcartlist();
//       } else {
//         debugPrint(response.statusCode.toString());
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "$e...!",
//         // backgroundColor: ColorConstant.deepPurpleA200,
//         textColor: Colors.white,
//         toastLength: Toast.LENGTH_SHORT,
//       );
//     }
//   }

//   int deliveryB = 50;
//   int totalPrice = 0;
//   int totalQty = 0;
//   calcTotalPrice() {
//     for (var i = 0; i < cartlist.length; i++) {
//       setState(() {
//         totalPrice = totalPrice +
//             ((int.parse(cartlist[i].quantity)) *
//                 (cartlist[i].foodProduct.product.sellingPrice.toInt()));
//       });
//     }
//   }

//   calcTotalQty() {
//     for (var i = 0; i < cartlist.length; i++) {
//       setState(() {
//         totalQty = totalQty + (int.parse(cartlist[i].quantity));
//       });
//     }
//   }

//   bool loadingRemoveCartProduct = true;
//   static List<Cartlist> cartlist = [];
//   bool loadingFetchcartlist = true;

//   String userId = '';

//   Future<void> fetchcartlist() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     userId = prefs.getString("api_response").toString();

//     final response = await http
//         .get(Uri.parse('http://${ApiServices.ipAddress}/cartlist/$userId'));

//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = json.decode(response.body);

//       setState(() {
//         cartlist = jsonResponse.map((data) => Cartlist.fromJson(data)).toList();
//         loadingFetchcartlist = false;
//       });

//       // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   //  late Future<List<SingleUsersData>> futureSingleUsersdata;
//   // List<User> singleUsersData = [];

//   // late String userId;

//   // fetchsingleUsersData() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();

//   //   userId = prefs.getString("api_response").toString();

//   //   final response = await http.get(
//   //       Uri.parse('http://${ApiServices.ipAddress}/single_users_data/$userId'));

//   //   if (response.statusCode == 200) {
//   //     final jsonResponse = json.decode(response.body);
//   //     // return singleUsersData.map((json1) => SingleUsersData.fromJson(json1)).toList();
//   //     setState(() {
//   //       singleUsersData =
//   //           jsonResponse.map((data) => User.fromJson(data)).toList();

//   //       // _isLoading = false;
//   //     });
//   //   } else {
//   //     throw Exception('Failed to load products');
//   //   }
//   // }

// // static List<SmAllClientsDataModel> _smAllClientsDataModel = [];

// //   // AdProAllUsersDataModel _smAllClientsDataModel = AdProAllUsersDataModel();

// //   Future<void> _fetchSmClientsData() async {
// //     late String ad_pro_user_id;

// //     SharedPreferences preferences = await SharedPreferences.getInstance();
// //     ad_pro_user_id = preferences.getString("uid2").toString();

// //     final response = await http
// //         .get(Uri.parse("http://${ApiService.ipAddress}/all_client_data"));

// //     if (response.statusCode == 200) {
// //       List<dynamic> jsonResponse = jsonDecode(response.body);
// //       setState(() {
// //         _smAllClientsDataModel = jsonResponse
// //             .map((data) => SmAllClientsDataModel.fromJson(data))
// //             .toList();

// //         _isLoading = false;
// //       });

// //       debugPrint(_smAllClientsDataModel[0].email);
// //       debugPrint(_smAllClientsDataModel[0].phoneNumber);
// //       debugPrint(_smAllClientsDataModel[1].clientLocation);
// //       debugPrint(_smAllClientsDataModel[1].googleMap);

// //       debugPrint(response.statusCode.toString());
// //       // debugPrint(response.body);
// //     } else {
// //       throw Exception('Failed to load data');
// //     }
// //   }

//   // List<String> orderedProIds = [];

//   loadDatas() {
//     getUserIdInSharedPreferences();
//     fetchDataFromListJson();
//   }

//   // Future<void> removeFromCartList(String cartId) async {

//   //   try {
//   //     final response = await http.delete(Uri.parse(url));

//   //     if (response.statusCode == 200) {
//   //       log('Item removed from cart successfully');
//   //       // You can potentially update your local cart list here if needed
//   //     } else {
//   //       throw Exception(
//   //           'Failed to remove item from cart (status code: ${response.statusCode})');
//   //     }
//   //   } on Exception catch (e) {
//   //     log('Error removing item from cart: $e');
//   //     rethrow; // Re-throw the exception for generic handling
//   //   }
//   // }
//   Future<void> removeFromCartList(String cartId) async {
//     String url =
//         'http://${ApiServices.ipAddress}/cartremove/D0WMX7J0ZJL/OQUKNS2LVEQ';
//     final headers = {
//       'Authorization': 'Bearer YOUR_TOKEN'
//     }; // Replace with your token

//     try {
//       final response = await http.delete(Uri.parse(url), headers: headers);
//       int statusCode = response.statusCode;

//       if (statusCode == 200) {
//         log('Item removed from cart successfully');
//       } else if (statusCode == 301) {
//         // Handle 301 redirect
//         String? newLocation = response.headers['location'];
//         if (newLocation != null) {
//           final newResponse =
//               await http.delete(Uri.parse(newLocation), headers: headers);
//           statusCode = newResponse.statusCode;
//           String? contentType = newResponse.headers['content-type'];

//           if (statusCode == 200) {
//             log('Item removed from cart successfully (after redirect)');
//           } else if (contentType == 'application/json') {
//             // Attempt to parse JSON response for error message (if applicable)
//             try {
//               final errorData = json.decode(newResponse.body);
//               String? errorMessage = errorData[
//                   'error_message']; // Replace with actual error key if known
//               if (errorMessage != null) {
//                 throw Exception(
//                     'Failed to remove item from cart: $errorMessage');
//               } else {
//                 throw Exception(
//                     'Failed to remove item from cart (status code: $statusCode after following redirect)');
//               }
//             } catch (e) {
//               throw Exception(
//                   'Failed to parse error response (status code: $statusCode after following redirect)');
//             }
//           } else {
//             throw Exception(
//                 'Failed to remove item from cart (status code: $statusCode after following redirect) - Unknown content type');
//           }
//         } else {
//           throw Exception(
//               'Failed to remove item from cart (status code: 301) - No new location in redirect');
//         }
//       } else {
//         throw Exception(
//             'Failed to remove item from cart (status code: $statusCode)'); // Catch other potential errors
//       }
//     } on Exception catch (e) {
//       log('Error removing item from cart: $e');
//       rethrow;
//     }
//   }

//   // Future<void> removeFromCartList(String cartId) async {
//   //   String url =
//   //       'http://${ApiServices.ipAddress}/cartremove/D0WMX7J0ZJL/$cartId';
//   //   try {
//   //     final response = await http.delete(Uri.parse(url));
//   //     int statusCode = response.statusCode;

//   //     if (statusCode == 200) {
//   //       log('Item removed from cart successfully');
//   //     } else if (statusCode == 301) {
//   //       // Handle 301 redirect (assuming the new location is in the response)
//   //       String? newLocation = response.headers['location'];
//   //       if (newLocation != null) {
//   //         final newResponse = await http.delete(Uri.parse(newLocation));
//   //         statusCode = newResponse.statusCode;
//   //         if (statusCode == 200) {
//   //           log('Item removed from cart successfully (after redirect)');
//   //         } else {
//   //           throw Exception(
//   //               'Failed to remove item from cart (status code: $statusCode after following redirect)');
//   //         }
//   //       } else {
//   //         throw Exception(
//   //             'Failed to remove item from cart (status code: 301) - No new location in redirect');
//   //       }
//   //     } else {
//   //       throw Exception(
//   //           'Failed to remove item from cart (status code: $statusCode)');
//   //     }
//   //   } on Exception catch (e) {
//   //     log('Error removing item from cart: $e');
//   //     rethrow; // Re-throw the exception for generic handling
//   //   }
//   // }

//   Future<dynamic> fetchDataFromListJson() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString("api_response").toString();
//     // D0WMX7J0ZJL
//     log(userId);

//     // String url = 'http://${ApiServices.ipAddress}/cartlist/$userID';
//     String url = 'http://${ApiServices.ipAddress}/cartlist/$userId';
//     int retryCount = 0; // Counter for retries
//     const maxRetries = 3; // Maximum number of retries

//     do {
//       try {
//         final response = await http.get(Uri.parse(url));
//         log(response.statusCode.toString());

//         if (response.statusCode == 200) {
//           log('Fetching Data');
//           final data = json.decode(response.body);

//           if (data is List) {
//             final jsonData = data;
//             log('Data fetched successfully');
//             return jsonData;
//           } else {
//             log('Unexpected data structure: ${data.runtimeType}');
//             throw Exception(
//                 'Unexpected data format'); // Specific error for data structure
//           }
//         } else {
//           // Handle errors based on status code
//           if (response.statusCode >= 500 && response.statusCode < 600) {
//             log('Server error (status code: ${response.statusCode})');
//             throw Exception('Internal server error. Please try again later.');
//           } else if (response.statusCode == 429) {
//             log('Too many requests (status code: ${response.statusCode})');
//             throw Exception('Too many requests. Please try again later.');
//           } else {
//             // Handle other errors (e.g., 404 Not Found)
//             throw Exception(
//                 'Failed to load data from URL: $url (Status code: ${response.statusCode})');
//           }
//         }
//       } on SocketException catch (e) {
//         log('Network error: $e');
//         throw Exception(
//             'Network error. Please check your internet connection.');
//       } on Exception catch (e) {
//         log('Error fetching data: $e');
//         rethrow; // Re-throw the original error for generic handling
//       } finally {
//         retryCount++;
//       }

//       await Future.delayed(const Duration(seconds: 2));
//       // } while (retryCount < maxRetries);

//       // throw Exception('Failed to fetch data after $maxRetries retries');
//     } while (retryCount < maxRetries);
//   }

//   // retrieveProductId() async {
//   //   for (var i = 0; i < widget.selectedFoods!.length; i++) {
//   //     orderedProIds.add(widget.selectedFoods![i][1]);
//   //   }
//   // }

//   // final List<String> _selectedItem = [];

//   List<int> qty = [];

//   String userID = '';

//   Future<void> getUserIdInSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString("api_response").toString();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     // fetchDataFromListJson();
//     loadDatas();

//     // fetchcartlist().whenComplete(() {
//     //   calcTotalPrice();
//     //   calcTotalQty();
//     //   _selectedItem = List<String>.generate(cartlist.length, (index) => '1');
//     // });

//     // qty = List<int>.generate(cartlist.length, (index) => 0);
//     // // calcTotalQty();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         // leading: IconButton(
//         //     onPressed: () {},
//         //     icon: const Icon(
//         //       Icons.arrow_back,
//         //       color: Colors.white,
//         //       size: 34,
//         //     )),
//         title: const Text(
//           'My Cart',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<dynamic>(
//         future: fetchDataFromListJson(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(
//               child: Text(
//                 'Something went wrong',
//               ),
//             );
//           } else {
//             final data = snapshot.data;

//             int dataLength = 0;

//             if (data != null) {
//               if (data is List) {
//                 dataLength = data.length;
//               } else {
//                 log('Data is not a list');
//               }
//             } else {
//               log('Data is null');
//             }

//             if (data != null) {
//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 5,
//                   vertical: 5,
//                 ),
//                 itemCount: dataLength,
//                 shrinkWrap: true,
//                 primary: false,
//                 itemBuilder: (context, index) {
//                   final cartId = data[index]['cart_id'];
//                   final category =
//                       data[index]['shop_product']['subcategory'].toString();
//                   final image = data[index]['shop_product']['product']
//                           ['primary_image']
//                       .toString();

//                   final name = data[index]['shop_product']['product']
//                           ['model_name']
//                       .toString();
//                   // final modelName = data[index]['product']['model_name'];
//                   // const cartId = 'Products';

//                   // final imageUrl =
//                   //     data[index]['product']['primary_image']?.toString();
//                   // final productName = data[index]['product']['model_name']
//                   //     .toString()
//                   //     .toUpperCase();
//                   // final sellingPrice = data[index]['product']['selling_price'];
//                   // // final actualprice = data[index]['product']['actual_price'];
//                   // // final rating = data[index]['rating'];

//                   // // final subcategory = data[index]['product']['subcategory'];
//                   // final productid = data[index]['product']['product_id'];
//                   // final shopeid = data[index]['product']['food_id'];

//                   // final category = data[index]['category'];
//                   // final description =
//                   //     data[index]['product']['product_description'];

//                   // log('Selling price is $sellingPrice');

//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: InkWell(
//                       onTap: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => GoToOrder(
//                         //       uId: userId,
//                         //       category: category,
//                         //       link: imageUrl,
//                         //       productId: productid,
//                         //       shopId: shopeid,
//                         //       totalPrice: '₹$sellingPrice'.toString(),
//                         //     ),
//                         //   ),
//                         // );
//                       },
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Color.fromARGB(255, 249, 227, 253),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(20),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   height: 100,
//                                   width: 100,
//                                   color:
//                                       const Color.fromARGB(255, 249, 227, 253),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Image.network(image.toString()),
//                                   ),
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.5,
//                                       child: Text(
//                                         name,
//                                         overflow: TextOverflow.fade,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                     Text(
//                                       category,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: IconButton(
//                                 onPressed: () {
//                                   removeFromCartList(cartId);
//                                 },
//                                 icon: const Icon(
//                                   Icons.info,
//                                   color: primaryColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );

//                   // productBox(
//                   //   imageUrl: imageUrl,
//                   //   pName: productName,
//                   //   oldPrice: actualprice,
//                   //   newPrice: discountPrice,
//                   //   rating: rating,
//                   //   offer: 28,
//                   //   color: Colors.red,
//                   //   onTap: () {
//                   //     Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //         builder: (context) => ProductDetailsPage(
//                   //           productId: productid,
//                   //           shopeid: shopeid,
//                   //           category: category,
//                   //         ),
//                   //       ),
//                   //     );
//                   //   },
//                   // );
//                 },
//               );
//             } else {
//               // Handle the case where data is null
//               return const Scaffold(
//                 body: Center(
//                   child: Text('No data found'),
//                 ),
//               );
//             }
//           }
//         },
//       ),

//       // Text(singleUsersData.toString())
//       //     SingleChildScrollView(
//       //   child: Padding(
//       //     padding: const EdgeInsets.all(10.0),
//       //     child: Column(
//       //       children: [
//       //         const SizedBox(
//       //           height: 20,
//       //         ),

//       //         Text(widget.selectedFoods.toString()),

//       //         // ListView.builder(
//       //         //     shrinkWrap: true,
//       //         //     controller: ScrollController(),
//       //         //     // physics: AlwaysScrollableScrollPhysics(),
//       //         //     itemCount: cartlist.length,

//       //         //     itemBuilder: (context, index) {
//       //         //       return Column(
//       //         //         children: [
//       //         //           // productDetailsBoxSrn(

//       //         //           productBox1(
//       //         //             remove:

//       //         //                 // cartRemoveProduct(cartlist[index].cartId),

//       //         //                 // removeProductFromCart(cartlist[index].user.uid),

//       //         //                 () async {
//       //         //               SharedPreferences prefs =
//       //         //                   await SharedPreferences.getInstance();

//       //         //               userId = prefs.getString("api_response").toString();

//       //         //               final response = await http.post(Uri.parse(
//       //         //                   'http://${ApiServices.ipAddress}/cartremove/$userId/${cartlist[index].cartId}/'));

//       //         //               debugPrint(
//       //         //                   'http://${ApiServices.ipAddress}/cartremove/$userId/${cartlist[index].cartId}/');
//       //         //               debugPrint(response.statusCode.toString());
//       //         //               if (response.statusCode == 200) {
//       //         //                 // List<dynamic> jsonResponse = json.decode(response.body);

//       //         //                 // setState(() {
//       //         //                 //   cartlist = jsonResponse.map((data) => Cartlist.fromJson(data)).toList();
//       //         //                 loadingFetchcartlist = false;

//       //         //                 fetchcartlist().whenComplete(() {
//       //         //                   calcTotalPrice();
//       //         //                   calcTotalQty();
//       //         //                 });
//       //         //                 // });

//       //         //                 // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
//       //         //               } else {
//       //         //                 // throw Exception('Failed to load products');
//       //         //               }
//       //         //             },

//       //         //             context: context,
//       //         //             primaryImage:
//       //         //                 cartlist[index].foodProduct.product.primaryImage,
//       //         //             // name: cartlist[index].foodProduct.product.name[0],
//       //         //             name: cartlist[index].cartId,
//       //         //             actualPrice: cartlist[index]
//       //         //                 .foodProduct
//       //         //                 .product
//       //         //                 .actualPrice[0],
//       //         //             sellingPrice: cartlist[index]
//       //         //                 .foodProduct
//       //         //                 .product
//       //         //                 .sellingPrice
//       //         //                 .toString(),
//       //         //             onTabQty: (p0) {
//       //         //               setState(() {
//       //         //                 qty[index] = int.parse(p0);
//       //         //               });
//       //         //             },
//       //         //             rating: '4.4',
//       //         //             items: const ['1', '2', '3'],
//       //         //             // selectedItem: _selectedItem[index],
//       //         //             selectedItem: cartlist[index].quantity,
//       //         //             onChanged: (value) {
//       //         //               cartUpdate(cartlist[index].cartId, value!);

//       //         //               setState(() {
//       //         //                 totalPrice = 0;
//       //         //                 totalQty = 0;
//       //         //               });

//       //         //               fetchcartlist().whenComplete(() {
//       //         //                 calcTotalPrice();
//       //         //                 calcTotalQty();
//       //         //               });

//       //         //               // setState(() {
//       //         //               //    _selectedItem[index] = value!;
//       //         //               // });
//       //         //             },
//       //         //           ),

//       //         //           Divider(
//       //         //             height: 10,
//       //         //             thickness: 5,
//       //         //             color: Colors.grey.shade100,
//       //         //           ),
//       //         //         ],
//       //         //       );
//       //         //     },
//       //         // ),

//       //         // Expanded(
//       //         //   child: ListView.builder(
//       //         //           itemCount: 4,
//       //         //           itemBuilder: (context, index) {
//       //         //   return  Card(
//       //         //     elevation: 2,
//       //         //     child: ListTile(
//       //         //       leading: Image.asset('assets/images/fashion.jpeg'),
//       //         //       title: Column(
//       //         //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         //         children: [
//       //         //           const Text('Trendy Women Dress'),
//       //         //           const Text('525'),
//       //         //           Row(
//       //         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //         //             children: [
//       //         //               Container(
//       //         //                   decoration: BoxDecoration(
//       //         //                       borderRadius: BorderRadius.circular(10),
//       //         //                       border: Border.all(color: Colors.blue)),
//       //         //                   child: const Padding(
//       //         //                     padding: EdgeInsets.all(4.0),
//       //         //                     child: Text(
//       //         //                       'Order Now',
//       //         //                       style: TextStyle(color: Colors.green),
//       //         //                     ),
//       //         //                   )),
//       //         //               const Row(
//       //         //                 children: [
//       //         //                   Icon(Icons.remove),
//       //         //                   Text('Remove'),
//       //         //                 ],
//       //         //               )
//       //         //             ],
//       //         //           ),
//       //         //         ],
//       //         //       ),
//       //         //       // trailing: Icon(Icons.edit),
//       //         //       tileColor: Colors.white,
//       //         //     ),
//       //         //   );
//       //         //           }),
//       //         // ),

//       //         const SizedBox(
//       //           height: 5,
//       //         ),

//       //         // addressContainer(
//       //         //   context,
//       //         //   cartlist[0].user.fullName,
//       //         //   cartlist[0].user.addressData.doorno,
//       //         //   cartlist[0].user.addressData.area,
//       //         //   cartlist[0].user.addressData.landmark,
//       //         //   cartlist[0].user.addressData.place,
//       //         //   cartlist[0].user.addressData.district,
//       //         //   cartlist[0].user.addressData.state,
//       //         //   cartlist[0].user.addressData.pincode,
//       //         // ),

//       //         const SizedBox(
//       //           height: 20,
//       //         ),
//       //         SizedBox(
//       //           height: 250,
//       //           child: Padding(
//       //             padding: const EdgeInsets.all(30.0),
//       //             child: Column(
//       //               crossAxisAlignment: CrossAxisAlignment.start,
//       //               children: [
//       //                 const Text(
//       //                   'Price Details',
//       //                   style: TextStyle(
//       //                       fontSize: 20,
//       //                       color: Colors.black,
//       //                       fontWeight: FontWeight.bold),
//       //                 ),
//       //                 Row(
//       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //                   children: [
//       //                     Text(
//       //                       'Price ($totalQty Items)',
//       //                       style: const TextStyle(
//       //                         fontSize: 20,
//       //                         color: Colors.black,
//       //                       ),
//       //                     ),
//       //                     const Text(' : '),
//       //                     Text(
//       //                       '₹ $totalPrice',
//       //                       style: const TextStyle(
//       //                         fontSize: 20,
//       //                         color: Colors.black,
//       //                         fontWeight: FontWeight.bold,
//       //                       ),
//       //                     ),
//       //                   ],
//       //                 ),
//       //                 Row(
//       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //                   children: [
//       //                     const Text(
//       //                       'Delivery Fees',
//       //                       style: TextStyle(
//       //                         fontSize: 20,
//       //                         color: Colors.black,
//       //                       ),
//       //                     ),
//       //                     const Text(' : '),
//       //                     Text(
//       //                       '₹ $deliveryB',
//       //                       // '',
//       //                       style: const TextStyle(
//       //                         fontSize: 20,
//       //                         color: Colors.black,
//       //                         fontWeight: FontWeight.bold,
//       //                       ),
//       //                     ),
//       //                   ],
//       //                 ),
//       //                 const Divider(),
//       //                 Row(
//       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //                   children: [
//       //                     const Text(
//       //                       'Order Total',
//       //                       style: TextStyle(
//       //                         fontSize: 20,
//       //                         color: Colors.black,
//       //                       ),
//       //                     ),
//       //                     const Text(' : '),
//       //                     Text(
//       //                       '₹ ${totalPrice + deliveryB}',
//       //                       // totalPrice.toString(),
//       //                       style: const TextStyle(
//       //                         fontSize: 20,
//       //                         color: Colors.black,
//       //                         fontWeight: FontWeight.bold,
//       //                       ),
//       //                     ),
//       //                   ],
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       bottomNavigationBar: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               style: ButtonStyle(
//                 minimumSize: WidgetStateProperty.all(const Size(250, 50)),
//                 shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(0.0),
//                 )),
//                 backgroundColor: WidgetStateProperty.all(Colors.white),
//               ),
//               onPressed: () {
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (context) => const OrderSuccess()));

//                 // bottomDetailsScreen(
//                 //     context: context,
//                 //     qtyB: totalqty1,
//                 //     priceB: totalQtyBasedPrice1,
//                 //     deliveryB: 50);
//               },
//               child:
//                   // Text(
//                   //   '$totalqty1 Items | ₹ ${totalQtyBasedPrice1}',
//                   //   style: TextStyle(color: Colors.purple, fontSize: 18),
//                   // ),

//                   AutoSizeText(
//                 // '$totalQty Items | ₹ ${totalPrice + (totalPrice == 0 ? 0 : 50)}',
//                 '₹ ${totalPrice + deliveryB}',
//                 minFontSize: 18,
//                 maxFontSize: 24,
//                 maxLines: 1, // Adjust this value as needed
//                 overflow: TextOverflow.ellipsis, // Handle overflow text
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ElevatedButton(
//               style: ButtonStyle(
//                 minimumSize: WidgetStateProperty.all(const Size(250, 50)),
//                 shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(0.0),
//                 )),
//                 backgroundColor: WidgetStateProperty.all(Colors.purple),
//               ),
//               onPressed: () {
//                 // print('orderedFoods : $orderedFoods');

//                 // addToCartAllSelectedProductsLoop();
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (context) => OrderingFor(
//                 //               totalPrice: totalQtyBasedPrice1,
//                 //               totalQty: totalqty1,
//                 //               selectedFoods: orderedFoods,
//                 //               qty: qty, productCategory: 'food',
//                 //             )));

//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>

//                             // MyHomePage()

//                             SelectPaymentMethod(
//                               addressIndex: 1, selectedFoods: const [],
//                               totalAmount: totalPrice, cartlist: cartlist,
//                               // selectedFoods: orderedFoods,
//                             )));
//               },
//               child: const Text(
//                 'Continue',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
