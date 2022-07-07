import 'package:flutter/material.dart';

height(
  BuildContext context,
  double height,
) {
  return MediaQuery.of(context).size.height * height;
}

width(
  BuildContext context,
  double width,
) {
  return MediaQuery.of(context).size.width * width;
}
