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
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/utils/validators.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

// ignore: must_be_immutable
class EditPost extends StatefulWidget {
  EditPost({this.postModel});

  AddPostModel? postModel;

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  TextEditingController descController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  RxList<XFile> newlyPickedImages = List<XFile>.from([]).obs;
  RxList<String> postImages = List<String>.from([]).obs;
  List<String> imagesToUpload = [];
  List<String> userIds = [];
  List<String> taggedPeople = [];
  List<String> taggedPeopleToken = [];
  RxMap selectedUsers = Map<String, dynamic>.from({}).obs;
  RxString userSearchText = "".obs;
  UserDetailsModel tempUserModel = UserDetailsModel();

  @override
  void initState() {
    // TODO: implement initState
    locationController.text = widget.postModel?.location ?? "";
    descController.text = widget.postModel?.postTitle ?? "";

    postImages.value = widget.postModel?.postImages ?? [];
    taggedPeople = widget.postModel?.taggedPeople ?? [];

    bool isPostModelTaggedPeopleIdsEmpty = widget.postModel?.taggedPeople?.isEmpty ?? true;
    if (!isPostModelTaggedPeopleIdsEmpty) {
      widget.postModel?.taggedPeople?.forEach((element) {
        ffstore.collection(accountsCollection).doc(element).get().then((value) {
          tempUserModel = UserDetailsModel.fromJson(value.data() ?? {});
          userIds.add(tempUserModel.uID ?? "");
          selectedUsers.addIf(!selectedUsers.containsKey(tempUserModel.uID ?? ""), tempUserModel.uID ?? "", {
            "id": tempUserModel.uID,
            "name": tempUserModel.fullName,
            "email": tempUserModel.email,
            "token": tempUserModel.fcmToken,
          });
        });
      });
      // setState(() {});
    }
    super.initState();
  }

