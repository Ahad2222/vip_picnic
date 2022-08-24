import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:vip_picnic/get_storage_data/get_storage_data.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class GoogleAuthController extends GetxController {
  static GoogleAuthController instance = Get.find<GoogleAuthController>();

  List<String> userSearchParameters = [];

  DateTime createdAt = DateTime.now();
  DateFormat? format;

  Future googleSignIn(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loading();
        },
      );
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? gAuth =
          await googleUser?.authentication;

      if (gAuth!.accessToken != null || gAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );
        UserCredential userCredential =
            await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            int emailLength = userCredential.user?.email?.length ?? 0;
            String email = userCredential.user?.email ?? "";
            for (int i = 0; i < emailLength; i++) {
              if (email[i] != " ") {
                userSearchParameters.add(email[i]);
                var wordUntil = email.substring(0, i+1);
                log("wordUntil: $wordUntil");
                userSearchParameters.add(wordUntil);
              }
            }
            String? token = await fcm.getToken();
            userDetailsModel = UserDetailsModel(
              uID: userCredential.user!.uid,
              profileImageUrl: userCredential.user!.photoURL,
              fullName: userCredential.user!.displayName,
              email: userCredential.user!.email,
              accountType: 'Private',
              iFollowed: [],
              TheyFollowed: [],
              userSearchParameters: userSearchParameters,
              fcmToken: token,
              fcmCreatedAt: DateTime.now(),
              address: "",
              city: "",
              password: "",
              phone: "",
              state: "",
              zip: "",
              createdAt:
                  DateFormat.yMEd().add_jms().format(createdAt).toString(),
            );
            await accounts.doc(userCredential.user!.uid).set(
                  userDetailsModel.toJson(),
                );
            await UserSimplePreference.setUserData(userDetailsModel);
            if(auth.currentUser != null){
              String? token = await fcm.getToken() ?? userDetailsModel.fcmToken;
              try {
                ffstore.collection("Accounts").doc(auth.currentUser?.uid).update({
                  "fcmToken": token,
                  "fcmCreatedAt": DateTime.now().toIso8601String(),
                });
              } catch (e) {
                print(e);
                log("error in updating fcmToken in my own collection $e");
              }
              fcm.onTokenRefresh.listen((streamedToken) {
                try {
                  ffstore.collection("Accounts").doc(auth.currentUser?.uid).update({
                    "fcmToken": streamedToken,
                    "fcmCreatedAt": DateTime.now().toIso8601String(),
                  });
                } catch (e) {
                  print(e);
                  log("error in updating fcmToken in my own collection on change $e");
                }
              });
            }
            Get.offAll(
              () => BottomNavBar(),
            );
            navigatorKey.currentState!.popUntil((route) => route.isCurrent);
          } else {
            await accounts.doc(userCredential.user!.uid).get().then(
              (value) async {
                userDetailsModel = UserDetailsModel.fromJson(
                  value.data() as Map<String, dynamic>,
                );
              },
            );
            await UserSimplePreference.setUserData(userDetailsModel);
            if(auth.currentUser != null){
              String? token = await fcm.getToken() ?? userDetailsModel.fcmToken;
              try {
                ffstore.collection("Accounts").doc(auth.currentUser?.uid).update({
                  "fcmToken": token,
                  "fcmCreatedAt": DateTime.now().toIso8601String(),
                });
              } catch (e) {
                print(e);
                log("error in updating fcmToken in my own collection $e");
              }
              fcm.onTokenRefresh.listen((streamedToken) {
                try {
                  ffstore.collection("Accounts").doc(auth.currentUser?.uid).update({
                    "fcmToken": streamedToken,
                    "fcmCreatedAt": DateTime.now().toIso8601String(),
                  });
                } catch (e) {
                  print(e);
                  log("error in updating fcmToken in my own collection on change $e");
                }
              });
            }
            Get.offAll(
              () => BottomNavBar(),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showMsg(
        context: context,
        msg: e.message,
        bgColor: Colors.red,
      );
    }
  }
}
