import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/provider/user_provider/user_provider.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, UserProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                MyTextField(
                  hintText: 'Username',
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextField(
                  hintText: 'Password',
                  isObSecure: false,
                ),
                SizedBox(
                  height: 15,
                ),
                MyButton(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppLinks.bottomNavBar,
                    (route) => false,
                  ),
                  buttonText: 'login',
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    keepMeLoggedIn(UserProvider),
                    MyText(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppLinks.forgotPassword,
                      ),
                      text: 'Forgot?',
                      size: 18,
                      color: kTertiaryColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                createAccountButton(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppLinks.signup,
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
      },
    );
  }

  Widget createAccountButton({
    VoidCallback? onTap,
  }) {
    return Container(
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 1.0, color: kDarkBlueColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          splashColor: kDarkBlueColor.withOpacity(0.05),
          highlightColor: kDarkBlueColor.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                MyText(
                  size: 19,
                  text: 'Create account'.toUpperCase(),
                  color: kDarkBlueColor,
                ),
                Image.asset(
                  Assets.imagesArrowForward,
                  height: 11.77,
                  color: kDarkBlueColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget keepMeLoggedIn(UserProvider UserProvider) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor,
            border: Border.all(
              width: 1.0,
              color: kBorderColor,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => UserProvider.yesKeepLoggedIn(),
              splashColor: kSecondaryColor.withOpacity(0.1),
              highlightColor: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              child: Center(
                child: UserProvider.isKeepMeLoggedIn
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: kSecondaryColor,
                      )
                    : SizedBox(),
              ),
            ),
          ),
        ),
        MyText(
          paddingLeft: 10,
          text: 'Keep me logged in',
          size: 18,
          color: kDarkBlueColor,
        ),
      ],
    );
  }
}
