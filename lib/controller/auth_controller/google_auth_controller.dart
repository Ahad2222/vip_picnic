import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class GoogleAuthController extends GetxController {
  DateTime createdAt = DateTime.now();
  DateFormat? format;

  Future googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? gAuth =
          await googleUser?.authentication;

      if (gAuth!.accessToken != null || gAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('Private Accounts')
                .doc(userCredential.user!.email)
                .set(
              {
                'profileImageUrl': userCredential.user!.photoURL,
                'fullName': userCredential.user!.displayName,
                'email': userCredential.user!.email,
                'accountType': 'Private',
                'createdAt':
                    DateFormat.yMEd().add_jms().format(createdAt).toString(),
              },
            ).then(
              (value) {
                Get.offAll(
                  () => BottomNavBar(),
                );
              },
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
