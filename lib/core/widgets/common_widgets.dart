import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/profile/widgets/your_order_widgets.dart';
import 'package:miogra/features/shopping/presentation/pages/order_placed_succesfully.dart';
import 'package:miogra/models/cart/cartlist_model.dart';
import 'package:miogra/models/profile/all_users_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class D10HCustomClSizedBoxWidget extends StatelessWidget {
  final double height;

  const D10HCustomClSizedBoxWidget({
    super.key,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 1.5,
      height: MediaQuery.of(context).size.height / height,
    );
  }
}

bottomDetailsScreen({
  required BuildContext context,
  required List<String> left,
  required List<String> right,
}) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (context) {
        return
        
         GridView.builder(
          // padding: const EdgeInsets.symmetric(horizontal: 5),
          itemCount: left.length,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0,
            // mainAxisSpacing: 1,
            crossAxisCount: 1,
            // childAspectRatio: .85,
          ),
          itemBuilder: (context, index) {
            return SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    left[index],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text(' : '),
                  Text(
                    right[index],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
}

class SelectPaymentMethod extends StatefulWidget {
  SelectPaymentMethod(
      {super.key,
      //  required this.addressSelected,
      required this.addressIndex,
      required this.selectedFoods,
      this.totalAmount,
      required this.cartlist, this.noOfProds,  this.qty, this.totalQty, });

//  final List<Map> addressSelected;

  final int addressIndex;
  final int? totalAmount;

  final List selectedFoods;

  final List<Cartlist> cartlist;

  final String? noOfProds;

   final List<int>? qty;

   final int? totalQty;

  

  @override
  State<SelectPaymentMethod> createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
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

  Future<void> collectOrderedProductCategoryListMethod() async {
    debugPrint('collectOrderedProductCategoryListMethod start');

    for (var i = 0; i < widget.cartlist.length; i++) {
      if (!(widget.cartlist[i].shopProduct.toString() == null.toString())) {
        setState(() {
          collectOrderedProductCategoryList.add('shopProduct');
        });
      } else if (!(widget.cartlist[i].dOriginProduct.toString() ==
          null.toString())) {
        setState(() {
          collectOrderedProductCategoryList.add('dOriginProduct');
        });
      } else if (!(widget.cartlist[i].dailymioProduct.toString() ==
          null.toString())) {
        setState(() {
          collectOrderedProductCategoryList.add('dailymioProduct');
        });
      } else if (!(widget.cartlist[i].foodProduct.toString() ==
          null.toString())) {
        setState(() {
          collectOrderedProductCategoryList.add('foodProduct');
        });
      } else if (!(widget.cartlist[i].freshcutProduct.toString() ==
          null.toString())) {
        setState(() {
          collectOrderedProductCategoryList.add('freshcutProduct');
        });
      } else if (!(widget.cartlist[i].jewelProduct.toString() ==
          null.toString())) {
        setState(() {
          collectOrderedProductCategoryList.add('jewelProduct');
        });
      } else if (!(widget.cartlist[i].pharmacyProduct.toString() ==
          null.toString())) {
        setState(() {
          collectOrderedProductCategoryList.add('pharmacyProduct');
        });
      } else {
        // collectOrderedProductCategoryList.add('pharmacyProduct');
        null;
      }
    }
  }

  Future createOrder() async {

    debugPrint('createOrder method start');
    var request;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    uidUser = prefs.getString("api_response").toString();

   
    print('userid : $uidUser');
    debugPrint(widget.cartlist[0].foodProduct.toString());
debugPrint(widget.cartlist[0].freshcutProduct.toString());

//  final url = Uri.parse(
//             "https://${ApiServices.ipAddress}/enduser_order_create/8MF6W8AC3BP/food/${widget.cartlist[i].foodProduct.productId}}");
//         request = http.MultipartRequest('POST', url);

    for (var i = 0; i < widget.cartlist.length; i++) {
      if (!(widget.cartlist[i].foodProduct.toString() == null.toString())) {
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].foodProduct.productId}/food/");
        request = http.MultipartRequest('POST', url);

        debugPrint(uidUser);
        debugPrint(widget.cartlist[i].foodProduct.productId);
        // debugPrint("https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].foodProduct.productId}/food/");
      }
      else if (!(widget.cartlist[i].dOriginProduct.toString() == null.toString())) {
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].dOriginProduct.productId}/d_original/");
        request = http.MultipartRequest('POST', url);
      }
       else if (!(widget.cartlist[i].dailymioProduct.toString() == null.toString())) {
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].dailymioProduct.productId}/daily_mio");
        request = http.MultipartRequest('POST', url);
      }
       else if (!(widget.cartlist[i].freshcutProduct.toString() == null.toString())) {
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].freshcutProduct.productId}/fresh_cuts");
        request = http.MultipartRequest('POST', url);
      }
       else if (!(widget.cartlist[i].jewelProduct.toString() == null.toString())) {
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].jewelProduct.productId}/jewellery");
        request = http.MultipartRequest('POST', url);
      }
       else if (!(widget.cartlist[i].pharmacyProduct.toString() == null.toString())) {
        final url = Uri.parse(
            "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.cartlist[i].pharmacyProduct.productId}/pharmacy");
        request = http.MultipartRequest('POST', url);
      }
       else {
        null;
       }

       request.fields['quantity'] = '4';  
       request.fields['delivery_address'] = endUserMyData.addressData!.toJson().toString();  
       request.fields['payment_type'] = 'Cash On Delivery';  
       request.fields['pincode'] = '600000';  
       
       


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
            msg: "order Created Successfully...!",
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );

        }
      } catch (e) {
        print("Error While Uploading$e");
      }
    }

    if (orderPlacedSuccess == widget.cartlist.length) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const OrderSuccess()));
    }
  }

   Future createSingleOrder() async {
    debugPrint('createSingleOrder method start');
   
    SharedPreferences prefs = await SharedPreferences.getInstance();

    uidUser = prefs.getString("api_response").toString();

    // print("uid for Update $uidUser ");
    print('userid : $uidUser');
    debugPrint(widget.selectedFoods[0][1]);
    debugPrint(widget.selectedFoods.length.toString());
    debugPrint(widget.selectedFoods.toString());
    // debugPrint(widget.);
//     debugPrint(widget.cartlist[0].foodProduct.toString());
// debugPrint(widget.cartlist[0].freshcutProduct.toString());



for (var i = 0; i < widget.selectedFoods.length; i++) {

  final url = Uri.parse(
            // "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.selectedFoods[0][1]}/food");
"https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.selectedFoods[i][1]}/food/");
            debugPrint("https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.selectedFoods[i][1]}/food/");
       var request = http.MultipartRequest('POST', url);

    

       request.fields['quantity'] = widget.qty![i].toString();  
       request.fields['delivery_address'] = 'Test Address';  
       request.fields['payment_type'] = 'Cash On Delivery';  
       request.fields['pincode'] = '600001';  
       


      //  debugPrint(endUserMyData.addressData!.toJson().toString());
       


      try {
        final send = await request.send();
        final response = await http.Response.fromStream(send);
        print(response.statusCode);
        // print(response.body);

        if (response.statusCode == 200) {


             Fluttertoast.showToast(
            msg: "Cetogory Order Created Successfully...!",
            // backgroundColor: ColorConstant.deepPurpleA200,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
          
          setState(() {
            orderPlacedSuccess++;
            debugPrint(orderPlacedSuccess.toString());
            debugPrint(widget.totalQty.toString());
            
          });
             orderPlacedSuccess == widget.qty!.length ?
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  OrderSuccess())) : null;
    
       

       

          
        }

        else {

          debugPrint(response.statusCode.toString());
        }
      } catch (e) {
        print("Error While Uploading$e");
      }
  
}

