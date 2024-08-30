import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../Constant/ConstantOfApp.dart';

class ToastUtils {
  void showToastUtils(
    BuildContext context,
    ToastificationType type,
    String name,
    String msg,
    IconData icons,
  ) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: type,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        name,
        style: ConstantOfApp.subHeading
            .copyWith(color: ConstantOfApp.primaryColor),
      ),
      // you can also use RichText widget for title and description parameters
      description: RichText(
          text: TextSpan(
              text: msg,
              style: ConstantOfApp.subHeading
                  .copyWith(color: ConstantOfApp.primaryColor))),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: Icon(
        icons,
        color: ConstantOfApp.primaryColor,
      ),
      showIcon: true, // show or hide the icon
      primaryColor: ConstantOfApp.secondaryColor,
      backgroundColor: ConstantOfApp.secondaryColor,
      foregroundColor: ConstantOfApp.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
}
