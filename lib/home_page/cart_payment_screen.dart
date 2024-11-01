// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/profile/widgets/your_order_widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:miogra/home_page/home_page_trail.dart';

import 'cart_razor_pay.dart';

class CartPaymentScreen extends StatefulWidget {
  const CartPaymentScreen({
    super.key,
    required this.shopId,
    required this.productId,
    required this.totalPrice,
    this.discounts,
    this.actualPrice,
    this.totalQuantity,
    required this.address,
    required this.pinCode,
    required this.userId,
    required this.category,
    this.productData, this.foodcategory,

  });

  final String shopId;
  final List productId;
  final dynamic totalPrice;
  final dynamic discounts;
  final dynamic actualPrice;
  final dynamic totalQuantity;
  final String address;
  final String pinCode;
  final String userId;
  final List category;
  final String? foodcategory;
  final List<Map<String, dynamic>>? productData;

  @override
  State<CartPaymentScreen> createState() => _CartPaymentScreenState();
}

class _CartPaymentScreenState extends State<CartPaymentScreen> {
  int orderPlacedSuccess = 0;
  dynamic deliveryCharge = 50;

  String paymentType = 'COD';

  bool cod = true;

  int selectedPaymentMethod = 2;

  String orderId = '';

  // List collectOrderedProductCategoryList = [];


  void createNewOrderDataTest() async {
    print("Entered loop 1");

    for (int i = 0; i < widget.productId.length; i++) {
      http.MultipartRequest? request;
      String url = "";
print("Test:${widget.productId[i]}");
      switch (widget.category[i]) {
        case 'shopping':
          url = "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/shopping/";
          break;
        case 'food':
          url = "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/food/";
          break;
        case 'd_original':
          url = "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/d_original/";
          break;
        case 'daily_mio':
          url = "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/daily_mio/";
          break;
        case 'fresh_cuts':
          url = "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/fresh_cuts/";
          break;
        case 'jewellery':
          url = "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/jewellery/";
          break;
        case 'pharmacy':
          url = "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/pharmacy/";
          break;
        default:
          print("No valid category found");
          continue;
      }

      request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['quantity'] = widget.totalQuantity;
      request.fields['delivery_address'] = widget.address;
      request.fields['payment_type'] = 'COD';
      request.fields['pincode'] = widget.pinCode;

      log(widget.userId);
      log(widget.productId.toString());
      log(widget.category.toString());
      log(widget.address.toString());
      log(widget.totalQuantity.toString());
      log(widget.pinCode.toString());

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
        final send = await request.send();
        final response = await http.Response.fromStream(send);
        print(response.statusCode);

        if (response.statusCode == 200) {
          setState(() {
            orderPlacedSuccess++;
          });

          showOrderSuccess();
        }
      } catch (e) {
        print("Error While Uploading $e");
      }
    }
    print("Process Completed......");
   Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
  }

  void showOrderSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Order placed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void createNewOrderData() async {
    print("Entered loop 1");
    // var request;
    http.MultipartRequest? request;

    for (int i = 0; i <= widget.productId.length; i++) {
      if (widget.category[i] == 'shopping') {
        print("Entered loop 1");
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/shopping/");
        request = http.MultipartRequest('POST', url);
      } else if (widget.category[i] == 'food') {
        print("Entered loop 1");
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/food/");
        request = http.MultipartRequest('POST', url);
      } else if (widget.category[i] == 'd_original') {
        print("Entered loop 1");
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/d_original/");
        request = http.MultipartRequest('POST', url);
      } else if (widget.category[i] == 'daily_mio') {
        print("Entered loop 1");
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/daily_mio/");
        request = http.MultipartRequest('POST', url);
      } else if (widget.category[i] == 'fresh_cuts') {
        print("Entered loop 1");
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/fresh_cuts/");
        request = http.MultipartRequest('POST', url);
      } else if (widget.category[i] == 'jewellery') {
        print("Entered loop 1");
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/jewellery/");
        request = http.MultipartRequest('POST', url);
      } else if (widget.category[i] == 'pharmacy') {
        print("Entered loop 1");
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId[i]}/pharmacy/");
        request = http.MultipartRequest('POST', url);
      } else {
        print("no value");
        null;
      }
    }
    print("Exited from loop");

    request?.fields['quantity'] = widget.totalQuantity;
    request?.fields['delivery_address'] = widget.address;
    request?.fields['payment_type'] = 'Cash On Delivery';
    request?.fields['pincode'] = widget.pinCode;

    log(widget.userId);
    log(widget.productId.toString());
    log(widget.category.toString());
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
      final send = await request?.send();
      final response = await http.Response.fromStream(send!);
      print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          orderPlacedSuccess++;
        });
        // Fluttertoast.showToast(
        //   msg: "order Created Successfully...!",
        //   textColor: Colors.white,
        //   toastLength: Toast.LENGTH_SHORT,
        // );

        showOrderSuccess();
      }
    } catch (e) {
      print("Error While Uploading$e");
    }

    // try {
    //   // var request = http.MultipartRequest('POST', Uri.parse(url));

    //   request.fields['quantity'] = widget.totalQuantity;
    //   request.fields['delivery_address'] = widget.address;
    //   request.fields['payment_type'] = paymentType;
    //   request.fields['pincode'] = widget.pinCode;

    //   var response = await request.send();

    //   log(response.toString());

    //   log(response.statusCode.toString());
    //   if (response.statusCode == 200) {
    //     String responseBody = await response.stream.bytesToString();

    //     responseBody = responseBody.trim().replaceAll('"', '');

    //     log('userId $responseBody');
    //     log('Payment successfull');

    //     Navigator.pop(context);
    //     // showOrderSuccess();
    //   } else {
    //     Navigator.pop(context);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         behavior: SnackBarBehavior.floating,
    //         backgroundColor: Colors.green,
    //         content: Text('Ordered Successfully...'),
    //       ),
    //     );
    //     log('Failed to post data: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   log('Exception while posting data: $e');
    // }
  }

  void netBanking() async {
    String url = 'https://${ApiServices.ipAddress}/razor_pay_order';

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

      double totalRate = widget.totalPrice + deliveryCharge;

      request.fields['amount'] = totalRate.toString();

      var response = await request.send();

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        dynamic responseBody = await response.stream.bytesToString();

        Map data = json.decode(responseBody);

        setState(() {
          orderId = data['id'];
        });

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RazorPayPaymentCart(
              address: widget.address,
              category: widget.category,
              pinCode: widget.pinCode,
              productId: widget.productId,
              totalQuantity: widget.totalQuantity,
              userId: widget.userId,
              orderId: orderId,
              totalAmount: widget.totalPrice + deliveryCharge,
            ),
          ),
        );
        // showOrderSuccess();
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

  // List<AllUsersData> all_users_data = [];

  // AllUsersData endUserMyData = AllUsersData();

  // bool loadingFetchAll_users_data = true;

  // Future<void> fetchAll_users_data() async {
  //   print('fetchAll_users_data method start');
  //   late String userId;

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getString("api_response").toString();

  //   final response = await http
  //       .get(Uri.parse('http://${ApiServices.ipAddress}/all_users_data'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> responseData = json.decode(response.body);

  //     all_users_data =
  //         responseData.map((json) => AllUsersData.fromJson(json)).toList();

  //     for (var i = 0; i < all_users_data.length; i++) {
  //       if (all_users_data[i].uid == userId) {
  //         setState(() {
  //           endUserMyData = all_users_data[i];
  //           loadingFetchAll_users_data = false;
  //         });
  //       }
  //     }
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  String userId = 'a';
  String finalPrice = 'a';
  String finalQty = 'a';

  // bool loadingGetFinalPaymentDataFromSharedPreferences = true;

  // Future<void> getFinalPaymentDataFromSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userId = prefs.getString("api_response").toString();
  //     // finalPrice = prefs.getString("finalPrice").toString();
  //     // finalQty = prefs.getString("qty").toString();
  //     // loadingGetFinalPaymentDataFromSharedPreferences = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    log(widget.address);
    log(widget.pinCode);
    log(widget.category.toString());
    log(widget.productId.toString());
    log(widget.shopId);
    log(widget.userId);
    log(widget.totalPrice.toString());
