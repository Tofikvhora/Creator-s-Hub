import 'package:flutter/material.dart';

class TextWidgets extends StatelessWidget {
  final String heading;
  final TextStyle style;
  const TextWidgets({super.key, required this.heading, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: style,
    );
  }
}
