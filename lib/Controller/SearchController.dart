import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SearchControllers extends ChangeNotifier {
  String userName = "";

  void searchByUserName(String value) {
    userName = value;
    notifyListeners();
  }
}
