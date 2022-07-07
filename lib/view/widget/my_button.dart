import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/my_text.dart';


// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    Key? key,
    this.buttonText,
    this.onTap,
  }) : super(key: key);
  String? buttonText;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      height: 47,
      elevation: 0,
      highlightElevation: 0,
      highlightColor: kPrimaryColor.withOpacity(0.1),
      splashColor: kPrimaryColor.withOpacity(0.1),
      shape: StadiumBorder(),
      color: kTertiaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          MyText(
            size: 19,
            text: '$buttonText'.toUpperCase(),
            color: kPrimaryColor,
          ),
          Image.asset(
            Assets.imagesArrowForward,
            height: 11.77,
          ),
        ],
      ),
    );
  }
}