//  final url = Uri.parse(
//             // "https://${ApiServices.ipAddress}/enduser_order_create/$uidUser/${widget.selectedFoods[0][1]}/food");
// "https://${ApiServices.ipAddress}/enduser_order_create/8MF6W8AC3BP/FQ02VWQ03QY/food");
//             debugPrint("https://${ApiServices.ipAddress}/enduser_order_create/8MF6W8AC3BP/FQ02VWQ03QY/food");
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
    }

    // if (orderPlacedSuccess == widget.cartlist.length) {
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const OrderSuccess()));
    // }
  

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
    getFinalPaymentDataFromSharedPreferences();
    fetchAll_users_data();

    collectOrderedProductCategoryList = [];

    collectOrderedProductCategoryListMethod();

    orderPlacedSuccess =0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: loadingGetFinalPaymentDataFromSharedPreferences
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(widget.totalQty!.toString()),
                    Text(orderPlacedSuccess.toString()),



                    

                    Text(widget.qty.toString()),
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
                      'Total Amount : ${widget.totalAmount}',
              
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
              
                    Row(
                      children: [
                        Text(endUserMyData.addressData!.doorno.toString()),
                        Text(' , '),
                        Text(endUserMyData.addressData!.area.toString()),
                      ],
                    ),
              
                    Row(
                      children: [
                        Text(endUserMyData.addressData!.landmark.toString()),
                        Text(' , '),
                        Text(endUserMyData.addressData!.place.toString()),
                      ],
                    ),
              
                    Row(
                      children: [
                        Text(endUserMyData.addressData!.district.toString()),
                        Text(' , '),
                        Text(endUserMyData.addressData!.state.toString()),
                      ],
                    ),
              
                    Text(endUserMyData.addressData!.pincode.toString()),
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
                // collectOrderedProductCategoryListMethod().whenComplete(() => createOrder);
widget.noOfProds == 'single' ? 


    createSingleOrder() :

                createOrder();
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




class productBox1 extends StatefulWidget {
   productBox1({super.key, 
  required this.context, 
   required this.primaryImage, 
   required this.name, 
   required this.actualPrice, 
   required this.sellingPrice,
    required this.remove, 
    required this.rating, 
    required this.items,  
    this.onTabQty,
   required this.selectedItem , required this.onChanged,
    
    
    });


