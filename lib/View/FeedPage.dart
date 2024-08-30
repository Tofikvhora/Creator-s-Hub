import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Widgets/AppBarWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("UserPost").snapshots(),
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
                        heading: "No feed yet",
                        style: ConstantOfApp.heading
                            .copyWith(color: ConstantOfApp.secondaryColor)),
                  )
                : PageView.builder(
                    itemCount: snap.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final data = snap[index];
                      return feedWidget(context, data);
                    },
                  );
          }),
    );
  }
}

Widget feedWidget(BuildContext context, var data) {
  return Stack(
    children: [
      SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: const AppBarWidget(name: "Feed"),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: CachedNetworkImage(
              filterQuality: FilterQuality.medium,
              imageUrl: data["Image"].toString(),
              errorWidget: (context, error, stackTrace) {
                return Icon(
                  Icons.error,
                  size: 25.w,
                  color: ConstantOfApp.secondaryColor,
                );
              },
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      Positioned(
          bottom: -10,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ConstantOfApp.secondaryColor),
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
                          width: 90.w,
                          height: 90.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextWidgets(
                        heading: data["Name"].toString(),
                        style: ConstantOfApp.subHeading
                            .copyWith(color: ConstantOfApp.secondaryColor)),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextWidgets(
                      heading: data["Details"],
                      style: ConstantOfApp.normal.copyWith(
                          color:
                              ConstantOfApp.secondaryColor.withOpacity(0.5))),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ))
    ],
  );
}
