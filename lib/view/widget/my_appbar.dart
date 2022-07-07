import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

AppBar myAppBar({
  String? title,
  VoidCallback? onTap,
}) {
  return AppBar(
    centerTitle: true,
    toolbarHeight: 75,
    leading: Padding(
      padding: const EdgeInsets.only(
        left: 5,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Image.asset(
          Assets.imagesArrowBack,
          height: 22.04,
        ),
      ),
    ),
    title: MyText(
      text: title,
      size: 20,
      color: kSecondaryColor,
    ),
  );
}