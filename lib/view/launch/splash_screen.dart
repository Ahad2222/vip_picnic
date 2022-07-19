import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/controller/splash_screen_controller/splash_screen_controller.dart';
import 'package:vip_picnic/generated/assets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: Image.asset(
              Assets.imagesLogo,
              height: 145.57,
            ),
          ),
        );
      },
    );
  }
}
