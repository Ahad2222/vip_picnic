import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find<HomeController>();
  late final TextEditingController descriptionCon;
  late final TextEditingController tagCon;
  late final TextEditingController locationCon;

  List<String> imagesToUpload = [];
  DateTime createdAt = DateTime.now();
  DateFormat? format;
  List<String> taggedPeople = [];
  List<String> taggedPeopleToken = [];
  int? commentCount;
  int? likeCount;
  int? shareCount;
  RxList selectedImages = [].obs;
  final pageController = PageController();
  RxInt currentPost = 0.obs;

  void getCurrentPostIndex(int index) {
    currentPost.value = index;
    update();
  }

  Future pickImages(
    BuildContext context,
  ) async {
    try {
      List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images != null) {
        selectedImages.value = images;
      } else {
        return [].obs;
      }
      update();
    } on PlatformException catch (e) {
      showMsg(
        msg: e.message,
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  Future uploadPost(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loading();
      },
    );
    if (selectedImages.isNotEmpty || descriptionCon.text.isNotEmpty) {
      var postID = Uuid().v1();
      try {
        await uploadAllImages();
        log('Images UPLOADED!');
        addPostModel = AddPostModel(
          postID: postID,
          uID: userDetailsModel.uID,
          postBy: userDetailsModel.fullName,
          profileImage: userDetailsModel.profileImageUrl,
          postImages: imagesToUpload,
          postTitle: descriptionCon.text.trim(),
          taggedPeople: taggedPeople,
          taggedPeopleToken: taggedPeopleToken,
          location: locationCon.text.trim(),
          createdAt: DateFormat.yMEd().add_jms().format(createdAt).toString(),
          createdAtMilliSeconds: DateTime.now().millisecondsSinceEpoch,
          likeIDs: [],
          likeCount: 0,
          commentCount: 0,
          shareCount: 0,
        );
        log('Data assigned to POST MODEL CLASS!');
        await posts.doc(postID).set(addPostModel.toJson()).then(
          (value) {
            log('Data set to FIREBASE!');
            selectedImages = [].obs;
            imagesToUpload = [];
            descriptionCon.clear();
            tagCon.clear();
            locationCon.clear();
            taggedPeople = [];
            log('CLEAR');
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
            update();
          },
        );
      } on FirebaseException catch (e) {
        showMsg(
          msg: e.message,
          bgColor: Colors.red,
          context: context,
        );
      }
    } else {
      showMsg(
        msg: 'Invalid Post!',
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  Future<List<String>> uploadAllImages() async {
    for (int i = 0; i < selectedImages.length; i++) {
      imagesToUpload.add(
        await uploadSingleImage(selectedImages[i]),
      );
    }
    return imagesToUpload;
  }

  Future uploadSingleImage(XFile image) async {
    Reference ref = await fstorage.ref().child(
          'postImages/images/${DateTime.now().toString()}',
        );
    await ref.putFile(
      File(image.path),
    );
    return ref.getDownloadURL();
  }

  void removeImage(int index) {
    selectedImages.removeWhere(
      (element) => element.path == selectedImages[index].path,
    );
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    descriptionCon = TextEditingController();
    tagCon = TextEditingController();
    locationCon = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    descriptionCon.dispose();
    tagCon.dispose();
    locationCon.dispose();
  }
}
