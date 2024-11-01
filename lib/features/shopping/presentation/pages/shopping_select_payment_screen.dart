
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/profile/widgets/your_order_widgets.dart';
import 'package:miogra/features/shopping/presentation/pages/order_placed_succesfully.dart';
import 'package:miogra/models/cart/cartlist_model.dart';
import 'package:miogra/models/profile/all_users_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShoppingSelectPaymentMethod extends StatefulWidget {
  ShoppingSelectPaymentMethod(
      {super.key, required this.shopId, required this.productId, required this.totalPrice,
      //  required this.addressSelected,
      // required this.addressIndex,
      // required this.selectedFoods,
      // this.totalAmount,
      // required this.cartlist, this.noOfProds,


      
      
      });

//  final List<Map> addressSelected;

  // final int addressIndex;
  // final int? totalAmount;

  // final List selectedFoods;

  // final List<Cartlist> cartlist;

  // final String? noOfProds;

  final String shopId;
  final String productId;
  final String totalPrice;
  
  

  @override
  State<ShoppingSelectPaymentMethod> createState() => _ShoppingSelectPaymentMethodState();
}

class _ShoppingSelectPaymentMethodState extends State<ShoppingSelectPaymentMethod> {
  late String uidUser;

  int orderPlacedSuccess = 0;

  List<String> orderedFoodCategory = [
    'shopProduct'
        'jewelProduct',
    'dOriginProduct',
    'dailymioProduct',
    'pharmacyProduct',
    'foodProduct',
    'freshcutProduct',
  ];

  List collectOrderedProductCategoryList = [];

  // Future<void> collectOrderedProductCategoryListMethod() async {
  //   debugPrint('collectOrderedProductCategoryListMethod start');

