// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:miogra/features/auth/presentation/pages/signin.dart';
import 'package:miogra/features/profile/pages/address.dart';
import 'package:miogra/features/profile/pages/qty.dart';
import 'package:miogra/features/shopping/presentation/pages/paymentScreen.dart';
import 'package:miogra/models/profile/single_users_data1.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

import '../../../profile/widgets/your_order_widgets.dart';

const List list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

class YourOrderPage extends StatefulWidget {
  final String? productId;
  final String? shopId;
  final String? link;
  final String? totalPrice;

  const YourOrderPage(
      {super.key, this.productId, this.shopId, this.link, this.totalPrice});

  @override
  State<YourOrderPage> createState() => _YourOrderPageState();
}

class _YourOrderPageState extends State<YourOrderPage> {
  String userId = 'a';

  // Future<void> getUserIdInSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userId = prefs.getString("api_response").toString();
  //   });
  // }

  int dropdownValue = 1;

  int totalPrice = 0;

  int deliveryFees = 0;
  int discount = 0;

  List<SingleUsersData> singleUsersData = [];

// String userId = '';

  bool loadingFetchsingleUsersData = true;

  // Future<void> fetchsingleUsersData() async {
  //   print('fetchsingleUsersData method start');

  //   late String userId;

  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   userId = prefs.getString("api_response").toString();

  //   final response = await http.get(
  //       Uri.parse('http://${ApiServices.ipAddress}/single_users_data/$userId'));

  //   if (response.statusCode == 200) {
  //     // final jsonResponse = json.decode(response.body);
  //     // return singleUsersData.map((json1) => SingleUsersData.fromJson(json1)).toList();
  //     //  setState(() {
  //     // singleUsersData = jsonResponse
  //     //     .map((data) => User.fromJson(data))
  //     //     .toList();

  //     // // _isLoading = false;

  //     final List<dynamic> responseData = json.decode(response.body);
  //     // setState(() {
  //     singleUsersData =
  //         responseData.map((json) => SingleUsersData.fromJson(json)).toList();

  //     // loadingFetchsingleUsersData = false;

  //     // });
  //     // });

  //     // print(userId);
  //     // print(response.statusCode);
  //   } else {
  //     throw Exception('Failed to load products');
  //   }

  //   //  print('fetchsingleUsersData method end');
  // }

  // Future<List<GetSingleShopproduct>> fetchGetSingleShopproduct() async {
  //   final response = await http.get(Uri.parse(
  //       // 'http://${ApiServices.ipAddress}/get_single_shopproduct/$shopId/$productId'));
  //       'http://${ApiServices.ipAddress}/get_single_shopproduct/${widget.shopId}/${widget.productId}'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonResponse = json.decode(response.body);

  //     return jsonResponse
  //         .map((json) => GetSingleShopproduct.fromJson(json))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  // late Future<List<GetSingleShopproduct>> futureGetSingleShopproduct;

