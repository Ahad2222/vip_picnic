import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/get_storage_data/get_storage_data.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/model/facebook_user_data_model/facebook_user_data_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/user/social_login.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class AppleAuthController extends GetxController {
  static AppleAuthController instance = Get.find<AppleAuthController>();

  List<String> userSearchParameters = [];

  DateTime createdAt = DateTime.now();
  DateFormat? format;


  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }
  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future appleSignIn(BuildContext context) async {
    String userName = "";
    String userEmail = "";
    try {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) {
      //     return loading();
      //   },
      // );
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      print("apple cred email is: ${appleCredential.email}");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loading();
        },
      );
      if(appleCredential.email != null){
        //this means that he signed up for the very first time.
        await UserSimplePreference.setIsAppleSignedInBefore(true);
        userName = "${appleCredential.givenName ?? ""} ${appleCredential.familyName ?? ""}";
        await UserSimplePreference.setAppleName("${appleCredential.givenName ?? ""} ${appleCredential.familyName ?? ""}");
        userEmail = appleCredential.email ?? "";
        await UserSimplePreference.setAppleEmail(appleCredential.email ?? "");
      }else{
        await UserSimplePreference.getIsAppleSignedInBeforel();
        userName = await UserSimplePreference.getAppleName() ?? "";
        userEmail = await UserSimplePreference.getAppleEmail() ?? "";
      }
      print("apple cred email is: ${appleCredential.familyName}");
      print("apple cred email is: ${appleCredential.givenName}");
      print("apple cred email is: ${appleCredential}");
      print("fetched name is: ${userName}");
      print("fetched email is: ${userEmail}");

      //lutter: apple cred email is:
      // AuthorizationAppleID(000702.0373124daad548d8b2d8f2c5d7b2aea8.0717, Faiz, Yab, yabi.faiz@gmail.com, null)
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.

      List<String> signInMethodsForFaceEmail = await auth.fetchSignInMethodsForEmail(userEmail);
      print("signInMethodsForFaceEmail: ${signInMethodsForFaceEmail}");
      bool isNewUser = signInMethodsForFaceEmail.isEmpty;
      print("isNewUser: ${isNewUser}");

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      //credential.user are: User(
      // displayName: null,
      // email: b8gkcj669y@privaterelay.appleid.com,
      // emailVerified: true,
      // isAnonymous: false,
      // metadata: UserMetadata(
      // creationTime: 2022-09-11 13:31:59.362,
      // lastSignInTime: 2022-09-11 13:39:11.205),
      // phoneNumber: null,
      // photoURL: null,
      // providerData,
      // [UserInfo(
      //   displayName: null,
      //   email: b8gkcj669y@privaterelay.appleid.com,
      //   phoneNumber: null,
      //   photoURL: null,
      //   providerId: apple.com,
      //   uid: 000702.0373124daad548d8b2d8f2c5d7b2aea8.0717)], refreshToken: , tenantId: null, uid: zGTVFteb3aUTuhfPktKirwqaqvg2)
      print("credential.user are: ${userCredential.user} \n");
      print("credential.user.toString are: ${userCredential.user.toString()} \n");
      print("credential.user?.providerData are: ${userCredential.user?.providerData} \n");
      print("credential.user?.metadata are: ${userCredential.user?.metadata} \n");
      print("credential.user?.metadata are: ${userCredential.user?.metadata} \n");

      // final LoginResult result = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly); // by default we request the email and the public profile
      // // if (result.status == LoginStatus.success) {
      //
      //   final AccessToken accessToken = result.accessToken!;
      //   log("accessToken.token: ${accessToken.token} and "
      //       "\n accessToken.grantedPermissions: ${accessToken.grantedPermissions}"
      //       "\n accessToken.applicationId: ${accessToken.applicationId}"
      //       "\n accessToken.expires: ${accessToken.expires}"
      //       "\n accessToken.lastRefresh: ${accessToken.lastRefresh}"
      //       "\n accessToken.toJson: ${accessToken.toJson()}"
      //       "");
      /**/
      //   if (accessToken.token != "") {
      //
      //     final userData = await FacebookAuth.instance.getUserData();
      //     FacebookUserDataModel facebookUserDataModel = FacebookUserDataModel.fromJson(userData);
      //     log("userData from faceBook: ${facebookUserDataModel.toJson()} ");

          print("auth.currentUser?.uid: ${auth.currentUser?.uid}");
      //
      //     final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);
      //
      //     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      //
      //     log("credential.user are: ${userCredential.user} \n");
      //     log("credential.user.toString are: ${userCredential.user.toString()} \n");
      //     log("credential.user?.providerData are: ${userCredential.user?.providerData} \n");
      //     log("credential.user?.metadata are: ${userCredential.user?.metadata} \n");
      //     log("credential.user?.metadata are: ${userCredential.user?.metadata} \n");
          /**/
          if (userCredential.user != {} && userCredential.user != null) {
            try {
              await ffstore.collection(deactivatedCollection).doc(auth.currentUser?.uid).get().then((value) async {
                if (!value.exists) {
                  if (isNewUser) {
                    int emailLength = userEmail.length;
                    String email = userEmail;
                    for (int i = 0; i < emailLength; i++) {
                      if (email[i] != " ") {
                        userSearchParameters.add(email[i]);
                        var wordUntil = email.substring(0, i + 1);
                        print("wordUntil: $wordUntil");
                        userSearchParameters.add(wordUntil);
                      }
                    }
                    String? token = await fcm.getToken();
                    userDetailsModel = UserDetailsModel(
                      uID: userCredential.user?.uid ?? "",
                      profileImageUrl: userCredential.user?.photoURL ?? "",
                      fullName: userName,
                      email: (userEmail != "") ? userEmail : userCredential.user?.email,
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
                      createdAt: DateFormat.yMEd().add_jms().format(createdAt).toString(),
                    );
                    await accounts.doc(userCredential.user!.uid).set(
                      userDetailsModel.toJson(),
                    );
                    await UserSimplePreference.setUserData(userDetailsModel);
                    if (auth.currentUser != null) {
                      String? token = await fcm.getToken() ?? userDetailsModel.fcmToken;
                      try {
                        ffstore.collection(accountsCollection).doc(auth.currentUser?.uid).update({
                          "fcmToken": token,
                          "fcmCreatedAt": DateTime.now().toIso8601String(),
                        });
                      } catch (e) {
                        print(e);
                        print("error in updating fcmToken in my own collection $e");
                      }
                      fcm.onTokenRefresh.listen((streamedToken) {
                        try {
                          ffstore.collection(accountsCollection).doc(auth.currentUser?.uid).update({
                            "fcmToken": streamedToken,
                            "fcmCreatedAt": DateTime.now().toIso8601String(),
                          });
                        } catch (e) {
                          print(e);
                          print("error in updating fcmToken in my own collection on change $e");
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
                    if (auth.currentUser != null) {
                      String? token = await fcm.getToken() ?? userDetailsModel.fcmToken;
                      try {
                        ffstore.collection(accountsCollection).doc(auth.currentUser?.uid).update({
                          "fcmToken": token,
                          "fcmCreatedAt": DateTime.now().toIso8601String(),
                        });
                      } catch (e) {
                        print(e);
                        print("error in updating fcmToken in my own collection $e");
                      }
                      fcm.onTokenRefresh.listen((streamedToken) {
                        try {
                          ffstore.collection(accountsCollection).doc(auth.currentUser?.uid).update({
                            "fcmToken": streamedToken,
                            "fcmCreatedAt": DateTime.now().toIso8601String(),
                          });
                        } catch (e) {
                          print(e);
                          print("error in updating fcmToken in my own collection on change $e");
                        }
                      });
                    }
                    Get.offAll(
                          () => BottomNavBar(),
                    );
                  }
                } else {
                  await FacebookAuth.instance.logOut();
                  showMsg(context: context, msg: "Your account is deactivated. Please contact support to activate it again.");
                  Future.delayed(Duration(seconds: 2), () {
                    Get.offAll(() => SocialLogin());
                  });
                }
              });
            } catch (e) {
              Get.back();
              print("Error in checking whether the account is deactivated or not is: $e");
              await FacebookAuth.instance.logOut();
              showMsg(context: context, msg: "Something went wrong during de-activation. Please try again.");
              Future.delayed(Duration(seconds: 2), () {
                Get.offAll(() => SocialLogin());
              });
            }
          } else {
            Get.back();
            showMsg(
              context: context,
              msg: "Something went wrong. Please try again",
              bgColor: Colors.red,
            );
            // print(result.status);
            // print(result.message);
          }
      /**/
        // }
      // } else {
      //   Get.back();
      //   print(result.status);
      //   print(result.message);
      // }

      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // final GoogleSignInAuthentication? gAuth = await googleUser?.authentication;


    } on FirebaseAuthException catch (e) {
      Get.back();
      showMsg(
        context: context,
        msg: e.message,
        bgColor: Colors.red,
      );
    }
  }

}