  final BuildContext context;
    final String primaryImage;
    final String name;
    final String actualPrice;
    final String sellingPrice;
    final VoidCallback remove;
    String rating = '4.3';
    
    Function(String)? onTabQty;
    final List <String> items ;
    final String selectedItem ;
    final ValueChanged<String?>? onChanged;

  @override
  State<productBox1> createState() => _productBox1State();
}

class _productBox1State extends State<productBox1> {
  @override
  Widget build(BuildContext context) {
    return  Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image:
                            // AssetImage(
                            //     'assets/woman-5828786_1280.jpg'),

                            NetworkImage(widget.primaryImage),
                        fit: BoxFit.cover)),
              )),
          // Expanded(
          // flex: 1,
          // child:
          SizedBox(
            width: 10,
          ),
          // ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // 'Trendy Women\'s Jacket',
                     widget. name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Container(
                      // height: 25,
                      // width: 75,
                      padding: EdgeInsets.all(5),
                      // margin: const EdgeInsets.only(
                      //     top: 10),
                      // height: MediaQuery.of(context)
                      //         .size
                      //         .height *
                      //     0.05,
                      // width: MediaQuery.of(context)
                      //         .size
                      //         .width *
                      //     0.17,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.purple),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            // '4.3',
                            widget.rating,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      // '767',
                     widget. actualPrice.toString(),
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          decorationColor: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      // '676',
                    widget.  sellingPrice.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: Colors.greenAccent,
                      // height: MediaQuery.of(context)
                      //         .size
                      //         .height *
                      //     0.03,
                      // width: MediaQuery.of(context)
                      //         .size
                      //         .width *
                      //     0.15,
                      child: Center(
                          child: Text(
                        '30% Off',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Size  :  S ,',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Color  : Blue',
                      style: TextStyle(fontSize: 14),
                    ),
                    // SizedBox(width: 20,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButton<String>(
      value: widget. selectedItem,
      onChanged: widget.onChanged,
      items: widget. items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: SizedBox()),

                    TextButton.icon(
                        onPressed:widget. remove,
                        icon: Icon(
                          Icons.delete_outlined,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Remove',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      // const Row(
      //   children: [
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Icon(
      //       Icons.delivery_dining,
      //       color: Colors.green,
      //       size: 34,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Text(
      //       'Delivery Within 2 Days',
      //       style: TextStyle(
      //           color: Colors.black45,
      //           fontSize: 18,
      //           fontWeight: FontWeight.w500),
      //     ),
      //   ],
      // ),
    ],
  );

  }
}

Widget productDetailsBoxSrn(
    {required BuildContext context,
    required String primaryImage,
    required String name,
    required String actualPrice,
    required String sellingPrice,
    required VoidCallback remove,
    String rating = '4.3',
    required List <String> qtyItems ,
    Function(String)? onTabQty,
    String selectedItem = '1'
    
    
    
    }) 
    
    
    
    {
  return 
  Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image:
                            // AssetImage(
                            //     'assets/woman-5828786_1280.jpg'),

                            NetworkImage(primaryImage),
                        fit: BoxFit.cover)),
              )),
          // Expanded(
          // flex: 1,
          // child:
          SizedBox(
            width: 10,
          ),
          // ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // 'Trendy Women\'s Jacket',
                      name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Container(
                      // height: 25,
                      // width: 75,
                      padding: EdgeInsets.all(5),
                      // margin: const EdgeInsets.only(
                      //     top: 10),
                      // height: MediaQuery.of(context)
                      //         .size
                      //         .height *
                      //     0.05,
                      // width: MediaQuery.of(context)
                      //         .size
                      //         .width *
                      //     0.17,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.purple),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '4.3',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      // '767',
                      actualPrice.toString(),
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          decorationColor: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      // '676',
                      sellingPrice.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: Colors.greenAccent,
                      // height: MediaQuery.of(context)
                      //         .size
                      //         .height *
                      //     0.03,
                      // width: MediaQuery.of(context)
                      //         .size
                      //         .width *
                      //     0.15,
                      child: Center(
                          child: Text(
                        '30% Off',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Size  :  S ,',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Color  : Blue',
                      style: TextStyle(fontSize: 14),
                    ),
                    // SizedBox(width: 20,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButton<String>(
                            value: selectedItem,
                            onChanged: (value) {
                              onTabQty;
                            },

                            // (String? newValue) {
                            //   setState(() {
                            //     selectedItem = newValue!;
                            //   });
                            // },
                            items: qtyItems
                            
                            // <String>[
                            //   '1',
                            //   '2',
                            //   '3',
                            //   '4'
                            // ]
                            
                            
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('$value Item'),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: SizedBox()),

                    TextButton.icon(
                        onPressed: remove,
                        icon: Icon(
                          Icons.delete_outlined,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Remove',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      // const Row(
      //   children: [
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Icon(
      //       Icons.delivery_dining,
      //       color: Colors.green,
      //       size: 34,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Text(
      //       'Delivery Within 2 Days',
      //       style: TextStyle(
      //           color: Colors.black45,
      //           fontSize: 18,
      //           fontWeight: FontWeight.w500),
      //     ),
      //   ],
      // ),
    ],
  );



}
