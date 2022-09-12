import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class CreateNewGroup extends StatelessWidget {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  List<String> userIds = [];
  RxMap selectedUsers = Map<String, dynamic>.from({}).obs;

  String? groupImage = '';
  File? pickedImage;
  RxString pickedImagePath = "".obs;

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
    Reference ref = await FirebaseStorage.instance.ref().child('Images/GroupChat Images/${DateTime.now().toString()}');
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
      resizeToAvoidBottomInset: true,
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
                    child: Obx(() {
                      return InkWell(
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
                        child: pickedImagePath.value == ""
                            ? Image.asset(
                                Assets.imagesUploadPicture,
                                height: 108.9,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  pickedImage!,
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      );
                    }),
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
                  if (groupChatController.userSearchText.value.trim() != "") {
                    // List<String> tempList = selectedUsers.length > 0 ? List<String>.from(selectedUsers.keys.toList()) : ["check"];
                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: ffstore
                          .collection(accountsCollection)
                          .where("userSearchParameters", arrayContains: groupChatController.userSearchText.value.trim())
                          // .where("uID", whereNotIn: tempList)
                          .snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        //log("inside stream-builder");
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          log("inside stream-builder in waiting state");
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState == ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Text('Some unknown error occurred');
                          } else if (snapshot.hasData) {
                            // log("inside hasData and ${snapshot.data!.docs}");
                            if (snapshot.data!.docs.length > 0) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  UserDetailsModel umdl = UserDetailsModel.fromJson(
                                      snapshot.data!.docs[index].data() as Map<String, dynamic>);
                                  return Obx(() {
                                    if (selectedUsers.containsKey(umdl.uID) || umdl.uID == auth.currentUser?.uid) {
                                      return SizedBox();
                                    }
                                    return contactTiles(
                                      profileImage: umdl.profileImageUrl,
                                      name: umdl.fullName,
                                      id: umdl.uID,
                                      email: umdl.email,
                                    );
                                  });
                                },
                              );
                            } else {
                              return Center(child: const Text('No Users Found'));
                            }
                          } else {
                            log("in else of hasData done and: ${snapshot.connectionState} and"
                                " snapshot.hasData: ${snapshot.hasData}");
                            return Center(child: const Text('No Users Found'));
                          }
                        } else {
                          log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                          return Center(child: Text('Some Error occurred while fetching the posts'));
                        }
                      },
                    );
                    // return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    //   stream: ffstore.collection(accountsCollection).snapshots(),
                    //   builder: (
                    //     BuildContext context,
                    //     AsyncSnapshot<QuerySnapshot> snapshot,
                    //   ) {
                    //     //log("inside stream-builder");
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       log("inside stream-builder in waiting state");
                    //       return Center(child: CircularProgressIndicator());
                    //     } else if (snapshot.connectionState == ConnectionState.active ||
                    //         snapshot.connectionState == ConnectionState.done) {
                    //       if (snapshot.hasError) {
                    //         return const Text('Some unknown error occurred');
                    //       } else if (snapshot.hasData) {
                    //         // log("inside hasData and ${snapshot.data!.docs}");
                    //         if (snapshot.data!.docs.length > 0) {
                    //           return ListView.builder(
                    //             shrinkWrap: true,
                    //             physics: BouncingScrollPhysics(),
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: 15,
                    //             ),
                    //             itemCount: snapshot.data!.docs.length,
                    //             itemBuilder: (context, index) {
                    //               UserDetailsModel umdl = UserDetailsModel.fromJson(
                    //                   snapshot.data!.docs[index].data() as Map<String, dynamic>);
                    //               return contactTiles(
                    //                 profileImage: umdl.profileImageUrl,
                    //                 name: umdl.fullName,
                    //                 id: umdl.uID,
                    //                 email: umdl.email,
                    //               );
                    //             },
                    //           );
                    //         } else {
                    //           return Center(child: const Text('No Users Found'));
                    //         }
                    //       } else {
                    //         log("in else of hasData done and: ${snapshot.connectionState} and"
                    //             " snapshot.hasData: ${snapshot.hasData}");
                    //         return Center(child: const Text('No Users Found'));
                    //       }
                    //     } else {
                    //       log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                    //       return Center(child: Text('Some Error occurred while fetching the posts'));
                    //     }
                    //   },
                    // );
                  }
                  return SizedBox();
                }),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  List userList = selectedUsers.values.toList();
                  log("userList: $userList");
                  return Wrap(runSpacing: 2,
                    children: List.generate(selectedUsers.length, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(right: 2),
                        padding: EdgeInsets.all(10),
                        width: (userList[index]['name'].length  * 12).toDouble(),
                        height: 45,
                        child: Row(
                          children: [
                            Expanded(child: Text("${userList[index]['name']}", maxLines: 1, overflow: TextOverflow.ellipsis,)),
                            GestureDetector(
                              onTap: () {
                                userIds.remove(userList[index]['id']);
                                selectedUsers.remove(userList[index]['id']);
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
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
              onTap: () async {
                if (pickedImage != null) {
                  await uploadPhoto();
                  if (groupNameController.text.trim() != "" &&
                      groupImage != "" &&
                      groupDescriptionController.text.trim() != "") {
                    groupChatController.createGroupChatRoomAndStartConversation(
                        groupName: groupNameController.text.trim(),
                        groupImage: groupImage!,
                        groupDescription: groupDescriptionController.text.trim(),
                        userIds: userIds,
                        creatorId: auth.currentUser?.uid ?? "",
                        creatorName: userDetailsModel.fullName);
                  } else {
                    showMsg(context: context, msg: "Please fill all the fields.");
                  }
                } else {
                  showMsg(context: context, msg: "Please fill all the fields.");
                }
              },
              buttonText: 'create group',
            ),
          ),
        ],
      ),
    );
  }

  Widget contactTiles({
    String? id,
    profileImage,
    name,
    email,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xffF5F5F6),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () async {
            //+add it to the lists
            userIds.addIf(!userIds.asMap().containsValue(id!), id);
            selectedUsers.addIf(!selectedUsers.containsKey(id), id, {
              "id": id,
              "name": name,
              "email": email,
            });
          },
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          leading: Container(
            height: 56.4,
            width: 56.4,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.16),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  profileImage,
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      BuildContext context,
                      Object exception,
                      StackTrace? stackTrace,
                      ) {
                    return const Text(' ');
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return loading();
                    }
                  },
                ),
              ),
            ),
          ),
          title: MyText(
            text: name,
            size: 14,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
          subtitle: MyText(
            text: email,
            size: 11,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }
}
