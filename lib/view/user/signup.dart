import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/controller/auth_controller/sign_up_controller.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/utils/validators.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

// ignore: must_be_immutable
class Signup extends StatelessWidget {
  DateTime currentTime = DateTime.now();
  DateFormat? format;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(
        title: 'register'.tr,
        onTap: () => Get.back(),
      ),
      body: Form(
        key: signupController.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                children: [
                  pickProfileImage(context, signupController),
                  SizedBox(
                    height: 50,
                  ),
                  ETextField(
                    controller: signupController.fullNameCon,
                    validator: (value) => emptyFieldValidator(value!),
                    labelText: 'fullName'.tr + ':',
                    // onChanged: (value) {},
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: signupController.emailCon,
                    validator: (value) => emailValidator(value!),
                    labelText: 'email'.tr + ':',
                    onChanged: (value) {
                      if (value.contains(" ")) {
                        var valueList = value.split(" ");
                        log("valueList is: ${valueList} and ");
                        final spaceCounter = valueList.length - 1;
                        log("spaceCounter is: ${spaceCounter} and ");
                        log("adding ${valueList[spaceCounter]} in if value.contains(' ')");
                        signupController.userSearchParameters.addIf(
                            !signupController.userSearchParameters.asMap().containsValue(valueList[spaceCounter].toLowerCase()),
                            valueList[spaceCounter].toLowerCase());
                        signupController.userSearchParameters.addIf(
                            !signupController.userSearchParameters.asMap().containsValue(value.toLowerCase()), value.toLowerCase());
                        log("searchTerms in if value.contains(' ') is: ${signupController.userSearchParameters}");
                      } else {
                        log("in else of onChange means there's no space.");
                        signupController.userSearchParameters.addIf(
                            !signupController.userSearchParameters.asMap().containsValue(value.toLowerCase()), value.toLowerCase());
                      }
                      log("added $value to array: ${signupController.userSearchParameters}");
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: signupController.passCon,
                    validator: (value) => passwordValidator(value!),
                    labelText: 'password'.tr + ':',
                    isObSecure: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: signupController.phoneCon,
                    validator: (value) => phoneValidator(value!),
                    labelText: 'phone'.tr + ':',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: signupController.cityCon,
                    validator: (value) => emptyFieldValidator(value!),
                    labelText: 'city'.tr + ':',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: signupController.stateCon,
                    validator: (value) => emptyFieldValidator(value!),
                    labelText: 'state'.tr + ':',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: signupController.zipCon,
                    validator: (value) => emptyFieldValidator(value!),
                    keyboardType: TextInputType.number,
                    labelText: 'zip'.tr + ':',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: signupController.addressCon,
                    validator: (value) => emptyFieldValidator(value!),
                    labelText: 'address'.tr + ':',
                  ),
                  MyText(
                    text: 'accountType'.tr,
                    size: 16,
                    weight: FontWeight.w700,
                    color: kSecondaryColor,
                    paddingBottom: 15,
                    paddingLeft: 5,
                    paddingTop: 15,
                  ),
                  Row(
                    children: List.generate(
                      2,
                      (index) {
                        return Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 10,
                              ),
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
                                  onTap: () => signupController.signupAccountType(
                                    index == 0 ? 'Private' : 'Business',
                                    index,
                                  ),
                                  splashColor: kSecondaryColor.withOpacity(0.1),
                                  highlightColor: kSecondaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  child: Obx(() {
                                    return Center(
                                      child: signupController.selectedAccountTypeIndex!.value == index
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
                              text: index == 0 ? 'private'.tr : 'business'.tr,
                              size: 14,
                              paddingRight: 30,
                              weight: FontWeight.w500,
                              color: kSecondaryColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: MyButton(
                // onTap: () => Navigator.pushNamed(
                //   context,
                //   AppLinks.verifyEmail,
                // ),
                onTap: () => signupController.signup(context),
                buttonText: 'continue'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pickProfileImage(
    BuildContext context,
    SignupController controller,
  ) {
    return Center(
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 180,
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    onTap: () => controller.pickImage(
                      context,
                      ImageSource.camera,
                    ),
                    leading: Image.asset(
                      Assets.imagesCamera,
                      color: kGreyColor,
                      height: 35,
                    ),
                    title: MyText(
                      text: 'Camera',
                      size: 20,
                    ),
                  ),
                  ListTile(
                    onTap: () => controller.pickImage(
                      context,
                      ImageSource.gallery,
                    ),
                    leading: Image.asset(
                      Assets.imagesGallery,
                      height: 35,
                      color: kGreyColor,
                    ),
                    title: MyText(
                      text: 'Gallery',
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          },
          isScrollControlled: true,
        ),
        child: Stack(
          children: [
            Container(
              height: 128,
              width: 128,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kBlackColor.withOpacity(0.16),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Center(
                child: GetBuilder<SignupController>(
                  init: SignupController(),
                  builder: (logic) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: controller.pickedImage == null
                          ? Image.asset(
                              Assets.imagesProfileAvatar,
                              height: height(context, 1.0),
                              width: width(context, 1.0),
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              controller.pickedImage!,
                              height: height(context, 1.0),
                              width: width(context, 1.0),
                              fit: BoxFit.cover,
                            ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                Assets.imagesAdd,
                height: 37.22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
