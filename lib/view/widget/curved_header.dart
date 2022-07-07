import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';

SliverToBoxAdapter curvedHeader({
  double? paddingTop = 300,
}) {
  return SliverToBoxAdapter(
    child: Container(
      height: 35,
      margin: EdgeInsets.only(
        top: paddingTop!,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
    ),
  );
}
