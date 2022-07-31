import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/view/about_us/about_us.dart';
import 'package:vip_picnic/view/about_us/support.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/choose_language/choose_language.dart';
import 'package:vip_picnic/view/profile/profile.dart';
import 'package:vip_picnic/view/report_problem/report_problem.dart';
import 'package:vip_picnic/view/user/social_login.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppBar(
        context,
        title: 'settings'.tr,
        haveLogoutButton: true,
        isOnSettingScreen: true,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        children: [
          settingsTiles(
            context,
            icon: Assets.imagesUser,
            title: 'profile'.tr,
            onTap: () => Get.to(
              () => Profile(),
            ),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesSimpleLock,
            iconSize: 24.6,
            title: 'privacy'.tr,
            onTap: () {},
          ),
          settingsTiles(
            context,
            icon: Assets.imagesLanguage,
            iconSize: 24.48,
            title: 'language'.tr,
            onTap: () => Get.to(
              () => ChooseLanguage(),
            ),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesSupport,
            title: 'support'.tr,
            onTap: () => Get.to(
              () => Support(),
            ),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesCautionSign,
            title: 'reportProblem'.tr,
            onTap: () => Get.to(
              () => ReportProblem(),
            ),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesInfo,
            iconSize: 22.87,
            title: 'aboutUs'.tr,
            onTap: () => Get.to(
              () => AboutUs(),
            ),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesMail,
            iconSize: 26.83,
            title: 'invite'.tr,
            onTap: () {},
          ),
          settingsTiles(
            context,
            icon: Assets.imagesDisable,
            iconSize: 26.83,
            title: 'deactivateAccount'.tr,
            onTap: () {},
          ),
          settingsTiles(
            context,
            icon: Assets.imagesTrash,
            iconSize: 26.83,
            title: 'deleteAccount'.tr,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget settingsTiles(
    BuildContext context, {
    String? icon,
    String? title,
    double? iconSize = 23.97,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap!,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      minLeadingWidth: 25,
      leading: Image.asset(
        icon!,
        height: iconSize,
        color: Color(0xff7D8187),
      ),
      title: MyText(
        text: title,
        size: 20,
        color: kGreyColorTwo,
      ),
    );
  }
}

AppBar settingsAppBar(
  BuildContext context, {
  bool? haveLogoutButton = false,
  bool? isOnSettingScreen = false,
  String? title,
}) {
  return AppBar(
    backgroundColor: kLightPurpleColorTwo,
    elevation: 0,
    toolbarHeight: 86,
    centerTitle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
    ),
    leading: IconButton(
      onPressed: isOnSettingScreen!
          ? () => Get.offAll(
                BottomNavBar(
                  currentIndex: 0,
                ),
              )
          : () => Get.back(),
      icon: Image.asset(
        Assets.imagesArrowBack,
        height: 22.04,
      ),
    ),
    title: MyText(
      text: '$title',
      size: 20,
      color: kSecondaryColor,
    ),
    actions: [
      haveLogoutButton!
          ? Padding(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              child: IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                },
                icon: Image.asset(
                  Assets.imagesLogout,
                  height: 20.96,
                ),
              ),
            )
          : SizedBox(),
    ],
  );
}
