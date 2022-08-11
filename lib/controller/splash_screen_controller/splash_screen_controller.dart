import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/get_storage_data/get_storage_data.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
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

  checkUser() async {
    if (_user != null) {
      try {
        // UserDetailsModel _userDetailsModel =
        //     await UserSimplePreference.getUserModelData();
        // log('SPLASH SCREEN userDetailsModel ${_userDetailsModel.toJson()}');
        Map<String,dynamic> data = await UserSimplePreference.getUserData();
        log('SPLASH SCREEN getUserData $data');
        userDetailsModel = UserDetailsModel.fromJson(data);
        log('SPLASH SCREEN DATA ${userDetailsModel.toJson()}');
      } catch (e) {
        log('SPLASH EXCEPTION $e');
      }
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
