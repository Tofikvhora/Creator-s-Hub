import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/ConstantOfApp.dart';
import 'BoxWidget.dart';

class AppBarWidget extends StatelessWidget {
  final String name;
  const AppBarWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: ConstantOfApp.heading,
          ),
          InkWell(
            onTap: () async {
              SharedPreferences sf = await SharedPreferences.getInstance();
              sf.clear();
            },
            child: BoxWidgets(
              child: Icon(
                IconlyLight.message,
                size: 25.w,
                color: ConstantOfApp.primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
