import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/view/user/login.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController instance =
      Get.find<ForgotPasswordController>();
  late final TextEditingController emailCon;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future resetPassword(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loading();
        },
      );
      try {
        formKey.currentState!.save();
        await fa
            .sendPasswordResetEmail(
          email: emailCon.text.trim(),
        )
            .then(
          (value) {
            emailCon.clear();
            showMsg(
              msg: 'Reset password email sent!',
              bgColor: Colors.green,
              context: context,
            );
            Get.offAll(
              () => Login(),
            );
            navigatorKey.currentState!.popUntil(
              (route) => route.isFirst,
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        showMsg(
          msg: e.message,
          bgColor: Colors.red,
          context: context,
        );
        navigatorKey.currentState!.pop();
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailCon = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailCon.dispose();
  }
}
