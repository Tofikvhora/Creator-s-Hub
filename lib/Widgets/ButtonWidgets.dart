import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:creatorhub/Widgets/TextWidgets.dart';
import 'package:flutter/material.dart';

class ButtonWidgets extends StatelessWidget {
  final String name;
  final Function() onTap;
  final Color? color;
  final Color? textColor;
  const ButtonWidgets({
    super.key,
    required this.name,
    required this.onTap,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color ?? ConstantOfApp.primaryColor),
        child: TextWidgets(
          style: ConstantOfApp.heading
              .copyWith(color: textColor ?? ConstantOfApp.secondaryColor),
          heading: name,
        ),
      ),
    );
  }
}
