import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  Responsive(
      {super.key,
      required this.Mobile,
      required this.Tablet,
      required this.Desktop});

  final Widget Tablet;
  final Widget Mobile;
  final Widget Desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return Desktop;
      } else if (constraints.maxWidth > 800) {
        return Tablet;
      } else {
        return Mobile;
      }
    });
  }
}
