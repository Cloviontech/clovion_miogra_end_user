import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:miogra/features/usedProducts/pages/used_products_landing_page.dart';
import 'package:miogra/home_page/home_page_trail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsedProductDetailsScreen extends StatefulWidget {
  final productId;

  UsedProductDetailsScreen({super.key, required this.productId});

  @override
  State<UsedProductDetailsScreen> createState() =>
      _UsedProductDetailsScreenState();
}

class _UsedProductDetailsScreenState extends State<UsedProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    print("productID:${widget.productId.toString()}");
    fetchData();
    super.initState();
  }

  List data = [];

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("uid");
    log(userId.toString());
    final String apiUrl =
        'https://miogra.clovion.org/get_single_used_products/${widget.productId}';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body); // Store JSON response
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 70,
              color: Color(0xff870081),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) =>
                               HomePage()
                            // UsedProductProductDetailsPage(productId: "${data[index]["product"]["product_id"]}",)
                            // UsedProductDetailsScreen(),
                            )
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${data[0]["product"]["primary_image"]}"))),
                    ),
                  ),
                  Text("${data[0]["product"]["description"]}"),
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    'Price: ₹${data[0]["product"]["selling_price"]}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Product Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Year and month of \npurchase :${data[0]["product"]["purchase"]}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  //    Text('Year and month of \npurchase :${data[0]["product"]["purchase"]}', style: TextStyle(fontWeight: FontWeight.w500),),
                  //   Text('Year and month of \npurchase :${data[0]["product"]["purchase"]}', style: TextStyle(fontWeight: FontWeight.w500),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
