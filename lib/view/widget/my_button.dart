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
    this.textSize = 19,
    this.buttonHeight = 47,
    this.iconSize = 11.77,
    this.buttonColor = kTertiaryColor,
    this.showIcon = true,
  }) : super(key: key);
  String? buttonText;
  VoidCallback? onTap;
  Color buttonColor;
  double textSize, buttonHeight, iconSize;
  bool showIcon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      height: buttonHeight,
      elevation: 0,
      highlightElevation: 0,
      highlightColor: kPrimaryColor.withOpacity(0.1),
      splashColor: kPrimaryColor.withOpacity(0.1),
      shape: StadiumBorder(),
      color: buttonColor,
      child: Row(
        mainAxisAlignment: showIcon
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          Container(),
          MyText(
            size: textSize,
            text: '$buttonText'.toUpperCase(),
            color: kPrimaryColor,
          ),
          showIcon
              ? Image.asset(
                  Assets.imagesArrowForward,
                  height: iconSize,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
