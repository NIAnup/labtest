import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  const Custombutton({super.key, this.onTap, required this.text});
  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.shade500),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontFamily: "uber", fontSize: 20),
          ),
        ),
      ),
    );
  }
}
