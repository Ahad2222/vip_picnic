import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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
          recognizer: TapGestureRecognizer()..onTap = () {
            launchUrl(
              Uri.parse('https://vippicnic.com/terms.php'),
            );
          },
        ),
        TextSpan(
          text: 'and'.tr,
        ),
        TextSpan(
          text: 'privacyPolicy'.tr,
          recognizer: TapGestureRecognizer()..onTap = () {
            launchUrl(
              Uri.parse('https://vippicnic.com/terms.php'),
            );
          },
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    ),
  );
}
