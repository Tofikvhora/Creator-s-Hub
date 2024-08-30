import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/NavbarController.dart';
import 'package:creatorhub/View/FollowingPage.dart';
import 'package:creatorhub/View/LoginPage.dart';
import 'package:creatorhub/View/PostDeatilsPage.dart';
import 'package:creatorhub/Widgets/AppBarWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  List postData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      QuerySnapshot query =
          await FirebaseFirestore.instance.collection("UserPost").get();
      for (var data in query.docs) {
        if (data["userEmail"] ==
            FirebaseAuth.instance.currentUser!.email.toString()) {
          setState(() {
            postData.add(data);
          });

          print(
              "this is post data of current user - -------------------------------------->$postData -------------------------------------------");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        children: [
          const AppBarWidget(name: "Profile"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Profile")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection("Data")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: ConstantOfApp.secondaryColor,
                        ));
                      }
                      final snapData = snapshot.data!.docs;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 150.w,
                            height: 150.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                placeholder: (context, url) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: ConstantOfApp.secondaryColor),
                                  );
                                },
                                imageUrl: snapData[0]["ProfileImage"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextWidgets(
                                    heading: snapData[0]["ProfileName"],
                                    style: ConstantOfApp.subHeading),
                                SizedBox(
                                  width: 165.w,
                                  child: TextWidgets(
                                      heading: snapData[0]["Bio"],
                                      style: ConstantOfApp.normal.copyWith(
                                          color: ConstantOfApp.secondaryColor
                                              .withOpacity(0.5))),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      followers(context),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Consumer<NavbarController>(
                                          builder: (context, value, child) {
                                        return InkWell(
                                          onTap: () async {
                                            SharedPreferences sf =
                                                await SharedPreferences
                                                    .getInstance();
                                            sf.clear();
                                            value.selectedIndex = 0;
                                            FirebaseAuth.instance
                                                .signOut()
                                                .then((value) {
                                              navigationCoreReplace(
                                                  const LoginPage(), context);
                                            });
                                          },
                                          child: TextWidgets(
                                              heading: "Logout",
                                              style: ConstantOfApp.normal
                                                  .copyWith(
                                                      color: Colors.red
                                                          .withOpacity(0.5))),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              const Divider(),
              userPost(context, postData),
            ],
          )
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

Widget userPost(
  BuildContext context,
  var postData,
) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("UserPost").snapshots(),
      builder: (context, postSnap) {
        if (!postSnap.hasData) {
          return const Center(
              child: CircularProgressIndicator(
                  color: ConstantOfApp.secondaryColor));
        }
        final snapPost = postSnap.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgets(
                heading: "You're Post", style: ConstantOfApp.subHeading),
            SizedBox(height: 5.h),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: postData.isEmpty
                  ? Center(
                      child: TextWidgets(
                          heading: "NO POST YET",
                          style: ConstantOfApp.heading.copyWith(
                              color: ConstantOfApp.secondaryColor
                                  .withOpacity(0.5))))
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: postData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 5.w,
                          mainAxisSpacing: 5.h),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: ConstantOfApp.secondaryColor
                                      .withOpacity(0.5),
                                  width: 3,
                                  style: BorderStyle.solid,
                                  strokeAlign: BlurEffect.neutralBlur)),
                          child: InkWell(
                            onTap: () {
                              navigationCore(
                                  PostDetailsPage(
                                    data: postData[index],
                                    likes: postData[index]["like"],
                                  ),
                                  context);
                            },
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: postData[index]["Image"],
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.medium,
                                errorWidget: (context, url, error) {
                                  return Icon(
                                    Icons.error,
                                    size: 30.w,
                                    color: ConstantOfApp.secondaryColor,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      });
}

Widget followers(BuildContext context) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Followers")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("Data")
          .snapshots(),
      builder: (context, snaps) {
        if (!snaps.hasData) {
          return const SizedBox();
        }
        final data = snaps.data!.docs;
        return InkWell(
          onTap: () {
            navigationCore(const FollowingPage(), context);
          },
          child: TextWidgets(
              heading: "${data.length} Following",
              style: ConstantOfApp.normal.copyWith(
                  color: ConstantOfApp.secondaryColor.withOpacity(0.5))),
        );
      });
}
