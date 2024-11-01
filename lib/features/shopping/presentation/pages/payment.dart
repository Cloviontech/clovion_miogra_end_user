import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miogra/features/profile/pages/address.dart';
import 'package:miogra/features/profile/pages/qty.dart';
import 'package:miogra/features/profile/widgets/your_order_widgets.dart';
import 'package:miogra/features/shopping/presentation/pages/choose_address.dart';
import 'package:miogra/features/shopping/presentation/pages/order_placed_succesfully.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: orderSummery1(context),
      bottomNavigationBar: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(250, 50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          )),
          backgroundColor: MaterialStateProperty.all(Colors.purple),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OrderSuccess()));
        },
        child: const Text(
          'Continue',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
