import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/config/theme/light_theme.dart';
import 'package:vip_picnic/provider/chat_provider/chat_provider.dart';
import 'package:vip_picnic/provider/story_provider/story_provider.dart';
import 'package:vip_picnic/utils/localization.dart';

import 'provider/chat_provider/chat_head_provider.dart';
import 'provider/user_provider/user_provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      locale: Localization.locale,
      fallbackLocale: Localization.fallBackLocale,
      translations: Localization(),
      title: 'Vip Picnic',
      themeMode: ThemeMode.light,
      theme: lightTheme,
      initialRoute: AppLinks.bottomNavBar,
      getPages: Routes.pages,
    );
  }
}
