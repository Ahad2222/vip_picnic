import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/view/user/login.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class SignupController extends GetxController {
  // static SignupController instance = Get.find();
  final fullNameCon = TextEditingController();
  final phoneCon = TextEditingController();
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  final cityCon = TextEditingController();
  final stateCon = TextEditingController();
  final zipCon = TextEditingController();
  final addressCon = TextEditingController();
  String? profileImage = '';
  String? accountType = '';
  int? selectedAccountTypeIndex;
  DateTime createdAt = DateTime.now();
  DateFormat? format;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? pickedImage;

  Future pickImage(BuildContext context, bool isGallery) async {
    try {
      final img = await ImagePicker().pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera,
        maxWidth: 525,
        maxHeight: 525,
        imageQuality: 75,
      );
      if (img == null)
        return;
      else {
        pickedImage = File(img.path);
        Get.back();
        update();
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
        .child('ProfileImages/${pickedImage!.path}');
    await ref.putFile(pickedImage!);
    ref.getDownloadURL().then((value) {
      profileImage = value;
      update();
    });
  }

  Future signup(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else if (accountType!.isEmpty) {
      showMsg(
        msg: 'Please select account type!',
        bgColor: Colors.red,
        context: context,
      );
    } else if (pickedImage == null) {
      showMsg(
        msg: 'Please upload a photo!',
        bgColor: Colors.red,
        context: context,
      );
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
        uploadPhoto();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailCon.text.trim(),
              password: passCon.text.trim(),
            )
            .then(
              (value) => FirebaseFirestore.instance
                  .collection('${accountType!} Accounts')
                  .doc(emailCon.text.trim())
                  .set(
                {
                  'profileImageUrl': profileImage,
                  'fullName': fullNameCon.text.trim(),
                  'email': emailCon.text.trim(),
                  'password': passCon.text.trim(),
                  'phone': phoneCon.text.trim(),
                  'city': cityCon.text.trim(),
                  'state': stateCon.text.trim(),
                  'zip': zipCon.text.trim(),
                  'address': addressCon.text.trim(),
                  'accountType': accountType,
                  'createdAt':
                      DateFormat.yMEd().add_jms().format(createdAt).toString(),
                },
              ),
            )
            .then(
          (value) {
            profileImage = '';
            fullNameCon.clear();
            phoneCon.clear();
            emailCon.clear();
            passCon.clear();
            cityCon.clear();
            stateCon.clear();
            zipCon.clear();
            addressCon.clear();
            accountType = '';
            Get.offAll(
              () => Login(),
            );
            navigatorKey.currentState!.popUntil((route) => route.isCurrent);
          },
        );
      } on FirebaseAuthException catch (e) {
        showMsg(
          msg: e.message.toString(),
          bgColor: Colors.red,
          context: context,
        );
        navigatorKey.currentState!.pop();
      }
    }
  }

  void signupAccountType(
    String type,
    int index,
  ) {
    selectedAccountTypeIndex = index;
    accountType = type;
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    fullNameCon.dispose();
    phoneCon.dispose();
    emailCon.dispose();
    passCon.dispose();
    cityCon.dispose();
    stateCon.dispose();
    zipCon.dispose();
    addressCon.dispose();
  }
}
