import 'package:flutter/material.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/headings.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class CreateNewPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesLock,
              height: 117.34,
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: registerHeading(
                text: 'New Password',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: registerSubHeading(
                text: 'Enter your new password',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            MyTextField(
              hintText: 'New Password',
              isObSecure: true,
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hintText: 'Confirm Password',
              isObSecure: true,
            ),
            SizedBox(
              height: 15,
            ),
            MyButton(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppLinks.login,
                (route) => route.isCurrent,
              ),
              buttonText: 'save password',
            ),
          ],
        ),
      ),
    );
  }
}
