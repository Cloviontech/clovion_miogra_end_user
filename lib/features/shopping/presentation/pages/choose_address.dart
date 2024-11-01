// import 'package:flutter/material.dart';
// import 'package:miogra/core/colors.dart';
// import 'package:miogra/features/profile/pages/add_address_page.dart';
// import 'package:miogra/features/shopping/presentation/pages/payment.dart';
// import 'package:miogra/features/profile/widgets/address_display_widget.dart';

// class ChooseAddress extends StatefulWidget {
//   const ChooseAddress({super.key});

//   @override
//   State<ChooseAddress> createState() => _ChooseAddressState();
// }

// class _ChooseAddressState extends State<ChooseAddress> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text(
//           'Choose Address',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       height: 30,
//                       width: 75,
//                       child: ElevatedButton(
//                         style: const ButtonStyle(
//                           shape: MaterialStatePropertyAll(
//                               RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(5)))),
//                           foregroundColor: MaterialStatePropertyAll(
//                             Colors.white,
//                           ),
//                           backgroundColor: MaterialStatePropertyAll(
//                             primaryColor,
//                           ),
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   const AddAddressPage(userId: 'UserName'),
//                             ),
//                           );
//                         },
//                         child: const Text('Add'),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               address(context),
//               address(context),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 15,
//               vertical: 10,
//             ),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: const ButtonStyle(
//                   shape: MaterialStatePropertyAll(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                   ),
//                   foregroundColor: MaterialStatePropertyAll(
//                     Colors.white,
//                   ),
//                   backgroundColor: MaterialStatePropertyAll(
//                     primaryColor,
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const Payment(),
//                     ),
//                   );
//                 },
//                 child: const Text('Continue'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
