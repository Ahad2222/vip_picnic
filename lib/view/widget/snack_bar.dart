import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

showMsg({
  String? msg,
  Color? bgColor = kBlackColor,
  BuildContext? context,
}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      content: MyText(
        text: '$msg',
        size: 12,
        weight: FontWeight.w500,
        color: kPrimaryColor,
      ),
    ),
  );
}
