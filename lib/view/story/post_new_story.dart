import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/story_model/story_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

// ignore: must_be_immutable
class PostNewStory extends StatelessWidget {
  // bool? isMediaPicked = false;
  // String? pickedImage = '';
  TextEditingController descriptionController = TextEditingController();

  File? pickedImage;
  RxString pickedImagePath = "".obs;
  String storyImageUrl = "";

  Future pickImage(BuildContext context, ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(
        source: source,
      );
      if (img == null)
        return;
      else {
        pickedImage = File(img.path);
        pickedImagePath.value = img.path;
        Get.back();
        // update();
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
    Reference ref = await FirebaseStorage.instance.ref().child('Images/Story Images/${DateTime.now().toString()}');
    await ref.putFile(pickedImage!);
    await ref.getDownloadURL().then((value) {
      log('Story Image URL $value');
      storyImageUrl = value;
      // update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(
        title: 'Post New Story',
        onTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kLightBlueColor,
                  ),
                  child: Center(
                    child: Obx(() {
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ListTile(
                                      onTap: () =>
                                          pickImage(
                                            context,
                                            ImageSource.camera,
                                          ),
                                      leading: Image.asset(
                                        Assets.imagesCamera,
                                        color: kGreyColor,
                                        height: 35,
                                      ),
                                      title: MyText(
                                        text: 'Camera',
                                        size: 20,
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () =>
                                          pickImage(
                                            context,
                                            ImageSource.gallery,
                                          ),
                                      leading: Image.asset(
                                        Assets.imagesGallery,
                                        height: 35,
                                        color: kGreyColor,
                                      ),
                                      title: MyText(
                                        text: 'Gallery',
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            isScrollControlled: true,
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: pickedImagePath.value != ""
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            pickedImage!,
                            height: height(context, 1.0),
                            width: width(context, 1.0),
                            fit: BoxFit.cover,
                          ),
                        )
                            : Image.asset(
                          Assets.imagesUploadPicture,
                          height: 108.9,
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Description...',
                  maxLines: 6,
                  controller: descriptionController,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: MyButton(
              onTap: () async {
                //+ code to add the post to firestore goes here
                loading(); //+ not showing up and at the end ther is no feedback
                if (pickedImagePath.value != "" && pickedImage != null) {
                  await uploadPhoto();
                }
                if (pickedImagePath.value != "" || descriptionController.text.trim() != "") {
                  String mediaType = "";
                  if (pickedImagePath.value != "" && descriptionController.text.trim() != "") {
                    mediaType = "ImageWithCaption";
                  } else if (pickedImagePath.value != "") {
                    mediaType = "Image";
                  } else if (descriptionController.text.trim() != "") {
                    mediaType = "Caption";
                  }
                  StoryModel storyModel = StoryModel(
                    createdAt: DateTime
                        .now()
                        .millisecondsSinceEpoch,
                    mediaType: mediaType,
                    storyImage: storyImageUrl,
                    storyPersonId: userDetailsModel.uID,
                    storyPersonImage: userDetailsModel.profileImageUrl,
                    storyPersonName: userDetailsModel.fullName,
                    storyText: descriptionController.text.trim(),
                  );
                  await ffstore.collection(storyCollection).add(storyModel.toJson());
                  Navigator.pop(context);
                  Get.back();
                }
              },
              buttonText: 'post',
            ),
          ),
        ],
      ),
    );
  }
}
