import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/controller/auth_controller/email_auth_controller.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/validators.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/terms_and_condition_text.dart';

class Login extends StatelessWidget {
  EmailAuthController _emailAuthController = Get.put(
    EmailAuthController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _emailAuthController.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyTextField(
                hintText: 'email'.tr,
                controller: _emailAuthController.emailCon,
                validator: (value) => emailValidator(value!),
              ),
              SizedBox(
                height: 15,
              ),
              MyTextField(
                hintText: 'password'.tr,
                controller: _emailAuthController.passCon,
                validator: (value) => passwordValidator(value!),
                isObSecure: true,
              ),
              SizedBox(
                height: 15,
              ),
              MyButton(
                onTap: () => _emailAuthController.login(context),
                buttonText: 'login'.tr,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  keepMeLoggedIn(_emailAuthController),
                  Expanded(
                    child: MyText(
                      align: TextAlign.end,
                      onTap: () => Get.toNamed(
                        AppLinks.forgotPassword,
                      ),
                      text: 'forgot'.tr + '?',
                      size: 18,
                      maxLines: 1,
                      overFlow: TextOverflow.ellipsis,
                      color: kTertiaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              createAccountButton(
                onTap: () => Get.toNamed(
                  AppLinks.signup,
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
      ),
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
                  text: 'createAccount'.tr.toUpperCase(),
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

  Widget keepMeLoggedIn(
    EmailAuthController controller,
  ) {
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
              onTap: () => controller.yesKeepLoggedIn(),
              splashColor: kSecondaryColor.withOpacity(0.1),
              highlightColor: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              child: Obx(() {
                return Center(
                  child: controller.isKeepMeLoggedIn.value
                      ? Icon(
                          Icons.check,
                          size: 18,
                          color: kSecondaryColor,
                        )
                      : SizedBox(),
                );
              }),
            ),
          ),
        ),
        MyText(
          paddingLeft: 10,
          text: 'keepMeLoggedIn'.tr,
          size: 18,
          color: kDarkBlueColor,
        ),
      ],
    );
  }
}
