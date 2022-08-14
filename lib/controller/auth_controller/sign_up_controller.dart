import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vip_picnic/get_storage_data/get_storage_data.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class SignupController extends GetxController {
  static SignupController instance = Get.find<SignupController>();
  late final TextEditingController fullNameCon;
  late final TextEditingController phoneCon;
  late final TextEditingController emailCon;
  late final TextEditingController passCon;
  late final TextEditingController cityCon;
  late final TextEditingController stateCon;
  late final TextEditingController zipCon;
  late final TextEditingController addressCon;
  String? profileImage = '';
  String? accountType = '';
  RxInt? selectedAccountTypeIndex = 0.obs;
  DateTime createdAt = DateTime.now();
  DateFormat? format;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? pickedImage;

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
    Reference ref = await FirebaseStorage.instance.ref().child('Images/Profile Images/${DateTime.now().toString()}');
    await ref.putFile(pickedImage!);
    ref.getDownloadURL().then((value) {
      log('Profile Image URL $value');
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
        await uploadPhoto();
        await fa
            .createUserWithEmailAndPassword(
          email: emailCon.text.trim(),
          password: passCon.text.trim(),
        )
            .then((value) async {
          userDetailsModel = UserDetailsModel(
            profileImageUrl: profileImage,
            fullName: fullNameCon.text.trim(),
            email: emailCon.text.trim(),
            uID: fa.currentUser!.uid,
            password: passCon.text.trim(),
            phone: phoneCon.text.trim(),
            city: cityCon.text.trim(),
            state: stateCon.text.trim(),
            zip: zipCon.text.trim(),
            address: addressCon.text.trim(),
            accountType: accountType,
            createdAt: DateFormat.yMEd().add_jms().format(createdAt).toString(),
          );
          await accounts.doc(fa.currentUser!.uid).set(userDetailsModel.toJson());
        }).then(
          (value) async {
            await UserSimplePreference.setUserData(userDetailsModel);
            // await UserSimplePreference.setProfileImageUrl(profileImage!);
            // await UserSimplePreference.setFullName(fullNameCon.text.trim());
            // await UserSimplePreference.setEmail(emailCon.text.trim());
            // await UserSimplePreference.setUID(fa.currentUser!.uid);
            // await UserSimplePreference.setPassword(passCon.text.trim());
            // await UserSimplePreference.setPhoneNumber(phoneCon.text.trim());
            // await UserSimplePreference.setCity(cityCon.text.trim());
            // await UserSimplePreference.setState(stateCon.text.trim());
            // await UserSimplePreference.setZip(zipCon.text.trim());
            // await UserSimplePreference.setAddress(addressCon.text.trim());
            // await UserSimplePreference.setAccountType(accountType!);
            // await UserSimplePreference.setCreatedAt(
            //   DateFormat.yMEd().add_jms().format(createdAt).toString(),
            // );
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
              () => BottomNavBar(),
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
    selectedAccountTypeIndex!.value = index;
    accountType = type;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fullNameCon = TextEditingController();
    phoneCon = TextEditingController();
    emailCon = TextEditingController();
    passCon = TextEditingController();
    cityCon = TextEditingController();
    stateCon = TextEditingController();
    zipCon = TextEditingController();
    addressCon = TextEditingController();
  }

  @override
  void onClose() {
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
