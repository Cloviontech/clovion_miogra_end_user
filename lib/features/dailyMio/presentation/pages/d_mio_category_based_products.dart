// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:miogra/core/api_services.dart';

// import 'package:miogra/features/dailyMio/models/category_based_dmio_model.dart';
// import 'package:miogra/features/dailyMio/presentation/pages/d_mio_single_product_details_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class DailyMioCategoryBasedProductsScreen extends StatefulWidget {
//   const DailyMioCategoryBasedProductsScreen(
//       {super.key, required this.subCategory});

//   final String subCategory;

//   @override
//   State<DailyMioCategoryBasedProductsScreen> createState() =>
//       _DailyMioCategoryBasedProductsScreenState();
// }

// class _DailyMioCategoryBasedProductsScreenState
//     extends State<DailyMioCategoryBasedProductsScreen> {
//   final int _selectedValue = 1;

//   void _showModalBottomSheet(BuildContext context) {
//     int selectedValue = 1;

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SizedBox(
//           height: 200, // Adjust the height as needed
//           child: ListView(
//             children: <Widget>[
//               RadioListTile<int>(
//                 title: const Text('Option 1'),
//                 value: 1,
//                 groupValue: selectedValue,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedValue = value!;
//                   });
//                 },
//               ),
//               RadioListTile<int>(
//                 title: const Text('Option 2'),
//                 value: 2,
//                 groupValue: selectedValue,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedValue = value!;
//                   });
//                 },
//               ),
//               RadioListTile<int>(
//                 title: const Text('Option 3'),
//                 value: 3,
//                 groupValue: selectedValue,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedValue = value!;
//                   });
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   int groupValueSubscribe = 1;
//   List valueSubscribe = [1, 2, 3, 4];

//   static late List<CategoryBasedDmio> categoryBasedDmio;

//   bool loadingfetchCategoryBasedDmio = true;

//   // Future<void> fetchCategoryBasedDmio() async {

//   //   late String privateInvesticatorId;
//   //   SharedPreferences preferences = await SharedPreferences.getInstance();
//   //   privateInvesticatorId = preferences.getString("uid2").toString();

//   //   final response = await http.get(Uri.parse(
//   //       "http://${ApiServices.ipAddress}/category_based_dmio/${widget.subCategory}"));

//   //   if (response.statusCode == 200) {
//   //     List<dynamic> jsonResponse = jsonDecode(response.body);
//   //     setState(() {
//   //       categoryBasedDmio = jsonResponse
//   //           .map((data) => CategoryBasedDmio.fromJson(data))
//   //           .toList();

//   //       loadingfetchCategoryBasedDmio = false;
//   //     });
//   //   } else {
//   //     throw Exception('Failed to load data');
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // fetchCategoryBasedDmio();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 7),
//           child: loadingfetchCategoryBasedDmio
//               ? const CircularProgressIndicator()
//               : Column(
//                   children: [
//                     Container(
//                       height: 70,
//                       width: double.maxFinite,
//                       decoration: const BoxDecoration(color: Color(0xff870081)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(
//                                     Icons.arrow_back,
//                                     color: Colors.white,
//                                   )),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Text(categoryBasedDmio[0].productId),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       primary: false,
//                       padding: const EdgeInsets.only(left: 5, right: 5),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 1,
//                               crossAxisSpacing: 5,
//                               mainAxisSpacing: 5,
//                               childAspectRatio: 2.8),
//                       itemCount: categoryBasedDmio.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           padding: const EdgeInsets.only(top: 7),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(context,
//                                   MaterialPageRoute(builder: (context) {
//                                 return DMioSingleProductDetailsScreen(
                             
//                                   primaryImage: categoryBasedDmio[index]
//                                       .product
//                                       .primaryImage,
//                                   name:
//                                       categoryBasedDmio[index].product.name[0],
//                                   price: categoryBasedDmio[index]
//                                       .product
//                                       .sellingPrice
//                                       .toString(),
//                                   description: categoryBasedDmio[index]
//                                       .product
//                                       .subcategory[0],
//                                 );
//                               }));
//                             },
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 2,
//                                   child: SizedBox(
//                                     child: Column(
//                                       children: [
//                                         Expanded(
//                                           // flex: 3,
//                                           child: Container(
//                                             margin: const EdgeInsets.symmetric(
//                                                 horizontal: 10),
//                                             decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                 image: NetworkImage(
//                                                   // 'assets/images/appliances.jpeg'
//                                                   categoryBasedDmio[index]
//                                                       .product
//                                                       .primaryImage,
//                                                 ),
//                                                 fit: BoxFit.fill,
//                                               ),
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(15)),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: SizedBox(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           // flex: 3,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 // "Milma 1/2 litre Pack",
//                                                 categoryBasedDmio[index]
//                                                     .product
//                                                     .name[0],
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 19,
//                                                   color: Color(0xE6434343),
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Text(
//                                                 // "₹40",
//                                                 categoryBasedDmio[index]
//                                                     .product
//                                                     .sellingPrice
//                                                     .toString(),
//                                                 style: const TextStyle(
//                                                     fontSize: 19,
//                                                     color: Color(0xE6434343)),
//                                               ),
//                                               const SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Container(
//                                                     height: 30,
//                                                     decoration:
//                                                         const BoxDecoration(
//                                                             color: Color(
//                                                                 0xff870081),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             7))),
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                             right: 10),
//                                                     alignment: Alignment.center,
//                                                     child: const Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               horizontal: 10),
//                                                       child: Text(
//                                                         "Got Once",
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize: 17),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       // _showModalBottomSheet(context);
//                                                       // showModalBottomSheet(
//                                                       //     shape: const RoundedRectangleBorder(
//                                                       //         borderRadius:
//                                                       //             BorderRadius.vertical(
//                                                       //                 top: Radius
//                                                       //                     .circular(
//                                                       //                         20))),
//                                                       //     context: context,
//                                                       //     builder: (context) {
//                                                       //       return Column(
//                                                       //         children: [
//                                                       //           RadioListTile(
//                                                       //             value: 1,
//                                                       //             groupValue:
//                                                       //                 groupValueSubscribe,
//                                                       //             onChanged:
//                                                       //                 (value) {

