import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/controller/auth_controller/forgot_password_controller.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/validators.dart';
import 'package:vip_picnic/view/widget/headings.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPasswordController forgotPasswordController = Get.put(
    ForgotPasswordController(),
  );

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
                text: 'forgotPassword'.tr + '?',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: registerSubHeading(
                text: 'passwordResetIns'.tr,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: forgotPasswordController.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: MyTextField(
                hintText: 'email123@mail.com',
                controller: forgotPasswordController.emailCon,
                validator: (value) => emailValidator(value!),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MyButton(
              onTap: () => forgotPasswordController.resetPassword(context),
              buttonText: 'resetPassword'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
