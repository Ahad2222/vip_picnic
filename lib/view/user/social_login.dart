import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

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
              () {},
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
              buttonText: 'login with email',
              onTap: () => Get.toNamed(
                AppLinks.login,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: kDarkBlueColor,
                  decoration: TextDecoration.none,
                  fontFamily: GoogleFonts.openSans().fontFamily,
                ),
                children: [
                  TextSpan(
                    text: 'By tapping Log In, you agree with our\n',
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
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
                align: TextAlign.center,
                text: 'login with $buttonText'.toUpperCase(),
                size: 15,
                weight: FontWeight.w500,
                paddingRight: 15,
                color: kGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