  //   for (var i = 0; i < widget.cartlist.length; i++) {
  //     if (!(widget.cartlist[i].shopProduct.toString() == null.toString())) {
  //       setState(() {
  //         collectOrderedProductCategoryList.add('shopProduct');
  //       });
  //     } else if (!(widget.cartlist[i].dOriginProduct.toString() ==
  //         null.toString())) {
  //       setState(() {
  //         collectOrderedProductCategoryList.add('dOriginProduct');
  //       });
  //     } else if (!(widget.cartlist[i].dailymioProduct.toString() ==
  //         null.toString())) {
  //       setState(() {
  //         collectOrderedProductCategoryList.add('dailymioProduct');
  //       });
  //     } else if (!(widget.cartlist[i].foodProduct.toString() ==
  //         null.toString())) {
  //       setState(() {
  //         collectOrderedProductCategoryList.add('foodProduct');
  //       });
  //     } else if (!(widget.cartlist[i].freshcutProduct.toString() ==
  //         null.toString())) {
  //       setState(() {
  //         collectOrderedProductCategoryList.add('freshcutProduct');
  //       });
  //     } else if (!(widget.cartlist[i].jewelProduct.toString() ==
  //         null.toString())) {
  //       setState(() {
  //         collectOrderedProductCategoryList.add('jewelProduct');
  //       });
  //     } else if (!(widget.cartlist[i].pharmacyProduct.toString() ==
  //         null.toString())) {
  //       setState(() {
  //         collectOrderedProductCategoryList.add('pharmacyProduct');
  //       });
  //     } else {
  //       // collectOrderedProductCategoryList.add('pharmacyProduct');
  //       null;
  //     }
  //   }
  // }



//   Future createOrder() async {
//     var request;
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     uidUser = prefs.getString("api_response").toString();

//     print("uid for Update $uidUser ");
//     print('userid : $uidUser');
//     debugPrint(widget.cartlist[0].foodProduct.toString());
// debugPrint(widget.cartlist[0].freshcutProduct.toString());

// //  final url = Uri.parse(
// //             "http://${ApiServices.ipAddress}/enduser_order_create/8MF6W8AC3BP/food/${widget.cartlist[i].foodProduct.productId}}");
// //         request = http.MultipartRequest('POST', url);

//     for (var i = 0; i < widget.cartlist.length; i++) {
//       if (!(widget.cartlist[i].foodProduct.toString() == null.toString())) {
//         final url = Uri.parse(
//             "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].foodProduct.productId}/food/");
//         request = http.MultipartRequest('POST', url);

//         debugPrint(uidUser);
//         debugPrint(widget.cartlist[i].foodProduct.productId);
//         debugPrint("http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].foodProduct.productId}/food/");
//       }
//       else if (!(widget.cartlist[i].dOriginProduct.toString() == null.toString())) {
//         final url = Uri.parse(
//             "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].dOriginProduct.productId}/d_original/");
//         request = http.MultipartRequest('POST', url);
//       }
//        else if (!(widget.cartlist[i].dailymioProduct.toString() == null.toString())) {
//         final url = Uri.parse(
//             "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].dailymioProduct.productId}/daily_mio");
//         request = http.MultipartRequest('POST', url);
//       }
//        else if (!(widget.cartlist[i].freshcutProduct.toString() == null.toString())) {
//         final url = Uri.parse(
//             "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].freshcutProduct.productId}/fresh_cuts");
//         request = http.MultipartRequest('POST', url);
//       }
//        else if (!(widget.cartlist[i].jewelProduct.toString() == null.toString())) {
//         final url = Uri.parse(
//             "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].jewelProduct.productId}/jewellery");
//         request = http.MultipartRequest('POST', url);
//       }
//        else if (!(widget.cartlist[i].pharmacyProduct.toString() == null.toString())) {
//         final url = Uri.parse(
//             "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].pharmacyProduct.productId}/pharmacy");
//         request = http.MultipartRequest('POST', url);
//       }
//        else {
//         null;
//        }

//        request.fields['quantity'] = '4';  
//        request.fields['delivery_address'] = endUserMyData.addressData!.toJson().toString();  
//        request.fields['payment_type'] = 'Cash On Delivery';  
       


//       try {
//         final send = await request.send();
//         final response = await http.Response.fromStream(send);
//         print(response.statusCode);
//         // print(response.body);

//         if (response.statusCode == 200) {
//           setState(() {
//             orderPlacedSuccess++;
//           });
//           Fluttertoast.showToast(
//             msg: "order Created Successfully...!",
//             // backgroundColor: ColorConstant.deepPurpleA200,
//             textColor: Colors.white,
//             toastLength: Toast.LENGTH_SHORT,
//           );

//           // print("about candidate ${_users.aboutCandidate}");
//           // Future.delayed(const Duration(seconds: 10), () {});
//           // Navigator.pushNamed(context, AppRoutes.FourteenScreenscr);
//         }
//       } catch (e) {
//         print("Error While Uploading$e");
//       }
//     }

//     if (orderPlacedSuccess == widget.cartlist.length) {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => const OrderSuccess()));
//     }
//   }

//    Future createSingleOrder() async {
   
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     uidUser = prefs.getString("api_response").toString();

//     print("uid for Update $uidUser ");
//     print('userid : $uidUser');
//     debugPrint(widget.selectedFoods[0][1]);
// //     debugPrint(widget.cartlist[0].foodProduct.toString());
// // debugPrint(widget.cartlist[0].freshcutProduct.toString());

//  final url = Uri.parse(
//             // "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.selectedFoods[0][1]}/food");
// "http://${ApiServices.ipAddress}/enduser_order_create/8MF6W8AC3BP/FQ02VWQ03QY/food");
//             debugPrint("http://${ApiServices.ipAddress}/enduser_order_create/8MF6W8AC3BP/FQ02VWQ03QY/food");
//        var request = http.MultipartRequest('POST', url);

    

//        request.fields['quantity'] = '4';  
//        request.fields['delivery_address'] = endUserMyData.addressData!.toJson().toString();  
//        request.fields['payment_type'] = 'Cash On Delivery';  


//        debugPrint(endUserMyData.addressData!.toJson().toString());
       


//       try {
//         final send = await request.send();
//         final response = await http.Response.fromStream(send);
//         print(response.statusCode);
//         // print(response.body);

//         if (response.statusCode == 200) {
//           setState(() {
//             orderPlacedSuccess++;
//           });
//           Fluttertoast.showToast(
//             msg: "Single Order Created Successfully...!",
//             // backgroundColor: ColorConstant.deepPurpleA200,
//             textColor: Colors.white,
//             toastLength: Toast.LENGTH_SHORT,
//           );

//           // print("about candidate ${_users.aboutCandidate}");
//           // Future.delayed(const Duration(seconds: 10), () {});
//           // Navigator.pushNamed(context, AppRoutes.FourteenScreenscr);
//         }

//         else {

//           debugPrint(response.statusCode.toString());
//         }
//       } catch (e) {
//         print("Error While Uploading$e");
//       }
//     }

