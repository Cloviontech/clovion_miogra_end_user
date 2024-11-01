import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miogra/home_page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess({super.key});

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  String totalPrice = '';

  getTotalPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() async {
      totalPrice = (prefs.getString('totalPrice'))!;
    });
  }

  appclose() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    const String name = 'boy';
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        return appclose();
      },
      child: Scaffold(
        backgroundColor: const Color(0xff870081),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 150,
              ),
              const Text(
                'Order Placed Successfully',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const Text(
                'Thank You for Shopping with Miogra',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                },
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
