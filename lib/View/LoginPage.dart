import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/AuthController.dart';
import 'package:creatorhub/View/SignUpPage.dart';
import 'package:creatorhub/Widgets/AnimateWidget.dart';
import 'package:creatorhub/Widgets/ButtonWidgets.dart';
import 'package:creatorhub/Widgets/LottieAnimationFile.dart';
import 'package:creatorhub/Widgets/TextFieldWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                height: MediaQuery.of(context).size.height * 0.45,
                child: const LottieAnimationFile(
                    name: "Asset/Lottie/Animation - 1699445265325.json"),
              ),
              SizedBox(
                height: 20.h,
              ),
              formWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget formWidget(BuildContext context) {
  return Consumer<AuthController>(builder: (context, value, child) {
    return AnimateWidget(
      widget: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.5,
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
                      heading: "Login",
                      style: ConstantOfApp.heading
                          .copyWith(color: ConstantOfApp.primaryColor)),
                ),
              ),
              TextFieldWidgets(
                  onChange: (value) {},
                  hint: "Enter you're email",
                  icons: IconlyLight.user,
                  controller: value.email,
                  textInputType: TextInputType.emailAddress),
              SizedBox(height: 10.h),
              TextFieldWidgets(
                  onChange: (value) {},
                  hint: "Enter you're password",
                  icons: Icons.visibility_off,
                  controller: value.password,
                  textInputType: TextInputType.visiblePassword),
              SizedBox(height: 5.h),
              TextWidgets(
                  heading: "Forgot?",
                  style: ConstantOfApp.subHeading.copyWith(color: Colors.blue)),
              SizedBox(height: 10.h),
              value.isLoading == true
                  ? Animate(
                      effects: const [
                        FadeEffect(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeIn),
                        SlideEffect(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeIn,
                        )
                      ],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ConstantOfApp.primaryColor,
                          strokeCap: StrokeCap.square,
                        ),
                      ),
                    )
                  : Animate(
                      effects: const [
                        FadeEffect(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease),
                        SlideEffect(
                            duration: Duration(milliseconds: 1200),
                            curve: Curves.ease,
                            begin: Offset(-1, 0),
                            end: Offset(0, 0))
                      ],
                      child: ButtonWidgets(
                        name: "Login",
                        onTap: () {
                          value.login(context);
                        },
                      ),
                    ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpPage())),
                child: Center(
                  child: TextWidgets(
                      heading: "New User ? SignUp",
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
