import 'package:flutter/material.dart';

import 'package:miogra/controllers/shopping/fetch_category.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/core/constants.dart';
import 'package:miogra/features/profile/widgets/order_track_widgets.dart';
import 'package:miogra/features/profile/widgets/address_display_widget.dart';
import 'package:miogra/models/shopping/get_single_shopproduct.dart';

class OrderPage extends StatefulWidget {
  final String? productId;
  final String? shopId;
  const OrderPage({super.key, this.productId, this.shopId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? value = "Qty 1";

  late Future<List<GetSingleShopproduct>> futureSingleProducts;

  @override
  void initState() {
    super.initState();
    futureSingleProducts = fetchSingleShopProducts(widget.shopId.toString(),
        widget.productId.toString(), 'all_shopproducts');
  }

  @override
  Widget build(BuildContext context) {
    const String name = 'boy';
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  // height: 50,
                  // width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                            child: const Text("1",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          Expanded(
                            child: Container(
                              height: 0,
                              // width: (MediaQuery.of(context).size.width) / 5,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: const Text(
                              "2",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                      const Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(),
                          Text(
                            "Order Summary",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            "Payment",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          SizedBox(
                            width: 35,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<GetSingleShopproduct>>(
                    future: futureSingleProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: 180,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(urls[0]),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Trendy Men Dress",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            // "₹641",
                                            snapshot.data![0].product!
                                                .actualPrice![0],
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.black),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "₹600",
                                            style: TextStyle(
                                                color: Color(0xFF3E3E3E),
                                                fontSize: 20),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            width: 75,
                                            height: 25,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: const Text(
                                              "30% OFF",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Size : S"),
                                          SizedBox(width: 10),
                                          Text("Color : Blue"),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: 90,
                                        height: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: .5),
                                        ),
                                        child: DropdownButton<String>(
                                          // Dropdown items
                                          items: <String>[
                                            'Qty 1',
                                            'Qty 2',
                                            'Qty 3',
                                            'Qty 4',
                                            'Qty 5',
                                            'Qty 6',
                                            'Qty 7',
                                            'Qty 8',
                                            'Qty 9',
                                            'Qty 10',
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          // Initial value
                                          value: value,
                                          // On changed callback
                                          onChanged: (String? newValue) {
                                            // Implement your logic here when the dropdown value changes
                                            setState(() {
                                              value = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: 100,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "4.3",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 62, 53, 53)),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                address(context),
                const SizedBox(
                  height: 10,
                ),
                priceContainer(
                  context: context,
                  sellingPrice: 2,
                  qty: 1,
                  deliveryPrice: 100,
                  discount: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
