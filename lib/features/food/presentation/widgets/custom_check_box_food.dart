import 'package:flutter/material.dart';

class CustomCheckBoxFood extends StatefulWidget {
  final String size;
  const CustomCheckBoxFood({super.key, required this.size});

  @override
  State<CustomCheckBoxFood> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBoxFood> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF870081)),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Text(widget.size, style: const TextStyle(color: Color(0xFF870081), fontSize: 20),),
    );
  }
}

