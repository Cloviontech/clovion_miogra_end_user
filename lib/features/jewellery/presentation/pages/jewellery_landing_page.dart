import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/jewellery/models/all_jewelproducts_model.dart';
import 'package:miogra/features/jewellery/presentation/pages/jewl_details.dart';
import 'package:miogra/features/jewellery/presentation/pages/jewl_products.dart';
import 'package:miogra/features/search/search_page.dart';
import 'package:miogra/features/selectedproduct.dart';
import 'package:miogra/features/shopping/presentation/pages/shopping_product_details_page.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:miogra/models/selectedproduct_model.dart';
import '../../../../core/api_services.dart';
import '../../../../core/colors.dart';
import '../../../../widgets/add_view.dart';
import '../../../shopping/presentation/pages/product_details.dart';
import 'jewl_product_category_silver.dart';

class JewelleryLandingPage extends StatefulWidget {
  const JewelleryLandingPage({super.key});

  @override
  State<JewelleryLandingPage> createState() => _JewelleryLandingPageState();
}

class _JewelleryLandingPageState extends State<JewelleryLandingPage> {
  List<Order> orders = [];
  final TextEditingController controller = TextEditingController();
  List<Order> searchResults = [];
  bool showResults = false;

  List<JewlProducts> allProducts = [];
  List<JewlProducts> filteredFoodProducts = [];
  final TextEditingController searchController = TextEditingController();

  List images1 = [];
  List images2 = [];

  Future<dynamic> fetchImages() async {
    String url =
        'https://${ApiServices.ipAddress}/admin/banner_display/jewellery';
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
  //       'http://${ApiServices.ipAddress}/user_get_all_shopproducts/QMC77LVGSXM/ID7KRF1K7K8';

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

  PageController pageController = PageController(initialPage: 0);

  List<String> images = [
    "assets/images/Rectangle 272.png",
    "assets/images/Rectangle 272.png",
    "assets/images/ad2.jpg",
    "assets/images/ad3.jpg",
    "assets/images/ad4.jpg",
    "assets/images/ad5.jpg",
  ];

  static List<AllJewelproducts> allJewelproducts = [];

  bool loadingFetchAllFreshcutproducts = true;

  // Future<void> fetchAllJewelproducts() async {
  //   final response = await https
  //       .get(Uri.parse('https://${ApiServices.ipAddress}/all_jewelproducts'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonResponse = json.decode(response.body);

  //     setState(() {
  //       allJewelproducts = jsonResponse
  //           .map((data) => AllJewelproducts.fromJson(data))
  //           .toList();
  //       loadingFetchAllFreshcutproducts = false;
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

  @override
  void initState() {
    super.initState();
    fetchImages();

    _fetchAllProducts();
    shutDown();

    // fetchAllJewelproducts();
    // fetchProducts();
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
                      height: 10,
                    ),

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
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoryJewlPage(
                                      subCategory: 'gold',
                                      category: 'jewellery',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.grey.shade500,
                                        width: .5)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(10)),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/Rectangle 270.png"),
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Gold",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoryJewlPageSilver(
                                    subCategory: 'silver',
                                    category: 'jewellery',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.grey.shade500, width: .5)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/Rectangle 271.png",
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Silver",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),

                    //advertisment Widget
                    // const AddView(),
                    AddsView(images: images1),

                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'All Jwellery products',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    FutureBuilder<dynamic>(
                      future: fetchAllJuelProducts(),
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
                                final shopeid = data[index]['jewel_id'];
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
                                            JewlProductsDetails(
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

                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.only(left: 10, bottom: 10),
                          //   child: Text(
                          //     "Suggested For You",
                          //     style: TextStyle(
                          //         fontSize: 17,
                          //         fontWeight: FontWeight.w500,
                          //         color: Color(0xE6434343)),
                          //   ),
                          // ),
                          GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: .8),
                            itemCount: allJewelproducts.length,
                            itemBuilder: (context, index) {
                              return

                                  // productBox(
                                  //     path : 'assets/images/home-theater.jpeg',
                                  //     pName: 'Home Theater',
                                  //     oldPrice: 7000,
                                  //     newPrice: 5000,
                                  //     offer : 30,
                                  //     color:  const Color(0x6B870081),
                                  //     page: (){
                                  //       Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductDetails()));
                                  //     });

                                  productBox(
                                      rating: 0,
                                      imageUrl: allJewelproducts[index]
                                          .product
                                          .primaryImage,
                                      pName: allJewelproducts[index]
                                          .product
                                          .name[0],
                                      oldPrice: int.parse(
                                          allJewelproducts[index]
                                              .product
                                              .actualPrice[0]),
                                      newPrice: allJewelproducts[index]
                                          .product
                                          .sellingPrice,
                                      offer: int.parse(allJewelproducts[index]
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
                                                          'single_jewelproduct',
                                                      productId:
                                                          allJewelproducts[
                                                                  index]
                                                              .product
                                                              .productId,
                                                      shopId: allJewelproducts[
                                                              index]
                                                          .product
                                                          .jewelId,
                                                    )));
                                      });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    )
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

  Future<dynamic> fetchAllJuelProducts() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url = 'https://${ApiServices.ipAddress}/all_jewelproducts';
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
        await http.get(Uri.parse('https://miogra.com/all_jewelproducts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allProducts =
            (data as List).map((item) => JewlProducts.fromJson(item)).toList();
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

class JewlProducts {
  final String name;

  JewlProducts.fromJson(Map<String, dynamic> json)
      : name = json['product']['model_name'];
}
