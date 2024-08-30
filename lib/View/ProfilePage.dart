import 'dart:io';

import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/ProfileController.dart';
import 'package:creatorhub/Widgets/ButtonWidgets.dart';
import 'package:creatorhub/Widgets/TextFieldWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

TextEditingController controller = TextEditingController();

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 50.h,
          ),
          Center(
            child: SafeArea(
                child: TextWidgets(
              style: ConstantOfApp.subHeading,
              heading:
                  "Welcome ${"${FirebaseAuth.instance.currentUser!.email!.substring(0, 9)}...."}",
            )),
          ),
          Consumer<ProfileController>(builder: (context, value, child) {
            return InkWell(
              onTap: () {
                value.pickImage();
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.h),
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: value.xfile != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(value.xfile!.path)))
                        : null,
                    color: ConstantOfApp.secondaryColor),
              ),
            );
          }),
          SizedBox(
            height: 15.h,
          ),
          bottomWidget(context),
        ],
      ),
    );
  }
}

Widget bottomWidget(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.71,
    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        color: ConstantOfApp.secondaryColor),
    child: Consumer<ProfileController>(builder: (context, value, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextWidgets(
              heading: "Profile",
              style: ConstantOfApp.heading
                  .copyWith(color: ConstantOfApp.primaryColor)),
          SizedBox(height: 10.h),
          TextFieldWidgets(
              onChange: (value) {},
              hint: "Profile name",
              icons: Icons.person,
              controller: value.profileName,
              textInputType: TextInputType.name),
          SizedBox(height: 10.h),
          TextFieldWidgets(
              onChange: (value) {},
              hint: "Profile Bio",
              icons: Icons.data_object_outlined,
              min: 1,
              max: 5,
              length: 200,
              controller: value.bio,
              textInputType: TextInputType.multiline),
          SizedBox(height: 10.h),
          TextFieldWidgets(
              onChange: (value) {},
              hint: "Add Links",
              icons: Icons.link_off_sharp,
              controller: value.link,
              textInputType: TextInputType.name),
          SizedBox(height: 20.h),
          value.isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                  color: ConstantOfApp.primaryColor,
                ))
              : ButtonWidgets(
                  name: "Submit",
                  onTap: () {
                    value.addProfileData(context);
                  })
        ],
      );
    }),
  );
}
