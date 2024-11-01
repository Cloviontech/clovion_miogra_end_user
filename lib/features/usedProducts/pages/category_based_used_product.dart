import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/shopping/presentation/pages/product_details.dart';
import 'package:miogra/features/usedProducts/pages/used_product_details_screen.dart';
class CategoryBasedUsedProduct extends StatefulWidget {
  final String category;
  final String subCategory;
   CategoryBasedUsedProduct({super.key, required this.category, required this.subCategory});

  @override
  State<CategoryBasedUsedProduct> createState() => _CategoryBasedUsedProductState();
}

class _CategoryBasedUsedProductState extends State<CategoryBasedUsedProduct> {
  String? image;

  Future<dynamic> fetchDataFromListJson() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url =
        'http://${ApiServices.ipAddress}/get_used_products_category/${widget.subCategory}';
    try {
      final response = await http.get(Uri.parse(url));



      if (response.statusCode == 200) {

        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;



          return jsonData;
        } else {

        }
      } else {
        throw Exception(
            'Failed to load data from URL: $url (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchDataFromListJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // productBox(path: path, pName: pName, oldPrice: oldPrice, newPrice: newPrice, offer: offer, color: color, page: page)
          const SizedBox(
            width: 260,
            height: 40,
            child: SearchBar(
              hintText: "Search in miogra",
              leading: Icon(
                Icons.search,
                color: primaryColor,
              ),
              backgroundColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 22),
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: const Icon(
              BootstrapIcons.sliders,
              color: Color(0xff870081),
              size: 27,
            ),
          ),
        ],
      ),
      body:

      FutureBuilder<dynamic>(
        future: fetchDataFromListJson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
              ),
            );
          } else {
            final data = snapshot.data;
            int dataLength = 0;

            if (data != null) {
              if (data is List) {
                dataLength = data.length;
              } else {

              }
            } else {

            }

            if (data != null && data is List && data.isNotEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                itemCount: dataLength,
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                  childAspectRatio: .85,
                ),
                itemBuilder: (context, index) {
                  final imageUrl =
                  data[index]['product']['primary_image']?.toString();
                  final productName = data[index]['product']['model_name']
                      .toString()
                      .toUpperCase();
                  final discountPrice = data[index]['product']['selling_price'];
                  final actualprice = data[index]['product']['actual_price'];
                  final rating = data[index]['rating'];

                  // final subcategory = data[index]['product']['subcategory'];
                  final productid = data[index]['product_id'];
                  final shopeid = data[index]['shop_id'];
                  final category = data[index]['category'];

                  return productBox(
                    imageUrl: imageUrl,
                    pName: productName,
                    oldPrice: actualprice,
                    newPrice: discountPrice,
                    rating: rating,
                    offer: 28,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>   UsedProductDetailsScreen(
                            productId: productid,

                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              // Handle the case where data is null//
              return const Scaffold(
                body: Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