//                                                       //               setState(() {
//                                                       //                 groupValueSubscribe = value!;
//                                                       //               });
//                                                       //             },
//                                                       //             title: Text(
//                                                       //                 'Daily'),
//                                                       //           ),
//                                                       //           RadioListTile(
//                                                       //             value: 2,
//                                                       //             groupValue:
//                                                       //                 groupValueSubscribe,
//                                                       //             onChanged:
//                                                       //                 (value) {
//                                                       //               setState(() {
//                                                       //                 groupValueSubscribe =
//                                                       //                     value!;
//                                                       //               });
//                                                       //             },
//                                                       //             title: Text(
//                                                       //                 'Weekly'),
//                                                       //           ),

//                                                       //            RadioListTile(
//                                                       //             value: 3,
//                                                       //             groupValue:
//                                                       //                 groupValueSubscribe,
//                                                       //             onChanged:
//                                                       //                 (value) {
//                                                       //               setState(() {
//                                                       //                 groupValueSubscribe =
//                                                       //                     value!;
//                                                       //               });
//                                                       //             },
//                                                       //             title: Text(
//                                                       //                 'Weekend'),
//                                                       //           ),
//                                                       //            RadioListTile(
//                                                       //             value: 4,
//                                                       //             groupValue:
//                                                       //                 groupValueSubscribe,
//                                                       //             onChanged:
//                                                       //                 (value) {
//                                                       //               setState(() {
//                                                       //                 groupValueSubscribe =
//                                                       //                     value!;
//                                                       //               });
//                                                       //             },
//                                                       //             title: Text(
//                                                       //                 'Alternate'),
//                                                       //           ),
//                                                       //         ],
//                                                       //       );

