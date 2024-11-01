import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPayment extends StatefulWidget {
  const RazorPayPayment({Key? key}) : super(key: key);

  @override
  _RazorPayPaymentState createState() => _RazorPayPaymentState();
}

class _RazorPayPaymentState extends State<RazorPayPayment> {
  late Razorpay _razorpay;
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize Razorpay instance with the test key
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print('Payment success: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selected
    print('External wallet: ${response.walletName}');
  }

  void openCheckout() {
    try {
      var options = {
        'key': 'rzp_test_v77gl3FhFEkagh', // Replace with your actual key
        'amount': int.parse(_amountController.text) * 100, // Amount in paise
        'name': 'Your App Name',
        'description': 'Test payment',
        'prefill': {
          'contact': '1234567890', // Replace with customer's phone number
          'email': 'test@example.com', // Replace with customer's email
        }
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RazorPay Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openCheckout,
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
