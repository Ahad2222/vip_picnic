import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/generated/assets.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(
        seconds: 3,
      ),
      () => Navigator.pushReplacementNamed(
        context,
        AppLinks.getStarted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.imagesLogo,
          height: 145.57,
        ),
      ),
    );
  }
}
