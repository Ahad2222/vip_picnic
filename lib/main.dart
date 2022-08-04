import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/config/theme/light_theme.dart';
import 'package:vip_picnic/controller/auth_controller/email_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/forgot_password_controller.dart';
import 'package:vip_picnic/controller/auth_controller/google_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/sign_up_controller.dart';
import 'package:vip_picnic/controller/home_controller/home_controller.dart';
import 'package:vip_picnic/controller/splash_screen_controller/splash_screen_controller.dart';
import 'package:vip_picnic/firebase_options.dart';
import 'package:vip_picnic/provider/chat_provider/chat_provider.dart';
import 'package:vip_picnic/provider/story_provider/story_provider.dart';
import 'package:vip_picnic/utils/localization.dart';
import 'package:vip_picnic/view/choose_language/choose_language.dart';
import 'provider/chat_provider/chat_head_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("This simulator is authorized to accept android notification.");
  }

  debugPrint('User granted permission: ${settings.authorizationStatus}');

  await GetStorage.init();
  Get.put(SplashScreenController());
  Get.put(EmailAuthController());
  Get.put(GoogleAuthController());
  Get.put(SignupController());
  Get.put(ForgotPasswordController());
  Get.put(HomeController());
  Get.put(ChooseLanguageController());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatHeadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoryProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      locale: Localization.locale,
      fallbackLocale: Localization.fallBackLocale,
      translations: Localization(),
      title: 'Vip Picnic',
      themeMode: ThemeMode.light,
      theme: lightTheme,
      initialRoute: AppLinks.splashScreen,
      getPages: Routes.pages,
    );
  }
}
