import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/HomeController.dart';
import 'package:creatorhub/Widgets/AppBarWidgets.dart';
import 'package:creatorhub/Widgets/BoxWidget.dart';
import 'package:creatorhub/Widgets/ButtonWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:creatorhub/utils/ToastUitls/ToastUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Followers")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("Data")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: ConstantOfApp.secondaryColor));
            }
            final data = snapshot.data!.docs;
            return data.isEmpty
                ? Center(
                    child: TextWidgets(
                      heading: "0 Following",
                      style: ConstantOfApp.heading,
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 0.h),
                        child: const AppBarWidget(
                          name: "Following",
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 0),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return SafeArea(
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            BoxWidgets(
                                                child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                imageUrl: data[index]["Image"],
                                                fit: BoxFit.cover,
                                                width: 50.w,
                                                height: 50.h,
                                              ),
                                            )),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            TextWidgets(
                                                heading: data[index]["name"],
                                                style: ConstantOfApp.heading),
                                          ],
                                        ),
                                        Consumer<HomeController>(
                                            builder: (context, value, child) {
                                          return InkWell(
                                            onTap: () async {
                                              value.unFollow(
                                                  context, data, index);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ConstantOfApp
                                                      .secondaryColor),
                                              child: TextWidgets(
                                                style: ConstantOfApp.heading
                                                    .copyWith(
                                                        color: ConstantOfApp
                                                            .primaryColor,
                                                        fontSize: 15.sp),
                                                heading: "Unfollow",
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}
