import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/category.dart';
import 'package:miogra/core/data.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/pharmacy/models/all_pharmproducts.dart';
import 'package:miogra/features/pharmacy/presentation/pages/pharmacy_item.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:miogra/features/pharmacy/presentation/pages/pharmacy_product_details.dart';
import 'package:miogra/features/search/search_page.dart';
import 'package:miogra/features/selectedproduct.dart';
import 'package:miogra/features/shopping/presentation/pages/shopping_product_details_page.dart';
import 'package:miogra/models/selectedproduct_model.dart';
import 'package:miogra/widgets/add_view.dart';

import '../../../../core/colors.dart';
import '../../../shopping/presentation/pages/product_details.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class PharmacyLandingPage extends StatefulWidget {
  const PharmacyLandingPage({super.key});

  @override
  State<PharmacyLandingPage> createState() => _PharmacyLandingPageState();
}

class _PharmacyLandingPageState extends State<PharmacyLandingPage> {
  List<Order> orders = [];
  final TextEditingController controller = TextEditingController();
  List<Order> searchResults = [];
  bool showResults = false;

  // @override
  // void initState() {
  //   super.initState();
  //   // Call fetchProducts when the widget is initialized
  //   fetchProducts();
  // }



  List images1 = [];
  List images2 = [];

  Future<dynamic> fetchImages() async {
    String url =
        'https://${ApiServices.ipAddress}/admin/banner_display/pharmacy';
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
    log('Order clicked: ${order.model_name}');
    // Navigate to the selected product page and pass the selected Order object
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectedProduct(order: order)),
    );
  }

  List<String> pharmCategories1 = ['allopathic', 'ayurvedic', 'sidda', 'unani'];

  bool loadingFetchAllPharmproducts = true;

  List<AllPharmproducts> allPharmproducts = [];

  List<PharmacyProducts> allProducts = [];
  List<PharmacyProducts> filteredFoodProducts = [];
  final TextEditingController searchController = TextEditingController();

  Future<void> fetchAllPharmproducts() async {
    final response = await http
        .get(Uri.parse('https://${ApiServices.ipAddress}/all_pharmproducts'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        allPharmproducts = jsonResponse
            .map((data) => AllPharmproducts.fromJson(data))
            .toList();
        loadingFetchAllPharmproducts = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  List orderedFoods = [];
  List<int> qty = [];

  void updateValueInc(int index1) {
    log('update quantity');
    setState(() {
      // Increment the value at the specified index
      // if (index >= 0 && index < qty.length) {
      // qty[index1] = qty[index1] + 1;

      qty[index1]++;

      if (!(orderedFoods.any((list) =>
          list.toString() ==
          [allPharmproducts[index1].pharmId, allPharmproducts[index1].productId]
              .toString()))) {
        setState(() {
          orderedFoods.insert(index1, [
            allPharmproducts[index1].pharmId,
            allPharmproducts[index1].productId
          ]);

          log('orderedFoods : $orderedFoods');
        });
      }

      // addToCart(foodGetProducts[index1].productId,
      //     foodGetProducts[index1].category, qty[index1]);
    });
    // log('orderedFoods : $orderedFoods');
    log(qty.toString());
    log(qty.length.toString());
    log(qty[index1].toString());
    log('${index1 + 1}'.toString());
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
          //   foodGetProducts[index1].foodId,
          //   foodGetProducts[index1].productId
          // ]
        );

        log('orderedFoods remove : $orderedFoods');
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
    for (var i = 0; i < allPharmproducts.length; i++) {
      setState(() {
        totalQtyBasedPrice
            .add(allPharmproducts[i].product.sellingPrice.toInt() * qty[i]);

        totalqty.add(qty[i]);
      });
    }

    setState(() {
      totalQtyBasedPrice1 =
          totalQtyBasedPrice.reduce((value, element) => value + element);

      totalqty1 = totalqty.reduce((value, element) => value + element);
    });

    log('totalQtyBasedPrice1 $totalQtyBasedPrice1');
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
    fetchImages();
   _fetchAllProducts();
    shutDown();
   fetchAllPharmacyProducts();
   //fetchProducts();

    // fetchAllPharmproducts().whenComplete(
    //     () => qty = List<int>.generate(allPharmproducts.length, (index) => 0));
    // .whenComplete(
    //   () => qty = List<int>.generate(allPharmproducts.length, (index) => 0),
    //   // null
    // );
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
                      height: 30,
                    ),

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
                    //             log('Input: $text');
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

                    const SizedBox(
                      height: 30,
                    ),
                    AddsView(images: images1),

                    // Upload File
                    SizedBox(
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xff870081),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Icon(
                                    BootstrapIcons.cloud_arrow_down_fill,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                  Text(
                                    "Upload Your Prescription",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xff870081),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/Rectangle 255.png",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 15, top: 15),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xE6434343),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 90,
                        child: GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 1,
                          ),
                          // itemCount: pharmCategories.length,
                          itemCount: pharmCategories.length,
                          itemBuilder: (context, index) {
                            return categoryItem(
                              pharmCategories[index]['image']!,
                              pharmCategories[index]['name']!,
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PharmacyItem(
                                      subCategory: pharmCategories1[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 10, bottom: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       const Text(
                          //         "Random Medicines",
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
                          //                   style:
                          //                       TextStyle(color: Color(0xff870081)),
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  'All Pharmacy Product',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          FutureBuilder<dynamic>(
                            future: fetchAllPharmacyProducts(),
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
                                      final discountPrice = data[index]
                                          ['product']['selling_price'];
                                      final actualprice = data[index]['product']
                                          ['actual_price'];
                                      final rating =
                                          data[index]['rating'] ?? 0.0;

                                      // final subcategory = data[index]['product']['subcategory'];
                                      final productid =
                                          data[index]['product_id'];
                                      final shopeid = data[index]['product']['pharm_id'];
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
                                              builder: (context) =>
                                                  PharmacyProducDetails(
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

                          Column(
                            children: [
                              // Text(allPharmproducts.length.toString()),
                              // Text(qty.length.toString()),
                              GridView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: allPharmproducts.length,
                                controller: ScrollController(),
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  // crossAxisCount: 2,
                                  // mainAxisSpacing: 15,
                                  // childAspectRatio: 2.1

                                  crossAxisSpacing: 5,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: .85,
                                ),
                                itemBuilder: (context, index) {
                                  return productBox(
                                      rating: 0,
                                      imageUrl: allPharmproducts[index]
                                          .product
                                          .primaryImage
                                          .toString(),
                                      pName: allPharmproducts[index]
                                          .product
                                          .name[0],
                                      oldPrice: int.parse(
                                          allPharmproducts[index]
                                              .product
                                              .actualPrice[0]),
                                      newPrice: allPharmproducts[index]
                                          .product
                                          .sellingPrice,
                                      offer: int.parse(allPharmproducts[index]
                                          .product
                                          .discountPrice[0]),
                                      color: const Color(0x6B870081),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                      link:
                                                          'get_single_shopproduct',
                                                      shopId: allPharmproducts[
                                                              index]
                                                          .product
                                                          .pharmId,
                                                      productId:
                                                          allPharmproducts[
                                                                  index]
                                                              .product
                                                              .productId,
                                                    )));
                                      });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // GridView.builder(
                          //   shrinkWrap: true,
                          //   primary: false,
                          //   padding: const EdgeInsets.only(left: 5, right: 5),
                          //   gridDelegate:
                          //       const SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 2,
                          //     crossAxisSpacing: 5,
                          //     mainAxisSpacing: 5,
                          //     childAspectRatio: .7,
                          //   ),
                          //   itemCount: 10,
                          //   itemBuilder: (context, index) {
                          //     return productWithCounterWithRatings(
                          //         'assets/images/appliances.jpeg',
                          //         'The frist medicine you need for oenutoheu oeuntheou',
                          //         2000,
                          //         1000,
                          //         50,
                          //         (){},
                          //         (){},
                          //         (){},

                          //         );
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

  Future<dynamic> fetchAllPharmacyProducts() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url = 'https://miogra.clovion.org/all_pharmproducts';
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
        await http.get(Uri.parse('https://miogra.clovion.org/all_pharmproducts/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allProducts = (data as List)
            .map((item) => PharmacyProducts.fromJson(item))
            .toList();
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

class PharmacyProducts {
  final String name;

  PharmacyProducts.fromJson(Map<String, dynamic> json)
      : name = json['product']['model_name'];
}
