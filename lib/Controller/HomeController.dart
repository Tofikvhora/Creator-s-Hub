import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/utils/ToastUitls/ToastUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class HomeController extends ChangeNotifier {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<void> addFollowFunction(BuildContext context, var data) async {
    DocumentReference df = _fs
        .collection("Followers")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("Data")
        .doc();
    if (data != null) {
      try {
        await df.set({
          "id": data["id"],
          "Email": data["userEmail"],
          "Image": data["ProfileImage"],
          "name": data["Name"],
          "thisId": ""
        }).then((value) async {
          await df.update({"thisId": df.id});
          if (context.mounted) {
            ToastUtils().showToastUtils(context, ToastificationType.success,
                data["Name"], "Followed", Icons.check);
          }
        });
      } catch (e) {
        if (context.mounted) {
          ToastUtils().showToastUtils(context, ToastificationType.error,
              "Something wrong", "Error $e", Icons.error);
        }
      }
    }
  }

  Future<void> unFollow(BuildContext context, List data, int index) async {
    await FirebaseFirestore.instance
        .collection("Followers")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("Data")
        .doc(data[index]["thisId"])
        .delete()
        .then((value) {
      ToastUtils().showToastUtils(context, ToastificationType.success,
          data[index]["name"], "unfollowed", Icons.check);
      notifyListeners();
    });
    notifyListeners();
  }
}
