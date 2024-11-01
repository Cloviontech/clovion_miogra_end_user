import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/food/models_foods/all_foodproducts_model.dart';
import 'package:miogra/features/freshCuts/presentation/pages/fresh_cut_details.dart';
import 'package:miogra/models/freshcuts/all_freshcutproducts_model.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/product_box.dart';

class FreshcutsProductsPage extends StatefulWidget {
  const FreshcutsProductsPage(
      {super.key, required this.categoryName, required this.subCategoryName});

  final String categoryName;
  final String subCategoryName;

  @override
  State<FreshcutsProductsPage> createState() => _FreshcutsProductsPageState();
}

class _FreshcutsProductsPageState extends State<FreshcutsProductsPage> {
  List orderedFoods = [];
  List<int> qty = [];
  void updateValueInc(int index1) {
    print('update quantity');
    setState(() {
      // Increment the value at the specified index
      // if (index >= 0 && index < qty.length) {
      // qty[index1] = qty[index1] + 1;

      qty[index1]++;

      if (!(orderedFoods.any((list) =>
          list.toString() ==
          [product[index1].freshId, product[index1].productId].toString()))) {
        setState(() {
          orderedFoods.insert(
              index1, [product[index1].freshId, product[index1].productId]);

          print(orderedFoods);
        });
      }
    });
    print(qty.toString());
    print(qty.length);
    print(qty[index1]);
    print(index1 + 1);
  }

  String userId = '';

  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();

      log('User ID is $userId');
    });
  }

  void updateValueDec(int index1) {
    if (qty[index1] >= 1) {
      setState(() {
        qty[index1]--;
      });
    } else {}

    if (qty[index1] == 0) {
      setState(() {
        orderedFoods.removeAt(
          index1,

          //  [
          //   product[index1].foodId,
          //   product[index1].productId
          // ]
        );

        print('orderedFoods remove : $orderedFoods');
      });
    }
  }

  List<int> totalQtyBasedPrice = [];

  List<int> totalqty = [];

  int totalQtyBasedPrice1 = 0;

  int totalqty1 = 0;

  calcTotalPriceWithResQty() {
    setState(() {
      totalQtyBasedPrice1 = 0;
      totalQtyBasedPrice = [];
      totalqty1 = 0;
      totalqty = [];
    });
    // totalQuantity = 0;
    for (var i = 0; i < product.length; i++) {
      setState(() {
        totalQtyBasedPrice
            .add(product[i].product.sellingPrice.toInt() * qty[i]);

        totalqty.add(qty[i]);
      });
    }

    setState(() {
      totalQtyBasedPrice1 =
          totalQtyBasedPrice.reduce((value, element) => value + element);

      totalqty1 = totalqty.reduce((value, element) => value + element);
    });

    print('totalQtyBasedPrice1 $totalQtyBasedPrice1');
  }

  // static List<AllFreshcutproducts> allFreshcutproducts = [];

  List<AllFreshcutproducts> product = [];
  // List<dynamic> product = [];

  bool loadingFetchAllFreshcutproducts = true;

  Future<dynamic> fetchDataFromListJson() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url =
        'https://${ApiServices.ipAddress}/category_based_fresh/${widget.subCategoryName}';

    log(widget.categoryName.toString());
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

  // static List<AllFoodproducts> allFoodproducts = [];

  List<AllFoodproducts> foodProduct = [];

  bool loadingFetchAllFoodproducts = true;

  @override
  void initState() {
    super.initState();

    getUserIdInSharedPreferences();

    fetchDataFromListJson();

// widget.subCategoryName == 'fresh_cuts' ?

    // fetchAllFreshcutproducts().whenComplete(
    //   () => qty = List<int>.generate(product.length, (index) => 0),
    // )

    // :

    // fetchAllFoodproducts().whenComplete(
    //   () => qty = List<int>.generate(product.length, (index) => 0),
    // )
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
            Text(widget.subCategoryName),
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

            if (data != null && data is List && data.isNotEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: dataLength,
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  // crossAxisSpacing: 5,
                  // mainAxisSpacing: 5,
                  // crossAxisCount: 2,
                  // childAspectRatio: .85,
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 5.0, // Spacing between columns
                  mainAxisSpacing: 5.0, // Spacing between rows (optional)
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final imageUrl =
                      data[index]['product']['primary_image']?.toString();
                  final productName = data[index]['product']['model_name']
                      .toString()
                      .toUpperCase();
                  final sellingPrice = data[index]['product']['selling_price'];
                  final actualprice = data[index]['product']['actual_price'];
                  final rating = data[index]['rating'] ?? '0.0';

                  // final subcategory = data[index]['product']['subcategory'];
                  final productid = data[index]['product_id'];
                  final shopeid = data[index]['fresh_id'];
                  final category = data[index]['category'];
                  log('Loading Datas..........................');
                  log(productid.toString());
                  log(shopeid.toString());
                  log(category.toString());

                  return productBox(
                    imageUrl: imageUrl,
                    pName: productName,
                    oldPrice: actualprice,
                    newPrice: sellingPrice,
                    rating: rating,
                    offer: 28,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FreshCutProductDetails(
                            productId: productid,
                            shopeid: shopeid,
                            category: category,
                          ),
                        ),
                      );
                    },
                  );

                  // return ProductItems(
                  //   ontapIncrement: () {
                  //     totalCountNotifier.value--;
                  //   },
                  //   ontapDecrement: () {
                  //     totalCountNotifier.value++;
                  //   },
                  //   oldPrice: actualprice.toString(),
                  //   productName: productName.toString(),
                  //   sellingPrice: sellingPrice.toString(),
                  //   imageUrl: imageUrl.toString(),
                  //   category: category,
                  //   productId: productid,
                  //   userId: userId,
                  // );
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
      // bottomNavigationBar: Row(
      //   children: [
      //     Expanded(
      //       child: ElevatedButton(
      //         style: ButtonStyle(
      //           minimumSize: WidgetStateProperty.all(const Size(250, 50)),
      //           shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(0.0),
      //             ),
      //           ),
      //           backgroundColor: WidgetStateProperty.all(Colors.white),
      //         ),
      //         onPressed: () {
      //           // Navigator.push(
      //           //     context,
      //           //     MaterialPageRoute(
      //           //         builder: (context) => const OrderSuccess()));

      //           bottomDetailsScreen(
      //             context: context,
      //             qtyB: totalCountNotifier.value,
      //             priceB: totalQtyBasedPrice1,
      //             deliveryB: 50,
      //           );
      //         },
      //         child:
      //             // Text(
      //             //   '$totalqty1 Items | ₹ ${totalQtyBasedPrice1}',
      //             //   style: TextStyle(color: Colors.purple, fontSize: 18),
      //             // ),

      //             // Text(totalCountNotifier.value.toString()),

      //             AutoSizeText(
      //           '$totalqty1 Items | ₹ ${totalQtyBasedPrice1 + (totalQtyBasedPrice1 == 0 ? 0 : 50)}',
      //           minFontSize: 18,
      //           maxFontSize: 24,
      //           maxLines: 1, // Adjust this value as needed
      //           overflow: TextOverflow.ellipsis, // Handle overflow text
      //           style: const TextStyle(
      //             fontWeight: FontWeight.bold,
      //             color: primaryColor,
      //           ),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: ElevatedButton(
      //         style: ButtonStyle(
      //           minimumSize: WidgetStateProperty.all(const Size(250, 50)),
      //           shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      //               RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(0.0),
      //           )),
      //           backgroundColor: WidgetStateProperty.all(primaryColor),
      //         ),
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => OrderingFor(
      //                 totalPrice: totalQtyBasedPrice1,
      //                 totalQty: totalqty1,
      //                 selectedFoods: orderedFoods,
      //                 qty: qty,
      //                 productCategory: 'freshCuts',
      //               ),
      //             ),
      //           );
      //         },
      //         child: const Text(
      //           'Proceed',
      //           style: TextStyle(color: Colors.white, fontSize: 24),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ProductItems extends StatefulWidget {
  const ProductItems({
    super.key,
    required this.productName,
    required this.sellingPrice,
    required this.oldPrice,
    required this.imageUrl,
    required this.ontapIncrement,
    required this.ontapDecrement,
    required this.category,
    required this.productId,
    required this.userId,
  });

  final String productName;
  final String sellingPrice;
  final String oldPrice;
  final String imageUrl;
  final Function ontapIncrement;
  final Function ontapDecrement;

  final String category;
  final String productId;
  final String userId;

  @override
  State<ProductItems> createState() => _ProductItemsState();
}

