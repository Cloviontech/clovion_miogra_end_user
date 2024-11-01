// import 'package:flutter/material.dart';
// import 'package:miogra/features/food/presentation/pages/food_landing_page.dart';
// import 'package:miogra/home_page/tabs/all_product_shoping.dart';

// class SearchViewList extends StatelessWidget {
//   const SearchViewList({
//     super.key,
//     required this.showSuggestions,
//     this.filteredProducts,
//     this.filteredFoodProducts,
//   });

//   final bool showSuggestions;
//   final List<Product>? filteredProducts;
//   final List<Food>? filteredFoodProducts;

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: showSuggestions,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: AnimatedContainer(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: const Color.fromARGB(255, 246, 213, 248),
//           ),
//           duration: const Duration(microseconds: 1000),
//           curve: Curves.easeInToLinear,
//           height: showSuggestions ? 300 : 0,
//           child: ListView.separated(
//             separatorBuilder: (context, index) => Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 10,
//               ),
//               child: Divider(
//                 color: Colors.grey[500],
//                 thickness: 0.5,
//               ),
//             ),
//             itemCount: filteredProducts.length,
//             itemBuilder: (context, index) {
//               final product = filteredProducts![index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 10,
//                 ),
//                 child: Text(product.name),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
