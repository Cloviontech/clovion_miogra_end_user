import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'your_order_daily.dart';

class DMioSingleProductDetailsScreen extends StatefulWidget {
  const DMioSingleProductDetailsScreen({
    super.key,
    required this.primaryImage,
    required this.name,
    required this.price,
    required this.description,
    required this.shopeid,
    required this.productid,
    required this.subcategory,
  });

  final String primaryImage;
  final String name;
  final String price;
  final String description;
  final String shopeid;
  final String productid;
  final String subcategory;

  @override
  State<DMioSingleProductDetailsScreen> createState() =>
      _DMioSingleProductDetailsScreenState();
}

class _DMioSingleProductDetailsScreenState
    extends State<DMioSingleProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getUserIdInSharedPreferences();
  }

  String userId = '';
  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Product Details',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width - 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.primaryImage,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),

                        Text(
                          '₹ ${widget.price}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        Text(
                          userId.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // temperory used for description
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: ElevatedButton(
          style: const ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(
              primaryColor,
            ),
            foregroundColor: MaterialStatePropertyAll(
              Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoToOrderDailyProducts(
                  uId: userId,
                  category: 'daily_mio',
                  link: widget.primaryImage,
                  productId: widget.productid,
                  shopId: widget.shopeid,
                  totalPrice: widget.price,
                ),
              ),
            );
          },
          child: const Text(
            'Continue',
          ),
        ),
      ),
    );
  }
}
