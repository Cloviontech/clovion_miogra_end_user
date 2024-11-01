// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/core/constants.dart';
import 'package:miogra/features/profile/pages/wishlist1_srn.dart';
import 'package:miogra/features/shopping/presentation/pages/go_to_order.dart';
import 'package:miogra/features/shopping/presentation/widgets/ratings.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:miogra/home_page/cart_page.dart';
import 'package:miogra/my_work/cart_page.dart';
import 'package:miogra/my_work/wish_list_screen.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api_services.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.shopeid,
    required this.category,
  });

  final String productId;
  final String shopeid;
  final String category;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String image = '';
  String productName = '';

  String productId = '';
  String productPrice = '';
  String shopeId = '';
  double price = 0.0;

  String description = '';
  String brandName = '';
  String discount = '';
  String rating = '';
  String category = '';
  String subCategory = '';
  String oldPrice = '';

  List images = [];
  List reviews = [];
  bool isFavorite = true;

  // final TextEditingController cartCount =TextEditingController();

  Future<List<dynamic>> fetchReviewsFromListJson() async {
    String url =
        'https://${ApiServices.ipAddress}/get_product_all_reviews/${widget.productId}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Using jsonDecode for clarity

        if (data is List) {
          final reviews = data;
          // log('Featching reviews...');
          log(reviews.toString());

          setState(() {
            this.reviews = reviews; // Use 'this' for clarity
          });
          return reviews;
        } else {
          log('Unexpected response format: ${data.runtimeType}'); // Informative error message
        }
      } else {
        log('Error fetching reviews: Status code ${response.statusCode}'); // Informative error message
      }
    } catch (e) {
      log('Error fetching reviews: $e'); // Log the full error
    }

    return []; // Return an empty list on errors or unexpected responses
  }

  double calculateOverallRating(List<double?> ratings) {
    if (ratings.isEmpty) {
      return 0.0;
    }

    double sum = 0.0;
    int validRatings = 0;
    for (double? rating in ratings) {
      if (rating != null) {
        sum += rating;
        validRatings++;
      }
    }
    return validRatings > 0 ? sum / validRatings : 0.0;
  }
  List data = [];
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("uid");
    log(userId.toString());
    final String apiUrl =  'https://${ApiServices.ipAddress}/get_single_shopproduct/${widget.shopeid}/${widget.productId}';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body); // Store JSON response
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:$e');
    }
  }
  String userId = '';

  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();

      log('User ID is $userId');
    });
  }

  double value = 0.0;

  Future<dynamic> fetchDataFromListJson() async {
    String url =
        'https://${ApiServices.ipAddress}/get_single_shopproduct/${widget.shopeid}/${widget.productId}';
    log(url);

    try {
      final response = await http.get(Uri.parse(url));

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Featching Data');
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          try {
            setState(() {
              images = data[0]['product']['other_images'];
              image = data[0]['product']['primary_image'];

              log(images.toString());

              productName = data[0]['product']['model_name'].toString();
              productId = data[0]['product_id'].toString();
              shopeId = data[0]['shop_id'].toString();
              brandName = data[0]['product']['brand'].toString();
              productPrice = data[0]['product']['selling_price'].toString();
              description =
                  data[0]['product']['product_description'].toString();
              oldPrice = data[0]['product']['actual_price'].toString();

              discount = data[0]['product']['discount'].toString();
              rating = data[0]['rating'].toString();

              value = double.parse(rating);

              price = double.parse(productPrice); // myDouble will be 3.14159
            });
          } catch (e) {
            setState(() {
              productName = '';
              brandName = '';
              productPrice = '';
              description = '';
              oldPrice = '';
              description = '';
            });
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

  @override
  void initState() {
    super.initState();
    getUserIdInSharedPreferences();
    fetchDataFromListJson();
    fetchReviewsFromListJson();
    fetchData();
  }

  // Future<void> initState() async {
  //   super.initState();
  //   fetchDataFromListJson();
  //   final reviews = await fetchReviewsFromListJson();
  //   // Use 'reviews' here (e.g., for display or data processing)
  // }

  String url = urls[0];
  String selected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined)),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
          const SizedBox(width: 20),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 55,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await PersistentShoppingCart().addToCart(
                    PersistentShoppingCartItem(
                      productId: productId,
                      productName: productName,
                      productDescription: description,
                      unitPrice: price,
                      productThumbnail: image,
                      quantity: 1,
                    ),
                  );

                  addToCart();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: primaryColor,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    "Add To Cart",
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // log(shopeId.toString());
                  // log(widget.productId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return GoToOrder(
                        link: image,
                        productId: widget.productId,
                        shopId: shopeId,
                        uId: userId,
                        category: widget.category,
                      );
                    }),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  color: primaryColor,
                  child: const Text(
                    "Buy Now",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image viewing widget
            SizedBox(
              height: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey[700],
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(image),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  image = images[index];
                                });
                              },
                              child: Container(
                                width: 90,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      images[index].toString(),
                                    ),
                                  ),
                                  color: Colors.grey[700],
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),



            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       '${ data[0]['product']['model_name'].toString().toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              isFavorite
                                  ? addToWishList()
                                  : removeFromWishList();
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            icon: isFavorite
                                ? const Icon(
                                    Icons.favorite_border,
                                    color: primaryColor,
                                    size: 35,
                                  )
                                : const Icon(
                                    Icons.favorite,
                                    color: primaryColor,
                                    size: 35,
                                  ),
                          ),
                          // const Icon(
                          //   Icons.share,
                          //   color: primaryColor,
                          //   size: 25,
                          // ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                       '₹${ data[0]['product']['actual_price'].toString()}',
                        style: const TextStyle(
                          // decoration: TextDecoration.lineThrough,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 3.0,
                          decorationColor: Color.fromARGB(255, 2, 179, 8),
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '₹${ data[0]['product']['selling_price'].toString()}',
                            style: TextStyle(
                              decorationThickness: 3.0,
                              fontSize: 30,
                              color: Colors.grey[900],
                              // color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 19, 180, 54),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            height: 30,
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${data[0]['product']['discount'].toString()}%OFF',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                children: [
                  const Text('Product Details'),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: showDetails,
                    child: const Row(
                      children: [
                        Text(
                          'More...',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(
              height: 5,
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Reviews and Ratings",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () async {
                          reviews.isEmpty ? noReviews() : await showReviews();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "View all reviews",
                              style: TextStyle(color: primaryColor),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_circle_right_rounded,
                              color: primaryColor,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          rating,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        starRating(value),
                        Text("$rating rating",
                            style: TextStyle(color: Colors.grey.shade500)),
                        Text("${reviews.length} reviews",
                            style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  addToCart() async {
    String url =
        'https://${ApiServices.ipAddress}/cart_product/$userId/$productId/${widget.category}/';

    // log(widget.userId);
    log(productId);
    log(widget.category);
    log(userId);
    print("shopId");
    log(shopeId);
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['quantity'] = '1';

      var response = await request.send();

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        log('Item Added to Cart');

        Navigator.pop(context);

        cartAdded();
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check The datas'),
          ),
        );
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  void cartAdded() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Item added to cart'),
      ),
    );
  }

  addToWishList() async {
    String url =
        'https://${ApiServices.ipAddress}/whishlist_product/$userId/$productId/${widget.category}/';

    // log(widget.userId);
    log(productId);
    log(widget.category);
    log(userId);
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['quantity'] = '1';

      var response = await request.send();

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        log('Item Added to Wish List');

        Navigator.pop(context);

        wishListAdded();
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check The datas'),
          ),
        );
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  void wishListAdded() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Item added to WishList'),
      ),
    );
  }

  removeFromWishList() async {
    String url =
        'https://${ApiServices.ipAddress}/remove_wish/$userId/$productId/';

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['quantity'] = '1';

      var response = await request.send();

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        log('Item removed from to Wish List');

        Navigator.pop(context);

        wishListRemovedItem();
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check The datas'),
          ),
        );
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  void wishListRemovedItem() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text('Item removed from wishlist'),
      ),
    );
  }

  Widget customRadio(String name, String index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = index;
        });
      },
      child: Container(
        width: 40,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (selected == index) ? primaryColor : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: (selected == index) ? primaryColor : primaryColor,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: (selected == index) ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }

  showReviews() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 25,
            bottom: 5,
          ),
          // height: MediaQuery.of(context).size.height * 0.9,
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.purple[50],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reviews[index]['user']['full_name']),
                        Text(reviews[index]['comment']),
                        Text(reviews[index]['user']['created_date']),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          height: 20,
                          width: 55,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '3.O',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  noReviews() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5),
          backgroundColor: Colors.white,
          title: const Text(
            'No Reviews Found',
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(
                  primaryColor,
                ),
                foregroundColor: const WidgetStatePropertyAll(
                  Colors.white,
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  showDetails() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          // color: Colors.white,
          padding: const EdgeInsets.only(top: 10, left: 10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'General Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Description :  $description',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Brand Name : $brandName',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Model Name : $productName',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
