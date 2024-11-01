import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
// import 'package:miogra/core/colors.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/pharmacy/models/all_pharmproducts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// import '../../../freshCuts/presentation/pages/fresh_cut_details.dart';
import 'pharmacy_product_details.dart';

class PharmacyItem extends StatefulWidget {
  const PharmacyItem({super.key, required this.subCategory});

  final String subCategory;

  @override
  State<PharmacyItem> createState() => _PharmacyItemState();
}

class _PharmacyItemState extends State<PharmacyItem> {
  List orderedFoods = [];
  List<int> qty = [];

  static List<AllPharmproducts> categoryBasedPharm = [];

  bool loadingfetchCategoryBasedPharm = true;

  Future<void> fetchCategoryBasedPharm() async {
    // late String userId;
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // userId = preferences.getString("uid2").toString();

    final response = await http.get(Uri.parse(
        "http://${ApiServices.ipAddress}/category_based_pharm/${widget.subCategory}"));
    debugPrint(
        'http://${ApiServices.ipAddress}/category_based_pharm/${widget.subCategory}');

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        categoryBasedPharm = jsonResponse
            .map((data) => AllPharmproducts.fromJson(data))
            .toList();

        loadingfetchCategoryBasedPharm = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  updateValueInc(int index1) {
    print('update quantity');
    // setState(() {
    // Increment the value at the specified index
    // if (index >= 0 && index < qty.length) {
    // qty[index1] = qty[index1] + 1;

    qty[index1]++;

    if (!(orderedFoods.any((list) =>
        list.toString() ==
        [
          categoryBasedPharm[index1].pharmId,
          categoryBasedPharm[index1].productId
        ].toString()))) {
      // setState(() {
      orderedFoods.insert(index1, [
        categoryBasedPharm[index1].pharmId,
        categoryBasedPharm[index1].productId
      ]);

      print('orderedFoods : $orderedFoods');
      // });
    }

    // addToCart(foodGetProducts[index1].productId,
    //     foodGetProducts[index1].category, qty[index1]);
    // });
    // print('orderedFoods : $orderedFoods');
    print(qty.toString());
    print(qty.length);
    print(qty[index1]);
    print(index1 + 1);
  }

  updateValueDec(int index1) {
    if (qty[index1] >= 1) {
      // setState(() {
      qty[index1]--;
      // });
    } else {}

    if (qty[index1] == 0) {
      // setState(() {
      orderedFoods.removeAt(
        index1,

        //  [
        //   foodGetProducts[index1].foodId,
        //   foodGetProducts[index1].productId
        // ]
      );

      print('orderedFoods remove : $orderedFoods');
      // });
    }
  }

  List<int> totalQtyBasedPrice = [];

  List<int> totalqty = [];

  int totalQtyBasedPrice1 = 0;

  int totalqty1 = 0;

  calcTotalPriceWithResQty() {
    // setState(() {
    totalQtyBasedPrice1 = 0;
    totalQtyBasedPrice = [];
    totalqty1 = 0;
    totalqty = [];
    // });
    // totalQuantity = 0;
    for (var i = 0; i < categoryBasedPharm.length; i++) {
      // setState(() {
      totalQtyBasedPrice
          .add(categoryBasedPharm[i].product.sellingPrice.toInt() * qty[i]);

      totalqty.add(qty[i]);
      // });
    }

    // setState(() {
    totalQtyBasedPrice1 =
        totalQtyBasedPrice.reduce((value, element) => value + element);

    totalqty1 = totalqty.reduce((value, element) => value + element);
    // });

    print('totalQtyBasedPrice1 $totalQtyBasedPrice1');
  }

  Future<dynamic> fetchDataFromListJson() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url =
        'https://${ApiServices.ipAddress}/category_based_pharm/${widget.subCategory}';

    log(widget.subCategory.toString());
    log('Category Name');
    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Featching Data');
        final data = json.decode(response.body);

        log('Loading Files .....');

        log(data.toString());

        if (data is List) {
          final jsonData = data;

          log('Data fetched successfully');

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
  void initState() {
    super.initState();
    fetchDataFromListJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        // toolbarHeight: 5,
        // elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.subCategory),
            // Text(product.length.toString()),
            // Text(widget.categoryName),
          ],
        ),

        backgroundColor: const Color(0xff870081),
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
            log('Fresh Cut Products Loading...');

            if (data != null) {
              if (data is List) {
                dataLength = data.length;
              } else {
                log('Data is not a list');
              }
            } else {
              log('Data is null');
            }
            log('Fresh Cut Products Loading...');

            if (data != null) {
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
                  final rating = data[index]['rating'] ?? '0.0';

                  // final subcategory = data[index]['product']['subcategory'];
                  final productid = data[index]['product_id'];
                  final shopeid = data[index]['pharm_id'];
                  final category = data[index]['category'];
                  log('Loading Datas..........................');
                  log(productid.toString());
                  log(shopeid.toString());
                  log(category.toString());

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
                          builder: (context) => PharmacyProducDetails(
                            
                            productId: productid,
                            shopeid: shopeid,
                            category: category,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
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

      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       // Text(product.length.toString()),

      //       // Text(product[0].productId),

      //       // Text(
      //       //   product[0].product.primaryImage.toString(),
      //       // ),
      //       // SizedBox(
      //       //   height: 200,
      //       //   width: 200,
      //       //   child: Image.network(
      //       //     "https://c.ndtvimg.com/2022-07/q8dnkacg_chicken_625x300_06_July_22.jpg?im=FeatureCrop,algorithm=dnn,width=620,height=350",
      //       //   ),
      //       // ),

      //       // productWithCounter(),

      //       // GridView.builder(
      //       //     // padding: EdgeInsets.zero,
      //       //     shrinkWrap: true,
      //       //     // primary: false,
      //       //     // itemCount: product.length,
      //       //     itemCount: 10,
      //       //     controller: ScrollController(),
      //       //     physics: const NeverScrollableScrollPhysics(),
      //       //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //       //       crossAxisCount: 2,
      //       //       // mainAxisSpacing: 1,
      //       //       // childAspectRatio: 2.1,
      //       //     ),
      //       //     itemBuilder: (context, index) {
      //       //       return Padding(
      //       //         padding: const EdgeInsets.all(1.0),
      //       //         child: Container(
      //       //           width: MediaQuery.of(context).size.width / 2 - 10,
      //       //           // height: MediaQuery.of(context).size.width / 2 + 200,
      //       //           color: Colors.white,
      //       //           child: const Column(
      //       //             children: [
      //       //               Text(
      //       //                 'Product Name',
      //       //               )
      //       //             ],
      //       //           ),
      //       //         ),
      //       //       );

      //       //       //                     Container(
      //       //       //                       // padding: const EdgeInsets.only(top: 7),
      //       //       //                       child: Row(
      //       //       //                         children: [
      //       //       //                           Expanded(
      //       //       //                             flex: 4,
      //       //       //                             child: Column(
      //       //       //                               children: [
      //       //       // //  Text(product.length.toString()),

      //       //       //                                 // Text(foods![index].foodId.toString()),
      //       //       //                                 Expanded(
      //       //       //                                   flex: 3,
      //       //       //                                   child: Container(
      //       //       //                                     margin: const EdgeInsets.symmetric(
      //       //       //                                         horizontal: 10),
      //       //       //                                     decoration: const BoxDecoration(
      //       //       //                                       image: DecorationImage(
      //       //       //                                         image: AssetImage(
      //       //       //                                             'assets/images/appliances.jpeg'),

      //       //       //                                         // image: NetworkImage(
      //       //       //                                         //   // foods![index]
      //       //       //                                         //   product[index]
      //       //       //                                         //       .product
      //       //       //                                         //       .primaryImage
      //       //       //                                         //       .toString(),
      //       //       //                                         // ),
      //       //       //                                         fit: BoxFit.fill,
      //       //       //                                       ),
      //       //       //                                       borderRadius:
      //       //       //                                           BorderRadius.all(Radius.circular(15)),
      //       //       //                                     ),
      //       //       //                                   ),
      //       //       //                                 ),
      //       //       //                                 Expanded(
      //       //       //                                   child: SizedBox(
      //       //       //                                     child: Row(
      //       //       //                                       mainAxisSize: MainAxisSize.min,
      //       //       //                                       children: [
      //       //       //                                         InkWell(
      //       //       //                                           onTap: () {
      //       //       //                                             updateValueDec(index);

      //       //       //                                             calcTotalPriceWithResQty();
      //       //       //                                           },
      //       //       //                                           child: Container(
      //       //       //                                             decoration: const BoxDecoration(
      //       //       //                                               color: Color(0xff870081),
      //       //       //                                               borderRadius: BorderRadius.only(
      //       //       //                                                 topLeft: Radius.circular(5),
      //       //       //                                                 bottomLeft: Radius.circular(5),
      //       //       //                                               ),
      //       //       //                                             ),
      //       //       //                                             height: 30,
      //       //       //                                             width: 30,
      //       //       //                                             alignment: Alignment.center,
      //       //       //                                             child: const Text(
      //       //       //                                               "-",
      //       //       //                                               style: TextStyle(
      //       //       //                                                   color: Colors.white,
      //       //       //                                                   fontSize: 25),
      //       //       //                                             ),
      //       //       //                                           ),
      //       //       //                                         ),
      //       //       //                                         Container(
      //       //       //                                           height: 30,
      //       //       //                                           width: 35,
      //       //       //                                           alignment: Alignment.center,
      //       //       //                                           decoration: BoxDecoration(
      //       //       //                                               border: Border.all(
      //       //       //                                                   color:
      //       //       //                                                       const Color(0xff870081))),
      //       //       //                                           child: const Text(
      //       //       //                                             'text',
      //       //       //                                             // _quantity
      //       //       //                                             //     .toString(),
      //       //       //                                             // qty[index].toString(),
      //       //       //                                             style: TextStyle(
      //       //       //                                                 color: Color(0xff870081),
      //       //       //                                                 fontSize: 20,
      //       //       //                                                 fontWeight: FontWeight.w500),
      //       //       //                                           ),
      //       //       //                                         ),
      //       //       //                                         GestureDetector(
      //       //       //                                           onTap: () {
      //       //       //                                             updateValueInc(index);

      //       //       //                                             calcTotalPriceWithResQty();
      //       //       //                                           },
      //       //       //                                           child: Container(
      //       //       //                                             decoration: const BoxDecoration(
      //       //       //                                                 color: Color(0xff870081),
      //       //       //                                                 borderRadius: BorderRadius.only(
      //       //       //                                                   topRight: Radius.circular(5),
      //       //       //                                                   bottomRight:
      //       //       //                                                       Radius.circular(5),
      //       //       //                                                 )),
      //       //       //                                             height: 30,
      //       //       //                                             width: 30,
      //       //       //                                             alignment: Alignment.center,
      //       //       //                                             child: const Text(
      //       //       //                                               "+",
      //       //       //                                               style: TextStyle(
      //       //       //                                                   color: Colors.white,
      //       //       //                                                   fontSize: 25),
      //       //       //                                             ),
      //       //       //                                           ),
      //       //       //                                         ),
      //       //       //                                       ],
      //       //       //                                     ),
      //       //       //                                   ),
      //       //       //                                 ),
      //       //       //                               ],
      //       //       //                             ),
      //       //       //                           ),
      //       //       //                           Expanded(
      //       //       //                             flex: 6,
      //       //       //                             child: Column(
      //       //       //                               crossAxisAlignment: CrossAxisAlignment.start,
      //       //       //                               children: [
      //       //       //                                 Expanded(
      //       //       //                                   // flex: 3,
      //       //       //                                   child: Column(
      //       //       //                                     crossAxisAlignment:
      //       //       //                                         CrossAxisAlignment.start,
      //       //       //                                     children: [
      //       //       //                                       Text(
      //       //       //                                         // "Chiken Manchurian",
      //       //       //                                         product[index].product.name![0],
      //       //       //                                         maxLines: 2,
      //       //       //                                         overflow: TextOverflow.ellipsis,
      //       //       //                                         style: const TextStyle(
      //       //       //                                           fontSize: 19,
      //       //       //                                           color: Color(0xE6434343),
      //       //       //                                           fontWeight: FontWeight.w500,
      //       //       //                                         ),
      //       //       //                                       ),
      //       //       //                                       const SizedBox(
      //       //       //                                         height: 10,
      //       //       //                                       ),
      //       //       //                                       Text(
      //       //       //                                         // "₹150",
      //       //       //                                         '₹ ${product[index].product.sellingPrice}',
      //       //       //                                         style: const TextStyle(
      //       //       //                                             fontSize: 19,
      //       //       //                                             color: Color(0xE6434343)),
      //       //       //                                       ),
      //       //       //                                       const SizedBox(
      //       //       //                                         height: 10,
      //       //       //                                       ),
      //       //       //                                       GestureDetector(
      //       //       //                                         onTap: () {
      //       //       //                                           showModalBottomSheet(
      //       //       //                                               shape:
      //       //       //                                                   const RoundedRectangleBorder(
      //       //       //                                                       borderRadius:
      //       //       //                                                           BorderRadius.vertical(
      //       //       //                                                               top: Radius
      //       //       //                                                                   .circular(
      //       //       //                                                                       20))),
      //       //       //                                               context: context,
      //       //       //                                               builder: (context) {
      //       //       //                                                 return Container(
      //       //       //                                                   child: Padding(
      //       //       //                                                     padding:
      //       //       //                                                         const EdgeInsets.all(
      //       //       //                                                             30.0),
      //       //       //                                                     child: Column(
      //       //       //                                                       children: [
      //       //       //                                                         // temperory used for description
      //       //       //                                                         Container(
      //       //       //                                                           decoration: BoxDecoration(
      //       //       //                                                               borderRadius:
      //       //       //                                                                   BorderRadius
      //       //       //                                                                       .circular(
      //       //       //                                                                           20)),
      //       //       //                                                           child: Image.network(
      //       //       //                                                               product[index]
      //       //       //                                                                   .product
      //       //       //                                                                   .primaryImage),
      //       //       //                                                         ),
      //       //       //                                                         const SizedBox(
      //       //       //                                                           height: 50,
      //       //       //                                                         ),
      //       //       //                                                         Text(
      //       //       //                                                           product[index]
      //       //       //                                                               .product
      //       //       //                                                               .otherImages![0],
      //       //       //                                                         )
      //       //       //                                                       ],
      //       //       //                                                     ),
      //       //       //                                                   ),
      //       //       //                                                 );
      //       //       //                                               });
      //       //       //                                         },
      //       //       //                                         child: Text(
      //       //       //                                           // temperory used for description

      //       //       //                                           product[index]
      //       //       //                                               .product
      //       //       //                                               .otherImages![0],

      //       //       //                                           maxLines: 3,
      //       //       //                                           overflow: TextOverflow.ellipsis,
      //       //       //                                           style: const TextStyle(
      //       //       //                                               fontSize: 15,
      //       //       //                                               color: Color(0xE6434343)),
      //       //       //                                         ),
      //       //       //                                       ),
      //       //       //                                     ],
      //       //       //                                   ),
      //       //       //                                 ),
      //       //       //                                 // const Expanded(child: SizedBox()),
      //       //       //                               ],
      //       //       //                             ),
      //       //       //                           ),
      //       //       //                         ],
      //       //       //                       ),
      //       //       //                     );
      //       //     })
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const OrderSuccess()));

                // bottomDetailsScreen(
                //     context: context,
                //     qtyB: totalqty1,
                //     priceB: totalQtyBasedPrice1,
                //     deliveryB: 50);
              },
              child:
                  // Text(
                  //   '$totalqty1 Items | ₹ ${totalQtyBasedPrice1}',
                  //   style: TextStyle(color: Colors.purple, fontSize: 18),
                  // ),

                  AutoSizeText(
                '$totalqty1 Items | ₹ ${totalQtyBasedPrice1 + (totalQtyBasedPrice1 == 0 ? 0 : 50)}',
                minFontSize: 18,
                maxFontSize: 24,
                maxLines: 1, // Adjust this value as needed
                overflow: TextOverflow.ellipsis, // Handle overflow text
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => OrderingFor(
                //               totalPrice: totalQtyBasedPrice1,
                //               totalQty: totalqty1,
                //               selectedFoods: orderedFoods,
                //               qty: qty,
                //               productCategory: 'freshCuts',
                //             )));
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
}
