import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';

import '../pages/address.dart';

Widget address(BuildContext context) {
  return Column(
    children: [
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.location_on_rounded,
          //     color: Colors.greenAccent,
          //   ),
          // ),
          Row(
            children: [
              Radio(
                value: '',
                groupValue: '',
                onChanged: (_) {},
              ),
              const Text(
                'Delivery Address',
                style: TextStyle(),
              ),
            ],
          ),

          TextButton(
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(
                primaryColor,
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Edit',
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: const Text(
          '1st  Floor, Sridattatrayaswamy Temp Complex, Gandhi Nagar , Bangalore , Karnataka ,  560009.',
          style: TextStyle(fontSize: 18),
        ),
      )
    ],
  );
}
