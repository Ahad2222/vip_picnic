import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/user/social_login.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController instance = Get.find<SplashScreenController>();
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    checkUser();
    super.onInit();
  }

  checkUser() {
    if (_user != null) {
      Timer(
        const Duration(
          seconds: 1,
        ),
        () => Get.offAll(
          () => BottomNavBar(),
        ),
      );
    } else {
      Timer(
        const Duration(
          seconds: 2,
        ),
        () => Get.offAll(
          () => SocialLogin(),
        ),
      );
    }
  }
}
