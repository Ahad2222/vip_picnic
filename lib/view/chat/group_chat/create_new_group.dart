import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class CreateNewGroup extends StatelessWidget {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  List<String> userIds = [];
  RxList<Map<String, dynamic>> selectedUsers = List<Map<String, dynamic>>.from([]).obs;

  String? groupImage = '';
  File? pickedImage;

  Future pickImage(BuildContext context, ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(
        source: source,
      );
      if (img == null)
        return;
      else {
        pickedImage = File(img.path);
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
    Reference ref = await FirebaseStorage.instance.ref().child('Images/Profile Images/${DateTime.now().toString()}');
    await ref.putFile(pickedImage!);
    await ref.getDownloadURL().then((value) {
      log('Profile Image URL $value');
      groupImage = value;
      // update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(
        title: 'New Group',
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
              ),
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kLightBlueColor,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        //+image adding code
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
                                    onTap: () => pickImage(
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
                                    onTap: () => pickImage(
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
                      child: Image.asset(
                        Assets.imagesUploadPicture,
                        height: 108.9,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Group Name',
                  maxLines: 1,
                  controller: groupNameController,
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Description...',
                  maxLines: 6,
                  controller: groupDescriptionController,
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Type Username to add...',
                  onChanged: (value) {
                    groupChatController.userSearchText.value = value;
                  },
                ),
                Obx(() {
                  return Wrap(
                    children: List.generate(selectedUsers.length, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Text("${selectedUsers[index]["name"]}"),
                      );
                    }),
                  );
                }),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: MyButton(
              onTap: () {
                groupChatController.createGroupChatRoomAndStartConversation(
                    groupName: groupNameController.text.trim(),
                    groupImage: groupImage!,
                    groupDescription: groupDescriptionController.text.trim(),
                    userIds: userIds,
                    creatorId: auth.currentUser?.uid ?? "",
                    creatorName: userDetailsModel.fullName);
              },
              buttonText: 'create group',
            ),
          ),
        ],
      ),
    );
  }
}
