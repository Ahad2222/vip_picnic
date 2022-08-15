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
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.16),
            blurRadius: 6,
            offset: Offset(-0, -6),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
    ),
  );
}
