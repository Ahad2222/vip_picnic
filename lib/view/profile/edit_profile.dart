import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/user/social_login.dart';
import 'package:vip_picnic/view/user/verification/edit_profile_verification_code.dart';
import 'package:vip_picnic/view/widget/edit_bottom_sheet.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();

  // TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  DocumentReference myDoc = accounts.doc(auth.currentUser?.uid ?? "");

  @override
  void initState() {
    // TODO: implement initState
    nameController.text =
        (userDetailsModel.fullName != null && userDetailsModel.fullName != "")
            ? (userDetailsModel.fullName ?? "")
            : "Enter name";
    emailController.text =
        (userDetailsModel.email != null && userDetailsModel.email != "")
            ? (userDetailsModel.email ?? "")
            : "Enter email";
    phoneController.text =
        (userDetailsModel.phone != null && userDetailsModel.phone != "")
            ? (userDetailsModel.phone ?? "")
            : "Enter phone no.";
    addressController.text =
        (userDetailsModel.address != null && userDetailsModel.address != "")
            ? (userDetailsModel.address ?? "")
            : "Enter address";
    cityController.text =
        (userDetailsModel.city != null && userDetailsModel.city != "")
            ? (userDetailsModel.city ?? "")
            : "Enter city";
    stateController.text =
        (userDetailsModel.state != null && userDetailsModel.state != "")
            ? (userDetailsModel.state ?? "")
            : "Enter state";
    zipController.text =
        (userDetailsModel.zip != null && userDetailsModel.zip != "")
            ? (userDetailsModel.zip ?? "")
            : "Enter zip";
    passwordController.text = "123456";
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        onTap: () => Get.back(),
        title: 'Edit Account',
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        children: [
          pickProfileImage(context),
          // MyText(
          //   paddingTop: 15,
          //   paddingBottom: 40,
          //   align: TextAlign.center,
          //   text: 'Username',
          //   size: 20,
          //   weight: FontWeight.w600,
          //   color: kSecondaryColor,
          // ),
          SizedBox(
            height: 40,
          ),
          ETextField(
            labelText: 'Name:',
            // initialValue: 'current name',
            controller: nameController,
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Name',
                    selectedField: ETextField(
                      labelText: 'Name:',
                      controller: nameController,
                    ),
                    onSave: () async {
                      Get.dialog(loading());
                      try {
                        await myDoc.update({"fullName": nameController.text});
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Successfully updated name.",
                          context: context,
                        );
                      } catch (e) {
                        log("error in name updating: $e");
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Something went wrong. Please try again.",
                          bgColor: Colors.red,
                          context: context,
                        );
                      }
                    },
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          // SizedBox(
          //   height: 15,
          // ),
          // ETextField(
          //   labelText: 'Bio:',
          //   initialValue: 'Current Bio',
          //   isReadOnly: true,
          //   isEditAble: true,
          //   onEditTap: () {
          //     showModalBottomSheet(
          //       backgroundColor: Colors.transparent,
          //       elevation: 0,
          //       context: context,
          //       builder: (context) {
          //         return bottomSheetForEdit(
          //           context,
          //           title: 'Bio',
          //           selectedField: ETextField(
          //             labelText: 'Bio:',
          //           ),
          //           onSave: () {},
          //         );
          //       },
          //       isScrollControlled: true,
          //     );
          //   },
          // ),
          SizedBox(
            height: 15,
          ),
          // ETextField(
          //   labelText: 'Date of Birth:',
          //   initialValue: 'Current Date of Birth',
          //   // controller: dobController,
          //   isReadOnly: true,
          //   isEditAble: true,
          //   onEditTap: () {
          //     showModalBottomSheet(
          //       backgroundColor: Colors.transparent,
          //       elevation: 0,
          //       context: context,
          //       builder: (context) {
          //         return bottomSheetForEdit(
          //           context,
          //           title: 'Date of Birth',
          //           selectedField: ETextField(
          //             labelText: 'Date of Birth:',
          //             controller: dobController,
          //           ),
          //           onSave: () {},
          //         );
          //       },
          //       isScrollControlled: true,
          //     );
          //   },
          // ),
          // SizedBox(
          //   height: 15,
          // ),

          FutureBuilder<List<String>>(
            future:
                auth.fetchSignInMethodsForEmail(userDetailsModel.email ?? ""),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ETextField(
                  labelText: 'Email:',
                  // initialValue: 'Current Email',
                  controller: emailController,
                  isReadOnly: true,
                  isEditAble: false,
                  onEditTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      context: context,
                      builder: (context) {
                        return bottomSheetForEdit(
                          context,
                          title: 'Email',
                          selectedField: ETextField(
                            controller: emailController,
                            labelText: 'Email:',
                          ),
                          onSave: () {},
                        );
                      },
                      isScrollControlled: true,
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return ETextField(
                    labelText: 'Email:',
                    // initialValue: 'Current Email',
                    controller: emailController,
                    isReadOnly: true,
                    isEditAble: false,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return bottomSheetForEdit(
                            context,
                            title: 'Email',
                            selectedField: ETextField(
                              controller: emailController,
                              labelText: 'Email:',
                            ),
                            onSave: () {},
                          );
                        },
                        isScrollControlled: true,
                      );
                    },
                  );
                } else if (snapshot.hasData) {
                  log("list is: ${snapshot.data}");
                  List<String> signInMethodsList = snapshot.data ?? [];
                  return ETextField(
                    labelText: 'Email:',
                    // initialValue: 'Current Email',
                    controller: emailController,
                    isReadOnly: true,
                    isEditAble:
                        signInMethodsList.contains("password") ? true : false,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return passwordBottomSheetForEdit(
                            context,
                            title: 'Current Password',
                            selectedField: ETextField(
                              labelText: 'Current Password:',
                              controller: currentPasswordController,
                              isObSecure: true,
                            ),
                            onSave: () async {
                              Get.dialog(loading());
                              AuthCredential credential =
                                  EmailAuthProvider.credential(
                                      email: userDetailsModel.email ?? "",
                                      password: currentPasswordController.text);
                              try {
                                await auth.currentUser
                                    ?.reauthenticateWithCredential(credential)
                                    .then((value) {
                                  Get.back();
                                  Get.back();
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      context: context,
                                      builder: (context) {
                                        return bottomSheetForEdit(
                                          context,
                                          title: 'Email',
                                          selectedField: ETextField(
                                            controller: newEmailController,
                                            labelText: 'Email:',
                                          ),
                                          onSave: () async {
                                            Get.dialog(loading());
                                            await FirebaseAuth
                                                .instance.currentUser
                                                ?.updateEmail(
                                                    newEmailController.text)
                                                .then((value) async {
                                              Get.back();
                                              showMsg(
                                                msg:
                                                    "Email changed successfully. Please sign-in again.",
                                                bgColor: Colors.red,
                                                context: context,
                                              );
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () async {
                                                await auth.signOut();
                                                Get.offAll(() => SocialLogin());
                                              });
                                            });
                                          },
                                        );
                                      });
                                });
                              } on FirebaseAuthException catch (e) {
                                Get.back();
                                Get.back();
                                currentPasswordController.clear();
                                newEmailController.clear();
                                log("error in re-authentication is: ${e.message}");
                                showMsg(
                                  msg: "${e.message}",
                                  bgColor: Colors.red,
                                  context: context,
                                );
                              } catch (e) {
                                Get.back();
                                Get.back();
                                currentPasswordController.clear();
                                newEmailController.clear();
                                log("error in re-authentication is: $e");
                                showMsg(
                                  msg:
                                      "Something went wrong. Please try again in a few minutes.",
                                  bgColor: Colors.red,
                                  context: context,
                                );
                              }
                            },
                          );
                          //   bottomSheetForEdit(
                          //   context,
                          //   title: 'Email',
                          //   selectedField: ETextField(
                          //     controller: emailController,
                          //     labelText: 'Email:',
                          //   ),
                          //   onSave: () {},
                          // );
                        },
                        isScrollControlled: true,
                      );
                    },
                  );
                } else {
                  return ETextField(
                    labelText: 'Email:',
                    // initialValue: 'Current Email',
                    controller: emailController,
                    isReadOnly: true,
                    isEditAble: false,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return bottomSheetForEdit(
                            context,
                            title: 'Email',
                            selectedField: ETextField(
                              controller: emailController,
                              labelText: 'Email:',
                            ),
                            onSave: () {},
                          );
                        },
                        isScrollControlled: true,
                      );
                    },
                  );
                }
              } else {
                return ETextField(
                  labelText: 'Email:',
                  // initialValue: 'Current Email',
                  controller: emailController,
                  isReadOnly: true,
                  isEditAble: false,
                  onEditTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      context: context,
                      builder: (context) {
                        return bottomSheetForEdit(
                          context,
                          title: 'Email',
                          selectedField: ETextField(
                            controller: emailController,
                            labelText: 'Email:',
                          ),
                          onSave: () {},
                        );
                      },
                      isScrollControlled: true,
                    );
                  },
                );
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Phone:',
            // initialValue: 'Current Phone Number',
            controller: phoneController,
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Phone with country code +1',
                    selectedField: ETextField(
                      labelText: 'Phone:',
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                    ),
                    onSave: () async {
                      // Get.dialog(loading());
                      // //+ below code would be commented out when the navigation from this bottom sheet
                      // //+ to the otp verification page is fixed.
                      // try {
                      //   await myDoc.update({"phone": phoneController.text});
                      //   Get.back();
                      //   Get.back();
                      //   showMsg(
                      //     msg: "Successfully updated phone number.",
                      //     context: context,
                      //   );
                      // } catch (e) {
                      //   log("error in phome updating: $e");
                      //   Get.back();
                      //   Get.back();
                      //   showMsg(
                      //     msg: "Something went wrong. Please try again.",
                      //     bgColor: Colors.red,
                      //     context: context,
                      //   );
                      // }
                      //+ below code is for number verification but is commented due to navigation from bottomsheet issue.

                      try {
                        if (phoneController.text.trim().startsWith("+")) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return loading();
                            },
                          );
                          var twilioResponse = await twilioPhoneVerify
                              .sendSmsCode(phoneController.text.trim());
                          if (twilioResponse.successful!) {
                            Get.back();
                            Get.back();
                            Get.to(
                              () => EditProfileVerificationCode(
                                phoneNum: phoneController.text.trim(),
                              ),
                            );
                          } else {
                            Get.back();
                            log("error is: ${twilioResponse.errorMessage}");
                            showMsg(
                              bgColor: Colors.red,
                              context: context,
                              msg: 'Something went wrong!',
                            );
                          }
                        }
                        // showMsg(
                        //   msg: "Successfully updated phone number.",
                        //   context: context,
                        // );
                      } catch (e) {
                        log("error in phome updating: $e");
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Something went wrong. Please try again.",
                          bgColor: Colors.red,
                          context: context,
                        );
                      }
                    },
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Address:',
            // initialValue: 'Current Address',
            controller: addressController,
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Address',
                    selectedField: ETextField(
                      labelText: 'Address:',
                      controller: addressController,
                    ),
                    onSave: () async {
                      Get.dialog(loading());
                      try {
                        await myDoc.update({"address": addressController.text});
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Successfully updated address.",
                          context: context,
                        );
                      } catch (e) {
                        log("error in address updating: $e");
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Something went wrong. Please try again.",
                          bgColor: Colors.red,
                          context: context,
                        );
                      }
                    },
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'City:',
            // initialValue: 'Current Address',
            controller: cityController,
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'City',
                    selectedField: ETextField(
                      labelText: 'City:',
                      controller: cityController,
                    ),
                    onSave: () async {
                      Get.dialog(loading());
                      try {
                        await myDoc.update({"city": cityController.text});
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Successfully updated city.",
                          context: context,
                        );
                      } catch (e) {
                        log("error in city updating: $e");
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Something went wrong. Please try again.",
                          bgColor: Colors.red,
                          context: context,
                        );
                      }
                    },
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'State:',
            // initialValue: 'Current Address',
            controller: stateController,
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'State',
                    selectedField: ETextField(
                      labelText: 'State:',
                      controller: stateController,
                    ),
                    onSave: () async {
                      Get.dialog(loading());
                      try {
                        await myDoc.update({"state": stateController.text});
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Successfully updated state.",
                          context: context,
                        );
                      } catch (e) {
                        log("error in state updating: $e");
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Something went wrong. Please try again.",
                          bgColor: Colors.red,
                          context: context,
                        );
                      }
                    },
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Zip:',
            // initialValue: 'Current Address',
            controller: zipController,
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Zip',
                    selectedField: ETextField(
                      labelText: 'Zip:',
                      controller: zipController,
                      keyboardType: TextInputType.number,
                    ),
                    onSave: () async {
                      Get.dialog(loading());
                      try {
                        await myDoc.update({"zip": zipController.text});
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Successfully updated zip.",
                          context: context,
                        );
                      } catch (e) {
                        log("error in zip updating: $e");
                        Get.back();
                        Get.back();
                        showMsg(
                          msg: "Something went wrong. Please try again.",
                          bgColor: Colors.red,
                          context: context,
                        );
                      }
                    },
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          FutureBuilder<List<String>>(
            future:
                auth.fetchSignInMethodsForEmail(userDetailsModel.email ?? ""),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<String>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const SizedBox();
                } else if (snapshot.hasData) {
                  log("list is: ${snapshot.data}");
                  List<String> signInMethodsList = snapshot.data ?? [];
                  if (signInMethodsList.contains("password")) {
                    return ETextField(
                      labelText: 'Password:',
                      // initialValue: 'Current Password',
                      controller: passwordController,
                      isReadOnly: true,
                      isEditAble: true,
                      isObSecure: true,
                      onEditTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          context: context,
                          builder: (context) {
                            return passwordBottomSheetForEdit(
                              context,
                              title: 'Current Password',
                              selectedField: ETextField(
                                labelText: 'Current Password:',
                                controller: currentPasswordController,
                                isObSecure: true,
                              ),
                              onSave: () async {
                                Get.dialog(loading());
                                AuthCredential credential =
                                    EmailAuthProvider.credential(
                                        email: userDetailsModel.email ?? "",
                                        password:
                                            currentPasswordController.text);
                                try {
                                  await auth.currentUser
                                      ?.reauthenticateWithCredential(credential)
                                      .then((value) {
                                    Get.back();
                                    Get.back();
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        context: context,
                                        builder: (context) {
                                          return bottomSheetForEdit(
                                            context,
                                            title: 'Password',
                                            selectedField: ETextField(
                                              labelText: 'Password:',
                                              isObSecure: true,
                                              controller: newPasswordController,
                                            ),
                                            onSave: () async {
                                              Get.dialog(loading());
                                              await FirebaseAuth
                                                  .instance.currentUser
                                                  ?.updatePassword(
                                                      newPasswordController
                                                          .text)
                                                  .then((value) async {
                                                Get.back();
                                                showMsg(
                                                  msg:
                                                      "Password changed successfully. Please sign-in again.",
                                                  bgColor: Colors.red,
                                                  context: context,
                                                );
                                                Future.delayed(
                                                    Duration(seconds: 1),
                                                    () async {
                                                  await auth.signOut();
                                                  Get.offAll(
                                                      () => SocialLogin());
                                                });
                                              });
                                            },
                                          );
                                        });
                                  });
                                } on FirebaseAuthException catch (e) {
                                  Get.back();
                                  Get.back();
                                  currentPasswordController.clear();
                                  newPasswordController.clear();
                                  log("error in re-authentication is: ${e.message}");
                                  showMsg(
                                    msg: "${e.message}",
                                    bgColor: Colors.red,
                                    context: context,
                                  );
                                } catch (e) {
                                  Get.back();
                                  Get.back();
                                  currentPasswordController.clear();
                                  newPasswordController.clear();
                                  log("error in re-authentication is: $e");
                                  showMsg(
                                    msg:
                                        "Something went wrong. Please try again in a few minutes.",
                                    bgColor: Colors.red,
                                    context: context,
                                  );
                                }
                              },
                            );
                            /**/
                            //   bottomSheetForEdit(
                            //   context,
                            //   title: 'Password',
                            //   selectedField: ETextField(
                            //     labelText: 'Password:',
                            //     controller: currentPasswordController,
                            //   ),
                            //   onSave: () {},
                            // );
                          },
                          isScrollControlled: true,
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget passwordBottomSheetForEdit(
    BuildContext context, {
    String? title,
    Widget? selectedField,
    VoidCallback? onSave,
  }) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Expanded(
                child: MyText(
                  text:
                      'Please enter current password to re-authenticate as this is a security sensitive operation',
                  size: 14,
                  color: kSecondaryColor,
                  maxLines: 3,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  Assets.imagesRoundedClose,
                  height: 22.44,
                ),
              ),
            ],
          ),
          selectedField!,
          MyButton(
            onTap: onSave,
            buttonText: 'Re-authenticate',
          ),
        ],
      ),
    );
  }

  File? pickedImage;
  RxString pickedImagePath = "".obs;
  String pickedImageUrl = "";

  Widget pickProfileImage(BuildContext context) {
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
                    onTap: () => pickImage(
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
                    onTap: () => pickImage(
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
                child: Obx(() {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: pickedImagePath.value == "" &&
                            userDetailsModel.profileImageUrl == ""
                        ? Image.asset(
                            Assets.imagesProfileAvatar,
                            height: height(context, 1.0),
                            width: width(context, 1.0),
                            fit: BoxFit.cover,
                          )
                        : userDetailsModel.profileImageUrl != "" &&
                                pickedImagePath.value == ""
                            ? Image.network(
                                userDetailsModel.profileImageUrl!,
                                height: height(context, 1.0),
                                width: width(context, 1.0),
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                pickedImage!,
                                height: height(context, 1.0),
                                width: width(context, 1.0),
                                fit: BoxFit.cover,
                              ),
                  );
                }),
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

  Future pickImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final img = await ImagePicker().pickImage(
        source: source,
      );
      if (img == null)
        return;
      else {
        pickedImage = File(img.path);
        pickedImagePath.value = img.path;
        Get.back();
        Get.dialog(loading());
        try {
          await uploadPhoto();
          Get.back();
        } catch (e) {
          Get.back();
          log("problem in image update is:$e");
          showMsg(
            msg: "Something went wrong. Please try again in a few minutes.",
            bgColor: Colors.red,
            context: context,
          );
        }
      }
    } on PlatformException catch (e) {
      showMsg(
        msg: e.message,
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  Future uploadPhoto() async {
    Reference ref = await FirebaseStorage.instance
        .ref()
        .child('Images/Profile Images/${DateTime.now().toString()}');
    await ref.putFile(pickedImage!);
    await ref.getDownloadURL().then((value) async {
      log('Profile Image URL $value');
      pickedImageUrl = value;
      await accounts
          .doc(auth.currentUser?.uid ?? "")
          .update({"profileImageUrl": pickedImageUrl}).then((value) {
        showMsg(context: context, msg: "Profile image updated successfully.");
      });
    });
  }

// Widget pickProfileImage(
//   BuildContext context,
// ) {
//   return Center(
//     child: Stack(
//       children: [
//         Container(
//           height: 128,
//           width: 128,
//           padding: EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             color: kPrimaryColor,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: kBlackColor.withOpacity(0.16),
//                 blurRadius: 6,
//                 offset: Offset(0, 0),
//               ),
//             ],
//           ),
//           child: Center(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(100),
//               child: Image.asset(
//                 Assets.imagesDummyProfileImage,
//                 height: height(context, 1.0),
//                 width: width(context, 1.0),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           child: Image.asset(
//             Assets.imagesAdd,
//             height: 37.22,
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
