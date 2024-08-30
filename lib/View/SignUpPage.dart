import 'package:creatorhub/Controller/AuthController.dart';
import 'package:creatorhub/View/LoginPage.dart';
import 'package:creatorhub/View/VerificationPage.dart';
import 'package:creatorhub/Widgets/AnimateWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../Constant/ConstantOfApp.dart';
import '../Widgets/ButtonWidgets.dart';
import '../Widgets/LottieAnimationFile.dart';
import '../Widgets/TextFieldWidgets.dart';
import '../Widgets/TextWidgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimateWidget(
          widget: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                child: const LottieAnimationFile(
                    name: "Asset/Lottie/Animation - 1699446413460.json"),
              ),
              SizedBox(
                height: 20.h,
              ),
              formWidget(context, email),
            ],
          ),
        ),
      ),
    );
  }
}

Widget formWidget(BuildContext context, TextEditingController email) {
  return Consumer<AuthController>(builder: (context, value, child) {
    return AnimateWidget(
      widget: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: ConstantOfApp.secondaryColor),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: Center(
                  child: TextWidgets(
                      heading: "Signup",
                      style: ConstantOfApp.heading
                          .copyWith(color: ConstantOfApp.primaryColor)),
                ),
              ),
              TextFieldWidgets(
                  hint: "Enter you're email",
                  icons: IconlyLight.user,
                  controller: value.sEmail,
                  onChange: (value) {},
                  textInputType: TextInputType.emailAddress),
              SizedBox(height: 10.h),
              TextFieldWidgets(
                  hint: "Enter you're password",
                  icons: Icons.visibility_off,
                  onChange: (value ) {},
                  controller: value.sPassword,
                  textInputType: TextInputType.visiblePassword),
              SizedBox(height: 10.h),
              TextFieldWidgets(
                  hint: "Confirm password",
                  icons: Icons.visibility_off,
                  onChange: (value) {},
                  controller: value.sConfirmPassword,
                  textInputType: TextInputType.visiblePassword),
              SizedBox(height: 15.h),
              value.isLoadingCreate == true
                  ? Animate(
                      effects: const [
                        FadeEffect(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.ease),
                        SlideEffect(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.ease,
                        )
                      ],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ConstantOfApp.primaryColor,
                        ),
                      ),
                    )
                  : Animate(
                      effects: const [
                        FadeEffect(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease),
                        SlideEffect(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease,
                            begin: Offset(-1, 0),
                            end: Offset(0, 0))
                      ],
                      child: ButtonWidgets(
                        name: "Signup",
                        onTap: () {
                          value.signup(context);
                        },
                      ),
                    ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage())),
                child: Center(
                  child: TextWidgets(
                      heading: "Already have an account ? Login",
                      style: ConstantOfApp.subHeading
                          .copyWith(color: Colors.grey)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  });
}
