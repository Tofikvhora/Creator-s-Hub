import 'dart:async';

import 'package:creatorhub/View/HomePage.dart';
import 'package:creatorhub/View/NavBarPage.dart';
import 'package:creatorhub/View/ProfilePage.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:creatorhub/utils/ToastUitls/ToastUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../View/VerificationPage.dart';

class AuthController extends ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? timer;
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    isLoading = true;
    Future.delayed(const Duration(milliseconds: 1000), () async {
      final SharedPreferences _sf = await SharedPreferences.getInstance();
      try {
        await _auth
            .signInWithEmailAndPassword(
                email: email.text, password: password.text)
            .then((value) {
          ToastUtils().showToastUtils(context, ToastificationType.success,
              "Login Successful", "Welcome!", Icons.check);
          navigationCoreReplace(const NavBarPage(), context);
          _sf.setString("email", _auth.currentUser!.email.toString());
          navigationCoreReplace(const NavBarPage(), context);
          isLoading = false;
          notifyListeners();
        });
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        isLoading = false;
        if (context.mounted) {
          ToastUtils().showToastUtils(context, ToastificationType.error,
              "Login error", e.message.toString(), Icons.error);
        }
        notifyListeners();
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  // Signup

  TextEditingController sEmail = TextEditingController();
  TextEditingController sPassword = TextEditingController();
  TextEditingController sConfirmPassword = TextEditingController();
  TextEditingController sName = TextEditingController();
  bool isLoadingCreate = false;
  Future<void> signup(BuildContext context) async {
    isLoadingCreate = true;
    Future.delayed(const Duration(milliseconds: 1000), () async {
      try {
        await _auth
            .createUserWithEmailAndPassword(
                email: sEmail.text, password: sPassword.text)
            .then((value) {
          isLoadingCreate = false;
          ToastUtils().showToastUtils(context, ToastificationType.success,
              "Signup Successful", "Verify email to Continue!", Icons.check);
          navigationCore(const VerificationPage(), context);
          notifyListeners();
        });
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          isLoadingCreate = false;
          ToastUtils().showToastUtils(context, ToastificationType.error,
              "Signup error", e.message.toString(), Icons.error);
          notifyListeners();
        }
      }
    });

    notifyListeners();
  }

  // verification
  bool success = false;
  Future<void> verification(BuildContext context) async {
    final SharedPreferences _sf = await SharedPreferences.getInstance();
    await _auth.currentUser!.sendEmailVerification();
    Future.delayed(const Duration(seconds: 23), () async {
      await _auth.currentUser!.reload();
      success = _auth.currentUser!.emailVerified;
      if (success == true) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          ToastUtils().showToastUtils(
              context,
              ToastificationType.success,
              "Verification Successful",
              "Please Complete profile!",
              Icons.check);
          navigationCoreReplace(const ProfilePage(), context);
        });
      }

      notifyListeners();
    });
    timer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) async {
        await _auth.currentUser!.reload();
        try {
          if (success == false) {
            if (_auth.currentUser!.emailVerified == true) {
              success = _auth.currentUser!.emailVerified;
              print("$success this is the value");
              timer.cancel();
              if (context.mounted) {
                ToastUtils().showToastUtils(
                    context,
                    ToastificationType.success,
                    "Verification Successful",
                    "Please Complete Profile !",
                    Icons.check);
                _sf.setString("email", _auth.currentUser!.email.toString());
                navigationCoreReplace(const ProfilePage(), context);
                notifyListeners();
              }
              notifyListeners();
            } else {
              success = _auth.currentUser!.emailVerified;
              print("$success this is the value");
              timer.cancel();
              _auth.currentUser!.delete();
              if (context.mounted) {
                success = false;
                Navigator.pop(context);
                ToastUtils().showToastUtils(
                    context,
                    ToastificationType.error,
                    "Verification error",
                    "Something want wrong try again",
                    Icons.error);
                notifyListeners();
              }
              notifyListeners();
            }
          }
        } on FirebaseAuthException catch (e) {
          success = false;
          if (context.mounted) {
            ToastUtils().showToastUtils(context, ToastificationType.error,
                "Verification error", e.message.toString(), Icons.error);
          }
          notifyListeners();
        } finally {
          success = false;
          notifyListeners();
        }
      },
    );
    notifyListeners();
  }
}
