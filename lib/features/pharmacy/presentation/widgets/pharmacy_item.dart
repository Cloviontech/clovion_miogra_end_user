import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/core/widgets/product_box_with_counter.dart';
import 'package:miogra/features/pharmacy/models/all_pharmproducts.dart';
import 'package:miogra/features/pharmacy/models/category_based_pharm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PharmacyItem extends StatefulWidget {
  const PharmacyItem({super.key, required this.subCategory});

  final String subCategory;

  @override
  State<PharmacyItem> createState() => _PharmacyItemState();
}

class _PharmacyItemState extends State<PharmacyItem> {


  List orderedFoods = [];
  List<int> qty = [];


  
  
  static List<AllPharmproducts> categoryBasedPharm =[];

  bool loadingfetchCategoryBasedPharm = true;

  Future<void> fetchCategoryBasedPharm() async {
    // late String userId;
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // userId = preferences.getString("uid2").toString();

    final response = await http.get(Uri.parse(
        "http://${ApiServices.ipAddress}/category_based_pharm/${widget.subCategory}"));
debugPrint('http://${ApiServices.ipAddress}/category_based_pharm/${widget.subCategory}');


debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        categoryBasedPharm = jsonResponse
            .map((data) => AllPharmproducts.fromJson(data))
            .toList();

        loadingfetchCategoryBasedPharm = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  
   updateValueInc(int index1) {
    print('update quantity');
    // setState(() {
      // Increment the value at the specified index
      // if (index >= 0 && index < qty.length) {
      // qty[index1] = qty[index1] + 1;

      qty[index1]++;

      if (!(orderedFoods.any((list) =>
          list.toString() ==
          [categoryBasedPharm[index1].pharmId, categoryBasedPharm[index1].productId]
              .toString()))) {
        // setState(() {
          orderedFoods.insert(index1, [
            categoryBasedPharm[index1].pharmId,
            categoryBasedPharm[index1].productId
          ]);

          print('orderedFoods : $orderedFoods');
        // });
      }

      // addToCart(foodGetProducts[index1].productId,
      //     foodGetProducts[index1].category, qty[index1]);
    // });
    // print('orderedFoods : $orderedFoods');
    print(qty.toString());
    print(qty.length);
    print(qty[index1]);
    print(index1 + 1);
  }

   updateValueDec(int index1) {
    if (qty[index1] >= 1) {
      // setState(() {
        qty[index1]--;
      // });
    } else {}
    ;

    if (qty[index1] == 0) {
      // setState(() {
        orderedFoods.removeAt(
          index1,

          //  [
          //   foodGetProducts[index1].foodId,
          //   foodGetProducts[index1].productId
          // ]
        );

        print('orderedFoods remove : $orderedFoods');
      // });
    }
  }

  List<int> totalQtyBasedPrice = [];

  List<int> totalqty = [];

  int totalQtyBasedPrice1 = 0;

  int totalqty1 = 0;

  calcTotalPriceWithResQty() {
    // setState(() {
      totalQtyBasedPrice1 = 0;
      totalQtyBasedPrice = [];
      totalqty1 = 0;
      totalqty = [];
    // });
    // totalQuantity = 0;
    for (var i = 0; i < categoryBasedPharm.length; i++) {
      // setState(() {
        totalQtyBasedPrice
            .add(categoryBasedPharm[i].product.sellingPrice.toInt() * qty[i]);

        totalqty.add(qty[i]);
      // });
    }

    // setState(() {
      totalQtyBasedPrice1 =
          totalQtyBasedPrice.reduce((value, element) => value + element);

      totalqty1 = totalqty.reduce((value, element) => value + element);
    // });

    print('totalQtyBasedPrice1 $totalQtyBasedPrice1');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategoryBasedPharm().whenComplete(() =>  qty = List<int>.generate(categoryBasedPharm.length, (index) => 0));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
                    height: 70,
                    width: double.maxFinite,
                    decoration: BoxDecoration(color: Color(0xff870081)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
            const SizedBox(
              height: 30,
            ),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.only(left: 5, right: 5),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: .75,
              ),
              itemCount: categoryBasedPharm.length,
              itemBuilder: (context, index) {
                return 
                // ProductBoxWithCounter(
                //   path: categoryBasedPharm[index].product.primaryImage, 
                //   pName: categoryBasedPharm[index].product.name[0],
                //  oldPrice: int.parse(categoryBasedPharm[index].product.actualPrice[0]), newPrice: categoryBasedPharm[index].product.sellingPrice, 
                //  offer: int.parse(categoryBasedPharm[index].product.discountPrice[0]), qty: qty[index], qtyInc: updateValueInc(index),
                //  qtyDec: updateValueDec(index), CalcPrice: calcTotalPriceWithResQty
                
                
                
                // ,);
                
      
                productWithCounterWithRatings(
                    categoryBasedPharm[index].product.primaryImage,
                    categoryBasedPharm[index].product.name[0],
                    int.parse(categoryBasedPharm[index].product.actualPrice[0]),
                    categoryBasedPharm[index].product.sellingPrice,
                    int.parse(categoryBasedPharm[index].product.discountPrice[0]),
                   

  //                   // (){},
  //                    (index) {
  //   print('update quantity');
  //   setState(() {
  //     // Increment the value at the specified index
  //     // if (index >= 0 && index < qty.length) {
  //     // qty[index] = qty[index] + 1;

  //     qty[index]++;

  //     if (!(orderedFoods.any((list) =>
  //         list.toString() ==
  //         [categoryBasedPharm[index].pharmId, categoryBasedPharm[index].productId]
  //             .toString()))) {
  //       setState(() {
  //         orderedFoods.insert(index, [
  //           categoryBasedPharm[index].pharmId,
  //           categoryBasedPharm[index].productId
  //         ]);

  //         print('orderedFoods : $orderedFoods');
  //       });
  //     }

  //     // addToCart(foodGetProducts[index].productId,
  //     //     foodGetProducts[index].category, qty[index]);
  //   });
  //   // print('orderedFoods : $orderedFoods');
  //   print(qty.toString());
  //   print(qty.length);
  //   print(qty[index]);
  //   print(index + 1);
  // },

  //                   (){},
  //                   (){},
  //                    qty[index],
                    
                    
                    
                    
                    );
  //               // productWithCounterWithRatings(
                //     'assets/images/appliances.jpeg',
                //     'The frist medicine you need for oenutoheu oeuntheou',
                //     2000,
                //     1000,
                //     50);
              },
            )
          ],
        ),
      ),
    );
  }
}
