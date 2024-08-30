import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Controller/NavbarController.dart';
import 'package:creatorhub/View/PostPage.dart';
import 'package:creatorhub/utils/NavigationCore/NavigationCore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavbarController>(context);
    return Scaffold(
      body: provider.screens[provider.selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigationCore(const PostPage(), context);
        },
        backgroundColor: ConstantOfApp.secondaryColor,
        elevation: 10,
        enableFeedback: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Icon(
          Icons.add,
          size: 25.w,
          color: ConstantOfApp.primaryColor,
        ),
      ),
      bottomNavigationBar:
          Consumer<NavbarController>(builder: (context, value, child) {
        return BottomNavigationBar(
          currentIndex: value.selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            value.onTap(index);
          },
          backgroundColor: ConstantOfApp.primaryColor,
          enableFeedback: true,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: ConstantOfApp.secondaryColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(IconlyLight.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(IconlyLight.video), label: "Feed"),
            BottomNavigationBarItem(
                icon: Icon(IconlyLight.profile), label: "Profile"),
          ],
        );
      }),
    );
  }
}
