import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorhub/View/NavBarPage.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../utils/ToastUitls/ToastUtils.dart';

class ProfileController extends ChangeNotifier {
  TextEditingController profileName = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController link = TextEditingController();
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _pick = ImagePicker();
  XFile? xfile;
  String imageUrl = "";
  bool isLoading = false;

  Future<void> pickImage() async {
    try {
      xfile = await _pick.pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        profileImageToFirebase();
        notifyListeners();
      }
      notifyListeners();
      print(xfile!.path);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> profileImageToFirebase() async {
    if (xfile != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child("Profile/${xfile!.name}");
      await storageRef.putFile(File(xfile!.path));
      imageUrl = await storageRef.getDownloadURL();
      print(imageUrl);
      notifyListeners();
    }
  }

  Future<void> addProfileData(BuildContext context) async {
    DocumentReference df = _fs
        .collection("Profile")
        .doc(_auth.currentUser!.email)
        .collection("Data")
        .doc();

    isLoading = true;
    Future.delayed(const Duration(milliseconds: 800), () async {
      if (profileName.text.isEmpty && xfile == null) {
        isLoading = false;
        ToastUtils().showToastUtils(
            context,
            ToastificationType.error,
            "Data is Empty",
            "Name and image can't be empty please add!",
            Icons.error);
        notifyListeners();
      } else {
        await df.set({
          "id": "",
          "ProfileImage": imageUrl,
          "ProfileName": profileName.text,
          "Bio": bio.text,
          "Links": link.text,
          "Followers": FieldValue.arrayUnion([]),
        }).then((value) async {
          await df.update({"id": df.id});
          addAllUsers();
          imageUrl = "";
          profileName.clear();
          bio.clear();
          link.clear();
          xfile = null;
          isLoading = false;
          if (context.mounted) {
            ToastUtils().showToastUtils(
                context,
                ToastificationType.success,
                "Profile Complete",
                "You're data is stored in our database!",
                Icons.check);
            navigationCoreReplace(const NavBarPage(), context);
            SharedPreferences sf = await SharedPreferences.getInstance();
            sf.setString("email", _auth.currentUser!.email.toString());
            notifyListeners();
          }
          notifyListeners();
        });
      }
    });
    notifyListeners();
  }

  Future<void> addAllUsers() async {
    DocumentReference df = _fs.collection("Users").doc();
    await df.set({
      "id": "",
      "ProfileImage": imageUrl,
      "Name": profileName.text,
      "userEmail": FirebaseAuth.instance.currentUser!.email,
      "Bio": bio.text,
      "Links": link.text,
    }).then((value) async {
      await df.update({"id": df.id});
    });
  }
}
