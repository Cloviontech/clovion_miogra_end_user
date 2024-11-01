// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/profile/pages/add_address_page.dart';
import 'package:miogra/features/shopping/presentation/pages/paymentScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_services.dart';
import '../../../auth/presentation/pages/signin.dart';
import '../../../profile/widgets/your_order_widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class GoToOrderDailyProducts extends StatefulWidget {
  final String? productId;
  final String shopId;
  final String? link;
  final dynamic totalPrice;
  final String uId;
  final String category;

  const GoToOrderDailyProducts({
    super.key,
    this.productId,
    required this.shopId,
    this.totalPrice,
    this.link,
    required this.uId,
    required this.category,
  });

  @override
  State<GoToOrderDailyProducts> createState() => _GoToOrderDailyProductsState();
}

class _GoToOrderDailyProductsState extends State<GoToOrderDailyProducts> {
  String userId = '';
  String image = '';
  String productName = '';
  String productId = '';
  String productPrice = '';
  String shopeId = '';
  String description = '';
  String brandName = '';
  String discount = '';
  String rating = '';
  String category = '';
  String subCategory = '';

//price
  dynamic newPrice = 0;
  dynamic totalPrice = 0;
  String oldPrice = '';

  bool addOrEdit = false;
  int count = 1;
  dynamic deliveryCharge = 50;
  int _selectedAddressIndex = 0;

//Address
  String address = '';
  List addressList = [];
  String doorNo = '';
  String area = '';
  String landMark = '';
  String place = '';
  String district = '';
  String state = '';
  String pincode = '';

  String fullAddress = '';
  String newPin = '';

