import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/config/theme/light_theme.dart';
import 'package:vip_picnic/provider/chat_provider/chat_provider.dart';

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
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Vip Picnic',
      initialRoute: AppLinks.splashScreen,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      routes: RoutesConfig.routes,
    );
  }
}