    // if (orderPlacedSuccess == widget.cartlist.length) {
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const OrderSuccess()));
    // }
  
 Future createSingleOrder1() async {
   
    SharedPreferences prefs = await SharedPreferences.getInstance();

    uidUser = prefs.getString("api_response").toString();

   
    print('userid : $uidUser');
    debugPrint(widget.productId);
    // debugPrint(widget.selectedFoods[0][1]);
//     debugPrint(widget.cartlist[0].foodProduct.toString());
// debugPrint(widget.cartlist[0].freshcutProduct.toString());

 final url = Uri.parse(
            // "http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.selectedFoods[0][1]}/food");
"https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.productId}/shopping/");
            debugPrint("http://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.productId}/fresh_cuts");
       var request = http.MultipartRequest('POST', url);

    

       request.fields['quantity'] = '1';  
      //  request.fields['delivery_address'] = endUserMyData.addressData!.toJson().toString();
       request.fields['delivery_address'] = 'Test Address';
         
       request.fields['payment_type'] = 'Cash On Delivery';  
       request.fields['pincode'] = '600025';  
       


      //  debugPrint(endUserMyData.addressData!.toJson().toString());
       


      try {
        final send = await request.send();
        final response = await http.Response.fromStream(send);
        print(response.statusCode);
        // print(response.body);

        if (response.statusCode == 200) {
          setState(() {
            orderPlacedSuccess++;
          });
          Fluttertoast.showToast(
            msg: "Single Order Created Successfully...!",
            // backgroundColor: ColorConstant.deepPurpleA200,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );

          // print("about candidate ${_users.aboutCandidate}");
          // Future.delayed(const Duration(seconds: 10), () {});
          // Navigator.pushNamed(context, AppRoutes.FourteenScreenscr);
        }

        else {

          debugPrint(response.statusCode.toString());
        }
      } catch (e) {
        print("Error While Uploading$e");
      }
    }

  List<AllUsersData> all_users_data = [];

  AllUsersData endUserMyData = AllUsersData();

  bool loadingFetchAll_users_data = true;

  Future<void> fetchAll_users_data() async {
    print('fetchAll_users_data method start');
    late String userId;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("api_response").toString();

    final response = await http
        .get(Uri.parse('https://${ApiServices.ipAddress}/all_users_data'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      all_users_data =
          responseData.map((json) => AllUsersData.fromJson(json)).toList();

      for (var i = 0; i < all_users_data.length; i++) {
        if (all_users_data[i].uid == userId) {
          setState(() {
            endUserMyData = all_users_data[i];
            loadingFetchAll_users_data = false;
          });
        }
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  String userId = 'a';
  String finalPrice = 'a';
  String finalQty = 'a';

  bool loadingGetFinalPaymentDataFromSharedPreferences = true;

  Future<void> getFinalPaymentDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
      finalPrice = prefs.getString("finalPrice").toString();
      finalQty = prefs.getString("qty").toString();
      loadingGetFinalPaymentDataFromSharedPreferences = false;
    });
  }

  int selectedPaymentMethod = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    // getFinalPaymentDataFromSharedPreferences();
    // fetchAll_users_data();

    // collectOrderedProductCategoryList = [];

    // collectOrderedProductCategoryListMethod();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
        //  loadingGetFinalPaymentDataFromSharedPreferences
        //     ? Center(child: CircularProgressIndicator())
        //     : 
            
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //     'collectOrderedProductCategoryList : ${collectOrderedProductCategoryList.toString()}'),
                    // Text(
                    //     'collectOrderedProductCategoryList : ${collectOrderedProductCategoryList.length}'),
                    // Text(widget.cartlist.length.toString()),
              
                    // Text(widget.cartlist[0].shopProduct.toString()),
                    // Text(widget.cartlist[0].foodProduct.toString()),
                    // Text(null.toString()),
                    // Text(orderPlacedSuccess.toString()),
                    // Text(widget.selectedFoods.toString()),
                    paymentMethod(context),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
              
                    Text(
                      // 'Total Amount : $finalPrice',
                      'Total Amount : ${widget.totalPrice}',
                      // 'Total',
              
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
              
                    Text(
                      "Select Payment Method",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              
                    RadioListTile(
                      value: 1,
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.purple,
                          content: Center(child: Text('Coming Soon')),
                          duration: Duration(seconds: 5),
                        ));
                        // setState(() {
                        //   selectedPaymentMethod = value!;
                        // });
                      },
                      title: Text('UPI'),
                    ),
              
                    RadioListTile(
                      value: 2,
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                      title: Text('Cash On Delivery'),
                    ),
                    // Text(widget.addressIndex.toString()),
              
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
              
                    Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              
                    // Row(
                    //   children: [
                    //     Text(endUserMyData.addressData!.doorno.toString()),
                    //     Text(' , '),
                    //     Text(endUserMyData.addressData!.area.toString()),
                    //   ],
                    // ),
              
                    // Row(
                    //   children: [
                    //     Text(endUserMyData.addressData!.landmark.toString()),
                    //     Text(' , '),
                    //     Text(endUserMyData.addressData!.place.toString()),
                    //   ],
                    // ),
              
                    // Row(
                    //   children: [
                    //     Text(endUserMyData.addressData!.district.toString()),
                    //     Text(' , '),
                    //     Text(endUserMyData.addressData!.state.toString()),
                    //   ],
                    // ),
              
                    // Text(endUserMyData.addressData!.pincode.toString()),
                  ],
                ),
            ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              onPressed: () async {

                createSingleOrder1();
                // collectOrderedProductCategoryListMethod().whenComplete(() => createOrder);
// widget.noOfProds == 'single' ? 


//     createSingleOrder() :

//                 createOrder();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>  AddressPage(amountToBePaid: '${widget.totalPrice + 50}')));
                //
                //                 SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.setString('totalPrice', '${widget.totalPrice + 50}');

                // print('userId : $userId');

                //         userId == null.toString()
                //             ? Navigator.push(context,
                //                 MaterialPageRoute(builder: (context) => const signin()))
                //             :
                //
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => OrderSuccess()));
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


