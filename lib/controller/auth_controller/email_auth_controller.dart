import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class EmailAuthController extends GetxController {
  // static LoginWithEmailController instance = Get.find();
  RxBool isKeepMeLoggedIn = false.obs;
  late final TextEditingController emailCon;
  late final TextEditingController passCon;

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
        await fa
            .signInWithEmailAndPassword(
          email: emailCon.text.trim(),
          password: passCon.text.trim(),
        )
            .then(
          (value) async {
            await privateAccCol.doc(fa.currentUser!.uid).get().then(
              (value) async {
                if (value.exists) {
                  userDetailsModel = UserDetailsModel.fromJson(
                    value.data() as Map<String, dynamic>,
                  );
                } else {
                  await businessAccCol.doc(fa.currentUser!.uid).get().then(
                    (value) {
                      if (value.exists) {
                        userDetailsModel = UserDetailsModel.fromJson(
                          value.data() as Map<String, dynamic>,
                        );
                      } else {
                        log('No Record Found!');
                      }
                    },
                  );
                }
              },
            );
            emailCon.clear();
            passCon.clear();
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
    isKeepMeLoggedIn.value = !isKeepMeLoggedIn.value;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    emailCon = TextEditingController();
    passCon = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailCon.dispose();
    passCon.dispose();
  }
}
