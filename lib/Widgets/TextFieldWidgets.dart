import 'package:creatorhub/Constant/ConstantOfApp.dart';
import 'package:flutter/material.dart';

class TextFieldWidgets extends StatelessWidget {
  final String hint;
  final IconData icons;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool? expand;
  final int? min, max, length;
  final Color? borderColor;
  final Function onChange;
  const TextFieldWidgets(
      {super.key,
      required this.hint,
      required this.icons,
      required this.controller,
      required this.textInputType,
      this.expand,
      this.min,
      required this.onChange,
      this.max,
      this.length,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      expands: false,
      maxLines: max,
      minLines: min,
      controller: controller,
      textAlign: TextAlign.start,
      maxLength: length,
      onChanged: onChange(String),
      style: ConstantOfApp.subHeading
          .copyWith(color: borderColor ?? ConstantOfApp.primaryColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: ConstantOfApp.subHeading.copyWith(
            color: borderColor ?? ConstantOfApp.primaryColor.withOpacity(0.5)),
        suffixIcon: Icon(
          icons,
          color: borderColor ?? ConstantOfApp.primaryColor.withOpacity(0.5),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: borderColor ?? ConstantOfApp.primaryColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: borderColor ?? ConstantOfApp.primaryColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: borderColor ?? ConstantOfApp.primaryColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: borderColor ?? ConstantOfApp.primaryColor)),
      ),
    );
  }
}
