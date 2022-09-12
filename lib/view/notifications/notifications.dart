import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/alert_model/alert_model.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/chat/group_chat/g_chat_screen.dart';
import 'package:vip_picnic/view/home/post_details.dart';
import 'package:vip_picnic/view/profile/other_user_profile.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        onTap: () => Get.offAll(
          BottomNavBar(
            currentIndex: 0,
          ),
        ),
        title: 'alerts'.tr,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ffstore
            .collection(alertsCollection)
            .where("forId", isEqualTo: auth.currentUser!.uid)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //log("inside stream-builder");
          if (snapshot.connectionState == ConnectionState.waiting) {
            log("inside stream-builder in waiting state");
            return Center(child: noPostYet());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Some unknown error occurred');
            } else if (snapshot.hasData) {
              // log("inside alert hasData and ${snapshot.data!.docs.length}");
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                  // shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    AlertModel amdl = AlertModel.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                    //+ type can be:
                    //+ postLiked, postCommented, follow, groupInvite, postTagged
                    return NotificationTiles(
                      profileImage: amdl.image,
                      dataId: amdl.dataId,
                      type: amdl.type,
                      docId: snapshot.data?.docs[index].id,
                      isNewFollower: amdl.type == "follow" ? true : false,
                      isEventInvite: false,
                      isGroupInvite: amdl.type == "groupInvite" ? true : false,
                      isPostLiked: amdl.type == "postLiked" ? true : false,
                      isPostCommented: amdl.type == "postCommented" ? true : false,
                      isPostTagged: amdl.type == "postTagged" ? true : false,
                      time: amdl.createdAt,
                    );
                  },
                );
              } else {
                return Center(child: noPostYet());
              }
            } else {
              log("in else of hasData done and: ${snapshot.connectionState} and"
                  " snapshot.hasData: ${snapshot.hasData}");
              return Center(child: noPostYet());
            }
          } else {
            log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
            return Center(child: noPostYet());
          }
        },
      ),
    );
  }

  Widget noPostYet() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 150,
      ),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              Assets.imagesNoDataFound,
              height: 180,
            ),
          ),
          MyText(
            text: 'No Notifications Yet',
            size: 18,
            weight: FontWeight.w700,
          ),
          MyText(
            text: 'Notifications will appear here whenever something exciting happens.',
            paddingLeft: 5,
            paddingRight: 5,
            size: 10,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class NotificationTiles extends StatelessWidget {
  NotificationTiles({
    Key? key,
    this.profileImage,
    this.time,
    this.dataId,
    this.type,
    this.docId,
    this.isEventInvite = false,
    this.isGroupInvite = false,
    this.isPostLiked = false,
    this.isPostCommented = false,
    this.isPostTagged = false,
    this.isNewFollower = false,
  }) : super(key: key);

  bool? isEventInvite, isGroupInvite, isNewFollower, isPostLiked, isPostCommented, isPostTagged;
  String? profileImage, docId, type, dataId;
  int? time;

  List<String> monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time ?? DateTime.now().millisecondsSinceEpoch);
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () async {
                Get.dialog(loading(), barrierDismissible: false);
                log("dataId: ${dataId}");
                if ((isNewFollower ?? false)) {
                  UserDetailsModel? umdl;
                  await ffstore.collection(accountsCollection).doc(dataId).get().then((value) {
                    Get.back();
                    if (value.exists) {
                      umdl = UserDetailsModel.fromJson(value.data() ?? {});
                      Get.to(() => OtherUserProfile(otherUserModel: umdl));
                    } else {
                      showMsg(context: context, msg: "Something went wrong. Please try again.");
                    }
                  });
                } else if ((isGroupInvite ?? false)) {
                  await ffstore.collection(groupChatCollection).doc(dataId).update({
                    "notDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid]),
                    "users": FieldValue.arrayUnion([auth.currentUser?.uid]),
                  });
                  await groupChatController.getAGroupChatRoomInfo(dataId!).then((value) {
                    Get.back();
                    if (value.exists) {
                      Get.to(() => GroupChat(docs: value.data()));
                    } else {
                      showMsg(context: context, msg: "Something went wrong. Please try again.");
                    }
                  });
                } else if ((isPostLiked ?? false) || (isPostCommented ?? false) || (isPostTagged ?? false)) {
                  await ffstore.collection(postsCollection).doc(dataId).get().then((value) {
                    Get.back();
                    if (value.exists) {
                      AddPostModel addPostModel = AddPostModel.fromJson(value.data() ?? {});
                      Get.to(() => PostDetails(isLikeByMe: false, postDocModel: addPostModel));
                    } else {
                      showMsg(context: context, msg: "Something went wrong. Please try again.");
                    }
                  });
                } else {
                  log("type could not be determined");
                }
              },
              leading: isNewFollower!
                  ? Container(
                      height: 48,
                      width: 48,
                      padding: EdgeInsets.all(3),
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
                            profileImage!,
                            height: height(context, 1.0),
                            width: width(context, 1.0),
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
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        profileImage!,
                        height: 48,
                        width: 48,
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
              title: MyText(
                text: isNewFollower!
                    ? 'follower'.tr
                    : isEventInvite!
                        ? 'inviteToEvent'.tr
                        : isGroupInvite!
                            ? 'inviteToGroup'.tr
                            : isPostLiked!
                                ? 'postLiked'.tr
                                : isPostCommented!
                                    ? 'postCommented'.tr
                                    : isPostTagged!
                                        ? 'postTagged'.tr
                                        : '',
                size: 18,
                color: kSecondaryColor,
              ),
              subtitle: MyText(
                text:
                    "${dateTime.day == DateTime.now().day ? 'Today' : '${dateTime.day} ${monthsList[dateTime.month - 1]}'}",
                size: 16,
                color: kLightPurpleColorThree,
              ),
              trailing: GestureDetector(
                onTap: () async {
                  await ffstore.collection(alertsCollection).doc(docId).delete();
                },
                child: Image.asset(
                  Assets.imagesClose,
                  height: 25.33,
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: kBorderColor,
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
          ),
        ],
      ),
    );
  }
}
