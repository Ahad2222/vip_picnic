import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/settings/settings.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppBar(
        context,
        title: 'Support',
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
            text: 'If you have any question please feel free to contact us.',
            size: 18,
            color: kSecondaryColor,
            weight: FontWeight.w600,
          ),
          MyText(
            paddingTop: 30,
            paddingBottom: 5,
            text: 'Email:',
            size: 16,
            color: kSecondaryColor,
            weight: FontWeight.w600,
          ),
          MyText(
            text: 'info@vippicnic.com',
            size: 14,
            decoration: TextDecoration.underline,
            color: kTertiaryColor,
          ),
          MyText(
            paddingTop: 30,
            paddingBottom: 5,
            text: 'Website:',
            size: 16,
            color: kSecondaryColor,
            weight: FontWeight.w600,
          ),
          MyText(
            paddingTop: 5.0,
            text: 'www.vippicnic.com',
            size: 14,
            decoration: TextDecoration.underline,
            color: kTertiaryColor,
          ),
        ],
      ),
    );
  }
}
