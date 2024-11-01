import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/widgets/common_widgets.dart';
import 'package:miogra/features/auth/presentation/pages/signin.dart';
import 'package:miogra/features/dOriginal/presentation/pages/d_original_check_out.dart';
import 'package:miogra/features/profile/pages/address.dart';
import 'package:http/http.dart' as http;
import 'package:miogra/models/freshcuts/all_freshcutproducts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderingFor extends StatefulWidget {
  const OrderingFor({
    super.key,
    required this.totalPrice,
    required this.totalQty,
    required this.selectedFoods,
    required this.qty,
    required this.productCategory,
    this.noOfProd,
    this.fromWhichPage,
  });

  final int totalPrice;
  final int totalQty;
  final List selectedFoods;
  final String productCategory;

  final List<int> qty;

  final String? noOfProd;
  final String? fromWhichPage;

  @override
  State<OrderingFor> createState() => _OrderingForState();
}

class _OrderingForState extends State<OrderingFor> {
  String userId = 'a';

  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });
  }

  static List<AllFreshcutproducts> single_foodproduct = [];

  static List<List<AllFreshcutproducts>> selected_single_foodproducts_list = [];

  Future<void> fetchsingle_foodproduct(String foodId, String productId) async {
    final response = widget.productCategory == 'food'
        ? await http.get(Uri.parse(
            'https://${ApiServices.ipAddress}/single_foodproduct/$foodId/$productId'))
        : widget.productCategory == 'freshCuts'
            ? await http.get(Uri.parse(
                'https://${ApiServices.ipAddress}/single_freshproduct/$foodId/$productId'))
            : await http.get(Uri.parse(
                'https://${ApiServices.ipAddress}/single_jewelproduct/$foodId/$productId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        single_foodproduct = jsonResponse
            .map((data) => AllFreshcutproducts.fromJson(data))
            .toList();

        selected_single_foodproducts_list.add(single_foodproduct);

        debugPrint(
            'selected_single_foodproducts_list : $selected_single_foodproducts_list');
      });

      debugPrint(single_foodproduct.toString());

      // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  retrieveSelectedProducts() {
    for (var i = 0; i < widget.selectedFoods.length; i++) {
      fetchsingle_foodproduct(
          widget.selectedFoods[i][0], widget.selectedFoods[i][1]);
    }
  }

  Future<void> putProductDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    await prefs.setString('finalPrice', widget.totalPrice.toString());
    await prefs.setString('qty', widget.totalQty.toString());
    // await prefs.setString('address', widget. .toString());

    // print('response $response');
  }

  int selectWhomFor = 1;
  // bool foodForMe = true;
  // bool foodForOthers = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected_single_foodproducts_list = [];

    retrieveSelectedProducts();

    getUserIdInSharedPreferences();
    putProductDataToSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.grey.shade200,

      // Color(0xfffff8fe,

      // ),
      // appBar: AppBar(
      // backgroundColor: Colors.purple,
      // backgroundColor: const Color(0xff870081),

      // leading: IconButton(
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => const QtyPage()));
      //     },
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //       size: 30,
      //     )),
      //     title: Text('Test'),
      // ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),

                    Text(widget.selectedFoods.toString()),

                    Text(selected_single_foodproducts_list.toString()),

                    // Text(selected_single_foodproducts_list[0][0].product.name[0]),
                    // Text(selected_single_foodproducts_list[1][0].product.name[0]),
                    // Text(single_foodproduct[0].product.name[0]),

                    // Text(widget.qty.toString()),

                    // Text(widget.selectedFoods.toString()),
                    Center(
                        child: Text(
                      'Ordering For',
                      style: themeData.textTheme.titleLarge,
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: 1,
                            groupValue: selectWhomFor,
                            onChanged: (value) {
                              setState(() {
                                selectWhomFor = value!;
                              });
                            },
                            title: const Text(
                              'MySelf',
                            ),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: 2,
                            groupValue: selectWhomFor,
                            onChanged: (value) {
                              setState(() {
                                selectWhomFor = value!;
                              });
                            },
                            title: const Text(
                              'Somebody Else',
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Text(foodForWhom.toString()),
                  ],
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              deliveryAddress(),

              ListView.builder(
                  itemCount: selected_single_foodproducts_list.length,
                  shrinkWrap: true,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const Divider(),
                        orderedFoods(
                          context,
                          selected_single_foodproducts_list[index][0]
                              .product
                              .name![0],
                          int.parse(selected_single_foodproducts_list[index][0]
                              .product
                              .actualPrice[0]),
                          selected_single_foodproducts_list[index][0]
                              .product
                              .sellingPrice
                              .toInt(),
                          selected_single_foodproducts_list[index][0]
                              .product
                              .subcategory[0],
                          selected_single_foodproducts_list[index][0]
                              .product
                              .primaryImage,
                        ),

                        // selected_single_foodproducts_list.length > 1 ?
                        const Divider()

                        // : SizedBox()
                      ],
                    );
                  }),

              //  orderedFoods(),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.white,
                // height: 250,
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
                            'Price (${widget.qty.reduce((value, element) => value + element)} Items)',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const Text(' : '),
                          Text(
                            '₹ ${widget.totalPrice}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Fees',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          Text(' : '),
                          Text(
                            '₹ ${50} ',
                            style: TextStyle(
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
                            '₹  ${widget.totalPrice + 50}',
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
              )
            ],
          ),
        ),
      ),

      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const OrderSuccess()));
              },
              child:
                  // Text(
                  //   '$totalqty1 Items | ₹ ${totalQtyBasedPrice1}',
                  //   style: TextStyle(color: Colors.purple, fontSize: 18),
                  // ),

                  AutoSizeText(
                '${widget.qty.reduce((value, element) => value + element)} Items  | ₹ ${widget.totalPrice + 50} ',
                minFontSize: 18,
                maxFontSize: 24,
                maxLines: 1, // Adjust this value as needed
                overflow: TextOverflow.ellipsis, // Handle overflow text
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
                minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: WidgetStateProperty.all(Colors.purple),
              ),
              onPressed: () async {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>  AddressPage(amountToBePaid: '${widget.totalPrice + 50}')));
                //
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    'totalPrice', '${widget.totalPrice + 50}');

                print('userId : $userId');

                userId == null.toString()
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()))
                    : (widget.noOfProd == 'single')
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectPaymentMethod(
                                      selectedFoods: widget.selectedFoods,
                                      addressIndex: 0,
                                      cartlist: const [],
                                      totalAmount: widget.totalPrice + 50,
                                      noOfProds: widget.noOfProd,
                                      qty: widget.qty,
                                      totalQty: widget.totalQty,
                                    )))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressPage(
                                      amountToBePaid: '',
                                      userId: userId,
                                      cartlist: const [],
                                    )));
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
