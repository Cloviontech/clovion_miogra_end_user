import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/dailyMio/presentation/pages/d_mio_single_product_details_page.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../../../core/api_services.dart';

class DailyProducts extends StatefulWidget {
  const DailyProducts(
      {super.key, required this.categoryName, required this.subCategoryName});

  final String categoryName;
  final String subCategoryName;

  @override
  State<DailyProducts> createState() => _DailyProductsState();
}

class _DailyProductsState extends State<DailyProducts> {
  String subcategory = '';
  String productid = '';
  String shopeid = '';

  Future<dynamic> fetchDataFromListJson() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url =
        'https://${ApiServices.ipAddress}/category_based_dmio/${widget.subCategoryName}';
    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          // log(data.toString());
          // log(jsonData.toString());

          log('Data fetched successfully...........');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
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
                log('Data is not a list');
              }
            } else {
              log('Data is null');
            }

            if (data != null) {
              return ListView.builder(
                itemCount: dataLength,
                itemBuilder: (context, index) {
                  final imageUrl =
                      data[index]['product']['primary_image'].toString();
                  final productName = data[index]['product']['model_name']
                      .toString()
                      .toUpperCase();
                  final sellingPrice = data[index]['product']['selling_price'];
                  final description =
                      data[index]['product']['product_description'];

                  final subcategory = data[index]['product']['subcategory'];
                  final productid = data[index]['product_id'];
                  final shopeid = data[index]['dmio_id'];

                  log(shopeid.toString());
                  log(productid.toString());
                  log(subcategory.toString());
                  // final category = data[index]['category'];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DMioSingleProductDetailsScreen(
                            description: description,
                            name: productName,
                            price: "$sellingPrice/-",
                            primaryImage: imageUrl.toString(),
                            productid: productid,
                            subcategory: subcategory,
                            shopeid: shopeid,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2.5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 237, 237),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image(
                                    image: NetworkImage(
                                      imageUrl.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '₹$sellingPrice /-',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DMioSingleProductDetailsScreen(
                                                description: description,
                                                name: productName,
                                                price: "$sellingPrice/-",
                                                primaryImage:
                                                    imageUrl.toString(),
                                                productid: productid,
                                                subcategory: subcategory,
                                                shopeid: shopeid,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Get Once'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                'Item Suscribed',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Suscibie'),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

              // GridView.builder(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 5,
              //     vertical: 5,
              //   ),
              //   itemCount: dataLength,
              //   // physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   primary: false,
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisSpacing: 5,
              //     mainAxisSpacing: 5,
              //     crossAxisCount: 2,
              //     childAspectRatio: .85,
              //   ),
              //   itemBuilder: (context, index) {
              //     final imageUrl =
              //         data[index]['product']['primary_image']?.toString();
              //     final productName = data[index]['product']['model_name']
              //         .toString()
              //         .toUpperCase();
              //     final discountPrice = data[index]['product']['selling_price'];
              //     final actualprice = data[index]['product']['actual_price'];
              //     final rating = data[index]['rating'];

              //     // final subcategory = data[index]['product']['subcategory'];
              //     final productid = data[index]['product_id'];
              //     final shopeid = data[index]['shop_id'];
              //     final category = data[index]['category'];

              //     return productBox(
              //       imageUrl: imageUrl,
              //       pName: productName,
              //       oldPrice: actualprice,
              //       newPrice: discountPrice,
              //       rating: rating,
              //       offer: 28,
              //       color: Colors.red,
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => ProductDetailsPage(
              //               productId: productid,
              //               shopeid: shopeid,
              //               category: category,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // );
            } else {
              // Handle the case where data is null
              return const Scaffold(
                body: Center(
                  child: Text('No data found'),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
