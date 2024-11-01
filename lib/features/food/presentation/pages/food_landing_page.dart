import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/category.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/food/models_foods/food_alldata.dart';
import 'package:miogra/features/food/presentation/pages/show_food_page.dart';
import 'package:miogra/features/search/search_page.dart';
import 'package:miogra/features/selectedproduct.dart';
import 'package:miogra/models/selectedproduct_model.dart';
import 'package:miogra/my_work/food_item_screen.dart';
import 'package:miogra/my_work/show_food_Screen.dart';
import '../../../../core/api_services.dart';
import '../../../../core/colors.dart';
import '../../../../widgets/add_view.dart';
import '../../controller/food_controller.dart';
import 'food_items.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class FoodLandingPage extends StatefulWidget {
  const FoodLandingPage({super.key});

  @override
  State<FoodLandingPage> createState() => _FoodLandingPageState();
}

class _FoodLandingPageState extends State<FoodLandingPage> {
  List<Order> orders = [];
  final TextEditingController controller = TextEditingController();
  List<Order> searchResults = [];
  bool showResults = false;

  List<Food> allProducts = []; // List to store all products
  List<Food> filteredFoodProducts = []; // List to store filtered products
  final TextEditingController searchController = TextEditingController();

  List images1 = [];
  List images2 = [];

  Future<dynamic> fetchImages() async {
    String url = 'https://${ApiServices.ipAddress}/admin/banner_display/food';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          final jsonData = data;
          setState(() {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while fetching images.'),
        ),
      );
      rethrow; // Rethrow for further handling if necessary
    }
  }

  Future<dynamic> fetchDataFromListJson() async {
    String url = 'https://${ApiServices.ipAddress}/all_foodproducts/';
    String? image;

    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Fetching Data...');
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data[0];
          log(jsonData.toString());
          final imageUrl = data[0]['product']['primary_image']?.toString();
          if (imageUrl != null) {
            image = imageUrl;
            log('Image URL: $image');
          } else {
            log('Image URL not found in data');
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

  bool shope = true;

  Future<dynamic> shutDown() async {
    String url = 'https://${ApiServices.ipAddress}/admin/get_shutdown';

    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          log(data.toString());

          setState(() {
            shope = data[0]['food'];
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

  late Future<List<FoodAlldata>> futureFetchFoodAllData;

  @override
  void initState() {
    super.initState();
    fetchImages();
    shutDown();
    // fetchProducts();

    futureFetchFoodAllData = fetchFoodAllData();
    _fetchAllProducts();
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
                    const SizedBox(height: 10),

                    // Text(futureFetchFoodAllData.toString()),

                    // Search Bar

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: textFeild(context),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
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

                    //advertisment widget
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
                      width: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 2,
                        // childAspectRatio: .85,
                        crossAxisSpacing: 7,
                        mainAxisSpacing: 10,
                        children: [
                          categoryItem(
                            'assets/images/Ellipse 1.png',
                            'Tiffen',
                            () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ShowFoodScreen(
                                    subCategoryName: 'tiffen',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                          categoryItem(
                            'assets/images/Ellipse_7.png',
                            'Meals',
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopeProductViewPage(
                                    subCategoryName: 'meals',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                          categoryItem(
                            'assets/images/Ellipse 2.png',
                            'Biriyani',
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopeProductViewPage(
                                    subCategoryName: 'briyani',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                          categoryItem(
                            'assets/images/Ellipse 5.png',
                            'Chicken',
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopeProductViewPage(
                                    subCategoryName: 'fried_chicken',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                          categoryItem(
                            'assets/images/Ellipse 4.jpg',
                            'Beaf & Mutton',
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopeProductViewPage(
                                    subCategoryName: 'beef',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                          categoryItem(
                            'assets/images/Ellipse 3.png',
                            'Pizza',
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopeProductViewPage(
                                    subCategoryName: 'pizza',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                          categoryItem(
                            'assets/images/kitchen.jpeg',
                            'cake',
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopeProductViewPage(
                                    subCategoryName: 'Cake',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                          categoryItem(
                            'assets/images/Ellipse 1 (1).png',
                            'Tea & Coffe',
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShopeProductViewPage(
                                    subCategoryName: 'tea_coffee',
                                    categoryName: "food",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 15),
                      child: Text(
                        'Restaurants',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xE6434343)),
                      ),
                    ),

                    FutureBuilder<List<FoodAlldata>>(
                      future: futureFetchFoodAllData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final rest = snapshot.data![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    /*
                                    MaterialPageRoute(builder: (context) {
                                      return FoodItems(
                                        foodId: snapshot.data![index].foodId
                                            .toString(),
                                        categoryName: 'food',
                                      );
                                    */
                                    MaterialPageRoute(builder: (context) {
                                      return FoodItemScreen(
                                        foodId: snapshot.data![index].foodId
                                            .toString(),
                                        categoryName: 'food',
                                      );
                                    }),
                                  );
                                },
                                child: restaurantView(
                                    rest.profile.toString(),
                                    rest.businessName.toString(),
                                    rest.streetName.toString(),
                                    10,
                                    20,
                                    4.4),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                          );
                        }
                      },
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

  void _fetchAllProducts() async {
    // Replace with your actual API call and data parsing logic
    final response = await http
        .get(Uri.parse('https://miogra.clovion.org/all_foodproducts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allProducts =
            (data as List).map((item) => Food.fromJson(item)).toList();
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

class Food {
  final String name;

  Food.fromJson(Map<String, dynamic> json)
      : name = json['product']['model_name'];
}
