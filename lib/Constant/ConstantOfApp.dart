import 'package:flutter/material.dart';

class ConstantOfApp {
  // Colors
  static const Color primaryColor = Color(0xff000000);
  static const Color secondaryColor = Color(0xffffffff);

  // TextStyle
  static TextStyle heading = const TextStyle(
    fontSize: 25,
    color: secondaryColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle subHeading = const TextStyle(
    fontSize: 18,
    color: secondaryColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle normal = const TextStyle(
    fontSize: 15,
    color: secondaryColor,
    fontWeight: FontWeight.bold,
  );
}
