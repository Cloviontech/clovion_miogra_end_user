// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AddView extends StatelessWidget {
  const AddView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1.0,
          // height: ,

          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: [
          "assets/images/ad1.jpg",
          "assets/images/ad2.jpg",
          "assets/images/ad3.jpg",
          "assets/images/ad4.jpg",
          "assets/images/ad5.jpg",
        ].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  i,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class AddsView extends StatelessWidget {
  const AddsView({
    super.key,
    required this.images,
  });

  final List<dynamic> images; // Ensure image list type

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: images.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Error loading image'));
                  },
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
