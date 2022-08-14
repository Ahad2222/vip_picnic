import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/get_storage_data/get_storage_data.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class EmailAuthController extends GetxController {
  static EmailAuthController instance = Get.find<EmailAuthController>();
  RxBool? isKeepMeLoggedIn = false.obs;
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
            await accounts.doc(fa.currentUser!.uid).get().then(
              (value) async {
                userDetailsModel = UserDetailsModel.fromJson(value.data() as Map<String, dynamic>);
              },
            );
            await UserSimplePreference.setUserData(userDetailsModel);

            if(auth.currentUser != null){
              String? token = await fcm.getToken() ?? userDetailsModel.fcmToken;
              try {
                fs.collection("Accounts").doc(auth.currentUser?.uid).update({
                  "fcmToken": token,
                  "fcmCreatedAt": DateTime.now().toIso8601String(),
                });
              } catch (e) {
                print(e);
                log("error in updating fcmToken in my own collection $e");
              }
              fcm.onTokenRefresh.listen((streamedToken) {
                try {
                  fs.collection("Accounts").doc(auth.currentUser?.uid).update({
                    "fcmToken": streamedToken,
                    "fcmCreatedAt": DateTime.now().toIso8601String(),
                  });
                } catch (e) {
                  print(e);
                  log("error in updating fcmToken in my own collection on change $e");
                }
              });
            }
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
    isKeepMeLoggedIn!.value = !isKeepMeLoggedIn!.value;
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
