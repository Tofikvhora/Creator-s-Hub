import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/PostProvider.dart';
import 'package:creatorhub/Widgets/AppBarWidgets.dart';
import 'package:creatorhub/Widgets/BoxWidget.dart';
import 'package:creatorhub/Widgets/ButtonWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PostProvider>(builder: (context, value, child) {
        return InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            children: [
              const AppBarWidget(name: "Post"),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.9,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Profile")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection("Data")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator(
                            color: ConstantOfApp.secondaryColor);
                      }
                      final snap = snapshot.data!.docs[0];
                      return SizedBox(
                        width: 50.w,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BoxWidgets(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          imageUrl: snap["ProfileImage"],
                                          fit: BoxFit.cover,
                                          width: 50.w,
                                          height: 50.h,
                                        ))),
                                SizedBox(
                                  height: 400.h,
                                  child: const VerticalDivider(),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 30.w,
                                      height: 30.h,
                                      child: BoxWidgets(
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: CachedNetworkImage(
                                                imageUrl: snap["ProfileImage"],
                                                fit: BoxFit.cover,
                                                width: 50.w,
                                                height: 50.h,
                                              ))),
                                    ),
                                    TextWidgets(
                                        heading: snap["ProfileName"].toString(),
                                        style: ConstantOfApp.subHeading
                                            .copyWith(
                                                color: ConstantOfApp
                                                    .secondaryColor,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 8.sp)),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidgets(
                                      heading: snap["ProfileName"].toString(),
                                      style: ConstantOfApp.subHeading.copyWith(
                                          color: ConstantOfApp.secondaryColor)),
                                  SizedBox(height: 5.h),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.67,
                                    child: TextField(
                                      autofocus: false,
                                      style: ConstantOfApp.subHeading.copyWith(
                                          fontWeight: value.fontWeightText,
                                          fontSize: 18.sp),
                                      controller: value.about,
                                      minLines: null,
                                      maxLines: null,
                                      expands: false,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          hintStyle: ConstantOfApp.subHeading,
                                          hintText: "What's New?",
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                          errorBorder: InputBorder.none),
                                    ),
                                  ),
                                  value.image == null
                                      ? const SizedBox()
                                      : Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.38,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Image.file(
                                              File(value.image!.path),
                                              fit: BoxFit.contain,
                                              height: 280.h,
                                            ),
                                          ),
                                        ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  elevation: 10,
                                                  surfaceTintColor:
                                                      ConstantOfApp
                                                          .secondaryColor,
                                                  backgroundColor: ConstantOfApp
                                                      .primaryColor,
                                                  title: Text(
                                                    "Choose Options",
                                                    style: ConstantOfApp.heading
                                                        .copyWith(
                                                            color: ConstantOfApp
                                                                .secondaryColor),
                                                  ),
                                                  content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          value
                                                              .pickImageGallery(
                                                                  context)
                                                              .then((value) {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: TextWidgets(
                                                            heading: "Gallery",
                                                            style: ConstantOfApp
                                                                .heading
                                                                .copyWith(
                                                                    color: ConstantOfApp
                                                                        .secondaryColor)),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          value
                                                              .pickImageCamera(
                                                                  context)
                                                              .then((value) {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: TextWidgets(
                                                            heading: "Camera",
                                                            style: ConstantOfApp
                                                                .heading
                                                                .copyWith(
                                                                    color: ConstantOfApp
                                                                        .secondaryColor)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.camera_alt,
                                            size: 25.w,
                                            color: ConstantOfApp.secondaryColor,
                                          )),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            value.changeFont(FontWeight.bold);
                                          },
                                          icon: Icon(
                                            Icons.format_bold,
                                            size: 25.w,
                                            color: ConstantOfApp.secondaryColor,
                                          )),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            value.changeFont(FontWeight.w300);
                                          },
                                          icon: Icon(
                                            Icons.format_clear,
                                            size: 25.w,
                                            color: ConstantOfApp.secondaryColor,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ButtonWidgets(
                                      name: "Post",
                                      onTap: () {
                                        value.addPost(context);
                                      },
                                      color: ConstantOfApp.secondaryColor,
                                      textColor: ConstantOfApp.primaryColor,
                                    ).animate(effects: [
                                      const FadeEffect(
                                          duration: Duration(seconds: 1),
                                          curve: Curves.ease)
                                    ]),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ).animate(effects: [
            const FadeEffect(
                curve: Curves.ease, duration: Duration(milliseconds: 800)),
            const MoveEffect(
                curve: Curves.ease, duration: Duration(milliseconds: 900))
          ]),
        );
      }),
    );
  }
}
