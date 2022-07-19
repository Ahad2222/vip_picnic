import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/settings/settings.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:get/get.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppBar(
        context,
        title: 'aboutUs'.tr,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 20,
          bottom: 30,
        ),
        children: [
          MyText(
            text:
                'vip picnic we specialize in creative outdoor and indoors picnic decorations, we carry out classic, romantic picnics, pijama party, wedding picnics, bachelor parties,baby shower, baptism, birthday party\'s and customize party\'s. we do picnics on the beach in the park and private area, venues according to the client\'s nescecity, The initial price of the Vip picnic includes our initial decoration for the desired theme, which also includes a standard menu, we also have a menu available for extra requests, but we can also make themes adapted to the picnic according to the desire of the client, with a small addition.',
            size: 16,
            color: kSecondaryColor,
            height: 1.5,
            align: TextAlign.justify,
          ),
          MyText(
            paddingTop: 50.0,
            align: TextAlign.center,
            text: 'www.vippicnic.com',
            size: 14,
            weight: FontWeight.w600,
            decoration: TextDecoration.underline,
            color: kTertiaryColor,
          ),
          MyText(
            paddingTop: 5.0,
            align: TextAlign.center,
            text: 'Version 1.0',
            size: 10,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }
}
