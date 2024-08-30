import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/View/PostDeatilsPage.dart';
import 'package:creatorhub/Widgets/AppBarWidgets.dart';
import 'package:creatorhub/Widgets/BoxWidget.dart';
import 'package:creatorhub/Widgets/LiketTriggerWidget.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        children: [
          const AppBarWidget(name: "Creator's Hub "),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("UserPost").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: ConstantOfApp.secondaryColor),
                  );
                }
                final snap = snapshot.data!.docs;
                return snap.isEmpty
                    ? Center(
                        child: TextWidgets(
                            heading: "No post yet",
                            style: ConstantOfApp.heading
                                .copyWith(color: ConstantOfApp.secondaryColor)),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snap.length,
                          itemBuilder: (context, index) {
                            final data = snap[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: cardWidget(context, data, data["like"]),
                            );
                          },
                        ),
                      );
              })
        ],
      ).animate(effects: [
        const FadeEffect(
            curve: Curves.ease, duration: Duration(milliseconds: 800)),
        const MoveEffect(
            curve: Curves.ease, duration: Duration(milliseconds: 900))
      ]),
    );
  }
}

Widget cardWidget(BuildContext context, var data, List like) {
  return GestureDetector(
    onTap: () {
      navigationCore(
          PostDetailsPage(
            data: data,
            likes: like,
          ),
          context);
    },
    child: Card(
      color: ConstantOfApp.primaryColor,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoxWidgets(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkImage(
                  errorWidget: (context, error, stackTrace) {
                    return Icon(
                      Icons.error,
                      size: 25.w,
                      color: ConstantOfApp.primaryColor,
                    );
                  },
                  imageUrl: data["ProfileImage"].toString(),
                  fit: BoxFit.cover,
                ),
              )),
              SizedBox(
                width: 5.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidgets(
                                      heading: data["Name"].toString(),
                                      style: ConstantOfApp.subHeading.copyWith(
                                          color: ConstantOfApp.secondaryColor)),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                              // TextWidgets(
                              //     heading: data["location"],
                              //     style: ConstantOfApp.normal.copyWith(
                              //         color:
                              //             ConstantOfApp.secondaryColor.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CachedNetworkImage(
                        filterQuality: FilterQuality.medium,
                        errorWidget: (context, error, stackTrace) {
                          return Icon(
                            Icons.error,
                            size: 25.w,
                            color: ConstantOfApp.secondaryColor,
                          );
                        },
                        imageUrl: data["Image"].toString(),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextWidgets(
                          heading: data["Details"],
                          style: ConstantOfApp.normal.copyWith(
                              color: ConstantOfApp.secondaryColor
                                  .withOpacity(0.5))),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Profile")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .collection("Data")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          }
                          final value = snapshot.data!.docs;
                          return LikeTriggerWidget(
                              likes: data["like"],
                              id: data["id"],
                              userId: value[0]["id"]);
                        })
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
