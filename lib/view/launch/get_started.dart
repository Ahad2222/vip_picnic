import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              MyText(
                text: 'welcomeTo'.tr,
                size: 18,
                weight: FontWeight.w700,
                align: TextAlign.center,
              ),
              MyText(
                text: 'Vip Picnic',
                size: 28,
                color: kSecondaryColor.withOpacity(0.50),
                align: TextAlign.center,
              ),
            ],
          ),
          Image.asset(
            Assets.imagesGetStarted,
            height: 250.0,
          ),
          MyText(
            text: 'introMsg'.tr,
            size: 22,
            align: TextAlign.center,
          ),
          Center(
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kSecondaryColor,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.offAllNamed(
                    AppLinks.socialLogin,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  child: Center(
                    child: Image.asset(
                      Assets.imagesArrowForward,
                      height: 17.09,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
