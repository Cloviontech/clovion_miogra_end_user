import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String size;
  const CustomCheckBox({super.key, required this.size});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF870081)),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Text(widget.size, style: const TextStyle(color: Color(0xFF870081)),),
    );
  }
}

