import 'package:flutter/material.dart';

import '../pages/ordered_list_page.dart';
import '../pages/wishlist.dart';

Widget wishList() {
  return Expanded(
    child: ListView.builder(
      itemCount: 7,
      itemBuilder: (context, index) {
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
                child: Container(
                  height: 129,
                  width: 70,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/animal-before.webp'),
                    // fit: BoxFit.fill,
                  )),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Trendy Women Dress',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const Text(
                      '₹ 544',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderedProductsList()));
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              side: const BorderSide(color: Colors.greenAccent),
                            ),
                            child: const Text(
                              'Add To Cart',
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w700),
                            )),
                        const SizedBox(
                          width: 17,
                        ),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.delete)),
                        const Text(
                          'Remove',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
