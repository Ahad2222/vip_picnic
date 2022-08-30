import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';

import 'my_text.dart';

class GradientButton extends StatelessWidget {
  VoidCallback onTap;
  var buttonText;
  double textSize,height,opacity;

  GradientButton({
    required this.onTap,
    this.buttonText,
    this.opacity = 0.2,
    this.height = 45.0,
    this.textSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: kSecondaryColor.withOpacity(opacity),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kSecondaryColor.withOpacity(0.1),
          highlightColor: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: MyText(
              text: '$buttonText',
              size: textSize,
              weight: FontWeight.w500,
              color: kSecondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}