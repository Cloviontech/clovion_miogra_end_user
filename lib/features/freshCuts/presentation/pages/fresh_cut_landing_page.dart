import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/category.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/core/data.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/freshCuts/presentation/pages/fresh_cut_details.dart';
import 'package:miogra/features/freshCuts/presentation/pages/fresh_cuts_product_page.dart';
import 'package:miogra/features/search/search_page.dart';
import 'package:miogra/features/selectedproduct.dart';
import 'package:miogra/models/freshcuts/all_freshcutproducts_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:miogra/models/selectedproduct_model.dart';
import 'package:miogra/widgets/add_view.dart';

import '../../../shopping/presentation/pages/product_details.dart';

class FreshCutLandingPage extends StatefulWidget {
  const FreshCutLandingPage({super.key});

  @override
  State<FreshCutLandingPage> createState() => _FreshCutLandingPageState();
}

class _FreshCutLandingPageState extends State<FreshCutLandingPage> {
  static List<AllFreshcutproducts> allFreshcutproducts = [];

  List<Order> orders = [];
  final TextEditingController _controller = TextEditingController();
  List<Order> searchResults = [];
  bool showResults = false;

  List<FreshCuts> allProducts = [];
  List<FreshCuts> filteredFoodProducts = [];
  final TextEditingController searchController = TextEditingController();

  List images1 = [];
  List images2 = [];

