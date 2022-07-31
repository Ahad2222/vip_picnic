import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vip_picnic/constant/color.dart';

Widget termsAndConditionsText() {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w300,
        color: kDarkBlueColor,
        decoration: TextDecoration.none,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      children: [
        TextSpan(
          text: 'byTapping'.tr,
        ),
        TextSpan(
          text: 'termsOfServices'.tr,
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        TextSpan(
          text: 'and'.tr,
        ),
        TextSpan(
          text: 'privacyPolicy'.tr,
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    ),
  );
}
