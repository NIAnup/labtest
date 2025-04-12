import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  Customtextfield(
      {super.key,
      this.validator,
      this.onSaved,
      this.controller,
      this.hintText,
      this.keyboardAppearance,
      this.keyboardType,
      this.obscureText = false});

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  TextEditingController? controller;
  String? hintText;
  Brightness? keyboardAppearance;
  TextInputType? keyboardType;
  bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardAppearance: keyboardAppearance,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black, fontFamily: "uber"),
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontFamily: "uber"),
          hintStyle: const TextStyle(color: Colors.black, fontFamily: "uber"),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 2.0,
            ),
          ),
          hintText: hintText,
        ),
        validator: validator,
        onSaved: onSaved);
  }
}
