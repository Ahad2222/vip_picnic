import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/terms_and_condition_text.dart';

// ignore: must_be_immutable
class SocialLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        height: height(context, 1.0),
        width: width(context, 1.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesLoginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            socialLoginButton(
              Assets.imagesGoogle,
              'google',
              () => googleAuthController.googleSignIn(context),
            ),
            socialLoginButton(
              Assets.imagesFacebook,
              'facebook',
              () {},
            ),
            socialLoginButton(
              Assets.imagesApple,
              'apple ID',
              () {},
            ),
            MyButton(
              buttonText: 'login'.tr.toUpperCase() +
                  ' with'.tr.toUpperCase() +
                  ' email'.tr.toUpperCase(),
              onTap: () => Get.toNamed(
                AppLinks.login,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            termsAndConditionsText(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget socialLoginButton(
    String icon,
    buttonText,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: MaterialButton(
        height: 47,
        elevation: 0,
        highlightElevation: 0,
        highlightColor: kSecondaryColor.withOpacity(0.05),
        splashColor: kSecondaryColor.withOpacity(0.05),
        shape: StadiumBorder(),
        color: kPrimaryColor,
        onPressed: onTap,
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 25,
            ),
            Expanded(
              child: MyText(
                paddingLeft: 40,
                align: TextAlign.start,
                text: 'login'.tr.toUpperCase() +
                    ' with'.tr.toUpperCase() +
                    ' $buttonText'.toUpperCase(),
                size: 15,
                weight: FontWeight.w500,
                paddingRight: 15,
                maxLines: 1,
                overFlow: TextOverflow.ellipsis,
                color: kGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
