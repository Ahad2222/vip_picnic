import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/utils/validators.dart';
import 'package:vip_picnic/view/home/post_video_preview_from_file.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

// ignore: must_be_immutable
class AddNewPost extends StatelessWidget {
  AddNewPost({
    this.editPost = false,
    this.postImage,
    this.title,
  });

  bool? editPost;
  String? postImage, title;

  RxString userSearchText = "".obs;
  List<String> userIds = [];

  RxMap selectedUsers = Map<String, dynamic>.from({}).obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: editPost! ? 'Edit Post' : 'New Post',
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
                      onTap: editPost! ? () {} : () {},
                      borderRadius: BorderRadius.circular(16),
                      child: editPost!
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                postImage!,
                                height: height(context, 1.0),
                                width: width(context, 1.0),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Obx(() {
                              return GestureDetector(
                                onTap: () => showModalBottomSheet(
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
                                            onTap: () {
                                              homeController.pickImages(context);
                                            },
                                            leading: Image.asset(
                                              Assets.imagesGallery,
                                              color: kGreyColor,
                                              height: 35,
                                            ),
                                            title: MyText(
                                              text: 'Image',
                                              size: 20,
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () => homeController.pickVideo(context),
                                            // ImageSource.gallery
                                            leading: Image.asset(
                                              Assets.imagesFilm,
                                              height: 35,
                                              color: kGreyColor,
                                            ),
                                            title: MyText(
                                              text: 'Video',
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  isScrollControlled: true,
                                ),
                                child: homeController.selectedImages.isNotEmpty
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              File(
                                                homeController.selectedImages[0].path,
                                              ),
                                              height: Get.height,
                                              width: Get.width,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () => homeController.removeImage(0),
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
                                      )
                                    : homeController.selectedVideos.isNotEmpty
                                        ? Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: Get.height,
                                                width: Get.width,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(
                                                      homeController.selectedVideosThumbnails[0],
                                                    ),
                                                    height: Get.height,
                                                    width: Get.width,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                opacity: 1.0,
                                                duration: Duration(
                                                  milliseconds: 500,
                                                ),
                                                child: Container(
                                                  height: 55,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: kBlackColor.withOpacity(0.5),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.to(() => PostVideoPreview(
                                                              videoFile: homeController.selectedVideos[0],
                                                            ));
                                                      },
                                                      borderRadius: BorderRadius.circular(100),
                                                      splashColor: kPrimaryColor.withOpacity(0.1),
                                                      highlightColor: kPrimaryColor.withOpacity(0.1),
                                                      child: Center(
                                                        child: Image.asset(
                                                          Assets.imagesPlay,
                                                          height: 23,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: GestureDetector(
                                                  onTap: () => homeController.removeVideo(0),
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
                                          )
                                        : Image.asset(
                                            Assets.imagesUploadPicture,
                                            height: 108.9,
                                            fit: BoxFit.cover,
                                          ),
                                // Positioned(
                                //   top: 10,
                                //   right: 10,
                                //   child: GestureDetector(
                                //     onTap: () => homeController.removeImage(0),
                                //     child: Container(
                                //       height: 30,
                                //       width: 30,
                                //       decoration: BoxDecoration(
                                //         color: Colors.red,
                                //         borderRadius: BorderRadius.circular(6),
                                //       ),
                                //       child: Icon(
                                //         Icons.close,
                                //         size: 20,
                                //         color: kPrimaryColor,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              );
                              //           : Image.asset(
                              //               Assets.imagesUploadPicture,
                              //               height: 108.9,
                              //               fit: BoxFit.cover,
                              //             ),
                              // );
                            }),
                    ),
                  ),
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      homeController.selectedImages.isEmpty
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              height: 100,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: homeController.selectedImages.length,
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
                                            File(
                                              homeController.selectedImages[index].path,
                                            ),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () => homeController.removeImage(index),
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
                    ],
                  );
                }),
                SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      homeController.selectedVideosThumbnails.isEmpty
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              height: 100,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: homeController.selectedVideosThumbnails.length,
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
                                            File(
                                              homeController.selectedVideosThumbnails[index],
                                            ),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () => homeController.removeVideo(index),
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
                    controller: homeController.descriptionCon,
                    validator: (value) => emptyFieldValidator(value!),
                    hintText: 'Description...',
                    initialValue: title,
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
                    controller: homeController.tagCon,
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
                                  homeController.taggedPeople.remove(userList[index]['id']);
                                  homeController.taggedPeopleToken.remove(userList[index]['token']);
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
                //     //log("inside stream-builder");
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
                    controller: homeController.locationCon,
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
              onTap: () => homeController.uploadPost(context),
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
            homeController.taggedPeople.addIf(!homeController.taggedPeople.asMap().containsValue(id), id);
            homeController.taggedPeopleToken
                .addIf(!homeController.taggedPeopleToken.asMap().containsValue(userToken), userToken);
            selectedUsers.addIf(
                !selectedUsers.containsKey(id), id, {
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