class _ProductItemsState extends State<ProductItems> {
  @override
  void initState() {
    super.initState();
    totalCountNotifier.value = 0;
  }

  final ValueNotifier<int> _countNotifier = ValueNotifier(0);

  final List<Map<String, dynamic>> selectedProductsWithDetails = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.60,
      width: MediaQuery.of(context).size.width * 0.45,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.imageUrl,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(widget.productName),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹ ${widget.oldPrice}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('₹ ${widget.sellingPrice}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: widget.ontapIncrement(),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: primaryColor,
                        ),
                        height: 38,
                        width: 38,
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_countNotifier.value > 0) {
                              _countNotifier.value--;

                              setState(() {
                                totalCountNotifier.value--;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            width: 2,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      child: ValueListenableBuilder<int>(
                        valueListenable: _countNotifier,
                        builder: (context, count, child) => Text('$count'),
                      ),
                    ),
                    InkWell(
                      onTap: widget.ontapDecrement(),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: primaryColor,
                        ),
                        height: 38,
                        width: 38,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _countNotifier.value++;
                            setState(() {
                              totalCountNotifier.value++;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void selectProduct() {
    selectedProductsWithDetails.add({
      'user_Id': widget.userId,
      'product_id': widget.productId,
      'sellingPrice': widget.sellingPrice,
      'categoryId': widget.category,
      'quantity': _countNotifier.toString(),
    });
  }

  void unSelectedProducts() {}

  // void unselectedProducts() {
  //   selectedProductsWithDetails.remove();
  // }

  // void unselectProduct(Product product) {
  //   if (selectedProducts.containsKey(product)) {
  //     selectedProducts.remove(product);
  //     final index = selectedProductsWithDetails.indexWhere(
  //         (map) => map['id'] == product.id); // Find corresponding map by ID
  //     if (index != -1) {
  //       selectedProductsWithDetails.removeAt(index);
  //     }
  //   }
  //   notifyListeners();
  // }
}

final ValueNotifier<int> totalCountNotifier = ValueNotifier(0);

class Product {
  final int userId;
  final int id;
  final String name;
  final double sellingPrice;
  final String category;
  final int quantity;

  const Product({
    required this.userId,
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.category,
    this.quantity = 1,
  });
}
