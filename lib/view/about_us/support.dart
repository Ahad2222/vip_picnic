import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/settings/settings.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppBar(
        context,
        title: 'support'.tr,
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
            text: 'contactUs'.tr,
            size: 18,
            color: kSecondaryColor,
            weight: FontWeight.w600,
          ),
          MyText(
            paddingTop: 30,
            paddingBottom: 0,
            text: 'emailUs'.tr,
            size: 16,
            color: kSecondaryColor,
            weight: FontWeight.w600,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  launchUrl(
                    Uri.parse('mailto:info@vippicnic.com?subject=Support email &body=Hi, Write your message here'),
                  );
                },
                child: MyText(
                  text: 'info@vippicnic.com',
                  size: 15,
                  decoration: TextDecoration.underline,
                  color: kTertiaryColor,
                ),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: "info@vippicnic.com"),
                    ).then((value) {
                      showMsg(
                        // msg: "Link Copied!",
                        context: context,
                        msg: "Email has been copied to clipboard",
                      );
                    });
                  },
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                  ))

            ],
          ),
          MyText(
            paddingTop: 30,
            paddingBottom: 0,
            text: 'webSite'.tr,
            size: 16,
            color: kSecondaryColor,
            weight: FontWeight.w600,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  launchUrl(
                    Uri.parse('https://www.vippicnic.com'),
                  );
                },
                child: MyText(
                  paddingTop: 0.0,
                  text: 'www.vippicnic.com',
                  size: 14,
                  decoration: TextDecoration.underline,
                  color: kTertiaryColor,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: "https://www.vippicnic.com"),
                    ).then((value) {
                      showMsg(
                        // msg: "Link Copied!",
                        context: context,
                        msg: "Website link has been copied to clipboard",
                      );
                    });
                  },
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
