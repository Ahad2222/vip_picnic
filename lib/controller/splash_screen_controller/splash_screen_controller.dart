import 'dart:async';

import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Timer(
      Duration(
        seconds: 3,
      ),
      () => Get.offAllNamed(
        AppLinks.getStarted,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<SplashScreenController>();
  }
}
