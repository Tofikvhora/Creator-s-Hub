import 'package:creatorhub/View/FeedPage.dart';
import 'package:creatorhub/View/HomePage.dart';
import 'package:creatorhub/View/PostPage.dart';
import 'package:creatorhub/View/ProfileHomePage.dart';
import 'package:creatorhub/View/SearchPage.dart';
import 'package:flutter/cupertino.dart';

class NavbarController extends ChangeNotifier {
  List screens = [
    const HomePage(),
    const SearchPage(),
    const FeedPage(),
    const ProfileHomePage()
  ];
  int selectedIndex = 0;

  void onTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
