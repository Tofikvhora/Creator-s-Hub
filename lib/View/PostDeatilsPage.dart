import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/Controller/HomeController.dart';
import 'package:creatorhub/Controller/PostProvider.dart';
import 'package:creatorhub/View/UserProfilePage.dart';
import 'package:creatorhub/Widgets/AppBarWidgets.dart';
import 'package:creatorhub/Widgets/LiketTriggerWidget.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../Constant/ConstantOfApp.dart';
import '../Widgets/BoxWidget.dart';
import '../Widgets/TextWidgets.dart';

class PostDetailsPage extends StatefulWidget {
  var data;
  final List likes;
  PostDetailsPage({super.key, required this.data, required this.likes});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  String id = "";
  String name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection("Followers")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("Data")
          .get();
      for (var newData in qs.docs) {
        if (widget.data["id"] == newData["id"] ||
            widget.data["Name"] == newData["name"]) {
          setState(() {
            id = newData["id"];
          });
          setState(() {
            name = newData["name"].toString();
            print(name);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      children: [
        const AppBarWidget(name: "Post's  Details"),
        SizedBox(
          height: 30.h,
        ),
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
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      size: 25.w,
                                      color: ConstantOfApp.secondaryColor,
                                    ),
                                    imageUrl: widget.data["ProfileImage"],
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
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error,
                                            size: 25.w,
                                            color: ConstantOfApp.secondaryColor,
                                          ),
                                          imageUrl: widget.data["ProfileImage"],
                                          fit: BoxFit.cover,
                                          width: 30.w,
                                          height: 30.h,
                                        ))),
                              ),
                              TextWidgets(
                                  heading: widget.data["Name"].toString(),
                                  style: ConstantOfApp.subHeading.copyWith(
                                      color: ConstantOfApp.secondaryColor,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 8.sp)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    navigationCore(
                                        UserProfilePage(
                                          data: widget.data,
                                        ),
                                        context);
                                  },
                                  child: TextWidgets(
                                      heading: widget.data["Name"].toString(),
                                      style: ConstantOfApp.subHeading.copyWith(
                                          color: ConstantOfApp.secondaryColor)),
                                ),
                                SizedBox(width: 5.w),
                                widget.data["Name"] == name ||
                                        widget.data["id"] == id
                                    ? TextWidgets(
                                            heading: "Followed",
                                            style: ConstantOfApp.normal
                                                .copyWith(
                                                    color: Colors.blueAccent
                                                        .withOpacity(0.8)))
                                        .animate(effects: [
                                        const ShimmerEffect(
                                            color: ConstantOfApp.secondaryColor,
                                            curve: Curves.ease,
                                            delay: Duration(milliseconds: 500),
                                            angle: 20,
                                            colors: [
                                              Colors.blue,
                                              ConstantOfApp.secondaryColor
                                            ],
                                            duration:
                                                Duration(milliseconds: 800))
                                      ])
                                    : widget.data["userEmail"] ==
                                            FirebaseAuth
                                                .instance.currentUser!.email
                                        ? TextWidgets(
                                            heading: "",
                                            style: ConstantOfApp.normal
                                                .copyWith(fontSize: 12.sp))
                                        : Consumer<HomeController>(
                                            builder: (context, value, child) {
                                            return InkWell(
                                              onTap: () {
                                                value
                                                    .addFollowFunction(
                                                        context, widget.data)
                                                    .then((value) {
                                                  Future.microtask(() async {
                                                    QuerySnapshot qs =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Followers")
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .email)
                                                            .collection("Data")
                                                            .get();
                                                    for (var newData
                                                        in qs.docs) {
                                                      if (widget.data["id"] ==
                                                          newData["id"]) {
                                                        setState(() {
                                                          id = newData["id"];
                                                          name =
                                                              newData["name"];
                                                        });
                                                      }
                                                    }
                                                  });
                                                });
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  color: ConstantOfApp
                                                      .secondaryColor,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 5.h),
                                                  child: TextWidgets(
                                                      heading: "Follow",
                                                      style: ConstantOfApp
                                                          .normal
                                                          .copyWith(
                                                              color: ConstantOfApp
                                                                  .primaryColor)),
                                                ),
                                              ),
                                            );
                                          }).animate(effects: [
                                            const ShimmerEffect(
                                                color: ConstantOfApp
                                                    .secondaryColor,
                                                curve: Curves.ease,
                                                delay:
                                                    Duration(milliseconds: 500),
                                                angle: 20,
                                                colors: [
                                                  Colors.transparent,
                                                  ConstantOfApp.primaryColor
                                                ],
                                                duration:
                                                    Duration(milliseconds: 800))
                                          ]),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            widget.data["Image"] == null
                                ? const SizedBox()
                                : Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.38,
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.data["Image"],
                                        fit: BoxFit.contain,
                                        height: 280.h,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextWidgets(
                                  heading: widget.data["Details"].toString(),
                                  style: ConstantOfApp.subHeading.copyWith(
                                      color: ConstantOfApp.secondaryColor
                                          .withOpacity(0.8))),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 25.w,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                TextWidgets(
                                    heading: "${widget.likes.length} Likes",
                                    style: ConstantOfApp.subHeading.copyWith(
                                        color: ConstantOfApp.secondaryColor
                                            .withOpacity(0.5)))
                              ],
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
    ]));
  }
}

Widget likeUi(List likes, var data) {
  if (likes.contains(data[0]["id"])) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.favorite,
          size: 25.w,
          color: Colors.red,
        ),
        SizedBox(
          width: 8.w,
        ),
        likes.isEmpty
            ? TextWidgets(
                heading: "0 Likes",
                style: ConstantOfApp.subHeading.copyWith(
                    color: ConstantOfApp.secondaryColor.withOpacity(0.5)))
            : TextWidgets(
                heading: "${likes.length} likes",
                style: ConstantOfApp.subHeading.copyWith(
                    color: ConstantOfApp.secondaryColor.withOpacity(0.5)))
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.favorite_border,
          size: 25.w,
          color: Colors.grey,
        ),
        SizedBox(
          width: 8.w,
        ),
        TextWidgets(
            heading: "0 Likes",
            style: ConstantOfApp.subHeading
                .copyWith(color: ConstantOfApp.secondaryColor.withOpacity(0.5)))
      ],
    );
  }
}
