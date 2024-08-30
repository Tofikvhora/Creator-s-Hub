import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationFile extends StatelessWidget {
  final String name;
  const LottieAnimationFile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(name, width: 200.w, height: 200.h);
  }
}
