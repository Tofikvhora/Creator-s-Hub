import 'package:creatorhub/Controller/PostProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Constant/ConstantOfApp.dart';
import 'TextWidgets.dart';

class LikeTriggerWidget extends StatelessWidget {
  final List likes;
  final String userId;
  final String id;
  const LikeTriggerWidget(
      {super.key, required this.likes, required this.id, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder: (context, value, child) {
      return InkWell(
        onTap: () {
          if (likes.contains(userId)) {
            value.disLike(context, id, userId);
          } else {
            value.addLike(context, id, userId);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  likes.contains(userId)
                      ? Icon(
                          Icons.favorite,
                          size: 25.w,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 25.w,
                          color: Colors.grey,
                        ),
                  SizedBox(
                    width: 8.w,
                  ),
                  TextWidgets(
                      heading: "${likes.length} Likes",
                      style: ConstantOfApp.subHeading.copyWith(
                          color: ConstantOfApp.secondaryColor.withOpacity(0.5)))
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
