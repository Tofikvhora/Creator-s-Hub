import 'package:flutter/material.dart';

void navigationCore(Widget child, BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => child));
}

void navigationCoreReplace(Widget widget, BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}
