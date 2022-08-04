import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/view/about_us/about_us.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/chat/chat_head.dart';
import 'package:vip_picnic/view/chat/group_chat/create_new_group.dart';
import 'package:vip_picnic/view/events/customize_event.dart';
import 'package:vip_picnic/view/events/packages/picnic_packages.dart';
import 'package:vip_picnic/view/events/purchase_events.dart';
import 'package:vip_picnic/view/home/home.dart';
import 'package:vip_picnic/view/launch/get_started.dart';
import 'package:vip_picnic/view/launch/splash_screen.dart';
import 'package:vip_picnic/view/notifications/notifications.dart';
import 'package:vip_picnic/view/home/add_new_post.dart';
import 'package:vip_picnic/view/profile/edit_profile.dart';
import 'package:vip_picnic/view/profile/profile.dart';
import 'package:vip_picnic/view/settings/settings.dart';
import 'package:vip_picnic/view/user/forgot_password/create_new_password.dart';
import 'package:vip_picnic/view/user/forgot_password/forgot_password.dart';
import 'package:vip_picnic/view/user/login.dart';
import 'package:vip_picnic/view/user/signup.dart';
import 'package:vip_picnic/view/user/social_login.dart';
import 'package:vip_picnic/view/user/verification/create_password.dart';
import 'package:vip_picnic/view/user/verification/verification_code.dart';

abstract class Routes {
  Routes._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppLinks.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppLinks.getStarted,
      page: () => GetStarted(),
    ),
    GetPage(
      name: AppLinks.socialLogin,
      page: () => SocialLogin(),
    ),
    GetPage(
      name: AppLinks.login,
      page: () => Login(),
    ),
    GetPage(
      name: AppLinks.signup,
      page: () => Signup(),
    ),
    // GetPage(
    //   name: AppLinks.verifyEmail,
    //   page: () => VerifyEmail(),
    // ),
    GetPage(
      name: AppLinks.verificationCode,
      page: () => VerificationCode(),
    ),
    GetPage(
      name: AppLinks.createPassword,
      page: () => CreatePassword(),
    ),
    GetPage(
      name: AppLinks.forgotPassword,
      page: () => ForgotPassword(),
    ),
    GetPage(
      name: AppLinks.createNewPassword,
      page: () => CreateNewPassword(),
    ),
    //Bottom Nav Bar
    GetPage(
      name: AppLinks.bottomNavBar,
      page: () => BottomNavBar(),
    ),
    GetPage(
      name: AppLinks.home,
      page: () => Home(),
    ),

    //  Chat
    GetPage(
      name: AppLinks.chatHead,
      page: () => ChatHead(),
    ),
    GetPage(
      name: AppLinks.createNewGroup,
      page: () => CreateNewGroup(),
    ),

    //  settings
    GetPage(
      name: AppLinks.settings,
      page: () => Settings(),
    ),
    GetPage(
      name: AppLinks.aboutUs,
      page: () => AboutUs(),
    ),
    GetPage(
      name: AppLinks.notifications,
      page: () => Notifications(),
    ),
    GetPage(
      name: AppLinks.profile,
      page: () => Profile(),
    ),
    GetPage(
      name: AppLinks.editProfile,
      page: () => EditProfile(),
    ),
    GetPage(
      name: AppLinks.addNewPost,
      page: () => AddNewPost(),
    ),

    //Events
    GetPage(
      name: AppLinks.purchaseEvents,
      page: () => PurchaseEvents(),
    ),
    GetPage(
      name: AppLinks.picnicPackages,
      page: () => PicnicPackages(),
    ),
    GetPage(
      name: AppLinks.customizeEvent,
      page: () => CustomizeEvent(),
    ),
  ];
}

class RoutesConfig {
  static final routes = <String, WidgetBuilder>{
    AppLinks.splashScreen: (_) => SplashScreen(),
    AppLinks.getStarted: (_) => GetStarted(),
    AppLinks.socialLogin: (_) => SocialLogin(),
    AppLinks.login: (_) => Login(),
    AppLinks.signup: (_) => Signup(),
    // AppLinks.verifyEmail: (_) => VerifyEmail(),
    AppLinks.verificationCode: (_) => VerificationCode(),
    AppLinks.createPassword: (_) => CreatePassword(),
    AppLinks.forgotPassword: (_) => ForgotPassword(),
    AppLinks.createNewPassword: (_) => CreateNewPassword(),
    AppLinks.bottomNavBar: (_) => BottomNavBar(),
    AppLinks.home: (_) => Home(),
    //Chat
    AppLinks.chatHead: (_) => ChatHead(),
    AppLinks.createNewGroup: (_) => CreateNewGroup(),
    //  settings
    AppLinks.settings: (_) => Settings(),
    AppLinks.aboutUs: (_) => AboutUs(),
    AppLinks.notifications: (_) => Notifications(),
    AppLinks.profile: (_) => Profile(),
    AppLinks.editProfile: (_) => EditProfile(),
    AppLinks.addNewPost: (_) => AddNewPost(),
    //Events
    AppLinks.purchaseEvents: (_) => PurchaseEvents(),
    AppLinks.picnicPackages: (_) => PicnicPackages(),
    AppLinks.customizeEvent: (_) => CustomizeEvent(),
  };
}

abstract class AppLinks {
  AppLinks._();
  static const splashScreen = '/splash_screen';
  static const getStarted = '/get_started';
  static const socialLogin = '/social_login';
  static const login = '/login';
  static const signup = '/signup';
  // static const verifyEmail = '/verify_email';
  static const verificationCode = '/verification_code';
  static const createPassword = '/create_password';
  static const forgotPassword = '/forgot_password';
  static const createNewPassword = '/create_new_password';
  static const bottomNavBar = '/bottom_nav_bar';
  static const home = '/home';
  static const settings = '/settings';
  static const aboutUs = '/about_us';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const editProfile = '/edit_profile';
  static const addNewPost = '/add_new_post';

  //chat
  static const chatHead = '/chat_head';
  static const createNewGroup = '/create_new_group';

  //Events
  static const purchaseEvents = '/purchase_events';
  static const picnicPackages = '/picnic_packages';
  static const customizeEvent = '/customize_event';
}