  @override
  void initState() {
    super.initState();

    log('Shope iD is ${widget.shopId}');

    getUserIdInSharedPreferences();

    fetchUserFromListJson();

    fetchFetchDailyProductsFromListJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Your Order Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ButtonStyle(
          // minimumSize: MaterialStateProperty.all(const Size(250, 50)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(primaryColor),
        ),
        onPressed: () async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setString('totalPrice', totalPrice.toString());

          userId == null.toString()
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInPage(),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // SelectPaymentMethod( cartlist: [], addressIndex: 0, selectedFoods: [],),
                        PaymentScreen(
                      shopId: widget.shopId.toString(),
                      productId: widget.productId.toString(),
                      discounts: discount.toString(),
                      actualPrice: oldPrice,
                      totalQuantity: count.toString(),
                      totalPrice: totalPrice,
                      category: widget.category,
                      address: fullAddress,
                      pinCode: newPin,
                      userId: widget.uId,
                    ),
                  ),
                );
        },
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              orderSummery(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 199, 199, 199),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.link.toString(),
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      productName,
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1,
                                      horizontal: 5,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: Colors.purple,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          rating,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    oldPrice,
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.totalPrice.toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    color: Colors.green,
                                    height: 25,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: const Center(
                                      child: Text(
                                        '30% OFF',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (count > 1) {
                                          // Ensure count is greater than 1 to avoid division by zero
                                          count--;
                                          totalPrice = newPrice - newPrice;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(count.toString()),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        count++;
                                        totalPrice = newPrice * count;
                                        log(totalPrice.toString());
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/delivey.svg',
                          height: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Delivery With In 2 Days',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color.fromRGBO(243, 229, 245, 1),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/location.svg',
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Delivery Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                            !addOrEdit
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddAddressPage(
                                                edit: false,
                                                userId: userId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 26,
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'Add',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: showMoreAddress,

                                        //   // Navigator.of(context).push(
                                        //   //   MaterialPageRoute(
                                        //   //     builder: (context) =>
                                        //   //         const ChooseAddress(),
                                        //   //     // AddressPage()
                                        //   //     // AddressPage(amountToBePaid: amountToBePaid, userId: userId, cartlist: cartlist)
                                        //   //   ),
                                        //   // );
                                        //   // Navigator.push(
                                        //   //   context,
                                        //   //   MaterialPageRoute(
                                        //   //     builder: (context) => const AddressPage(
                                        //   //       amountToBePaid: '',
                                        //   //       cartlist: [],
                                        //   //       userId: '',
                                        //   //       productId: '',
                                        //   //       shopId: '',
                                        //   //       selectedFoods: [],
                                        //   //     ),
                                        //   //   ),
                                        //   // );

                                        //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ChangeAddressPage(
                                        //   //                                   amountToBePaid: '',
                                        //   //                                   userId: '',
                                        //   //                                   cartlist: const [],
                                        //   //                                   shopId: widget.shopId,
                                        //   //                                   productId: widget.productId,
                                        //   //                                 ) )) ;
                                        // },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 26,
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'Change',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddAddressPage(
                                            userId: userId,
                                            edit: false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 26,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(fullAddress),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price ($count Item) :',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹$totalPrice/-',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Fees :',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹50/-',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Discount :',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '-$discount',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Total :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${totalPrice + deliveryCharge}/-'.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showMoreAddress() {
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: ListView.builder(
            shrinkWrap: true, // Prevent excessive scrolling
            itemCount: addressList.length,
            itemBuilder: (context, index) {
              final address = addressList[index];
              String dorNo = address['doorno'];
              String area = address['area'];
              String? landmark = address['landmark'];
              String? place = address['place'];
              String? district = address['district'];
              String? state = address['state'];
              String? pincode = address['pincode'];
              String? fullAdd =
                  ('$dorNo $area $landmark $place $district $state ($pincode)');

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 247, 227, 251),
                  ),
                  child: RadioListTile<int>(
                    activeColor: primaryColor,
                    title: Text(
                      fullAdd.toString(),
                    ),
                    value: index,
                    groupValue: _selectedAddressIndex,
                    onChanged: (value) {
                      setState(() {
                        _selectedAddressIndex = value!;
                        Navigator.pop(context);

                        fullAddress = fullAdd.toString();

                        newPin = pincode.toString();
                      });
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });
  }

  String prz = 'o';

  Future<dynamic> fetchFetchDailyProductsFromListJson() async {
    String url =
        'https://${ApiServices.ipAddress}/get_single_dmio_product/${widget.shopId}/${widget.productId}';

    try {
      final response = await http.get(Uri.parse(url));

      // log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          try {
            setState(() {
              // image = data[0]['product']['primary_image'];

              log('ShopeID is...............');

              // log(widget.shopId.toString());
              // log(widget.productId.toString());

              productName = data[0]['product']['model_name'].toString();

              productId = data[0]['product_id'].toString();

              shopeId = data[0]['dmio_id'].toString();
              brandName = data[0]['product']['brand'].toString();
              productPrice = data[0]['product']['selling_price'].toString();
              description =
                  data[0]['product']['product_description'].toString();
              oldPrice = data[0]['product']['actual_price'].toString();

              newPrice = data[0]['product']['selling_price'];

              String sellingPrice =
                  data[0]['product']['selling_price'].toString();
              newPrice = int.parse(sellingPrice);
              discount = data[0]['product']['discount'].toString();
              rating = data[0]['rating'].toString();
              String totalPrices = newPrice.toString();
              try {
                totalPrice = int.parse(totalPrices);
                print(newPrice); // This will print 30
              } on FormatException {
                print(
                    "The string '$totalPrice' could not be converted to an integer.");
              }

              log('Price of product');
              log(newPrice.toString());
              log('Price of product');
            });
          } catch (e) {
            setState(() {
              productName = '';
              brandName = '';
              productPrice = '';
              description = '';
              oldPrice = '';
              description = '';
            });
          }

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

  Future<dynamic> fetchUserFromListJson() async {
    String url =
        'https://${ApiServices.ipAddress}/single_users_data/${widget.uId}';

    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          try {
            setState(() {
              log('loading....');

              address = data[0]['address_data'].toString();
              List addresslength = data[0]['address_data'];
              int existAddress = addresslength.length;

              existAddress == 0 ? addOrEdit = true : addOrEdit = false;

              doorNo = data[0]['address_data'][3]['doorno'].toString();
              area = data[0]['address_data'][3]['area'].toString();
              landMark = data[0]['address_data'][3]['landmark'].toString();
              place = data[0]['address_data'][3]['place'].toString();
              district = data[0]['address_data'][3]['district'].toString();
              state = data[0]['address_data'][3]['state'].toString();
              pincode = data[0]['address_data'][3]['pincode'].toString();

              newPin = pincode;

              addressList = data[0]['address_data'];

              fullAddress =
                  ('$doorNo, $area, $landMark, $place, $district, $state, ($pincode)');
            });
          } catch (e) {
            setState(() {
              address = '';
            });
          }

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
}
