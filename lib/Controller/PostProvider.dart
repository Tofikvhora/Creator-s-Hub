import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../utils/ToastUitls/ToastUtils.dart';

class PostProvider extends ChangeNotifier {
  FontWeight fontWeightText = FontWeight.w300;
  bool isLoading = false;
  XFile? image;
  final TextEditingController about = TextEditingController();
  final TextEditingController address = TextEditingController();
  String location = "";
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  String downloadUrl = "";
  int like = 0;
  bool isLiked = false;

  updateTextField() {
    about;
    address;
    notifyListeners();
  }

  void changeFont(FontWeight bold) {
    fontWeightText = bold;
    notifyListeners();
  }

  Future<void> pickImageGallery(BuildContext context) async {
    if (image == null) {
      image =
          await _picker.pickImage(source: ImageSource.gallery).then((value) {
        addImageInFirebase();
      });
    } else {
      ToastUtils().showToastUtils(context, ToastificationType.error, "Error",
          "Something want wrong try again", Icons.error);
    }

    notifyListeners();
  }

  Future<void> pickImageCamera(BuildContext context) async {
    image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      ToastUtils().showToastUtils(context, ToastificationType.error, "Error",
          "Something want wrong try again", Icons.error);
    }
    addImageInFirebase();
    notifyListeners();
  }

  Future<void> addImageInFirebase() async {
    if (image != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child("uploads/${image!.name}");
      await storageRef.putFile(File(image!.path));
      downloadUrl = await storageRef.getDownloadURL();
      print(downloadUrl);
      notifyListeners();
    }
  }

  Future<void> addPost(BuildContext context) async {
    DocumentReference df = _fs.collection("UserPost").doc();
    isLoading = true;
    String currentUser = "";
    String profileImage = "";
    QuerySnapshot querySnapshot = await _fs
        .collection("Profile")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("Data")
        .get();
    for (var name in querySnapshot.docs) {
      currentUser = name["ProfileName"].toString();
      profileImage = name["ProfileImage"].toString();
    }
    try {
      if (downloadUrl.isEmpty) {
        ToastUtils().showToastUtils(context, ToastificationType.error,
            "Image Error", "Image Can't be empty", Icons.error);
      } else {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        df.set({
          "Name": currentUser,
          "ProfileImage": profileImage,
          "Image": downloadUrl,
          "Details": about.text,
          "location": address.text,
          "like": FieldValue.arrayUnion([]),
          "comment": 0,
          "share": 0,
          "userId": userId,
          "userEmail": FirebaseAuth.instance.currentUser!.email.toString(),
          "id": ""
        }).then((value) async {
          await df.update({"id": df.id});
          image = null;
          about.clear();
          address.clear();
          downloadUrl = "";
          location = "";
          isLoading = false;
          ToastUtils().showToastUtils(context, ToastificationType.success,
              "Post Added", "Post Add Successfully", Icons.check);
          notifyListeners();
        });
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      isLoading = false;
      ToastUtils().showToastUtils(context, ToastificationType.error,
          "Post error", e.toString(), Icons.error);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> addLike(BuildContext context, String id, String userId) async {
    DocumentReference df = _fs.collection("UserPost").doc(id);

    await df.update({
      "like": FieldValue.arrayUnion([userId])
    });
    notifyListeners();
  }

  Future<void> disLike(BuildContext context, String id, String userId) async {
    DocumentReference df = _fs.collection("UserPost").doc(id);
    await df.update({
      "like": FieldValue.arrayRemove([userId])
    }).then((value) {});
    notifyListeners();
  }
}
