import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/dOriginal/models/all_d_originalproducts.dart';
import 'package:http/http.dart' as http;
import 'package:miogra/features/food/presentation/pages/ordering_for_page.dart';
import 'package:miogra/widgets/add_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/colors.dart';
import 'your_order_d_orginal.dart';

class DOriginalLandingPage extends StatefulWidget {
  const DOriginalLandingPage({super.key});

  @override
  State<DOriginalLandingPage> createState() => _DOriginalLandingPageState();
}

class _DOriginalLandingPageState extends State<DOriginalLandingPage> {
  String selectedDistrict = 'All Districts';

  bool productFound = false;

  bool loadingFetchAllDOriginalproducts = true;

  List<AllDOriginalproducts> allDOriginalproducts = [];
  List<AllDOriginalproducts> districtWiseDOriginalproducts = [];

  Future<void> fetchAllDOriginalproducts() async {
    final response = await http.get(
        Uri.parse('https://${ApiServices.ipAddress}/all_d_originalproducts'));

    debugPrint('https://${ApiServices.ipAddress}/all_d_originalproducts');

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        allDOriginalproducts = jsonResponse
            .map((data) => AllDOriginalproducts.fromJson(data))
            .toList();
        loadingFetchAllDOriginalproducts = false;
      });

      // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  List images1 = [];
  List images2 = [];

  Future<dynamic> fetchImages() async {
    String url =
        'https://${ApiServices.ipAddress}/admin/banner_display/d_original';
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

  fetchProductDistWise() {
    setState(() {
      districtWiseDOriginalproducts.clear();
      productFound = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.purple,
        content: Center(
            child: Text('Sorry...! No Products found for this District...!')),
        duration: Duration(seconds: 5),
      ));
    });

    for (var i = 0; i < allDOriginalproducts.length; i++) {
      if (allDOriginalproducts[i].district.toLowerCase() ==
          selectedDistrict.toLowerCase()) {
        setState(() {
          districtWiseDOriginalproducts.add(allDOriginalproducts[i]);
          productFound = true;
        });
      }
    }
  }

  Future<dynamic> fetchDataFromListJson() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url = 'https://${ApiServices.ipAddress}/all_d_originalproducts/';
    log(url);
    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Featching Data');
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          // log(jsonData.toString());
          // log(data.toString());

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

  String userId = '';
  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserIdInSharedPreferences();
    fetchDataFromListJson();
    fetchImages();
    // fetchAllDOriginalproducts();

    shutDown();
  }

  @override
  Widget build(BuildContext context) {
    List<String> districts = [
      'All Districts',
      'Chennai',
      'Madurai',
      'Coimbatore',
      'Trichy',
      'Tirunelveli',
      'Srivilliputhur',
      'Theni',
      'Karur',
      'Erode',
      'Kanniyakumari'

      // Add more district names as needed
    ];
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
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 20),
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: const Color(0xff870081),
                    //       width: 1.3,
                    //     ),
                    //     borderRadius: const BorderRadius.all(
                    //       Radius.circular(7),
                    //     ),
                    //   ),
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "Select District",
                    //         style: TextStyle(color: Colors.grey.shade500, fontSize: 20),
                    //       ),
                    //       const Icon(
                    //         Icons.keyboard_arrow_down_rounded,
                    //         size: 30,
                    //         color: Color(0xff870081),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButtonFormField(
                        padding: EdgeInsets.zero,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        value: selectedDistrict,
                        hint: const Text('Select District'),
                        items: districts.map((String district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(district),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value!;
                          });

                          fetchProductDistWise();
                        },
                      ),
                    ),
                    AddsView(
                      images: images1,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 15, top: 15),
                      child: Text(
                        'Products',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xE6434343)),
                      ),
                    ),
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
                                final imageUrl =
                                    data[index]['product']['primary_image'];
                                final productName = data[index]['product']
                                        ['model_name']
                                    .toString()
                                    .toUpperCase();
                                final discountPrice =
                                    data[index]['product']['selling_price'];
                                final actualprice =
                                    data[index]['product']['actual_price'];
                                final sellingPrice =
                                    data[index]['product']['selling_price'];
                                final rating = data[index]['rating'] ?? '0.0';
                                final productid =
                                    data[index]['product']['product_id'];
                                final shopeid = data[index]['product']['d_id'];

                                final category = data[index]['category'];
                                final description = data[index]['product']
                                    ['product_description'];
                                // final subCategory =
                                //     data[index]['product']['product_description'];

                                // final subcategory = data[index]['product']['subcategory'];

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
                                    showDetailsOfFood(
                                        description,
                                        imageUrl,
                                        category,
                                        productid,
                                        shopeid,
                                        sellingPrice);
                                  },
                                );
                              },
                            );

                            // ListView.builder(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 5,
                            //     vertical: 5,
                            //   ),
                            //   itemCount: dataLength,
                            //   shrinkWrap: true,
                            //   primary: false,
                            //   itemBuilder: (context, index) {
                            //     final imageUrl = data[index]['product']
                            //             ['primary_image']
                            //         ?.toString();
                            //     final productName = data[index]['product']
                            //             ['model_name']
                            //         .toString()
                            //         .toUpperCase();
                            //     final sellingPrice =
                            //         data[index]['product']['selling_price'];
                            //     // final actualprice = data[index]['product']['actual_price'];
                            //     // final rating = data[index]['rating'];

                            //     // final subcategory = data[index]['product']['subcategory'];
                            //     final productid =
                            //         data[index]['product']['product_id'];
                            //     final shopeid = data[index]['product']['d_id'];

                            //     final category = data[index]['category'];
                            //     final description =
                            //         data[index]['product']['product_description'];
                            //     final subCategory =
                            //         data[index]['product']['product_description'];

                            //     // log('Selling price is $sellingPrice');

                            //     return Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: InkWell(
                            //         onTap: () {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (context) => GoToOrderDOrginal(
                            //                 uId: userId,
                            //                 category: category,
                            //                 link: imageUrl,
                            //                 productId: productid,
                            //                 shopId: shopeid,
                            //                 totalPrice: '₹$sellingPrice'.toString(),
                            //               ),
                            //             ),
                            //           );
                            //         },
                            //         child: Container(
                            //           decoration: const BoxDecoration(
                            //             color: Color.fromARGB(255, 249, 227, 253),
                            //             borderRadius: BorderRadius.all(
                            //               Radius.circular(20),
                            //             ),
                            //           ),
                            //           child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Row(
                            //                 children: [
                            //                   Container(
                            //                     height: 100,
                            //                     width: 100,
                            //                     color: const Color.fromARGB(
                            //                         255, 249, 227, 253),
                            //                     child: Padding(
                            //                       padding: const EdgeInsets.all(8.0),
                            //                       child: Image.network(
                            //                           imageUrl.toString()),
                            //                     ),
                            //                   ),
                            //                   Column(
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.start,
                            //                     children: [
                            //                       SizedBox(
                            //                         width: MediaQuery.of(context)
                            //                                 .size
                            //                                 .width *
                            //                             0.5,
                            //                         child: Text(
                            //                           productName,
                            //                           overflow: TextOverflow.fade,
                            //                           style: const TextStyle(
                            //                             fontWeight: FontWeight.bold,
                            //                             fontSize: 18,
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       Text(
                            //                         '₹$sellingPrice',
                            //                         style: const TextStyle(
                            //                           fontWeight: FontWeight.bold,
                            //                           fontSize: 16,
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   )
                            //                 ],
                            //               ),
                            //               const Column(
                            //                 children: [
                            //                   // SizedBox(
                            //                   //   child: Row(
                            //                   //     children: [
                            //                   //       InkWell(
                            //                   //         onTap: () {
                            //                   //           count--;
                            //                   //         },
                            //                   //         child: Container(
                            //                   //           height: 25,
                            //                   //           width: 25,
                            //                   //           decoration: BoxDecoration(
                            //                   //             color: primaryColor,
                            //                   //             borderRadius:
                            //                   //                 BorderRadius.circular(5),
                            //                   //           ),
                            //                   //           child: const Icon(
                            //                   //             Icons.remove,
                            //                   //             color: Colors.white,
                            //                   //             size: 15,
                            //                   //           ),
                            //                   //         ),
                            //                   //       ),
                            //                   //       Padding(
                            //                   //         padding: const EdgeInsets.symmetric(
                            //                   //           horizontal: 10,
                            //                   //         ),
                            //                   //         child: Text(
                            //                   //           count.toString(),
                            //                   //           style: const TextStyle(
                            //                   //             color: primaryColor,
                            //                   //           ),
                            //                   //         ),
                            //                   //       ),
                            //                   //       InkWell(
                            //                   //         onTap: () {
                            //                   //           setState(() {
                            //                   //             count++;
                            //                   //           });
                            //                   //         },
                            //                   //         child: Container(
                            //                   //           height: 25,
                            //                   //           width: 25,
                            //                   //           decoration: BoxDecoration(
                            //                   //             color: primaryColor,
                            //                   //             borderRadius:
                            //                   //                 BorderRadius.circular(5),
                            //                   //           ),
                            //                   //           child: const Icon(
                            //                   //             Icons.add,
                            //                   //             color: Colors.white,
                            //                   //             size: 15,
                            //                   //           ),
                            //                   //         ),
                            //                   //       ),
                            //                   //     ],
                            //                   //   ),
                            //                   // )
                            //                 ],
                            //               ),
                            //               Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     showDetailsOfFood(
                            //                       description,
                            //                       imageUrl.toString(),
                            //                     );
                            //                   },
                            //                   icon: const Icon(
                            //                     Icons.info,
                            //                     color: primaryColor,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     );

                            //     // productBox(
                            //     //   imageUrl: imageUrl,
                            //     //   pName: productName,
                            //     //   oldPrice: actualprice,
                            //     //   newPrice: discountPrice,
                            //     //   rating: rating,
                            //     //   offer: 28,
                            //     //   color: Colors.red,
                            //     //   onTap: () {
                            //     //     Navigator.push(
                            //     //       context,
                            //     //       MaterialPageRoute(
                            //     //         builder: (context) => ProductDetailsPage(
                            //     //           productId: productid,
                            //     //           shopeid: shopeid,
                            //     //           category: category,
                            //     //         ),
                            //     //       ),
                            //     //     );
                            //     //   },
                            //     // );
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

                    // GridView.builder(
                    //   shrinkWrap: true,
                    //   primary: false,
                    //   padding: const EdgeInsets.only(left: 5, right: 5),
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 5,
                    //     mainAxisSpacing: 5,
                    //     childAspectRatio: .7,
                    //   ),
                    //   itemCount: districtWiseDOriginalproducts.length,
                    //   itemBuilder: (context, index) {
                    //     return GestureDetector(
                    //       onTap: () {
                    //         bottomSheet(
                    //           context,
                    //           districtWiseDOriginalproducts[index]
                    //               .product
                    //               .primaryImage,
                    //           districtWiseDOriginalproducts[index].product.name[0],
                    //           districtWiseDOriginalproducts[index]
                    //               .product
                    //               .actualPrice[0],
                    //           districtWiseDOriginalproducts[index]
                    //               .product
                    //               .sellingPrice
                    //               .toString(),
                    //           districtWiseDOriginalproducts[index]
                    //               .product
                    //               .otherImages[0],
                    //         );
                    //       },
                    //       child: productWithCounterWithRatings(
                    //           districtWiseDOriginalproducts[index]
                    //               .product
                    //               .primaryImage,
                    //           districtWiseDOriginalproducts[index].product.name[0],
                    //           int.parse(districtWiseDOriginalproducts[index]
                    //               .product
                    //               .actualPrice[0]),
                    //           districtWiseDOriginalproducts[index]
                    //               .product
                    //               .sellingPrice,
                    //           int.parse(districtWiseDOriginalproducts[index]
                    //               .product
                    //               .discountPrice[0]),
                    //           context: context),

                    //       // productWithCounterWithRatings(
                    //       //     'assets/images/appliances.jpeg',
                    //       //     'The frist medicine you need for oenutoheu oeuntheou',
                    //       //     2000,
                    //       //     1000,
                    //       //     50,
                    //       //     context: context),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          );
  }

  showDetailsOfFood(String details, String imageUrl, category, productid,
      shopeid, sellingPrice) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: NetworkImage(
                        imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity - 50,
                  height: MediaQuery.of(context).size.width - 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      details,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5,
                                  ),
                                ),
                              ),
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              primaryColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoToOrderDOrginal(
                                  uId: userId,
                                  category: category,
                                  link: imageUrl,
                                  productId: productid,
                                  shopId: shopeid,
                                  totalPrice: '₹$sellingPrice'.toString(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Order',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future bottomSheet(BuildContext context, String priImage, String name,
    String oldPrice, String sellPrice, String description) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
    builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderingFor(
                totalPrice: int.parse(sellPrice),
                totalQty: 1,
                selectedFoods: const [],
                qty: const [],
                productCategory: '',
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        image: DecorationImage(image: NetworkImage(
                            // "https://thefederal.com/file/2023/01/Lead-1-4.jpg"
                            priImage), fit: BoxFit.fill)),
                  ),
                  Text(
                    // "Tirunelveli Halwa",

                    name,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3E3E3E),
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        oldPrice,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        sellPrice,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      // """
                      // Tirunelveli Halwa / Wheat Halwa, popularly
                      // known as Tirunelveli Halwa is one of the famous
                      // Sweet in South Indian Cuisine. Tirunelveli Halwa
                      // is known for its unique, exotic, and incomparable
                      // taste. It is believed that Thamirabharani river
                      // water and fermented wheat milk is the key
                      // ingredient for this delicacy
                      // """
                      description),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
