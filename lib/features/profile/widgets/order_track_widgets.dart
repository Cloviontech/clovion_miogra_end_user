import 'package:flutter/material.dart';
import 'package:miogra/features/profile/pages/address.dart';
import 'package:order_tracker/order_tracker.dart';

import '../../../core/colors.dart';
import '../../shopping/presentation/widgets/ratings.dart';
import '../pages/qty.dart';
import '../pages/return.dart';

Widget addressContainer(
  BuildContext context,
  String name,
  String doorNo,
  String area,
  String lanmark,
  String place,
  String district,
  String state,
  String pincode,
) {
  return Container(
    // height: MediaQuery.of(context).size.height*0.22,
    width: double.infinity,
    decoration: const BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 5,
      )
    ]),
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.location_on_outlined,
                color: Colors.black,
              ),
              label: const Text(
                'Delivery Address',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddressPage(
                    amountToBePaid: '',
                    userId: '',
                    cartlist: [],
                  );
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: const Text(
                  'Change',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$doorNo, $area',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$lanmark,',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            place,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$district, ',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$state,',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$pincode,',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    ),
  );
}

class ProductName extends StatelessWidget {
  final String image;
  final String productName;
  final dynamic price;
  final dynamic review;

  const ProductName(
      {super.key,
      required this.image,
      required this.productName,
      this.price,
      this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5,
        )
      ]),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 109,
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image.toString()),
                    // fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  productName.toString(),
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w600),
                ),
                Text(
                  '₹ $price',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const Text(
                //   'Delivery by 22/05/2024',
                //   style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.w700,
                //       color: Colors.greenAccent),
                // ),
                SizedBox(
                  height: 25,
                  // width: ,
                  child: starRating(review ?? 0.0),
                ),

                TextButton(
                  // onPressed: showBottomSheet(context)(){},
                  onPressed: () {
                    // Scaffoldmessange
                    // log('Products Id are ${productsIds[index]}');

                    // showMyModalBottomSheet(
                    //   context,
                    //   productsIds[index],
                    // );
                  },
                  child: const Text(
                    'Post your review',
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ),
                // IconButton(
                //     onPressed: () {}, icon: const Icon(Icons.star_border),),
                // GestureDetector(
                //   onTap: () {
                //     showDialog<void>(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           content: SizedBox(
                //             height: MediaQuery.of(context).size.height * 0.4,
                //             child: Center(
                //               child: Column(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceAround,
                //                 mainAxisSize: MainAxisSize.min,
                //                 children: <Widget>[
                //                   Container(
                //                     height: MediaQuery.of(context).size.height *
                //                         0.2,
                //                     width:
                //                         MediaQuery.of(context).size.width * 0.8,
                //                     decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(7),
                //                         color: Colors.white,
                //                         border:
                //                             Border.all(color: Colors.black45)),
                //                     child: TextFormField(
                //                         keyboardType: TextInputType.multiline,
                //                         decoration: const InputDecoration(
                //                           hintText: 'Post Your Review',
                //                           contentPadding: EdgeInsets.symmetric(
                //                               horizontal: 10),
                //                           border: InputBorder.none,
                //                         )),
                //                   ),
                //                   SizedBox(
                //                     height: MediaQuery.of(context).size.height *
                //                         0.03,
                //                   ),
                //                   ElevatedButton(
                //                     onPressed: () {
                //                       Navigator.pop(context);
                //                     },
                //                     style: ElevatedButton.styleFrom(
                //                       minimumSize: const Size(170, 40),
                //                       backgroundColor: Colors.purple,
                //                       shape: RoundedRectangleBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(10)),
                //                     ),
                //                     child: const Text(
                //                       'Submit ',
                //                       style: TextStyle(
                //                           fontWeight: FontWeight.w700,
                //                           color: Colors.white70),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: const Text(
                //     'Post Your Review',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w700, color: Colors.purple),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget trackingContainer(BuildContext context) {
  return Container(
    height: 320,
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5,
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: OrderTracker(
        status: Status.delivered,
        activeColor: Colors.green,
        inActiveColor: Colors.grey[300],
      ),
    ),
  );
}

Widget returnContainer(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(10),
    height: 70,
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5,
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Return or Exchange',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReturnPage(
                  orderId: '',
                  userId: '',
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.play_arrow,
            size: 27,
            color: Colors.purple,
          ),
        ),
      ],
    ),
  );
}

Widget priceContainer(
    {required BuildContext context,
    required dynamic sellingPrice,
    required int qty,
    required int deliveryPrice,
    required int discount}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    height: MediaQuery.of(context).size.height * 0.26,
    width: double.infinity,
    decoration: const BoxDecoration(color: Colors.white, boxShadow: [
      // BoxShadow(
      //   color: Colors.grey,
      //   blurRadius: 5,
      // )
    ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Price Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price ($qty item${qty == 1 ? "" : 's'})',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Text(
                '₹ ${sellingPrice } ',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deliver Fees   :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Text(
                '₹ $deliveryPrice ',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Discount         :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Text(
                '₹ $discount',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.greenAccent),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Colors.black26,
          indent: 10,
          endIndent: 10,
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Total     :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Text(
                '₹ ${(sellingPrice + 50).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