//createNewOrderData();
//createNewOrderDataTest();
    //getFinalPaymentDataFromSharedPreferences();
    // fetchAll_users_data();

    // collectOrderedProductCategoryList = [];

    // collectOrderedProductCategoryListMethod();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        title: const Text('Payment'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            paymentMethod(context),

            const Divider(),

            const Text(
              "Select Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            RadioListTile(
              value: 1,
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;

                  value == 1 ? cod = false : cod = true;

                  log(cod.toString());
                });
              },
              title: const Text('UPI'),
            ),

            RadioListTile(
              value: 2,
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                  value == 2 ? cod = true : cod = false;

                  log(cod.toString());
                });
              },
              title: const Text('Cash On Delivery'),
            ),
            // Text(widget.addressIndex.toString()),

            const Divider(),
            const SizedBox(
              height: 10,
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
                          'Price (${widget.totalQuantity} Item) :',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '₹${widget.totalPrice}/-',
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
                  /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Discount : ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '-${widget.discounts}'.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                   */
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                        //  '₹${widget.totalPrice + deliveryCharge}/-'.toString(),
                          // '₹${totalPrice + deliveryCharge}/-',
                          "₹${(double.parse(widget.totalPrice) + 50).toStringAsFixed(2)}",
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
            ),

            const Divider(),
          ],
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
                backgroundColor: WidgetStateProperty.all(primaryColor),
              ),
              onPressed: () async {
                print("button pressed");
                // createNewOrderData();
                cod ? createNewOrderDataTest() : netBanking();

                // createSingleOrder1();
                // collectOrderedProductCategoryListMethod().whenComplete(() => createOrder);
                // widget.noOfProds == 'single' ?

                //     createSingleOrder() :

                //                 createOrder();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>  AddressPage(amountToBePaid: '${widget.totalPrice + 50}')));
                //
                //                 SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.setString('totalPrice', '${widget.totalPrice + 50}');

                // print('userId : $userId');

                //         userId == null.toString()
                //             ? Navigator.push(context,
                //                 MaterialPageRoute(builder: (context) => const signin()))
                //             :
                //
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => OrderSuccess()));
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

  showOrderSuccessk() {
    showDialog(
      context: context,
      builder: (context) => const SnackBar(content: Text('Order Success')),
    );
  }
}
