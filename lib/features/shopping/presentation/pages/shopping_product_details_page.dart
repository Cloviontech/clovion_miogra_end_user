import 'package:flutter/material.dart';
import 'package:miogra/controllers/shopping/fetch_category.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/core/constants.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/core/widgets/common_widgets.dart';
import 'package:miogra/features/shopping/presentation/pages/your_order.dart';
import 'package:miogra/features/jewellery/models/all_jewelproducts_model.dart';
import 'package:miogra/features/shopping/presentation/widgets/ratings.dart';
import 'package:miogra/features/shopping/presentation/widgets/recently_viewed.dart';
import 'package:miogra/models/shopping/get_single_shopproduct.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final String? productId;
  final String? shopId;
  final String? link;
  final String? subCategory;

  const ProductDetails({
    super.key,
    this.productId,
    this.shopId,
    this.link,
    this.subCategory,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String url = urls[0];
  String selected = "";

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

  String userId = 'a';

  addToCart(String productId, String subCategory, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });

    debugPrint('userId : $userId');
    debugPrint('productId : $productId');
    debugPrint('subCategory : $subCategory');
    debugPrint('quantity : $quantity');

    var headers = {
      'Context-Type': 'application/json',
    };

    var requestBody = {
      "quantity": quantity.toString(),
      // 'area': areaController.text,
    };

    try {
      var response = await https.post(
        Uri.parse(
            "https://${ApiServices.ipAddress}/cart_product/$userId/$productId/$subCategory/"),
        headers: headers,
        body: requestBody,
      );
      debugPrint(
          "https://${ApiServices.ipAddress}/cart_product/$userId/$productId/$subCategory/}");
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        print(response.statusCode);
        debugPrint(response.body);
        print('Product Added To Cart Successfully');
      } else {
        print('status code : ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String totalPrice = '';

  late Future<List<GetSingleShopproduct>> futureSingleShopProducts;
  late Future<List<AllJewelproducts>> futureSingleJewelProducts;

  @override
  void initState() {
    super.initState();

    widget.link == 'single_jewelproduct'
        ? futureSingleJewelProducts = fetchSingleJewelProducts(
            widget.shopId.toString(),
            widget.productId.toString(),
            widget.link.toString())
        : widget.link == 'get_single_shopproduct'
            ? futureSingleShopProducts = fetchSingleShopProducts(
                widget.shopId.toString(),
                widget.productId.toString(),
                widget.link.toString())
            : fetchSingleJewelProducts(widget.shopId.toString(),
                widget.productId.toString(), widget.link.toString());
  }

  @override
  Widget build(BuildContext context) {
    const String name = 'boy';
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBF1),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.favorite),
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
                onTap: () {
                  addToCart(widget.productId.toString(),
                      widget.subCategory.toString(), 1);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: primaryColor, width: 1)),
                  child: const Text(
                    "Add To Cart",
                    style: TextStyle(fontSize: 18, color: primaryColor),
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

                            // OrderPage(shopId: widget.shopId,productId:  widget.productId)
                            YourOrderPage(
                              shopId: widget.shopId,
                              productId: widget.productId,
                              totalPrice: getSingleShopproductS[0]
                                  .product!
                                  .sellingPrice
                                  .toString(),
                            )));
              },
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                color: primaryColor,
                child: const Text(
                  "Buy Now",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.link == 'get_single_shopproduct'
                ? FutureBuilder<List<GetSingleShopproduct>>(
                    future: futureSingleShopProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot
                                          .data![0].product!.primaryImage!),
                                    )),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 100,
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // itemCount: urls.length,
                                  itemCount: snapshot
                                      .data![0].product!.otherImages!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          mainAxisSpacing: 5),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          url = urls1[index];
                                          // url = "http://192.168.1.6:8000//media/api/shop_products/QMC77LVGSXM/other_images/nokkiya_Qgkzkw2.jpg";
                                        });
                                      },
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: .2),
                                            image: DecorationImage(
                                                image: NetworkImage(snapshot
                                                        .data![0]
                                                        .product!
                                                        .otherImages![index]
                                                    // urls1[index]
                                                    // "http://192.168.1.6:8000//media/api/shop_products/QMC77LVGSXM/other_images/nokkiya_Qgkzkw2.jpg",

                                                    ))),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // "Trendy Men's Dress",
                                      snapshot.data![0].product!.name![0],
                                      //  '${snapshot.data![0].product!.primaryImage!}',
                                      style: const TextStyle(fontSize: 21),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.share_outlined,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.favorite_border,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      // "₹641",
                                      snapshot
                                          .data![0].product!.actualPrice![0],
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          decorationColor:
                                              Colors.grey.shade700),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      // "₹641",
                                      snapshot.data![0].product!.sellingPrice
                                          .toString(),
                                      style: const TextStyle(fontSize: 21),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: 75,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        // "5% OFF",
                                        '${snapshot.data![0].product!.discountPrice![0]}% OFF',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Seller ID : ${snapshot.data![0].shopId}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Delivery Within 2 Days",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 20)
                            ],
                          ),
                        );
                      }
                    },
                  )
                : FutureBuilder<List<AllJewelproducts>>(
                    future: futureSingleJewelProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot
                                          .data![0].product.primaryImage),
                                    )),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 100,
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // itemCount: urls.length,
                                  itemCount: snapshot
                                      .data![0].product.otherImages.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          mainAxisSpacing: 5),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          url = urls1[index];
                                          // url = "http://192.168.1.6:8000//media/api/shop_products/QMC77LVGSXM/other_images/nokkiya_Qgkzkw2.jpg";
                                        });
                                      },
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: .2),
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                    .data![0]
                                                    .product
                                                    .otherImages[index]
                                                // urls1[index]
                                                // "http://192.168.1.6:8000//media/api/shop_products/QMC77LVGSXM/other_images/nokkiya_Qgkzkw2.jpg",

                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // "Trendy Men's Dress",
                                      snapshot.data![0].product.name[0],
                                      //  '${snapshot.data![0].product!.primaryImage!}',
                                      style: const TextStyle(fontSize: 21),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.share_outlined,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.favorite_border,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      // "₹641",
                                      snapshot.data![0].product.actualPrice[0],
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          decorationColor:
                                              Colors.grey.shade700),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      // "₹641",
                                      snapshot.data![0].product.sellingPrice
                                          .toString(),
                                      style: const TextStyle(fontSize: 21),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: 75,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        // "5% OFF",
                                        '${snapshot.data![0].product.discountPrice[0]}% OFF',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Seller ID : ${snapshot.data![0].jewelId}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Delivery Within 2 Days",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 20)
                            ],
                          ),
                        );
                      }
                    },
                  ),

            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Size",
                        style: TextStyle(
                            fontSize: 17, color: Colors.grey.shade800),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          customRadio("XS", "xs"),
                          const SizedBox(width: 10),
                          customRadio("S", "s"),
                          const SizedBox(width: 10),
                          customRadio("M", "m"),
                          const SizedBox(width: 10),
                          customRadio("L", "l"),
                          const SizedBox(width: 10),
                          customRadio("XL", "xl"),
                          const SizedBox(width: 10),
                          customRadio("XXL", "xxl")
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 5,
            ),
            // Product Details
            GestureDetector(
              onTap: () {
                bottomDetailsScreen(
                    context: context,
                    left: ["first", "second", 'Third'],
                    right: ['value1', 'value2', 'value3']);
                // showModalBottomSheet(
                //     shape: const RoundedRectangleBorder(
                //         borderRadius:
                //             BorderRadius.vertical(top: Radius.circular(20))),
                //     context: context,
                //     builder: (context) {
                //       return Container(
                //         padding: const EdgeInsets.only(top: 10, left: 10),
                //         width: double.infinity,
                //         child: const Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               "Trendy Women Dress",
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 color: Colors.black,
                //               ),
                //             ),
                //             SizedBox(height: 10),
                //             Text(
                //               "The Casual Long Sleeve Floral Maxi Dress For Women Is Made Of Soft And Breathable Fabric, Which Is Skin-Friendly And Comfortable To Wear. Thanks To Loose Fit Cut, This Cocktail Dress Is Fit For Most Figures. The Partially Lined Ensures The Smocked Tiered Flowy Boho Long Dress Not See Through",
                //               style: TextStyle(
                //                   fontSize: 15, color: Colors.black87),
                //             ),
                //           ],
                //         ),
                //       );
                //     });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text("Product Details",
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      """The Casual Long Sleeve Floral Maxi Dress For Women Is Made Of Soft And Breathable Fabric, Which Is Skin-Friendly And Comfortable To Wear""",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
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
                  const Text("Reviews and Ratings",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Center(
                      child: Column(
                    children: [
                      const Text(
                        "3.5",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      starRating(2.3),
                      Text("1,342 ratings",
                          style: TextStyle(color: Colors.grey.shade500)),
                      Text("1,000 reviews",
                          style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  )),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: .2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Krithi",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 25,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "4.3",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.star,
                                        color: Colors.white, size: 15)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.more_horiz_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Really Happy With The Product",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text("2 Days ago",
                              style: TextStyle(color: Colors.grey.shade600)),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                  const Row(
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 5),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child:
                        Text("Recently Viewed", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 130,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      shrinkWrap: false,
                      itemCount: 10,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return recentlyViewed(context, () {},
                            image:
                                "https://i.pinimg.com/736x/83/1e/8a/831e8abf10dae58a8991330099e6ae0d.jpg",
                            name: "T Shirts");
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                // color: Color(0xffF0E6EF),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Similar Products",
                          style: TextStyle(fontSize: 19),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "View All",
                                    style: TextStyle(color: Color(0xff870081)),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Icon(
                                    Icons.arrow_circle_right_rounded,
                                    color: Color(0xff870081),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    crossAxisSpacing: 5,
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    childAspectRatio: .85,
                    children: <Widget>[
                      productBox(
                          imageUrl: 'assets/images/home-theater.jpeg',
                          pName: 'Home Theater',
                          oldPrice: 7000,
                          newPrice: 5000,
                          rating: 0,
                          offer: 30,
                          color: const Color(0x6B870081),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductDetails()));
                          }),
                      productBox(
                          imageUrl: 'assets/images/home-theater.jpeg',
                          pName: 'Home Theater',
                          oldPrice: 7000,
                          newPrice: 5000,
                          rating: 0,
                          offer: 30,
                          color: const Color(0x6B870081),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductDetails()));
                          }),
                      productBox(
                          imageUrl: 'assets/images/home-theater.jpeg',
                          pName: 'Home Theater',
                          oldPrice: 7000,
                          newPrice: 5000,
                          rating: 0,
                          offer: 30,
                          color: const Color(0x6B870081),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductDetails()));
                          }),
                      productBox(
                        imageUrl: 'assets/images/home-theater.jpeg',
                        pName: 'Home Theater',
                        oldPrice: 7000,
                        newPrice: 5000,
                        offer: 30,
                        rating: 0,
                        color: const Color(0x6B870081),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductDetails(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
