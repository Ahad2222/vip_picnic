import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/about_us/about_us.dart';
import 'package:vip_picnic/view/about_us/support.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/profile/profile.dart';
import 'package:vip_picnic/view/report_problem/report_problem.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppBar(
        context,
        title: 'Settings',
        haveLogoutButton: true,
        isOnSettingScreen: true,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: 40,
        ),
        children: [
          settingsTiles(
            context,
            icon: Assets.imagesUser,
            title: 'Profile',
            goTo: Profile(),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesSimpleLock,
            iconSize: 24.6,
            title: 'Privacy',
            goTo: Profile(),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesLanguage,
            iconSize: 24.48,
            title: 'Idiom',
            goTo: Profile(),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesSupport,
            title: 'Support',
            goTo: Support(),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesCautionSign,
            title: 'Report Problem',
            goTo: ReportProblem(),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesInfo,
            iconSize: 22.87,
            title: 'About Us',
            goTo: AboutUs(),
          ),
          settingsTiles(
            context,
            icon: Assets.imagesMail,
            iconSize: 26.83,
            title: 'Invite',
            goTo: Profile(),
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
    Widget? goTo,
  }) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => goTo!,
        ),
      ),
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
          ? () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavBar(
                    currentIndex: 0,
                  ),
                ),
                (route) => route.isCurrent,
              )
          : () => Navigator.pop(context),
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
                onPressed: () {},
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
