// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:miogra/core/colors.dart';
import 'package:order_tracker/order_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api_services.dart';
import '../widgets/order_track_widgets.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'return.dart';

class OrderTrackPage extends StatefulWidget {
  const OrderTrackPage({
    super.key,
    this.orderId,
    this.image,
    this.productName,
    this.productId,
    this.price,
    this.review,
    this.userId,
    this.status,
  });

  final String? orderId;
  final String? image;

  final String? productName;
  final String? productId;
  final dynamic price;
  final dynamic review;
  final String? userId;

  final String? status;

  @override
  State<OrderTrackPage> createState() => _OrderTrackPageState();
}

class _OrderTrackPageState extends State<OrderTrackPage> {
  final TextEditingController _comment = TextEditingController();
  final TextEditingController _rating = TextEditingController();

  int? price;
  @override
  void initState() {
    super.initState();

    fetchDataFromListJson();

    parse();
  }

  parse() {
    if (widget.price == int) {
      return widget.price == widget.price;
    } else {
      // setState(() {
      //   widget.price = int.parse(widget.price);
      // });

      setState(() {
      //  price = int.parse(widget.price);

      });
      //
    }
  }

  // List<TextDto> orderList = [
  //   TextDto("Order placed", "Tue, 29th Mar '22 - 5:04pm"),
  // ];

  // List<TextDto> shippedList = [
  //   TextDto("Your order has been shipped", "Tue, 29th Mar '22 - 5:04pm"),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Order',
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductName(
              image: widget.image ?? '',
              review: widget.review,
              price: widget.price,
              productName: widget.productName ?? 'Product Name',
            ),
            // addressContainer(context),
            // orderRatingContainer(
            //   context,

            //   widget.price,

            // ),
            // trackingContainer(context),
            if (status == 'accepted')
              Container(
                height: 320,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: OrderTracker(
                    headingDateTextStyle:
                        const TextStyle(color: Colors.transparent),
                    orderTitleAndDateList: [TextDto(orderDate, '')],
                    shippedTitleAndDateList: [
                      TextDto('Expected Delevered Date', expectDeleveryDate)
                    ],
                    subDateTextStyle: const TextStyle(color: Colors.grey),
                    status: Status.order,
                    activeColor: Colors.green,
                    inActiveColor: Colors.grey[300],
                  ),
                ),
              )
            else if (status == 'shipped')
              Container(
                height: 320,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: OrderTracker(
                    headingDateTextStyle:
                        const TextStyle(color: Colors.transparent),
                    orderTitleAndDateList: [TextDto(orderDate, '')],
                    shippedTitleAndDateList: [
                      TextDto('Expected Delevered Date', expectDeleveryDate)
                    ],
                    subDateTextStyle: const TextStyle(color: Colors.grey),
                    status: Status.shipped,
                    activeColor: Colors.green,
                    inActiveColor: Colors.grey[300],
                  ),
                ),
              )
            else if (status == 'delivered')
              Container(
                height: 320,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: OrderTracker(
                    headingDateTextStyle:
                        const TextStyle(color: Colors.transparent),
                    orderTitleAndDateList: [TextDto(orderDate, '')],
                    shippedTitleAndDateList: [
                      TextDto('Expected Delevered Date', expectDeleveryDate)
                    ],
                    subDateTextStyle: const TextStyle(color: Colors.grey),
                    status: Status.delivered,
                    activeColor: Colors.green,
                    inActiveColor: Colors.grey[300],
                  ),
                ),
              )
            else if (status == 'cancel')
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Order Canceled',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            else if (status == 'pending')
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Color.fromARGB(255, 255, 213, 6),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Order Pending',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      orderCancelRequest();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // returnContainer(context),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Return or Exchange',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReturnPage(
                                userId: widget.userId!,
                                orderId: widget.orderId!,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 27,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              height: 1,
            ),
            priceContainer(
              context: context,
              sellingPrice: widget.price,
              qty: 1,
              deliveryPrice: 50,
              discount: 0,
            ),
          ],
        ),
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
        'https://${ApiServices.ipAddress}/create_reviews_for_delivered_products/${widget.userId}/$productId/';

    log('productId..............$productId');
    log('userId..............${widget.userId}');
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

  String? status = '';
  String? orderDate = '';
  String? expectDeleveryDate = '';
  // String? status = '';

  Future<dynamic> fetchDataFromListJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("api_response").toString();
    log(userId);
    log(widget.orderId.toString());
    // log(userId);
    String url =
        'https://${ApiServices.ipAddress}/enduser_single_order_list/$userId/${widget.orderId}';
    log(url);
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      // log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log(url.toString());
        // log('Featching Data');
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          setState(() {
            status = data[0]['status'];
            orderDate = data[0]['order_date'];
            expectDeleveryDate = data[0]['expected_deliverydate'];
          });

          log(status.toString());

          // log(data.toString());

          // log(data.toString());

          // log('Data fetched successfully');

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

  void orderCancelRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("api_response").toString();
    String url =
        'https://${ApiServices.ipAddress}/enduser_order_cancel/$userId/${widget.orderId}';

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

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully posted data
        log('Order Canceled...');
        // String responseBody = await response.stream.bytesToString();
        // responseBody = responseBody.trim().replaceAll('"', '');

        // log('userId $responseBody');

        Navigator.pop(context);

        // Display a Snackbar when the response is 200
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order Canceled'),
          ),
        );
      } else {
        Navigator.pop(context);
        // Display a Snackbar when the response is not 200
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
        // Error occurred while posting data, but it's expected
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }
}
