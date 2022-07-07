import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vip_picnic/constant/color.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: kPrimaryColor,
  fontFamily: GoogleFonts.openSans().fontFamily,
  splashColor: kSecondaryColor.withOpacity(0.05),
  highlightColor: kSecondaryColor.withOpacity(0.05),
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimaryColor,
    elevation: 0,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kSecondaryColor.withOpacity(0.05),
  ),
);
