import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget starRating(rating) {

  
  return RatingBarIndicator(
    unratedColor: Colors.grey.shade300,
    rating: rating,
    itemBuilder: (context, index) => const Icon(
      Icons.star,
      color: Colors.green,
    ),
    itemCount: 5,
    itemSize: 40.0,
    direction: Axis.horizontal,
  );
}