//                                                       //       // Container(
//                                                       //       //   child: Padding(
//                                                       //       //     padding:
//                                                       //       //         const EdgeInsets.all(
//                                                       //       //             30.0),
//                                                       //       //     child: Column(
//                                                       //       //       children: [
//                                                       //       //         // temperory used for description
//                                                       //       //         Container(
//                                                       //       //           decoration: BoxDecoration(
//                                                       //       //               borderRadius:
//                                                       //       //                   BorderRadius
//                                                       //       //                       .circular(
//                                                       //       //                           20)),
//                                                       //       //           child: Image.network(
//                                                       //       //               categoryBasedDmio[index]
//                                                       //       //                   .product
//                                                       //       //                   .primaryImage),
//                                                       //       //         ),
//                                                       //       //         const SizedBox(
//                                                       //       //           height: 50,
//                                                       //       //         ),
//                                                       //       //         Text(
//                                                       //       //           categoryBasedDmio[index]
//                                                       //       //               .product
//                                                       //       //               .otherImages[0],
//                                                       //       //         )
//                                                       //       //       ],
//                                                       //       //     ),
//                                                       //       //   ),
//                                                       //       // );
//                                                       //     });

//                                                       //                                                 showModalBottomSheet(
//                                                       //   context: context,
//                                                       //   builder: (BuildContext context) {
//                                                       //     return Container(
//                                                       //       height: 200, // Adjust the height as needed
//                                                       //       child: ListView(
//                                                       //         children: <Widget>[
//                                                       //           RadioListTile<int>(
//                                                       //             title: Text('Option 1'),
//                                                       //             value: 1,
//                                                       //             groupValue: _selectedValue,
//                                                       //             onChanged: (value) {
//                                                       //               setState(() {
//                                                       //                 _selectedValue = value!;
//                                                       //               });
//                                                       //             },
//                                                       //           ),
//                                                       //           RadioListTile<int>(
//                                                       //             title: Text('Option 2'),
//                                                       //             value: 2,
//                                                       //             groupValue: _selectedValue,
//                                                       //             onChanged: (value) {
//                                                       //               setState(() {
//                                                       //                 _selectedValue = value!;
//                                                       //               });
//                                                       //             },
//                                                       //           ),
//                                                       //           RadioListTile<int>(
//                                                       //             title: Text('Option 3'),
//                                                       //             value: 3,
//                                                       //             groupValue: _selectedValue,
//                                                       //             onChanged: (value) {
//                                                       //               setState(() {
//                                                       //                 _selectedValue = value!;
//                                                       //               });
//                                                       //             },
//                                                       //           ),
//                                                       //         ],
//                                                       //       ),
//                                                       //     );
//                                                       //   },
//                                                       // );
//                                                     },
//                                                     child: Container(
//                                                       height: 30,
//                                                       decoration: const BoxDecoration(
//                                                           color:
//                                                               Color(0xff870081),
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           7))),
//                                                       margin:
//                                                           const EdgeInsets.only(
//                                                               right: 10),
//                                                       alignment:
//                                                           Alignment.center,
//                                                       child: const Padding(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 horizontal: 10),
//                                                         child: Text(
//                                                           "Subscribe",
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontSize: 17),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );

//                         // dailyMioItemBox(
//                         //     categoryBasedDmio[index].product.primaryImage,
//                         //     categoryBasedDmio[index].product.name[0],
//                         //     categoryBasedDmio[index]
//                         //         .product
//                         //         .sellingPrice
//                         //         .toString());
//                       },
//                     )
//                   ],
//                 ),
//         ),
//       ),

//       bottomSheet: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Text('1 Item/₹40'), Text('Check out')],
//       ),
//     );
//   }
// }
