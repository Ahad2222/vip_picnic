import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
            text: 'aboutUsText'.tr,
            size: 16,
            color: kSecondaryColor,
            height: 1.5,
            align: TextAlign.justify,
          ),
          GestureDetector(
            onTap: () {
              launchUrl(
                Uri.parse('https://www.vippicnic.com'),
              );
            },
            child: MyText(
              paddingTop: 50.0,
              align: TextAlign.center,
              text: 'www.vippicnic.com',
              size: 14,
              weight: FontWeight.w600,
              decoration: TextDecoration.underline,
              color: kTertiaryColor,
            ),
          ),
          MyText(
            paddingTop: 5.0,
            align: TextAlign.center,
            text: 'version'.tr + ' 1.0',
            size: 10,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }
}
