import 'package:flutter/material.dart';

Widget categoryItem(String path, String name, void Function() page) {
  return SizedBox(
    child: Column(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
              onTap: page,
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                    image: AssetImage(path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Expanded(flex: 0,child: SizedBox(height: 5,)),
        Expanded(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              // fontSize: 10,
              color: Color(0xff870081),
              // fontWeight: FontWeight.w300
            ),
          ),
        )
      ],
    ),
  );
}
