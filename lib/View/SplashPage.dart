import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/View/LoginPage.dart';
import 'package:creatorhub/View/NavBarPage.dart';
import 'package:creatorhub/Widgets/ButtonWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: TextWidgets(
                heading: "Creator Hub", style: ConstantOfApp.heading),
          ),
          SizedBox(height: 20.h),
          ButtonWidgets(
            name: "Explore Now",
            onTap: () async {
              SharedPreferences sf = await SharedPreferences.getInstance();
              String? value = sf.getString("email");
              if (context.mounted) {
                value == null
                    ? navigationCoreReplace(const LoginPage(), context)
                    : navigationCoreReplace(const NavBarPage(), context);
              }
            },
            color: ConstantOfApp.secondaryColor,
            textColor: ConstantOfApp.primaryColor,
          )
        ],
      ),
    );
  }
}
