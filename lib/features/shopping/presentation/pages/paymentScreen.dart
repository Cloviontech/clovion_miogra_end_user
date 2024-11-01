// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/profile/widgets/your_order_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:miogra/home_page/home_page_trail.dart';
import 'package:miogra/payment_gateway/razor_pay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
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
  });

  final String shopId;
  final String productId;
  final dynamic totalPrice;
  final dynamic discounts;
  final dynamic actualPrice;
  final dynamic totalQuantity;
  final String address;
  final String pinCode;
  final String userId;
  final String category;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String delivaryTotal = '';

  Future<void> fetchdeliveryTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response") ?? '';
    try {
      final response = await http.get(Uri.parse(
          'https://miogra.clovion.org/quick_delivery_km_for_order/${widget.userId}/${widget.shopId}'));
      if (response.statusCode == 200) {
        setState(() {
          delivaryTotal = json.decode(response.body).toString();
        });
      } else {
        print('Failed to load cart total: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading cart total: $e');
    }
  }
  int orderPlacedSuccess = 0;
  dynamic deliveryCharge = 50;

  String paymentType = 'COD';

  int value = 3;

  bool cod = true;

  int selectedPaymentMethod = 0;

  String orderId = '';

  // List collectOrderedProductCategoryList = [];

  void createNewOrderData() async {
    print("Entered on the api function");
    String url =
        'https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId}/${widget.category}/';

    log(widget.userId);
    log(widget.productId);
    log(widget.category);
    log(widget.pinCode);
    log(widget.address);
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

      request.fields['quantity'] = widget.totalQuantity;
      request.fields['delivery_address'] = widget.address;
      request.fields['payment_type'] = paymentType;
      request.fields['pincode'] = widget.pinCode;

      var response = await request.send();

      log(response.toString());

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        log('Payment successfull');


        //showOrderSuccess();
     Cod();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
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
  void Cod() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Order Placed Successfully'),
      ),
    );
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

      int totalRate = widget.totalPrice + deliveryCharge;

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
            builder: (context) => RazorPayPayment(
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

    // log(widget.address);
    // log(widget.pinCode);
    // log(widget.category);
    // log(widget.productId);
    // log(widget.shopId);
    // log(widget.userId);
    // log(widget.totalPrice.toString());
fetchdeliveryTotal();
    fetchUpiCodAccess();

    // getFinalPaymentDataFromSharedPreferences();
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

            Stack(
              children: [
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
                upiAccess == false
                    ? Container(
                        alignment: Alignment.center,
                        color: const Color.fromARGB(0, 255, 255, 255),
                        height: 65,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: Container(), // Empty container
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),

            Stack(
              children: [
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
                codAccess == false
                    ? Container(
                        alignment: Alignment.center,
                        color: const Color.fromARGB(0, 255, 255, 255),
                        height: 65,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: Container(), // Empty container
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
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
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          'Delivery Fees :',
                          style: TextStyle(fontSize: 18),
                        ),
                        delivaryTotal.isEmpty
                            ? Text(
                          '₹50',
                          style: TextStyle(fontSize: 18),
                        )
                            : Text(
                          '₹$delivaryTotal',
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
                        delivaryTotal.isEmpty
                            ? Text(
                          '₹${widget.totalPrice + 50}',
                          style: TextStyle(fontSize: 18),
                        ):
                        Text(
                          '₹${(double.parse(delivaryTotal) + widget.totalPrice).toStringAsFixed(0)}'.toString(),
                          // '₹${totalPrice + deliveryCharge}/-',
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
                // createNewOrderData();
                cod ? createNewOrderData() : netBanking();

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
  void _showSnackBar(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  showOrderSuccess() {
    showDialog(
      context: context,
      builder: (context) => const SnackBar(content: Text('Order Success')),
    );
  }

  bool? upiAccess;
  bool? codAccess;

  Future<dynamic> fetchUpiCodAccess() async {
    String url = 'https://${ApiServices.ipAddress}/admin/get_shutdown';

    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());
      log('Data loading***********');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          log(data.toString());

          setState(() {
            upiAccess = data[0]['online_payment'];
            codAccess = data[0]['cod'];
          });
          log('upi$upiAccess');
          log('cod$codAccess');

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
