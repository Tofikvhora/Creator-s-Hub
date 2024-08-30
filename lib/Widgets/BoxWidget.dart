import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constant/ConstantOfApp.dart';

class BoxWidgets extends StatelessWidget {
  final Widget child;
  const BoxWidgets({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50.w,
        height: 50.h,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: ConstantOfApp.secondaryColor),
        child: child);
  }
}
