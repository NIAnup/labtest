import 'package:flutter/material.dart';

class Myscaffold extends StatelessWidget {
  const Myscaffold({super.key, this.backgroundColor, required this.body});
  final Color? backgroundColor;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: body,
    );
  }
}
