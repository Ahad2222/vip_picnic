import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';

Widget loading() {
  return Center(
    child: SizedBox(
      height: 45,
      width: 45,
      child: CircularProgressIndicator(
        color: kTertiaryColor,
      ),
    ),
  );
}
