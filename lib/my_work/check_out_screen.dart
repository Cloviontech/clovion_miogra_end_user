import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/profile/pages/add_address_page.dart';
import 'package:miogra/home_page/cart_payment_screen.dart';
import 'package:miogra/home_page/home_page_trail.dart';
import 'package:miogra/widgets/square_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckOutPage extends StatefulWidget {
  final List image;
  final String price;
  final String shopId;
  final List productId;
  final dynamic totalPrice;
  final dynamic discounts;
  final dynamic actualPrice;
  final dynamic totalQuantity;
  final List brandName;
  final String userId;
  final List category;
  final List? singleProduct;
  final List? discountPrice;
  final List? discountPercentage;

  // final String? foodcategory;
  // final List<Map<String, dynamic>>? productData;
  CheckOutPage({super.key,
    required this.image,
    required this.price,
    required this.shopId,
    required this.productId,
    this.totalPrice,
    this.discounts,
    this.actualPrice,
    this.totalQuantity,
    required this.userId,
    required this.category,
    required this.brandName,
    this.singleProduct,
    this.discountPrice,
    this.discountPercentage});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List<dynamic> products = [];
  String cartTotal = '';
  String userId = '';
  bool addOrEdit = false;

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
  int _selectedAddressIndex = 0;

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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          fullAdd.toString(),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddAddressPage(
                                      userId: userId,
                                      edit: true,
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

  void updateCartTotal() {
    double total = 0;
    for (var product in products) {
      total += product['total'] * product['quantity'];
    }
    setState(() {
      cartTotal = total.toString();
    });
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

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCartTotal();
    fetchUserFromListJson();
  }

  Future<void> fetchCartTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response").toString();
    try {
      final response = await http.get(Uri.parse(
          'https://${ApiServices.ipAddress}/cart_total_amount/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          cartTotal = json.decode(response.body);
        });
      } else {
        print('Failed to load cart total: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading cart total: $e');
    }
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response").toString();
    try {
      final response = await http
          .get(Uri.parse('https://${ApiServices.ipAddress}/cartlist/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body).map((product) {
            product['quantity'] = 1; // Initialize quantity
            return product;
          }).toList();
        });
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.productId.length,
        itemBuilder: (context, index) {
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
                            image: widget.image[index],
                            title: 'Product Name',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.brandName[index].toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹ ${widget.price[index].toString()}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '₹ ${widget.singleProduct?[index]
                                      .toString()}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 25,
                                  width: 80,
                                  decoration:
                                  BoxDecoration(color: Colors.green),
                                  child: Center(
                                    child: Text(
                                      '${widget.discountPercentage?[index]
                                          .toString()}% OFF',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 25,
                                  width: 75,
                                  decoration:
                                  BoxDecoration(color: primaryColor),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '4.3',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          'qty:${widget.totalQuantity[index]
                                              .toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.delete)),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _removeFromCart(index);
                                        });
                                      },
                                      child: Text(
                                        'Remove',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                )
                              ],
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
        },
      ),
      bottomNavigationBar: Container(
        height: 450, // Adjust height as needed
        color: Colors.white, // Background color for the bottom navigation bar
        child: Column(
          children: [
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
                                        userId: userId,
                                        edit: false,
                                        food: false,
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
                              builder: (context) =>
                                  AddAddressPage(
                                    userId: userId,
                                    edit: false,
                                    food: false,
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                      MaterialStateProperty.all(const Size(250, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                    child: AutoSizeText(
                      '₹${widget.price}', // Replace with actual text
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
                      minimumSize:
                      MaterialStateProperty.all(const Size(250, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CartPaymentScreen(
                                    totalQuantity:
                                    widget.totalQuantity.toString(),
                                    shopId: widget.shopId,
                                    productId: widget.productId,
                                    totalPrice: widget.price,
                                    address: address,
                                    pinCode: pincode,
                                    userId: widget.userId,
                                    category: widget.category,
                                  )));

                      // Navigation or other actions
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Price:',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                Text(
                  '₹${(double.parse(widget.price) + 50).toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'Deliver Fees:',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                Text(
                  '₹50',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ],
            ),

            /*
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Discount:',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                Text(
                  '₹-${widget.discountPrice?[0].toString()}',
                  style: TextStyle(color: Colors.green, fontSize: 24),
                ),
              ],
            ),
            */
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Order Total:',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                Text(
                  '₹${(double.parse(widget.price) + 50).toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                //  Text(
                //   '₹${(double.parse(widget.price) + 50 - (widget.discountPrice?.isNotEmpty == true ? double.parse(widget.discountPrice![0]) : 0)).toStringAsFixed(2)}',
                //   style: TextStyle(color: Colors.black, fontSize: 24),
                //  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //    Text("You saved ₹${widget.discountPrice?[0].toString()} in this order",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.green),),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<dynamic> fetchUserFromListJson() async {
    String url =
        'https://${ApiServices.ipAddress}/single_users_data/${widget.userId}';

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

              doorNo = data[0]['address_data'][0]['doorno'].toString();
              area = data[0]['address_data'][0]['area'].toString();
              landMark = data[0]['address_data'][0]['landmark'].toString();
              place = data[0]['address_data'][0]['place'].toString();
              district = data[0]['address_data'][0]['district'].toString();
              state = data[0]['address_data'][0]['state'].toString();
              pincode = data[0]['address_data'][0]['pincode'].toString();

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
            'Failed to load data from URL: $url (Status code: ${response
                .statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
