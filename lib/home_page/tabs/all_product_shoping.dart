import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/category.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/search/search_page.dart';
import 'package:miogra/features/shopping/presentation/widgets/category_page.dart';
import 'package:miogra/widgets/add_view.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../core/api_services.dart';
import '../../features/shopping/presentation/pages/product_details.dart';

class AllProductShoping extends StatefulWidget {
  const AllProductShoping({
    super.key,
  });

  @override
  State<AllProductShoping> createState() => _AllProductShopingState();
}

class _AllProductShopingState extends State<AllProductShoping> {
  List<Product> allProducts = []; // List to store all products
  List<Product> filteredProducts = []; // List to store filtered products
  final TextEditingController searchController = TextEditingController();

  List images1 = [];
  List images2 = [];

  // String url = "https://miogra.com/all_shopproducts/";
  Future<dynamic> fetchDataFromListJson() async {
    String url = 'https://${ApiServices.ipAddress}/all_shopproducts/';
    String? image;

    try {
      final response = await http.get(Uri.parse(url));

      // log(response.statusCode.toString());

      if (response.statusCode == 200) {
        // log('Fetching Data...');
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data[0];

          // log(jsonData.toString());
          final imageUrl = data[0]['product']['primary_image']?.toString();

          if (imageUrl != null) {
            image = imageUrl;
            log('Image URL: $image');
          } else {
            // log('Image URL not found in data');
          }

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

  Future<dynamic> fetchImages() async {
    String url =
        'https://${ApiServices.ipAddress}/admin/banner_display/shopping';
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

  @override
  void initState() {
    super.initState();
    fetchDataFromListJson();
    _fetchAllProducts();
    fetchImages();
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                    },
                    child: GestureDetector(
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
                                padding:  EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Divider(
                                  color: Colors.grey[500],
                                  thickness: 0.5,
                                ),
                              ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                                  },
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                                      },
                                        child: Text(product.name)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AddsView(images: images1),

                  const Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 15,
                      top: 15,
                    ),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xE6434343),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 203,
                    child: GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 2,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 10,
                      children: [
                        categoryItem(
                          'assets/images/phone.jpeg',
                          'Mobiles',
                          () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "mobiles",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/groceries.jpeg',
                          'Groceries',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "groceries",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/fashion.jpeg',
                          'Fashion',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "fashion",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/furniture.jpeg',
                          'Furniture',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "furniture",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/appliances.jpeg',
                          'Appliances',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "appliances",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/auto.webp',
                          'Auto Accessories',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "auto_accessories",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/kitchen.jpeg',
                          'Kitchen',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "kitchen",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/electronics.jpeg',
                          'Electronics',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "electronics",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/pet.jpeg',
                          'Pet Supplies',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "pet_supplies",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/toys.jpeg',
                          'Toys',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "toys",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/sports.jpeg',
                          'Sports & Fitness',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "sports_and_fitness",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/books.webp',
                          'Books',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "books",
                                ),
                              ),
                            );
                          },
                        ),
                        categoryItem(
                          'assets/images/personal.jpg',
                          'Personal Care',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoryPage(
                                  subCategory: 'shopping',
                                  category: "personal_care",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // const AddView(),

                  // You may like
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 15,
                      top: 15,
                    ),
                    child: Text(
                      "You may like",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xE6434343),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: GridView.count(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 1,
                      childAspectRatio: .39,
                      mainAxisSpacing: 10,
                      children: [
                        rectangleBox(
                            'assets/images/phone.jpeg',
                            'Samsung Galaxy F14 (6GB RAM)',
                            18000,
                            15000,
                            () {}),
                        rectangleBox('assets/images/phone2.jpeg',
                            'Redmit Note 12 Pro+ 5G', 18000, 15000, () {}),
                        rectangleBox(
                            'assets/images/phone.jpeg',
                            'Samsung Galaxy F14 (6GB RAM)',
                            18000,
                            15000,
                            () {}),
                        rectangleBox('assets/images/phone2.jpeg',
                            'Redmit Note 12 Pro+ 5G', 18000, 15000, () {}),
                        rectangleBox(
                            'assets/images/phone.jpeg',
                            'Samsung Galaxy F14 (6GB RAM)',
                            18000,
                            15000,
                            () {}),
                        rectangleBox('assets/images/phone2.jpeg',
                            'Redmit Note 12 Pro+ 5G', 18000, 15000, () {}),
                      ],
                    ),
                  ),
                  AddsView(images: images2),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Text(
                      'All Shope Products',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  // TODO: Small Banner Ad

                  // TODO: Big Banner Ad

                  // FutureBuilder<dynamic>(
                  //   future: fetchAllShopProducts(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return const Center(
                  //         child: Text(
                  //           'Something went wrong',
                  //         ),
                  //       );
                  //     } else {
                  //       final data = snapshot.data;
                  //       int dataLength = 0;

                  //       if (data != null) {
                  //         if (data is List) {
                  //           dataLength = data.length;
                  //         } else {
                  //           log('Data is not a list');
                  //         }
                  //       } else {
                  //         log('Data is null');
                  //       }

                  //       if (data != null && data is List && data.isNotEmpty) {
                  //         return GridView.builder(
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 5,
                  //             vertical: 5,
                  //           ),
                  //           itemCount: dataLength,
                  //           // physics: const NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           primary: false,
                  //           gridDelegate:
                  //               const SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisSpacing: 5,
                  //             mainAxisSpacing: 5,
                  //             crossAxisCount: 2,
                  //             childAspectRatio: .85,
                  //           ),
                  //           itemBuilder: (context, index) {
                  //             final imageUrl = data[index]['product']
                  //                     ['primary_image']
                  //                 ?.toString();
                  //             final productName = data[index]['product']
                  //                     ['model_name']
                  //                 .toString()
                  //                 .toUpperCase();
                  //             final discountPrice =
                  //                 data[index]['product']['selling_price'];
                  //             final actualprice =
                  //                 data[index]['product']['actual_price'];
                  //             final rating = data[index]['rating'] ?? 0.0;

                  //             // final subcategory = data[index]['product']['subcategory'];
                  //             final productid = data[index]['product_id'];
                  //             final shopeid = data[index]['shop_id'];
                  //             final category = data[index]['category'];

                  //             return productBox(
                  //               imageUrl: imageUrl,
                  //               pName: productName,
                  //               oldPrice: actualprice,
                  //               newPrice: discountPrice,
                  //               rating: rating,
                  //               offer: 28,
                  //               color: Colors.red,
                  //               onTap: () {
                  //                 Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                     builder: (context) => ProductDetailsPage(
                  //                       productId: productid,
                  //                       shopeid: shopeid,
                  //                       category: category,
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             );
                  //           },
                  //         );
                  //       } else {
                  //         // Handle the case where data is null//
                  //         return const Scaffold(
                  //           body: Center(
                  //             child: Text(
                  //               'No products found',
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //     }
                  //   },
                  // ),

                  // SizedBox(
                  //   height: 220,
                  //   child: GridView.count(
                  //     padding:
                  //         const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //     scrollDirection: Axis.horizontal,
                  //     crossAxisCount: 1,
                  //     childAspectRatio: .9,
                  //     mainAxisSpacing: 10,
                  //     children: [
                  //       basicSquareBoxOne(
                  //         'assets/images/laptop.png',
                  //         """Dell 15 Laptop, Intel Core i3-1115G4 Processor/8GB DDR4/512GB SSD/15.6" (39.62cm) FHD Anti-Glare 120Hz Refresh Rate 250 nits Narrow Border Display/Win 11+MSO'21/15 Month McAfee/Carbon Black/1.66 kg""",
                  //         () {},
                  //       ),
                  //       basicSquareBoxOne(
                  //         'assets/images/laptop.webp',
                  //         """Apple MacBook Air Laptop M1 chip, 13.3-inch/33.74 cm Retina Display, 8GB RAM, 256GB SSD Storage, Backlit Keyboard, FaceTime HD Camera, Touch ID. Works with iPhone/iPad; Silver""",
                  //         () {},
                  //       ),
                  //       basicSquareBoxOne(
                  //         'assets/images/laptop.png',
                  //         """Dell 15 Laptop, Intel Core i3-1115G4 Processor/8GB DDR4/512GB SSD/15.6" (39.62cm) FHD Anti-Glare 120Hz Refresh Rate 250 nits Narrow Border Display/Win 11+MSO'21/15 Month McAfee/Carbon Black/1.66 kg""",
                  //         () {},
                  //       ),
                  //       basicSquareBoxOne(
                  //         'assets/images/laptop.webp',
                  //         """Apple MacBook Air Laptop M1 chip, 13.3-inch/33.74 cm Retina Display, 8GB RAM, 256GB SSD Storage, Backlit Keyboard, FaceTime HD Camera, Touch ID. Works with iPhone/iPad; Silver""",
                  //         () {},
                  //       ),
                  //       basicSquareBoxOne(
                  //         'assets/images/laptop.png',
                  //         """Dell 15 Laptop, Intel Core i3-1115G4 Processor/8GB DDR4/512GB SSD/15.6" (39.62cm) FHD Anti-Glare 120Hz Refresh Rate 250 nits Narrow Border Display/Win 11+MSO'21/15 Month McAfee/Carbon Black/1.66 kg""",
                  //         () {},
                  //       ),
                  //       basicSquareBoxOne(
                  //         'assets/images/laptop.webp',
                  //         """Apple MacBook Air Laptop M1 chip, 13.3-inch/33.74 cm Retina Display, 8GB RAM, 256GB SSD Storage, Backlit Keyboard, FaceTime HD Camera, Touch ID. Works with iPhone/iPad; Silver""",
                  //         () {},
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  FutureBuilder<dynamic>(
                    future: fetchAllShopProducts(),
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
                                      builder: (context) => ProductDetailsPage(
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
                ],
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
        await http.get(Uri.parse('https://miogra.clovion.org/all_shopproducts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allProducts =
            (data as List).map((item) => Product.fromJson(item)).toList();
        filteredProducts = allProducts; // Initially show all products
      });
    } else {
      // Handle API request error
    }
  }

  Future<dynamic> fetchAllShopProducts() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url = 'https://${ApiServices.ipAddress}/all_shopproducts';
    try {
      final response = await http.get(Uri.parse(url));

      // log(response.statusCode.toString());

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

  void _filterProducts(String searchTerm) {
    filteredProducts = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    setState(() {}); // Rebuild the UI with filtered products
  }

  bool showSuggestions = false;

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
}

class Product {
  final String name;

  Product.fromJson(Map<String, dynamic> json)
      : name = json['product']['model_name'];
}
