import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/SearchController.dart';
import 'package:creatorhub/View/PostDeatilsPage.dart';
import 'package:creatorhub/View/ProfileHomePage.dart';
import 'package:creatorhub/View/UserProfilePage.dart';
import 'package:creatorhub/Widgets/AppBarWidgets.dart';
import 'package:creatorhub/Widgets/BoxWidget.dart';
import 'package:creatorhub/Widgets/TextFieldWidgets.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        children: [
          const AppBarWidget(name: "Search"),
          Consumer<SearchControllers>(builder: (context, value, child) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: TextField(
                controller: search,
                textAlign: TextAlign.start,
                onChanged: (val) {
                  setState(() {
                    value.userName = val;
                  });
                },
                style: ConstantOfApp.subHeading
                    .copyWith(color: ConstantOfApp.secondaryColor),
                decoration: InputDecoration(
                  hintText: "Search by Username",
                  hintStyle: ConstantOfApp.subHeading.copyWith(
                      color: ConstantOfApp.secondaryColor.withOpacity(0.5)),
                  suffixIcon: Icon(
                    IconlyLight.search,
                    color: ConstantOfApp.secondaryColor.withOpacity(0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: ConstantOfApp.secondaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: ConstantOfApp.secondaryColor)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: ConstantOfApp.secondaryColor)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: ConstantOfApp.secondaryColor)),
                ),
              ),
            );
          }),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("UserPost").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: ConstantOfApp.secondaryColor));
                }
                final snap = snapshot.data!.docs;
                return Consumer<SearchControllers>(
                    builder: (context, value, child) {
                  return search.text == ""
                      ? SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: MasonryGridView.count(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            itemCount: snap.length,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            itemBuilder: (context, index) {
                              final data = snap[index];
                              return InkWell(
                                onTap: () {
                                  navigationCore(
                                      PostDetailsPage(
                                        data: data,
                                        likes: data["like"],
                                      ),
                                      context);
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: (index % 3 + 3) * 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: data["Image"],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .snapshots(),
                          builder: (context, snapsh) {
                            if (!snapsh.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final users = snapsh.data!.docs;
                            return SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final data = users[index];
                                  if (value.userName.isEmpty) {
                                    return TextWidgets(
                                        heading: "No Such Name",
                                        style: ConstantOfApp.subHeading
                                            .copyWith(
                                                color: ConstantOfApp
                                                    .secondaryColor));
                                  }
                                  if (data["Name"].toString().startsWith(
                                      value.userName.toLowerCase())) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: InkWell(
                                          onTap: () {
                                            navigationCore(
                                                UserProfilePage(
                                                  data: data,
                                                ),
                                                context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: BoxWidgets(
                                                      child: CachedNetworkImage(
                                                        imageUrl: data[
                                                            "ProfileImage"],
                                                        width: 80.w,
                                                        height: 80.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  TextWidgets(
                                                    heading: data["Name"],
                                                    style: ConstantOfApp
                                                        .subHeading
                                                        .copyWith(
                                                            color: ConstantOfApp
                                                                .secondaryColor),
                                                  ),
                                                ],
                                              ),
                                              Icon(
                                                IconlyBold.arrow_right,
                                                size: 25.w,
                                                color: ConstantOfApp
                                                    .secondaryColor
                                                    .withOpacity(0.5),
                                              )
                                            ],
                                          )),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            );
                          });
                });
              }),
        ],
      ),
    );
  }
}
