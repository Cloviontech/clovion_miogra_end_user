import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/category.dart';
import 'package:miogra/core/data.dart';
import 'package:miogra/features/dailyMio/models/all_dmioproducts_model.dart';
import 'package:miogra/features/dailyMio/presentation/pages/daily_category_products.dart';
import 'package:miogra/features/search/search_page.dart';
import 'package:miogra/features/selectedproduct.dart';

import 'package:http/http.dart' as http;
import 'package:miogra/models/selectedproduct_model.dart';
import 'package:miogra/widgets/add_view.dart';

import '../../../../core/api_services.dart';
import '../../../../core/colors.dart';
import 'd_mio_single_product_details_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class DailyMioLandingPage extends StatefulWidget {
  const DailyMioLandingPage({super.key});

  @override
  State<DailyMioLandingPage> createState() => _DailyMioLandingPageState();
}

class _DailyMioLandingPageState extends State<DailyMioLandingPage> {
  List<Order> orders = [];
  // final TextEditingController _controller = TextEditingController();
  List<Order> searchResults = [];
  bool showResults = false;

  List images1 = [];
  List images2 = [];

  Future<dynamic> fetchImages() async {
    String url =
        'https://${ApiServices.ipAddress}/admin/banner_display/daily_mio';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Validate data type as a list
        if (data is List) {
          final jsonData = data;
          setState(() {
            // images1 = jsonData[0]['banner_list1']?.cast<String>() ?? [];
            images2 = jsonData[0]['banner_list2']?.cast<String>() ?? [];
            setState(() {
              images1 = jsonData[0]['banner_list1']?.cast<String>() ?? [];
            });
          });
        } else {
          log('Unexpected data structure: ${data.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load data from URL: $url (Status code: ${response.statusCode})');
      }
    } catch (e) {
      // Handle general exceptions with a user-friendly message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while fetching images.'),
        ),
      );
      rethrow; // Rethrow for further handling if necessary
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Call fetchProducts when the widget is initialized
  //   fetchProducts();
  // }

  // Future<void> fetchProducts() async {
  //   // final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   const url =
  //       'https://${ApiServices.ipAddress}/user_get_all_shopproducts/QMC77LVGSXM/ID7KRF1K7K8';

  //   try {
  //     final response = await https.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);

  //       setState(() {
  //         orders.clear();
  //         for (var item in jsonData) {
  //           Order order = Order(
  //             model_name: item['product']['model_name'],
  //             model_brand: item['product']['model_brand'],
  //             model_actual_price: item['product']['model_actual_price'],
  //             model_discount_price: item['product']['model_discount_price'],
  //           );
  //           orders.add(order);
  //         }
  //       });
  //     } else {
  //       print('Failed to fetch orders: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception while fetching orders: $e');
  //   }
  // }

  void searchOrders(String query) {
    if (query.isEmpty) {
      setState(() {
        showResults = false;
        searchResults.clear();
      });
      return;
    }
    setState(() {
      showResults = true;
      searchResults.clear();
      searchResults
          .addAll(orders.where((order) => order.model_name.contains(query)));
    });
  }

  void onOrderClicked(Order order) {
    // Handle click on order
    print('Order clicked: ${order.model_name}');
    // Navigate to the selected product page and pass the selected Order object
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectedProduct(order: order)),
    );
  }

  List orderedFoods = [];
  List<int> qty = [];

  // void updateValueInc(int index1) {
  //   print('update quantity');
  //   setState(() {
  //     // Increment the value at the specified index
  //     // if (index >= 0 && index < qty.length) {
  //     // qty[index1] = qty[index1] + 1;

  //     qty[index1]++;

  //     if (!(orderedFoods.any((list) =>
  //         list.toString() ==
  //         [allDmioproducts[index1].dmioId, allDmioproducts[index1].productId]
  //             .toString()))) {
  //       setState(() {
  //         orderedFoods.insert(index1, [
  //           allDmioproducts[index1].dmioId,
  //           allDmioproducts[index1].productId
  //         ]);

  //         print(orderedFoods);
  //       });
  //     }
  //   });
  //   print(qty.toString());
  //   print(qty.length);
  //   print(qty[index1]);
  //   print(index1 + 1);
  // }

  // void updateValueDec(int index1) {
  //   if (qty[index1] >= 1) {
  //     setState(() {
  //       qty[index1]--;
  //     });
  //   } else {}

  //   if (qty[index1] == 0) {
  //     setState(() {
  //       orderedFoods.removeAt(
  //         index1,

  //         //  [
  //         //   product[index1].foodId,
  //         //   product[index1].productId
  //         // ]
  //       );

  //       print('orderedFoods remove : $orderedFoods');
  //     });
  //   }
  // }

  List<int> totalQtyBasedPrice = [];

  List<int> totalqty = [];

  int totalQtyBasedPrice1 = 0;

  int totalqty1 = 0;

  // calcTotalPriceWithResQty() {
  //   setState(() {
  //     totalQtyBasedPrice1 = 0;
  //     totalQtyBasedPrice = [];
  //     totalqty1 = 0;
  //     totalqty = [];
  //   });
  //   // totalQuantity = 0;
  //   for (var i = 0; i < allDmioproducts.length; i++) {
  //     setState(() {
  //       totalQtyBasedPrice
  //           .add(allDmioproducts[i].product.sellingPrice.toInt() * qty[i]);

  //       totalqty.add(qty[i]);
  //     });
  //   }

  //   setState(() {
  //     totalQtyBasedPrice1 =
  //         totalQtyBasedPrice.reduce((value, element) => value + element);

  //     totalqty1 = totalqty.reduce((value, element) => value + element);
  //   });

  //   print('totalQtyBasedPrice1 $totalQtyBasedPrice1');
  // }

  bool loadingFetchAllDmioproducts = true;

  List<AllDmioproducts> allDmioproducts = [];

  List<DailyProduct> allProducts = [];
  List<DailyProduct> filteredFoodProducts = [];
  final TextEditingController searchController = TextEditingController();

  // Future<void> fetchAllShopproducts() async {
  //   final response = await https
  //       .get(Uri.parse('https://${ApiServices.ipAddress}/all_dmioproducts/'));

  //   debugPrint('https://${ApiServices.ipAddress}/all_dmioproducts');

  //   debugPrint(response.statusCode.toString());

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonResponse = json.decode(response.body);

  //     setState(() {
  //       allDmioproducts =
  //           jsonResponse.map((data) => AllDmioproducts.fromJson(data)).toList();
  //       loadingFetchAllDmioproducts = false;
  //     });

  //     // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  bool shope = true;
  Future<dynamic> shutDown() async {
    String url = 'https://${ApiServices.ipAddress}/admin/get_shutdown';

    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());
      log('Data loading***********');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          log(data.toString());

          setState(() {
            shope = data[0]['shopping'];
          });
          log('upi$shope');

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

  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    fetchImages();
    // fetchAllShopproducts().whenComplete(
    //     () => qty = List<int>.generate(allDmioproducts.length, (index) => 0));
    // fetchProducts();
    _fetchAllProducts();
    shutDown();
  }

  @override
  Widget build(BuildContext context) {
    return shope == false
        ? const SizedBox(
            child: Center(
              child: Text(
                'Shope Temporary Shutdown!\nComming Soon...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // Search Bar

                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 20),
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: const Color(0xff870081),
                    //       width: 1.3,
                    //     ),
                    //     borderRadius: const BorderRadius.all(
                    //       Radius.circular(15),
                    //     ),
                    //   ),
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Expanded(
                    //         // Replace Text widget with TextField widget
                    //         child: TextField(
                    //           controller: _controller,
                    //           decoration: InputDecoration(
                    //             hintText: "Search in miogra", // Placeholder text
                    //             hintStyle: TextStyle(
                    //               color: Colors.grey.shade500,
                    //               fontSize: 16,
                    //             ),
                    //             border: InputBorder.none, // Remove border
                    //           ),
                    //           style: const TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 16,
                    //           ), // Text style
                    //           onChanged: (text) {
                    //             // Handle text input changes
                    //             print('Input: $text');
                    //             searchOrders(text);
                    //           },
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           // Perform the same action as onOrderClicked when the icon is tapped
                    //           if (searchResults.isNotEmpty) {
                    //             onOrderClicked(searchResults[0]);
                    //           }
                    //         },
                    //         child: const Icon(
                    //           Icons.search_rounded,
                    //           color: Color(0xff870081),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: textFeild(context),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchScreen()));
                      },
                      child: Visibility(
                        visible: showSuggestions,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 246, 213, 248),
                            ),
                            duration: const Duration(microseconds: 1000),
                            curve: Curves.easeInToLinear,
                            height: showSuggestions ? 300 : 0,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Divider(
                                  color: Colors.grey[500],
                                  thickness: 0.5,
                                ),
                              ),
                              itemCount: filteredFoodProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredFoodProducts[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Text(product.name),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Display search results here
                    if (showResults)
                      Column(
                        children: searchResults.map((order) {
                          return GestureDetector(
                            onTap: () => onOrderClicked(order),
                            child: ListTile(
                              title: Text(order.model_name),
                              subtitle: Text(order.model_brand),
                              // Add more widgets to display other details if needed
                            ),
                          );
                        }).toList(),
                      ),

                    //advertisment Widget
                    AddsView(images: images1),

                    // Categories
                    const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 15, top: 15),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xE6434343)),
                      ),
                    ),

                    SizedBox(
                      height: 203,
                      child: GridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 7,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: dailyMioCategories.length,
                        itemBuilder: (context, index) {
                          return categoryItem(
                              dailyMioCategories[index]['image']!,
                              dailyMioCategories[index]['name']!, () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DailyProducts(
                                  categoryName: 'daily_mio',
                                  subCategoryName: dailyMioCategories[index]
                                          ['sub_cat']
                                      .toString(),
                                ),

                                //     DailyMioCategoryBasedProductsScreen(
                                //   subCategory: dailyMioCategories[index]['name']!,
                                // ),
                              ),
                            );
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        bottom: 15,
                        top: 15,
                      ),
                      child: Text(
                        "Daily Needs",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xE6434343),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 130,
                    //   child: GridView.count(
                    //     padding:
                    //         const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //     scrollDirection: Axis.horizontal,
                    //     crossAxisCount: 1,
                    //     childAspectRatio: .39,
                    //     mainAxisSpacing: 10,
                    //     children: [
                    //       rectangleBoxWithoutRatings('assets/images/phone.jpeg',
                    //           'Samsung Galaxy F14 (6GB RAM)', 18000, 15000, () {}),
                    //       rectangleBoxWithoutRatings('assets/images/phone2.jpeg',
                    //           'Redmit Note 12 Pro+ 5G', 18000, 15000, () {}),
                    //       rectangleBoxWithoutRatings('assets/images/phone.jpeg',
                    //           'Samsung Galaxy F14 (6GB RAM)', 18000, 15000, () {}),
                    //       rectangleBoxWithoutRatings('assets/images/phone2.jpeg',
                    //           'Redmit Note 12 Pro+ 5G', 18000, 15000, () {}),
                    //       rectangleBoxWithoutRatings('assets/images/phone.jpeg',
                    //           'Samsung Galaxy F14 (6GB RAM)', 18000, 15000, () {}),
                    //       rectangleBoxWithoutRatings('assets/images/phone2.jpeg',
                    //           'Redmit Note 12 Pro+ 5G', 18000, 15000, () {}),
                    //     ],
                    //   ),
                    // ),

                    FutureBuilder<dynamic>(
                      future: fetchDataFromListJson(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dataLength,
                              itemBuilder: (context, index) {
                                final imageUrl = data[index]['product']
                                        ['primary_image']
                                    .toString();
                                final productName = data[index]['product']
                                        ['model_name']
                                    .toString()
                                    .toUpperCase();
                                final sellingPrice =
                                    data[index]['product']['selling_price'];
                                final description = data[index]['product']
                                    ['product_description'];

                                final subcategory =
                                    data[index]['product']['subcategory'];
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
                                        builder: (context) =>
                                            DMioSingleProductDetailsScreen(
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
                                        color: const Color.fromARGB(
                                            255, 241, 241, 241),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            primaryColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                              description:
                                                                  description,
                                                              name: productName,
                                                              price:
                                                                  "$sellingPrice/-",
                                                              primaryImage:
                                                                  imageUrl
                                                                      .toString(),
                                                              productid:
                                                                  productid,
                                                              subcategory:
                                                                  subcategory,
                                                              shopeid: shopeid,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Get Once'),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            primaryColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                              'Item Suscribed',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Suscibie'),
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
                    const SizedBox(
                      height: 30,
                    ),

                    // Today Deals
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(15)),
                    //     color: Color(0xffF0E6EF),
                    //   ),
                    //   child: Column(
                    //     children: <Widget>[
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       const Padding(
                    //         padding: EdgeInsets.only(left: 10, bottom: 10),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Suggested Products",
                    //               style: TextStyle(
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Color(0xE6434343),
                    //               ),
                    //             ),
                    //             // Row(
                    //             //   mainAxisSize: MainAxisSize.min,
                    //             //   mainAxisAlignment: MainAxisAlignment.end,
                    //             //   children: [
                    //             //     TextButton(
                    //             //       onPressed: () {},
                    //             //       child: const Row(
                    //             //         mainAxisSize: MainAxisSize.min,
                    //             //         children: [
                    //             //           Text(
                    //             //             "View All",
                    //             //             style: TextStyle(color: Color(0xff870081)),
                    //             //           ),
                    //             //           SizedBox(
                    //             //             width: 7,
                    //             //           ),
                    //             //           Icon(
                    //             //             Icons.arrow_circle_right_rounded,
                    //             //             color: Color(0xff870081),
                    //             //           ),
                    //             //         ],
                    //             //       ),
                    //             //     )
                    //             //   ],
                    //             // )
                    //           ],
                    //         ),
                    //       ),

                    //       GridView.builder(
                    //         padding: EdgeInsets.zero,
                    //         shrinkWrap: true,
                    //         primary: false,
                    //         itemCount: allDmioproducts.length,
                    //         controller: ScrollController(),
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         gridDelegate:
                    //             const SliverGridDelegateWithFixedCrossAxisCount(
                    //                 crossAxisCount: 1,
                    //                 mainAxisSpacing: 15,
                    //                 childAspectRatio: 2.1),
                    //         itemBuilder: (context, index) {
                    //           return Container(
                    //             // padding: const EdgeInsets.only(top: 7),
                    //             child: Row(
                    //               children: [
                    //                 Expanded(
                    //                   flex: 4,
                    //                   child: Column(
                    //                     children: [
                    //                       //  Text(product.length.toString()),

                    //                       // Text(foods![index].foodId.toString()),
                    //                       Expanded(
                    //                         flex: 3,
                    //                         child: Container(
                    //                           margin: const EdgeInsets.symmetric(
                    //                               horizontal: 10),
                    //                           decoration: BoxDecoration(
                    //                             image: DecorationImage(
                    //                               // image: AssetImage(
                    //                               //     'assets/images/appliances.jpeg'),

                    //                               image: NetworkImage(
                    //                                 // foods![index]
                    //                                 allDmioproducts[index]
                    //                                     .product
                    //                                     .primaryImage
                    //                                     .toString(),
                    //                               ),
                    //                               fit: BoxFit.fill,
                    //                             ),
                    //                             borderRadius: const BorderRadius.all(
                    //                                 Radius.circular(15)),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Expanded(
                    //                         child: SizedBox(
                    //                           child: Row(
                    //                             mainAxisSize: MainAxisSize.min,
                    //                             children: [
                    //                               InkWell(
                    //                                 onTap: () {
                    //                                   // updateValueDec(index);

                    //                                   // calcTotalPriceWithResQty();
                    //                                 },
                    //                                 child: Container(
                    //                                   decoration: const BoxDecoration(
                    //                                     color: Color(0xff870081),
                    //                                     borderRadius:
                    //                                         BorderRadius.only(
                    //                                       topLeft: Radius.circular(5),
                    //                                       bottomLeft:
                    //                                           Radius.circular(5),
                    //                                     ),
                    //                                   ),
                    //                                   height: 30,
                    //                                   width: 30,
                    //                                   alignment: Alignment.center,
                    //                                   child: const Text(
                    //                                     "-",
                    //                                     style: TextStyle(
                    //                                         color: Colors.white,
                    //                                         fontSize: 25),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               Container(
                    //                                 height: 30,
                    //                                 width: 35,
                    //                                 alignment: Alignment.center,
                    //                                 decoration: BoxDecoration(
                    //                                     border: Border.all(
                    //                                         color: const Color(
                    //                                             0xff870081))),
                    //                                 child: Text(
                    //                                   // _quantity
                    //                                   //     .toString(),
                    //                                   qty[index].toString(),
                    //                                   style: const TextStyle(
                    //                                       color: Color(0xff870081),
                    //                                       fontSize: 20,
                    //                                       fontWeight:
                    //                                           FontWeight.w500),
                    //                                 ),
                    //                               ),
                    //                               GestureDetector(
                    //                                 onTap: () {
                    //                                   // updateValueInc(index);

                    //                                   // calcTotalPriceWithResQty();
                    //                                 },
                    //                                 child: Container(
                    //                                   decoration: const BoxDecoration(
                    //                                       color: Color(0xff870081),
                    //                                       borderRadius:
                    //                                           BorderRadius.only(
                    //                                         topRight:
                    //                                             Radius.circular(5),
                    //                                         bottomRight:
                    //                                             Radius.circular(5),
                    //                                       )),
                    //                                   height: 30,
                    //                                   width: 30,
                    //                                   alignment: Alignment.center,
                    //                                   child: const Text(
                    //                                     "+",
                    //                                     style: TextStyle(
                    //                                         color: Colors.white,
                    //                                         fontSize: 25),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Expanded(
                    //                   flex: 6,
                    //                   child: Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Expanded(
                    //                         // flex: 3,
                    //                         child: Column(
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: [
                    //                             Text(
                    //                               // "Chiken Manchurian",
                    //                               allDmioproducts[index]
                    //                                   .product
                    //                                   .name[0],
                    //                               maxLines: 2,
                    //                               overflow: TextOverflow.ellipsis,
                    //                               style: const TextStyle(
                    //                                 fontSize: 19,
                    //                                 color: Color(0xE6434343),
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             ),
                    //                             const SizedBox(
                    //                               height: 10,
                    //                             ),
                    //                             Text(
                    //                               // "₹150",
                    //                               '₹ ${allDmioproducts[index].product.sellingPrice}',
                    //                               style: const TextStyle(
                    //                                   fontSize: 19,
                    //                                   color: Color(0xE6434343)),
                    //                             ),
                    //                             const SizedBox(
                    //                               height: 10,
                    //                             ),
                    //                             GestureDetector(
                    //                               onTap: () {
                    //                                 showModalBottomSheet(
                    //                                     shape: const RoundedRectangleBorder(
                    //                                         borderRadius:
                    //                                             BorderRadius.vertical(
                    //                                                 top: Radius
                    //                                                     .circular(
                    //                                                         20))),
                    //                                     context: context,
                    //                                     builder: (context) {
                    //                                       return Container(
                    //                                         child: Padding(
                    //                                           padding:
                    //                                               const EdgeInsets
                    //                                                   .all(30.0),
                    //                                           child: Column(
                    //                                             children: [
                    //                                               // temperory used for description
                    //                                               Container(
                    //                                                 decoration: BoxDecoration(
                    //                                                     borderRadius:
                    //                                                         BorderRadius
                    //                                                             .circular(
                    //                                                                 20)),
                    //                                                 child: Image.network(
                    //                                                     allDmioproducts[
                    //                                                             index]
                    //                                                         .product
                    //                                                         .primaryImage),
                    //                                               ),
                    //                                               const SizedBox(
                    //                                                 height: 50,
                    //                                               ),
                    //                                               Text(
                    //                                                 allDmioproducts[
                    //                                                         index]
                    //                                                     .product
                    //                                                     .otherImages[0],
                    //                                               )
                    //                                             ],
                    //                                           ),
                    //                                         ),
                    //                                       );
                    //                                     });
                    //                               },
                    //                               child: Text(
                    //                                 // temperory used for description

                    //                                 allDmioproducts[index]
                    //                                     .product
                    //                                     .otherImages[0],

                    //                                 maxLines: 3,
                    //                                 overflow: TextOverflow.ellipsis,
                    //                                 style: const TextStyle(
                    //                                     fontSize: 15,
                    //                                     color: Color(0xE6434343)),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                       // const Expanded(child: SizedBox()),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           );
                    //         },
                    //       ),

                    //       //       Column(
                    //       //   children: [
                    //       //     // Text(allShopproducts.length.toString()),
                    //       //     // Text(qty.length.toString()),

                    //       //     GridView.builder(
                    //       //       padding: const EdgeInsets.symmetric(horizontal: 10),
                    //       //       shrinkWrap: true,
                    //       //       primary: false,
                    //       //       itemCount: allDmioproducts.length,
                    //       //       controller: ScrollController(),
                    //       //       physics: NeverScrollableScrollPhysics(),
                    //       //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       //         // crossAxisCount: 2,
                    //       //         // mainAxisSpacing: 15,
                    //       //         // childAspectRatio: 2.1

                    //       //         crossAxisSpacing: 5,
                    //       //         crossAxisCount: 2,
                    //       //         mainAxisSpacing: 5,
                    //       //         childAspectRatio: .85,
                    //       //       ),
                    //       //       itemBuilder: (context, index) {
                    //       //         return

                    //       //          productWithCounterWithRatings(
                    //       //              allDmioproducts[index]
                    //       //                 .product
                    //       //                 .primaryImage
                    //       //                 .toString(),
                    //       //              allDmioproducts[index].product.name[0],
                    //       //              int.parse(allDmioproducts[index]
                    //       //                 .product
                    //       //                 .actualPrice[0]),

                    //       //                 allDmioproducts[index].product.sellingPrice,
                    //       //              int.parse(allDmioproducts[index]
                    //       //                 .product
                    //       //                 .discountPrice[0]),
                    //       //             // color: const Color(0x6B870081),
                    //       //             // page: () {
                    //       //             //   Navigator.push(
                    //       //             //       context,
                    //       //             //       MaterialPageRoute(
                    //       //             //           builder: (context) => ProductDetails(
                    //       //             //                 link: 'get_single_shopproduct',
                    //       //             //                 shopId: allDmioproducts[index]
                    //       //             //                     .product
                    //       //             //                     .dmioId,
                    //       //             //                 productId: allDmioproducts[index]
                    //       //             //                     .product
                    //       //             //                     .productId,
                    //       //             //               )));
                    //       //             // }

                    //       //             );

                    //       //         // productBox(
                    //       //         //     path: allDmioproducts[index]
                    //       //         //         .product
                    //       //         //         .primaryImage
                    //       //         //         .toString(),
                    //       //         //     pName: allDmioproducts[index].product.name[0],
                    //       //         //     oldPrice: int.parse(allDmioproducts[index]
                    //       //         //         .product
                    //       //         //         .actualPrice[0]),
                    //       //         //     newPrice:
                    //       //         //         allDmioproducts[index].product.sellingPrice,
                    //       //         //     offer: int.parse(allDmioproducts[index]
                    //       //         //         .product
                    //       //         //         .discountPrice[0]),
                    //       //         //     color: const Color(0x6B870081),
                    //       //         //     page: () {
                    //       //         //       Navigator.push(
                    //       //         //           context,
                    //       //         //           MaterialPageRoute(
                    //       //         //               builder: (context) => ProductDetails(
                    //       //         //                     link: 'get_single_shopproduct',
                    //       //         //                     shopId: allDmioproducts[index]
                    //       //         //                         .product
                    //       //         //                         .dmioId,
                    //       //         //                     productId: allDmioproducts[index]
                    //       //         //                         .product
                    //       //         //                         .productId,
                    //       //         //                   )));
                    //       //         //     });

                    //       //       },
                    //       //     ),
                    //       //   ],
                    //       // ),

                    //       // const SizedBox(
                    //       //   height: 20,
                    //       // ),

                    //       // GridView.builder(
                    //       //   shrinkWrap: true,
                    //       //   primary: false,
                    //       //   padding: const EdgeInsets.only(left: 5, right:5),
                    //       //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       //       crossAxisCount: 2,
                    //       //       crossAxisSpacing: 5,
                    //       //       mainAxisSpacing: 5,
                    //       //       childAspectRatio: .75
                    //       //   ),
                    //       //   itemCount: 4,
                    //       //   itemBuilder: (context, index) {
                    //       //     return productWithCounter();
                    //       //   },
                    //       // ),

                    //       const SizedBox(
                    //         height: 20,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
  }

  PreferredSize textFeild(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: TextField(
        onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchScreen()));
    },

        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          setState(() {
            showSuggestions = false;
          });
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5.0,
          ),
          hintText: 'Search in miogra',
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ),
        onChanged: (value) {
          _filterProducts(value);
        },
      ),
    );
  }

  void _fetchAllProducts() async {
    // Replace with your actual API call and data parsing logic
    final response =
        await http.get(Uri.parse('https://miogra.com/all_foodproducts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allProducts =
            (data as List).map((item) => DailyProduct.fromJson(item)).toList();
        filteredFoodProducts = allProducts; // Initially show all products
      });
    } else {
      // Handle API request error
    }
  }

  Future<dynamic> fetchDataFromListJson() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url = 'https://${ApiServices.ipAddress}/all_dmioproducts';
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

  void _filterProducts(String searchTerm) {
    filteredFoodProducts = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    setState(() {}); // Rebuild the UI with filtered products
  }

  bool showSuggestions = false;
}

class DailyProduct {
  final String name;

  DailyProduct.fromJson(Map<String, dynamic> json)
      : name = json['product']['model_name'];
}
