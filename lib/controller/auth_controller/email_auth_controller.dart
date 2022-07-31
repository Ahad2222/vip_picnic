import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class EmailAuthController extends GetxController {
  // static LoginWithEmailController instance = Get.find();
  bool isKeepMeLoggedIn = false;
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future login(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      formKey.currentState!.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loading();
        },
      );

      try {
        await _auth
            .signInWithEmailAndPassword(
          email: emailCon.text.trim(),
          password: passCon.text.trim(),
        )
            .then(
          (value) {
            emailCon.clear();
            passCon.clear();
          },
        ).then(
          (value) {
            Get.offAll(() => BottomNavBar());
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

  void yesKeepLoggedIn() {
    isKeepMeLoggedIn = !isKeepMeLoggedIn;
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailCon.dispose();
    passCon.dispose();
  }
}
