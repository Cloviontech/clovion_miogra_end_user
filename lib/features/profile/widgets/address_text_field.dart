// Import statements (assuming you have necessary imports)

import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';

class AddressTextField extends StatelessWidget {
  const AddressTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.inpuitType,
    this.length,
  });

  final String title;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final TextInputType inpuitType;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        maxLength: length,
        keyboardType: inpuitType,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: primaryColor),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid, width: 1, color: primaryColor),
          ),
          label: Text(
            '  $title',
            style: const TextStyle(
              fontSize: 16,
              color: primaryColor,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