  Future pickImages(
    BuildContext context,
  ) async {
    try {
      List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images != null) {
        newlyPickedImages.value = images;
      } else {
        return [].obs;
      }
    } on PlatformException catch (e) {
      showMsg(
        msg: e.message,
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  Future<List<String>> uploadAllImages() async {
    for (int i = 0; i < newlyPickedImages.length; i++) {
      postImages.add(
        await uploadSingleImage(newlyPickedImages[i]),
      );
    }
    return postImages;
  }

  Future uploadSingleImage(XFile image) async {
    Reference ref = await fstorage.ref().child(
          'postImages/images/${DateTime.now().toString()}',
        );
    await ref.putFile(File(image.path));
    return ref.getDownloadURL();
  }

  Future uploadPost(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loading();
      },
    );
    if (postImages.isNotEmpty || descController.text.isNotEmpty) {
      var postID = widget.postModel?.postID;
      try {
        await uploadAllImages();
        log('Images UPLOADED!');
        Map<String, dynamic> updatedPostMap = {
          "postImages": postImages,
          "postTitle": descController.text.trim(),
          "taggedPeople": taggedPeople,
          "taggedPeopleToken": taggedPeopleToken,
          "location": locationController.text.trim(),
        };
        log('Data assigned to POST MODEL CLASS!');
        await posts.doc(postID).update(updatedPostMap).then(
          (value) {
            log('Data set to FIREBASE!');
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
            newlyPickedImages.value = [];
            imagesToUpload = [];
            descController.clear();
            tagController.clear();
            locationController.clear();
            taggedPeople = [];
            log('CLEAR');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Edit Post',
        onTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              children: [
                Container(
                  height: 220,
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kLightBlueColor,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: Obx(() {
                        bool isPostModelPostImagesEmpty = postImages.isEmpty;
                        return GestureDetector(
                          onTap: () => pickImages(context),
                          child: isPostModelPostImagesEmpty && newlyPickedImages.isEmpty
                              ? Image.asset(
                                  Assets.imagesUploadPicture,
                                  height: 108.9,
                                  fit: BoxFit.cover,
                                )
                              : Stack(
                                  children: [
                                    Obx(() {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: newlyPickedImages.isNotEmpty
                                            ? Image.file(
                                                File(newlyPickedImages[0].path),
                                                height: Get.height,
                                                width: Get.width,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                postImages[0],
                                                height: Get.height,
                                                width: Get.width,
                                                fit: BoxFit.cover,
                                              ),
                                      );
                                    }),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (newlyPickedImages.isNotEmpty) {
                                            newlyPickedImages.removeAt(0);
                                          } else {
                                            String link = postImages[0];
                                            postImages.remove(postImages[0]);
                                            await fstorage.refFromURL(link).delete().then((value) async {
                                              await posts.doc(widget.postModel?.postID).update({"postImages": postImages,});
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      }),
                    ),
                  ),
                ),
                Obx(() {
                  bool isPostModelPostImagesEmpty = postImages.isEmpty;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      isPostModelPostImagesEmpty && newlyPickedImages.isEmpty
                          ? SizedBox()
                          : !isPostModelPostImagesEmpty && newlyPickedImages.isNotEmpty
                              ? Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 20,
                                      ),
                                      height: 100,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: newlyPickedImages.length,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(newlyPickedImages[index].path),
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      newlyPickedImages.removeAt(index);
                                                      // await fstorage
                                                      //     .refFromURL(widget.postModel?.postImages![index] ?? "")
                                                      //     .delete()
                                                      //     .then((value) {
                                                      //   widget.postModel?.postImages
                                                      //       ?.remove(widget.postModel?.postImages![index]);
                                                      // });
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 15,
                                                        color: kPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 20,
                                      ),
                                      height: 100,
                                      child: Obx(() {
                                        return ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: postImages.length,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 7,
                                          ),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 7,
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(
                                                      postImages[index],
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 5,
                                                    right: 5,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        log("delete clicked for post previous image deletion");
                                                        String link = postImages[index];
                                                        postImages.remove(postImages[index]);
                                                        await fstorage.refFromURL(link).delete().then((value) async {
                                                          await posts.doc(widget.postModel?.postID).update({"postImages": postImages,});
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 15,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  ],
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                  ),
                                  height: 100,
                                  child: Obx(() {
                                    return ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: postImages.length,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 7,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  postImages[index],
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 5,
                                                right: 5,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    String link = postImages[index];
                                                    postImages.remove(postImages[index]);
                                                    await fstorage.refFromURL(link).delete().then((value) async {
                                                      await posts.doc(widget.postModel?.postID).update({"postImages": postImages,});
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 15,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                    ],
                  );
                }),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: SimpleTextField(
                    controller: descController,
                    validator: (value) => emptyFieldValidator(value!),
                    hintText: 'Description...',
                    // initialValue: widget.postModel?.postTitle ?? "",
                    maxLines: 6,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: SimpleTextField(
                    controller: tagController,
                    hintText: 'Tag people...',
                    haveSuffix: false,
                    onChanged: (value) {
                      userSearchText.value = value;
                    },
                    // suffix: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       width: 130,
                    //       height: 38,
                    //       child: tagPeopleBox(
                    //         radius: 14.0,
                    //         onTap: () {},
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Obx(() {
                  if (userSearchText.value.trim() != "") {
                    // List<String> tempList = selectedUsers.length > 0 ? List<String>.from(selectedUsers.keys.toList()) : ["check"];
                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: ffstore
                          .collection(accountsCollection)
                          .where("userSearchParameters", arrayContains: userSearchText.value.trim())
                          // .where("uID", whereNotIn: tempList)
                          .snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        log("inside stream-builder");
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
                                      userToken: umdl.fcmToken,
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
                    //     log("inside stream-builder");
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Obx(() {
                    List userList = selectedUsers.values.toList();
                    log("userList: $userList");
                    return Wrap(
                      runSpacing: 2,
                      children: List.generate(selectedUsers.length, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.only(right: 2),
                          padding: EdgeInsets.all(10),
                          width: userList[index]['name'].length <= 3
                              ? (userList[index]['name'].length * 28).toDouble()
                              : (userList[index]['name'].length * 12).toDouble(),
                          height: 45,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "${userList[index]['name']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              GestureDetector(
                                onTap: () {
                                  userIds.remove(userList[index]['id']);
                                  selectedUsers.remove(userList[index]['id']);
                                  taggedPeople.remove(userList[index]['id']);
                                  taggedPeopleToken.remove(userList[index]['token']);
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
                ),
                // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                //   stream: fs
                //       .collection(accountsCollection)
                //       .doc(userDetailsModel.uID)
                //       .collection('iFollowed')
                //       .snapshots(),
                //   builder: (
                //     BuildContext context,
                //     AsyncSnapshot<QuerySnapshot> snapshot,
                //   ) {
                //     log("inside stream-builder");
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       log("inside stream-builder in waiting state");
                //       return Center(child: CircularProgressIndicator());
                //     } else if (snapshot.connectionState ==
                //             ConnectionState.active ||
                //         snapshot.connectionState == ConnectionState.done) {
                //       if (snapshot.hasError) {
                //         return const Text('Some unknown error occurred');
                //       } else if (snapshot.hasData) {
                //         // log("inside hasData and ${snapshot.data!.docs}");
                //         if (snapshot.data!.docs.length > 0) {
                //           return SizedBox(
                //             height: 45,
                //             child: ListView.builder(
                //               physics: BouncingScrollPhysics(),
                //               padding: EdgeInsets.symmetric(
                //                 horizontal: 7,
                //               ),
                //               scrollDirection: Axis.horizontal,
                //               itemCount: snapshot.data!.docs.length,
                //               itemBuilder: (context, index) {
                //                 UserDetailsModel obj =
                //                     UserDetailsModel.fromJson(
                //                   snapshot.data!.docs[index].data()
                //                       as Map<String, dynamic>,
                //                 );
                //                 return tagPeopleBox(
                //                   personName: obj.fullName,
                //                   id: obj.uID,
                //                 );
                //               },
                //             ),
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
                //       return Center(
                //           child: Text(
                //               'Some Error occurred while fetching the posts'));
                //     }
                //   },
                // ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: SimpleTextField(
                    controller: locationController,
                    // initialValue: widget.postModel?.location,
                    hintText: 'Location (optional)...',
                  ),
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
              onTap: () => uploadPost(context),
              buttonText: 'publish',
            ),
          ),
        ],
      ),
    );
  }

  Widget contactTiles({String? id, profileImage, name, email, userToken}) {
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
            taggedPeople.addIf(!taggedPeople.asMap().containsValue(id), id);
            taggedPeopleToken.addIf(!taggedPeopleToken.asMap().containsValue(userToken), userToken);
            selectedUsers.addIf(!selectedUsers.containsKey(id), id, {
              "id": id,
              "name": name,
              "email": email,
              "token": userToken,
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

  Widget tagPeopleBox({
    String? id,
    String? personName,
    bool? isSelected = false,
    double? radius = 50.0,
    int? index,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 7,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: isSelected! ? kTertiaryColor : kGreyColor.withOpacity(0.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          splashColor: kPrimaryColor.withOpacity(0.1),
          highlightColor: kPrimaryColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  paddingLeft: 10,
                  paddingRight: 5,
                  text: personName,
                  size: 16,
                  color: isSelected ? kPrimaryColor : kBlackColor,
                ),
                Icon(
                  isSelected ? Icons.close : Icons.check,
                  color: isSelected ? kPrimaryColor : kBlackColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