  Future<dynamic> fetchImages() async {
    String url =
        'https://${ApiServices.ipAddress}/admin/banner_display/fresh_cuts';
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
  //     final response = await http.get(Uri.parse(url));

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
  //       log('Failed to fetch orders: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     log('Exception while fetching orders: $e');
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

  bool loadingFetchAllFreshcutproducts = true;

  Future<void> fetchAllFreshcutproducts() async {
    final response = await http.get(
        Uri.parse('https://${ApiServices.ipAddress}/all_freshcutproducts'));

    // if (response.statusCode == 200) {
    //   List<dynamic> jsonResponse = json.decode(response.body);

    //   setState(() {
    //     allFreshcutproducts = jsonResponse
    //         .map((data) => AllFreshcutproducts.fromJson(data))
    //         .toList();
    //     loadingFetchAllFreshcutproducts = false;
    //   });

    //   // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
    // } else {
    //   throw Exception('Failed to load products');
    // }
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        allFreshcutproducts = jsonResponse
            .map((data) => AllFreshcutproducts.fromJson(data))
            .toList();
        loadingFetchAllFreshcutproducts = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Timer? _timer;

  void loading() async {
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        // Check if widget is still mounted before setState
        setState(() {
          loadingFetchAllFreshcutproducts = !loadingFetchAllFreshcutproducts;
        });
      }
    });
  }

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

  @override
  void initState() {
    super.initState();
    // fetchAllFreshcutproducts();
    // fetchProducts();

    fetchImages();
    loading();
    _fetchAllProducts();
    shutDown();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if it exists
    super.dispose();
  }

  List<String> freshCutCate = [];

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
        : loadingFetchAllFreshcutproducts
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            : Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        // Search Bar

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

                        AddsView(images: images1),

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

                        const SizedBox(height: 10),

                        // Categories
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 15, top: 15),
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xE6434343),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 6,
                            ),
                            itemCount: freshCutCategories.length,
                            itemBuilder: (context, index) {
                              return categoryItem(
                                freshCutCategories[index]['image']!,
                                freshCutCategories[index]['name']!,
                                () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FreshcutsProductsPage(
                                        categoryName: 'fresh_cuts',
                                        subCategoryName:
                                            freshCutCategories[index]
                                                ['subCategory']!,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        // const Padding(
                        //   padding: EdgeInsets.only(
                        //     left: 10,
                        //     bottom: 15,
                        //     top: 15,
                        //   ),
                        //   child: Text(
                        //     "Trending Products",
                        //     style: TextStyle(
                        //       fontSize: 17,
                        //       fontWeight: FontWeight.w500,
                        //       color: Color(0xE6434343),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 130,
                        //   child: GridView.count(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 10, vertical: 10),
                        //     scrollDirection: Axis.horizontal,
                        //     crossAxisCount: 1,
                        //     childAspectRatio: .39,
                        //     mainAxisSpacing: 10,
                        //     children: [
                        //       rectangleBoxWithoutRatingWithQuantity(
                        //           'assets/images/phone.jpeg',
                        //           'Samsung Galaxy F14 (6GB RAM)',
                        //           '500g',
                        //           18000,
                        //           15000,
                        //           () {}),
                        //       rectangleBoxWithoutRatingWithQuantity(
                        //           'assets/images/phone2.jpeg',
                        //           'Redmit Note 12 Pro+ 5G',
                        //           '1kg',
                        //           18000,
                        //           15000,
                        //           () {}),
                        //       rectangleBoxWithoutRatingWithQuantity(
                        //           'assets/images/phone.jpeg',
                        //           'Samsung Galaxy F14 (6GB RAM)',
                        //           '500g',
                        //           18000,
                        //           15000,
                        //           () {}),
                        //       rectangleBoxWithoutRatingWithQuantity(
                        //           'assets/images/phone2.jpeg',
                        //           'Redmit Note 12 Pro+ 5G',
                        //           '1kg',
                        //           18000,
                        //           15000,
                        //           () {}),
                        //       rectangleBoxWithoutRatingWithQuantity(
                        //           'assets/images/phone.jpeg',
                        //           'Samsung Galaxy F14 (6GB RAM)',
                        //           '500g',
                        //           18000,
                        //           15000,
                        //           () {}),
                        //       rectangleBoxWithoutRatingWithQuantity(
                        //           'assets/images/phone2.jpeg',
                        //           'Redmit Note 12 Pro+ 5G',
                        //           '1kg',
                        //           18000,
                        //           15000,
                        //           () {}),
                        //     ],
                        //   ),
                        // ),

                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            'All fresh cut products',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        FutureBuilder<dynamic>(
                          future: fetchAllFreshCutProducts(),
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

                              if (data != null &&
                                  data is List &&
                                  data.isNotEmpty) {
                                return GridView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  itemCount: dataLength,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 2,
                                    childAspectRatio: .85,
                                  ),
                                  itemBuilder: (context, index) {
                                    final imageUrl = data[index]['product']
                                            ['primary_image']
                                        ?.toString();
                                    final productName = data[index]['product']
                                            ['model_name']
                                        .toString()
                                        .toUpperCase();
                                    final discountPrice =
                                        data[index]['product']['selling_price'];
                                    final actualprice =
                                        data[index]['product']['actual_price'];
                                    final rating = data[index]['rating'] ?? 0.0;

                                    // final subcategory = data[index]['product']['subcategory'];
                                    final productid = data[index]['product_id'];
                                    final shopeid = data[index]['fresh_id'];
                                    final category = data[index]['category'];

                                    return productBox(
                                      imageUrl: imageUrl.toString(),
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
                                            builder: (context) =>
                                                FreshCutProductDetails (
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

                        // Today Deals
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xffF0E6EF),
                          ),
                          child: const Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(left: 10, bottom: 10),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       const Text(
                              //         "Today Deals",
                              //         style: TextStyle(
                              //           fontSize: 17,
                              //           fontWeight: FontWeight.w500,
                              //           color: Color(0xE6434343),
                              //         ),
                              //       ),
                              //       Row(
                              //         mainAxisSize: MainAxisSize.min,
                              //         mainAxisAlignment: MainAxisAlignment.end,
                              //         children: [
                              //           TextButton(
                              //             onPressed: () {},
                              //             child: const Row(
                              //               mainAxisSize: MainAxisSize.min,
                              //               children: [
                              //                 Text(
                              //                   "View All",
                              //                   style: TextStyle(
                              //                       color: Color(0xff870081)),
                              //                 ),
                              //                 SizedBox(
                              //                   width: 7,
                              //                 ),
                              //                 Icon(
                              //                   Icons.arrow_circle_right_rounded,
                              //                   color: Color(0xff870081),
                              //                 ),
                              //               ],
                              //             ),
                              //           )
                              //         ],
                              //       )
                              //     ],
                              //   ),
                              // ),

                              // Column(
                              //   children: [
                              //     // Text(allShopproducts.length.toString()),
                              //     // Text(qty.length.toString()),
                              //     GridView.builder(
                              //       padding:
                              //           const EdgeInsets.symmetric(horizontal: 10),
                              //       shrinkWrap: true,
                              //       primary: false,
                              //       itemCount: allFreshcutproducts.length,
                              //       controller: ScrollController(),
                              //       physics: const NeverScrollableScrollPhysics(),
                              //       gridDelegate:
                              //           const SliverGridDelegateWithFixedCrossAxisCount(
                              //         // crossAxisCount: 2,
                              //         // mainAxisSpacing: 15,
                              //         // childAspectRatio: 2.1

                              //         crossAxisSpacing: 5,
                              //         crossAxisCount: 2,
                              //         mainAxisSpacing: 5,
                              //         childAspectRatio: .85,
                              //       ),
                              //       itemBuilder: (context, index) {
                              //         return productBox(
                              //           imageUrl: allFreshcutproducts[index]
                              //               .product
                              //               .primaryImage
                              //               .toString(),
                              //           rating: 0,
                              //           pName: allFreshcutproducts[index]
                              //               .product
                              //               .name![0],
                              //           oldPrice: int.parse(
                              //               allFreshcutproducts[index]
                              //                   .product
                              //                   .actualPrice[0]),
                              //           newPrice: allFreshcutproducts[index]
                              //               .product
                              //               .sellingPrice,
                              //           offer: int.parse(allFreshcutproducts[index]
                              //               .product
                              //               .discountPrice[0]),
                              //           color: const Color(0x6B870081),
                              //           onTap: () {
                              //             Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     FreshCutProductDetailsPage(
                              //                   link: 'single_freshproduct',
                              //                   shopId: allFreshcutproducts[index]
                              //                       .freshId,
                              //                   productId:
                              //                       allFreshcutproducts[index]
                              //                           .productId,
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //         );

                              //                           Container(
                              //                             // padding: const EdgeInsets.only(top: 7),
                              //                             child: Row(
                              //                               children: [
                              //                                 Expanded(
                              //                                   flex: 2,
                              //                                   child: Column(
                              //                                     children: [
                              // //  Text(foodGetProducts.length.toString()),

                              //                                       // Text(foods![index].foodId.toString()),
                              //                                       Expanded(
                              //                                         flex: 3,
                              //                                         child: Container(
                              //                                           margin: const EdgeInsets.symmetric(
                              //                                               horizontal: 10),
                              //                                           decoration: BoxDecoration(
                              //                                             image: DecorationImage(
                              //                                               // image: AssetImage(
                              //                                               //     'assets/images/appliances.jpeg'),

                              //                                               image: NetworkImage(
                              //                                                 // foods![index]
                              //                                                 allShopproducts[index]
                              //                                                     .product
                              //                                                     .primaryImage
                              //                                                     .toString(),
                              //                                               ),
                              //                                               fit: BoxFit.fill,
                              //                                             ),
                              //                                             borderRadius:
                              //                                                 const BorderRadius.all(
                              //                                                     Radius.circular(15)),
                              //                                           ),
                              //                                         ),
                              //                                       ),
                              //                                       Expanded(
                              //                                         child: SizedBox(
                              //                                           child: Row(
                              //                                             mainAxisSize: MainAxisSize.min,
                              //                                             children: [
                              //                                               InkWell(
                              //                                                 onTap: () {
                              //                                                   updateValueDec(index);

                              //                                                   calcTotalPriceWithResQty();
                              //                                                 },
                              //                                                 child: Container(
                              //                                                   decoration:
                              //                                                       const BoxDecoration(
                              //                                                     color: Color(0xff870081),
                              //                                                     borderRadius:
                              //                                                         BorderRadius.only(
                              //                                                       topLeft:
                              //                                                           Radius.circular(5),
                              //                                                       bottomLeft:
                              //                                                           Radius.circular(5),
                              //                                                     ),
                              //                                                   ),
                              //                                                   height: 30,
                              //                                                   width: 30,
                              //                                                   alignment: Alignment.center,
                              //                                                   child: const Text(
                              //                                                     "-",
                              //                                                     style: TextStyle(
                              //                                                         color: Colors.white,
                              //                                                         fontSize: 25),
                              //                                                   ),
                              //                                                 ),
                              //                                               ),
                              //                                               Container(
                              //                                                 height: 30,
                              //                                                 width: 35,
                              //                                                 alignment: Alignment.center,
                              //                                                 decoration: BoxDecoration(
                              //                                                     border: Border.all(
                              //                                                         color: const Color(
                              //                                                             0xff870081))),
                              //                                                 child: Text(
                              //                                                   // _quantity
                              //                                                   //     .toString(),
                              //                                                   qty[index].toString(),
                              //                                                   style: const TextStyle(
                              //                                                       color: Color(0xff870081),
                              //                                                       fontSize: 20,
                              //                                                       fontWeight:
                              //                                                           FontWeight.w500),
                              //                                                 ),
                              //                                               ),
                              //                                               GestureDetector(
                              //                                                 onTap: () {
                              //                                                   updateValueInc(index);

                              //                                                   calcTotalPriceWithResQty();
                              //                                                 },
                              //                                                 child: Container(
                              //                                                   decoration:
                              //                                                       const BoxDecoration(
                              //                                                           color:
                              //                                                               Color(0xff870081),
                              //                                                           borderRadius:
                              //                                                               BorderRadius.only(
                              //                                                             topRight:
                              //                                                                 Radius.circular(
                              //                                                                     5),
                              //                                                             bottomRight:
                              //                                                                 Radius.circular(
                              //                                                                     5),
                              //                                                           )),
                              //                                                   height: 30,
                              //                                                   width: 30,
                              //                                                   alignment: Alignment.center,
                              //                                                   child: const Text(
                              //                                                     "+",
                              //                                                     style: TextStyle(
                              //                                                         color: Colors.white,
                              //                                                         fontSize: 25),
                              //                                                   ),
                              //                                                 ),
                              //                                               ),
                              //                                             ],
                              //                                           ),
                              //                                         ),
                              //                                       ),
                              //                                     ],
                              //                                   ),
                              //                                 ),
                              //                                 Expanded(
                              //                                   flex: 3,
                              //                                   child: Column(
                              //                                     crossAxisAlignment:
                              //                                         CrossAxisAlignment.start,
                              //                                     children: [
                              //                                       Expanded(
                              //                                         // flex: 3,
                              //                                         child: Column(
                              //                                           crossAxisAlignment:
                              //                                               CrossAxisAlignment.start,
                              //                                           children: [
                              //                                             Text(
                              //                                               // "Chiken Manchurian",
                              //                                               allShopproducts[index]
                              //                                                   .product!
                              //                                                   .name[0],
                              //                                               maxLines: 2,
                              //                                               overflow: TextOverflow.ellipsis,
                              //                                               style: const TextStyle(
                              //                                                 fontSize: 19,
                              //                                                 color: Color(0xE6434343),
                              //                                                 fontWeight: FontWeight.w500,
                              //                                               ),
                              //                                             ),
                              //                                             const SizedBox(
                              //                                               height: 10,
                              //                                             ),
                              //                                             Text(
                              //                                               // "₹150",
                              //                                               '₹ ${allShopproducts[index].product!.sellingPrice}',
                              //                                               style: const TextStyle(
                              //                                                   fontSize: 19,
                              //                                                   color: Color(0xE6434343)),
                              //                                             ),
                              //                                             const SizedBox(
                              //                                               height: 10,
                              //                                             ),
                              //                                             GestureDetector(
                              //                                               onTap: () {
                              //                                                 showModalBottomSheet(
                              //                                                     shape: const RoundedRectangleBorder(
                              //                                                         borderRadius:
                              //                                                             BorderRadius.vertical(
                              //                                                                 top: Radius
                              //                                                                     .circular(
                              //                                                                         20))),
                              //                                                     context: context,
                              //                                                     builder: (context) {
                              //                                                       return Container(
                              //                                                         child: Padding(
                              //                                                           padding:
                              //                                                               const EdgeInsets
                              //                                                                   .all(30.0),
                              //                                                           child: Column(
                              //                                                             children: [
                              //                                                               // temperory used for description
                              //                                                               Container(
                              //                                                                 decoration: BoxDecoration(
                              //                                                                     borderRadius:
                              //                                                                         BorderRadius.circular(
                              //                                                                             20)),
                              //                                                                 child: Image.network(
                              //                                                                     allShopproducts[
                              //                                                                             index]
                              //                                                                         .product!
                              //                                                                         .primaryImage!),
                              //                                                               ),
                              //                                                               const SizedBox(
                              //                                                                 height: 50,
                              //                                                               ),
                              //                                                               Text(
                              //                                                                 allShopproducts[
                              //                                                                         index]
                              //                                                                     .product!
                              //                                                                     .otherImages![0],
                              //                                                               )
                              //                                                             ],
                              //                                                           ),
                              //                                                         ),
                              //                                                       );
                              //                                                     });
                              //                                               },
                              //                                               child: Text(
                              //                                                 // temperory used for description

                              //                                                 allShopproducts[index]
                              //                                                     .product!
                              //                                                     .otherImages![0],

                              //                                                 maxLines: 3,
                              //                                                 overflow: TextOverflow.ellipsis,
                              //                                                 style: const TextStyle(
                              //                                                     fontSize: 15,
                              //                                                     color: Color(0xE6434343)),
                              //                                               ),
                              //                                             ),
                              //                                           ],
                              //                                         ),
                              //                                       ),
                              //                                       // const Expanded(child: SizedBox()),
                              //                                     ],
                              //                                   ),
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           );
                              //       },
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 20,
                              ),

                              // GridView.builder(
                              //   shrinkWrap: true,
                              //   primary: false,
                              //   padding:
                              //       const EdgeInsets.only(left: 5, right: 5),
                              //   gridDelegate:
                              //       const SliverGridDelegateWithFixedCrossAxisCount(
                              //           crossAxisCount: 2,
                              //           crossAxisSpacing: 5,
                              //           mainAxisSpacing: 5,
                              //           childAspectRatio: .75),
                              //   itemCount: 4,
                              //   itemBuilder: (context, index) {
                              //     return productWithCounter();
                              //   },
                              // ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                            ],
                          ),
                        ),
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
          // FocusScope.of(context).unfocus();
          setState(() {
            // showSuggestions = false;
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

  Future<dynamic> fetchAllFreshCutProducts() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url = 'https://${ApiServices.ipAddress}/all_freshcutproducts';
    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Featching Data');
        final data = json.decode(response.body);

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

  void _fetchAllProducts() async {
    // Replace with your actual API call and data parsing logic
    final response =
        await http.get(Uri.parse('https://miogra.clovion.org/all_freshcutproducts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allProducts =
            (data as List).map((item) => FreshCuts.fromJson(item)).toList();
        filteredFoodProducts = allProducts; // Initially show all products
      });
    } else {
      // Handle API request error
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

class FreshCuts {
  final String name;

  FreshCuts.fromJson(Map<String, dynamic> json)
      : name = json['product']['model_name'];
}
