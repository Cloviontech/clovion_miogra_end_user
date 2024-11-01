import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/food/presentation/pages/food_items.dart';
import 'package:miogra/features/food/presentation/pages/ordering_for_page.dart';
import 'package:miogra/models/freshcuts/all_freshcutproducts_model.dart';

import 'package:http/http.dart' as http;

class PharmacyProductsPage extends StatefulWidget {
  const PharmacyProductsPage({super.key, required this.categoryName});

  final String categoryName;

  @override
  State<PharmacyProductsPage> createState() => _PharmacyProductsPageState();
}

class _PharmacyProductsPageState extends State<PharmacyProductsPage> {
  List orderedFoods = [];
  List<int> qty = [];
  void updateValueInc(int index1) {
    print('update quantity');
    setState(() {
      // Increment the value at the specified index
      // if (index >= 0 && index < qty.length) {
      // qty[index1] = qty[index1] + 1;

      qty[index1]++;

      if (!(orderedFoods.any((list) =>
          list.toString() ==
          [product[index1].freshId, product[index1].productId].toString()))) {
        setState(() {
          orderedFoods.insert(
              index1, [product[index1].freshId, product[index1].productId]);

          print(orderedFoods);
        });
      }
    });
    print(qty.toString());
    print(qty.length);
    print(qty[index1]);
    print(index1 + 1);
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
          //   product[index1].foodId,
          //   product[index1].productId
          // ]
        );

        print('orderedFoods remove : $orderedFoods');
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
    for (var i = 0; i < product.length; i++) {
      setState(() {
        totalQtyBasedPrice
            .add(product[i].product.sellingPrice.toInt() * qty[i]);

        totalqty.add(qty[i]);
      });
    }

    setState(() {
      totalQtyBasedPrice1 =
          totalQtyBasedPrice.reduce((value, element) => value + element);

      totalqty1 = totalqty.reduce((value, element) => value + element);
    });

    print('totalQtyBasedPrice1 $totalQtyBasedPrice1');
  }

  static List<AllFreshcutproducts> allFreshcutproducts = [];

  List<AllFreshcutproducts> product = [];

  bool loadingFetchAllFreshcutproducts = true;

  Future<void> fetchAllFreshcutproducts() async {
    final response = await http
        .get(Uri.parse('http://${ApiServices.ipAddress}/all_freshcutproducts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        allFreshcutproducts = jsonResponse
            .map((data) => AllFreshcutproducts.fromJson(data))
            .toList();

        for (var i = 0; i < allFreshcutproducts.length; i++) {
          if (allFreshcutproducts[i].subcategory == widget.categoryName) {
            product.add(allFreshcutproducts[i]);

            loadingFetchAllFreshcutproducts = false;
          }
        }
      });

      // return data.map((json) => product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchAllFreshcutproducts().whenComplete(
      () => qty = List<int>.generate(product.length, (index) => 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // toolbarHeight: 5,
      //   elevation: 10,

      //  backgroundColor: const Color(0xff870081),
      // ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: loadingFetchAllFreshcutproducts
                ? const Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Center(child: CircularProgressIndicator())),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),

                      // Text(product[0].productId),

                      // Text(
                      //   product[0].product.primaryImage.toString(),
                      // ),
                      // SizedBox(
                      //   height: 200,
                      //   width: 200,
                      //   child: Image.network("https://c.ndtvimg.com/2022-07/q8dnkacg_chicken_625x300_06_July_22.jpg?im=FeatureCrop,algorithm=dnn,width=620,height=350")),

                      // productWithCounter();

                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: product.length,
                        controller: ScrollController(),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 15,
                                childAspectRatio: 2.1),
                        itemBuilder: (context, index) {
                          return Container(
                            // padding: const EdgeInsets.only(top: 7),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
//  Text(product.length.toString()),

                                      // Text(foods![index].foodId.toString()),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              // image: AssetImage(
                                              //     'assets/images/appliances.jpeg'),

                                              image: NetworkImage(
                                                // foods![index]
                                                product[index]
                                                    .product
                                                    .primaryImage
                                                    .toString(),
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  updateValueDec(index);

                                                  calcTotalPriceWithResQty();
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xff870081),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  height: 30,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "-",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 35,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff870081))),
                                                child: Text(
                                                  // _quantity
                                                  //     .toString(),
                                                  qty[index].toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff870081),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  updateValueInc(index);

                                                  calcTotalPriceWithResQty();
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              Color(0xff870081),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5),
                                                          )),
                                                  height: 30,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "+",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        // flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // "Chiken Manchurian",
                                              product[index].product.name![0],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 19,
                                                color: Color(0xE6434343),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              // "₹150",
                                              '₹ ${product[index].product.sellingPrice}',
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  color: Color(0xE6434343)),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20))),
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(30.0),
                                                          child: Column(
                                                            children: [
                                                              // temperory used for description
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child: Image.network(
                                                                    product[index]
                                                                        .product
                                                                        .primaryImage),
                                                              ),
                                                              const SizedBox(
                                                                height: 50,
                                                              ),
                                                              Text(
                                                                product[index]
                                                                    .product
                                                                    .otherImages![0],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Text(
                                                // temperory used for description

                                                product[index]
                                                    .product
                                                    .otherImages![0],

                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xE6434343)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  )),
      ),

      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const OrderSuccess()));

                bottomDetailsScreen(
                    context: context,
                    qtyB: totalqty1,
                    priceB: totalQtyBasedPrice1,
                    deliveryB: 50);
              },
              child:
                  // Text(
                  //   '$totalqty1 Items | ₹ ${totalQtyBasedPrice1}',
                  //   style: TextStyle(color: Colors.purple, fontSize: 18),
                  // ),

                  AutoSizeText(
                '$totalqty1 Items | ₹ ${totalQtyBasedPrice1 + (totalQtyBasedPrice1 == 0 ? 0 : 50)}',
                minFontSize: 18,
                maxFontSize: 24,
                maxLines: 1, // Adjust this value as needed
                overflow: TextOverflow.ellipsis, // Handle overflow text
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: WidgetStateProperty.all(Colors.purple),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderingFor(
                              totalPrice: totalQtyBasedPrice1,
                              totalQty: totalqty1,
                              selectedFoods: orderedFoods,
                              qty: qty,
                              productCategory: 'pharmacy',
                            )));
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
