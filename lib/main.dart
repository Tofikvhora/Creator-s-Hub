import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/AuthController.dart';
import 'package:creatorhub/Controller/HomeController.dart';
import 'package:creatorhub/Controller/NavbarController.dart';
import 'package:creatorhub/Controller/PostProvider.dart';
import 'package:creatorhub/Controller/ProfileController.dart';
import 'package:creatorhub/Controller/SearchController.dart';
import 'package:creatorhub/View/HomePage.dart';
import 'package:creatorhub/View/LoginPage.dart';
import 'package:creatorhub/View/NavBarPage.dart';
import 'package:creatorhub/View/ProfilePage.dart';
import 'package:creatorhub/View/SplashPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => NavbarController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => SearchControllers()),
      ],
      child: ToastificationWrapper(
        child: ScreenUtilInit(
            designSize: const Size(380, 840),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Creator Hub',
                theme: ThemeData(
                  scaffoldBackgroundColor: ConstantOfApp.primaryColor,
                  useMaterial3: true,
                ),
                home: const SplashPage(),
              );
            }),
      ),
    );
  }
}
