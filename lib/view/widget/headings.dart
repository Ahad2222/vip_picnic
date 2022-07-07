import 'package:flutter/material.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

MyText registerSubHeading({
  String? text,
}) {
  return MyText(
    text: text,
    size: 18,
    align: TextAlign.center,
  );
}

MyText registerHeading({
  String? text,
}) {
  return MyText(
    text: text,
    size: 22,
    weight: FontWeight.w700,
  );
}