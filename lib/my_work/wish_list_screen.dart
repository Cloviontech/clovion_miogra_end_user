import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/freshCuts/presentation/pages/fresh_cut_details.dart';
import 'package:miogra/features/jewellery/presentation/pages/jewl_details.dart';
import 'package:miogra/features/pharmacy/presentation/pages/pharmacy_product_details.dart';
import 'package:miogra/features/shopping/presentation/pages/go_to_order.dart';
import 'package:miogra/features/shopping/presentation/pages/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  List<dynamic> products = [];
  String cartTotal = '';
  String userId = '';
  int globalIndexLength = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();

  }
  String getSellingPrice(Map<String, dynamic> product) {
    return product['shop_product']?['product']?['selling_price']?.toString() ??
        product['food_product']?['product']?['selling_price']?.toString() ??
        product['jewel_product']?['product']?['selling_price']?.toString() ??
        product['freshcut_product']?['product']?['selling_price']?.toString() ??
        product['d_origin_product']?['product']?['selling_price']?.toString() ??
        product['dailymio_product']?['product']?['selling_price']?.toString() ??
        product['pharmacy_product']?['product']?['selling_price']?.toString() ?? '';
  }
  String shopId(Map<String, dynamic> product) {
    return product['shop_product']?['product']?['shop_id']?.toString() ??
        product['food_product']?['product']?['food_id']?.toString() ??
        product['jewel_product']?['product']?['jewel_id']?.toString() ??
        product['freshcut_product']?['product']?['fresh_id']?.toString() ??
        product['d_origin_product']?['product']?['shop_id']?.toString() ??
        product['dailymio_product']?['product']?['shop_id']?.toString() ??
        product['pharmacy_product']?['product']?['pharm_id']?.toString() ?? '';
  }
  String getproductid(Map<String, dynamic> product) {
    return product['shop_product']?['product_id']?.toString() ??
        product['food_product']?['product_id']?.toString() ??
        product['jewel_product']?['product_id']?.toString() ??
        product['freshcut_product']?['product_id']?.toString() ??
        product['d_origin_product']?['product_id']?.toString() ??
        product['dailymio_product']?['product_id']?.toString() ??
        product['pharmacy_product']?['product_id']?.toString() ?? '';
  }
  String getcategory(Map<String, dynamic> product) {
    return product['shop_product']?['category']?.toString() ??
        product['food_product']?['category']?.toString() ??
        product['jewel_product']?['category']?.toString() ??
        product['freshcut_product']?['category']?.toString() ??
        product['d_origin_product']?['category']?.toString() ??
        product['dailymio_product']?['category']?.toString() ??
        product['pharmacy_product']?['category']?.toString() ?? '';
  }
  String getBrand(Map<String, dynamic> product) {
    return product['shop_product']?['product']?['brand'] ??
        product['food_product']?['product']?['brand'] ??
        product['jewel_product']?['product']?['brand'] ??
        product['freshcut_product']?['product']?['brand'] ??
        product['d_origin_product']?['product']?['brand'] ??
        product['dailymio_product']?['product']?['brand'] ??
        product['pharmacy_product']?['product']?['brand'] ?? '';
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response") ?? '';
    try {
      final response = await http
          .get(Uri.parse('https://${ApiServices.ipAddress}/all_wishlist/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(
              json.decode(response.body).map((product) {
                product['quantity'] = 1; // Initialize quantity
                return product;
              }));
        });

      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }







  String getPrimaryImage(Map<String, dynamic> product) {
    if (product['shop_product'] != null) {
      return product['shop_product']["product"]['primary_image'] ?? '';
    } else if (product['food_product'] != null) {
      return product['food_product']["product"]['primary_image'] ?? '';
    } else if (product['jewel_product'] != null) {
      return product['jewel_product']["product"]['primary_image'] ?? '';
    } else if (product['freshcut_product'] != null) {
      return product['freshcut_product']["product"]['primary_image'] ?? '';
    } else if (product['d_origin_product'] != null) {
      return product['d_origin_product']["product"]['primary_image'] ?? '';
    } else if (product['dailymio_product'] != null) {
      return product['dailymio_product']["product"]['primary_image'] ?? '';
    } else if (product['pharmacy_product'] != null) {
      return product['pharmacy_product']["product"]['primary_image'] ?? '';
    }
    return ''; // Default or fallback value if none of the conditions are met
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(10),
        //         bottomRight: Radius.circular(10))),

        backgroundColor: primaryColor,
        foregroundColor: Colors.white,

        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          globalIndexLength = index + 1;
          return GestureDetector(
            onTap: (){
              if(getcategory(product) == 'shopping'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }else if(getcategory(product) == 'fresh_cuts'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FreshCutProductDetails(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }else if(getcategory(product) == 'food'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoToOrder(
                      link: getPrimaryImage(product).toString(),
                      productId: getproductid(product), // Replace with your product ID
                      // Replace with your shop ID
                      category:getcategory(product), shopId: shopId(product), uId: userId, // Replace with your category
                    ),
                  ),
                );
              }
              else if(getcategory(product) == 'jewellery'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>   JewlProductsDetails(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }
              else if(getcategory(product) == 'pharmacy'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>    PharmacyProducDetails(
                      productId: getproductid(product), // Replace with your product ID
                      shopeid: shopId(product), // Replace with your shop ID
                      category:getcategory(product), // Replace with your category
                    ),
                  ),
                );
              }

            },
            child: Card(
              elevation: 2,
              child: ListTile(
                leading: SizedBox(
                  width: 80,
                  height: 100,
                  child: Image.network(
                    getPrimaryImage(product),
                    fit: BoxFit.cover,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( getBrand(product),),
                    const SizedBox(height: 5),
                    Text( '₹ ${getSellingPrice(product)}/-',),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          /*
                            async {
                                    await PersistentShoppingCart().addToCart(
                                      PersistentShoppingCartItem(
                                        productId: productsIds[index],
                                        productName: productNames[index],
                                        productDescription: '',
                                        unitPrice: priceOfProducts[index],
                                        productThumbnail: images[index],
                                        quantity: 1,
                                      ),
                                    );
                                    addToCart(productsIds[index],
                                        categoriesList[index]);
                                    removeFromWishList(productsIds[index]);
                                    setState(() {});
                             */
                          onTap: () {
                            addToCart(getproductid(product),
                                getcategory(product));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 28,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              // vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 0, 143, 124)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 143, 124),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            removeFromWishList(getproductid(product));
                            removed();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.grey[700],
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Remove',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                // trailing: Icon(Icons.edit),
                tileColor: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
  addToCart(productId, category) async {
    String url =
        'https://${ApiServices.ipAddress}/cart_product/$userId/$productId/$category/';

    // log(widget.userId);
    log(productId);
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

  void removed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Item removed from wish list'),
      ),
    );
  }

  removeFromWishList(productId) async {
    String url =
        'https://${ApiServices.ipAddress}/remove_wish/$userId/$productId/';

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

        // Navigator.pop(context);
      } else {
        // Navigator.pop(context);
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
}

