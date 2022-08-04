import 'package:flutter/material.dart';
import 'package:vip_picnic/generated/assets.dart';

class SplashScreen extends StatelessWidget {
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
