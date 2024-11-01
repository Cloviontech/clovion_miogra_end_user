// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/payment_gateway/order_placed_successfully.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../core/api_services.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class RazorPayPayment extends StatefulWidget {
  const RazorPayPayment({
    super.key,
    required this.totalQuantity,
    required this.userId,
    required this.address,
    required this.productId,
    required this.category,
    required this.pinCode,
    required this.orderId,
    this.totalAmount,
  });

  final String totalQuantity;
  final String userId;
  final String address;
  final String productId;
  final String category;
  final String pinCode;
  final String orderId;
  final dynamic totalAmount;

  @override
  State<RazorPayPayment> createState() => _RazorPayPaymentState();
}

class _RazorPayPaymentState extends State<RazorPayPayment> {
  late Razorpay _razorpay;

  int price = 1;
  String paymentId = '';
  String signatureId = '';

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    Timer(const Duration(seconds: 1), () {
      openCheckout();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.navigate_next_sharp),
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Redirecting to payment page',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    int totalRate = widget.totalAmount * 100;
    // String totalRateString = totalRate.toString();
try{
    // int amount = price * 100;
    var options = {
      'key': 'rzp_live_40vrRDs5JDf5dl',
      'amount': totalRate,
      'order_id': widget.orderId,
      'name': 'Ant-Esports-Mouse',
      'description': 'For Gamers',
      'prefill': {
        'contact': '9023456789',
        'email': 'autobotbozz@gmail.com',
      }
    };

    _razorpay.open(options);
  } catch (e) {
  debugPrint('Error: ${e.toString()}');
  }
}

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    log('Success Response paymentId ${response.paymentId}');
    log('Success Response orderId ${response.orderId}');
    log('Success Response signature ${response.signature}');
    log('Success Response data ${response.data}'.toString());

    setState(() {
      paymentId = response.paymentId ?? '';
      signatureId = response.signature ?? '';
    });

    Navigator.of(context).pop();

    setState(() {
      paymentId = response.paymentId ?? '';
      log(paymentId);
    });

    razorPayConform();

    response.paymentId == null
        ? ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'Order not placed',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderPlaced(),
            ),
          );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('Failure Response ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('Outside Response $response');
  }

  void razorPayConform() async {
    String url =
        'https://${ApiServices.ipAddress}/enduser_order_create/${widget.userId}/${widget.productId}/${widget.category}/';

    log(widget.userId);
    log(widget.productId);
    log(widget.category);
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

      // Populate form fields

      request.fields['quantity'] = widget.totalQuantity;
      request.fields['delivery_address'] = widget.address;
      request.fields['payment_type'] = 'netBanking';
      request.fields['pincode'] = widget.pinCode;

      request.fields['razorpay_payment_id'] = paymentId;
      request.fields['razorpay_order_id'] = widget.orderId;
      request.fields[' razorpay_signature '] = signatureId;

      var response = await request.send();

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        log('Payment successfull');
        log('Order Placed Successfully');

        Navigator.pop(context);
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
}
