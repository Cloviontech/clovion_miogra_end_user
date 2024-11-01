// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_view.dart';

class SquareImage extends StatelessWidget {
  const SquareImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    required this.title,
  });

  final String title;
  final String image;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageScreen(
              title: title,
              image: image,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? MediaQuery.of(context).size.width,
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 156, 39, 176),
              backgroundColor: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
          ),
        ),
      ),
    );
  }
}
