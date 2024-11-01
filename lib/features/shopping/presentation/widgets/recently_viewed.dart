import 'package:flutter/material.dart';

Widget recentlyViewed(BuildContext context, void Function() myFun,
    {required String image, required String name}) {
  return GestureDetector(
    onTap: myFun,
    child: SizedBox(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration( 
                color: Colors.green,
                image: DecorationImage( 
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(name, style: const TextStyle(fontSize: 15),),
            ),
          ),
        ],
      ),
    ),
  );
}
