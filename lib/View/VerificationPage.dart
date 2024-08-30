import 'package:creatorhub/Controller/AuthController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../Constant/ConstantOfApp.dart';
import '../Widgets/AnimateWidget.dart';
import '../Widgets/ButtonWidgets.dart';
import '../Widgets/LottieAnimationFile.dart';
import '../Widgets/TextFieldWidgets.dart';
import '../Widgets/TextWidgets.dart';
import '../utils/ToastUitls/ToastUtils.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthController>(context, listen: false);
      auth.verification(context);
    });
  }

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
              Consumer<AuthController>(builder: (context, value, child) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: LottieAnimationFile(
                      name: value.success == true
                          ? "Asset/Lottie/Success.json"
                          : "Asset/Lottie/verification.json"),
                );
              }),
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
  return AnimateWidget(
    widget: Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.49,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: ConstantOfApp.secondaryColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Center(
                child: TextWidgets(
                    heading: "Verification",
                    style: ConstantOfApp.heading
                        .copyWith(color: ConstantOfApp.primaryColor)),
              ),
            ),
            Text(
              "We have sent you email verification link please open you're email and verify",
              textAlign: TextAlign.center,
              style: ConstantOfApp.heading
                  .copyWith(color: ConstantOfApp.primaryColor),
            ),
            const SizedBox()
          ],
        ),
      ),
    ),
  );
}