  @override
  void initState() {
    super.initState();
    // futureGetSingleShopproduct = fetchGetSingleShopproduct();

    // getUserIdInSharedPreferences();

    // fetchsingleUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const QtyPage()));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              )),
          title: const Text(
            'Your Order',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: ElevatedButton(
          style: ButtonStyle(
            // minimumSize: MaterialStateProperty.all(const Size(250, 50)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            )),
            backgroundColor: MaterialStateProperty.all(Colors.purple),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('totalPrice', totalPrice.toString());

            userId == null.toString()
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInPage(
                        shopId: widget.shopId,
                      ),
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            // SelectPaymentMethod( cartlist: [], addressIndex: 0, selectedFoods: [],),
                            PaymentScreen(
                              category: '',
                              userId: '',
                              address: '',
                              pinCode: '',
                              shopId: widget.shopId.toString(),
                              productId: widget.productId.toString(),
                              totalPrice: widget.totalPrice.toString(),
                            )));
          },
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Text(widget.totalPrice.toString()),

                  // Text(widget.shopId.toString()),
                  // Text(widget.productId.toString()),

                  // Text(futureSingleProducts),
                  orderSummery(context),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        // width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 0.2,
                              )
                            ]),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Expanded(
                                //   flex: 2,
                                //   child: Container(
                                //     height: 130,
                                //     decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //         image:
                                //             // AssetImage(
                                //             //     'assets/woman-5828786_1280.jpg'),

                                //             NetworkImage(snapshot
                                //                 .data![0].product!.primaryImage
                                //                 .toString()),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.18,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   // 'Trendy Women\'s Jacket',
                                          //   snapshot.data![0].product!
                                          //       .name![0],
                                          //   style: const TextStyle(
                                          //       fontSize: 14),
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text(
                                              //   // '767',
                                              //   snapshot
                                              //       .data![0]
                                              //       .product!
                                              //       .actualPrice
                                              //       .toString(),
                                              //   style: TextStyle(
                                              //       decoration:
                                              //           TextDecoration
                                              //               .lineThrough,
                                              //       color: Colors.grey,
                                              //       decorationColor:
                                              //           Colors.grey
                                              //               .shade700,
                                              //       fontSize: 14,
                                              //       fontWeight:
                                              //           FontWeight
                                              //               .w300),
                                              // ),
                                              // Text(
                                              //   // '676',
                                              //   snapshot
                                              //       .data![0]
                                              //       .product!
                                              //       .sellingPrice
                                              //       .toString(),
                                              //   style: const TextStyle(
                                              //       fontSize: 14,
                                              //       fontWeight:
                                              //           FontWeight
                                              //               .w500),
                                              // ),
                                              Container(
                                                color: Colors.greenAccent,
                                                // height: MediaQuery.of(context)
                                                //         .size
                                                //         .height *
                                                //     0.03,
                                                // width: MediaQuery.of(context)
                                                //         .size
                                                //         .width *
                                                //     0.15,
                                                child: const Center(
                                                    child: Text(
                                                  '30% Off',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                              )
                                            ],
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Size  :  S ,',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                'Color  : Blue',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 7),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.055,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: DropdownButton<int>(
                                                  value: 1,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  underline: Container(
                                                    height: 0,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      dropdownValue = value!;
                                                    });
                                                  },
                                                  items: list.map<
                                                      DropdownMenuItem<
                                                          int>>((value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value,
                                                      child: Text(
                                                          'Qty ${dropdownValue.toString()}'),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child:
                                      // SizedBox(
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.19,
                                      // child:
                                      // Column(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.start,
                                      //   children: [
                                      Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      // margin: const EdgeInsets.only(
                                      //     top: 10),
                                      // height: MediaQuery.of(context)
                                      //         .size
                                      //         .height *
                                      //     0.05,
                                      // width: MediaQuery.of(context)
                                      //         .size
                                      //         .width *
                                      //     0.17,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.purple),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            '4.3',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     IconButton(
                                  //         onPressed: () {},
                                  //         icon: const Icon(
                                  //           Icons.delete,
                                  //           color: Colors.grey,
                                  //         )),
                                  //     const Text(
                                  //       'Remove',
                                  //       style: TextStyle(
                                  //           color: Colors.grey),
                                  //     ),
                                  //   ],
                                  // )
                                  //   ],
                                  // ),
                                  //   ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.delivery_dining,
                                  color: Colors.green,
                                  size: 34,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Delivery Within 2 Days',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // address(context),

                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.greenAccent,
                                  )),
                              const Text(
                                'Delivery Address',
                                style: TextStyle(),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddressPage(
                                                  amountToBePaid: '',
                                                  userId: '',
                                                  cartlist: const [],
                                                  shopId: widget.shopId,
                                                  productId: widget.productId,
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      // minimumSize:  Size(120, 40),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  child: const Text('Change',
                                      style: TextStyle(color: Colors.black)))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              // '1st  Floor, Sridattatrayaswamy Temp Complex, Gandhi Nagar , Bangalore , Karnataka ,  560009.',
                              singleUsersData[0].addressData.toString(),

                              style: const TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // priceContainer(
                      //   context: context,
                      //   sellingPrice: snapshot
                      //       .data![0].product!.sellingPrice!
                      //       .toDouble(),
                      //   qty: dropdownValue,
                      //   deliveryPrice: 50,
                      //   discount: 33,
                      // ),
                    ],
                  ),
                  // FutureBuilder<List<GetSingleShopproduct>>(
                  //   future: futureGetSingleShopproduct,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(child: Text('Error: ${snapshot.error}'));
                  //     } else {
                  //       // setState(() {
                  //       totalPrice =
                  //           snapshot.data![0].product!.sellingPrice!.toInt() +
                  //               deliveryFees +
                  //               discount;
                  //       // });

                  //       return Text('No text');
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
