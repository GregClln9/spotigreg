import 'package:flutter/material.dart';
import 'package:spotigreg_front/themes/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(title),
        ),
        TextField(
          autofocus: true,
          controller: controller,
          cursorColor: primaryColor,
          decoration: InputDecoration(
            focusColor: primaryColor,
            // fillColor: primaryColor,
            hoverColor: primaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
