import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/dynamic_link_handler.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/add_new_post.dart';
import 'package:vip_picnic/view/home/edit_post.dart';
import 'package:vip_picnic/view/home/post_details.dart';
import 'package:vip_picnic/view/profile/other_user_profile.dart';
import 'package:vip_picnic/view/profile/profile.dart';
import 'package:vip_picnic/view/widget/custom_popup.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class MyPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'myPosts'.tr,
        onTap: () => Navigator.pop(context),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ffstore
            .collection(postsCollection)
            .where("uID", isEqualTo: auth.currentUser?.uid)
            .orderBy("createdAtMilliSeconds", descending: true)
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          // log("inside stream-builder");
          if (snapshot.connectionState == ConnectionState.waiting) {
            // log("inside stream-builder in waiting state");
            return noPostYet();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Some unknown error occurred');
            } else if (snapshot.hasData) {
              // log("inside hasData and ${snapshot.data!.docs}");
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                  // shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    AddPostModel addPostModel = AddPostModel.fromJson(
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>);
                    return PostWidget(
                      postDocModel: addPostModel,
                      postID: addPostModel.postID,
                      isLikeByMe: addPostModel.likeIDs!
                          .asMap()
                          .containsValue(auth.currentUser!.uid),
                      profileImage: addPostModel.profileImage,
                      name: addPostModel.postBy,
                      postedTime: addPostModel.createdAt,
                      title: addPostModel.postTitle,
                      likeCount: addPostModel.likeIDs!.length,
                      isMyPost: true,
                      postImage: addPostModel.postImages!,
                    );
                  },
                );
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: BouncingScrollPhysics(),
                //   padding: EdgeInsets.symmetric(
                //     vertical: 30,
                //   ),
                //   itemCount: snapshot.data!.docs.length,
                //   itemBuilder: (context, index) {
                //     AddPostModel addPostModel =
                //     AddPostModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                //     return PostWidget(
                //       postDocModel: addPostModel,
                //       postID: addPostModel.postID,
                //       isLikeByMe: addPostModel.likeIDs!.asMap().containsValue(auth.currentUser!.uid),
                //       profileImage: addPostModel.profileImage,
                //       name: addPostModel.postBy,
                //       postedTime: addPostModel.createdAt,
                //       title: addPostModel.postTitle,
                //       likeCount: addPostModel.likeIDs!.length,
                //       isMyPost: false,
                //       postImage: addPostModel.postImages!,
                //     );
                //   },
                // );
              } else {
                return noPostYet();
              }
            } else {
              // log("in else of hasData done and: ${snapshot.connectionState} and"
              //     " snapshot.hasData: ${snapshot.hasData}");
              return noPostYet();
            }
          } else {
            // log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
            return noPostYet();
          }
        },
      ),
    );
  }

  Widget noPostYet() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
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
            text: 'No Post Yet',
            size: 18,
            weight: FontWeight.w700,
          ),
          MyText(
            text: 'All posts will appear here when you follow someone.',
            size: 10,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  PostWidget({
    Key? key,
    this.postID,
    this.postDocModel,
    this.profileImage,
    this.name,
    this.postedTime,
    this.title,
    this.postImage,
    this.likeCount = 0,
    this.isMyPost = true,
    this.isLikeByMe = false,
  }) : super(key: key);

  String? postID, profileImage, name, postedTime, title;
  List<String>? postImage;
  int? likeCount;
  AddPostModel? postDocModel;

  bool? isMyPost, isLikeByMe;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  RxInt currentPost = 0.obs;
  List<String> monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: widget.isMyPost!
                      ? () => Get.to(
                            () => Profile(),
                          )
                      : () async {
                          log("inside the lower going to user method");
                          UserDetailsModel otherUser = UserDetailsModel();
                          try {
                            // loading();
                            await ffstore
                                .collection(accountsCollection)
                                .doc(widget.postDocModel!.uID)
                                .get()
                                .then(
                              (value) {
                                otherUser = UserDetailsModel.fromJson(
                                    value.data() ?? {});
                              },
                            );
                          } catch (e) {
                            print(e);
                          }
                          // navigatorKey.currentState!.pop();
                          Get.to(
                            () => OtherUserProfile(otherUserModel: otherUser),
                          );
                        },
                  child: Container(
                    height: 54,
                    width: 54,
                    padding: EdgeInsets.all(4),
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
                      child: widget.isMyPost!
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userDetailsModel.profileImageUrl!,
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return loading();
                                  }
                                },
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                widget.profileImage!,
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
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
                ),
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        log("inside the lower going to user method");
                        UserDetailsModel otherUser = UserDetailsModel();
                        // loading();
                        try {
                          await ffstore
                              .collection(accountsCollection)
                              .doc(widget.postDocModel!.uID)
                              .get()
                              .then(
                            (value) {
                              otherUser =
                                  UserDetailsModel.fromJson(value.data() ?? {});
                            },
                          );
                        } catch (e) {
                          print(e);
                        }
                        // navigatorKey.currentState!.pop();
                        Get.to(
                          () => OtherUserProfile(otherUserModel: otherUser),
                        );
                      },
                      child: MyText(
                        text:
                            widget.isMyPost! ? 'yourPost'.tr : '${widget.name}',
                        size: 17,
                        weight: FontWeight.w600,
                        color: kSecondaryColor,
                        paddingBottom: 4,
                      ),
                    ),
                    MyText(
                      //+ 8/4/2022
                      text:
                          '  •  ${widget.postedTime!.split(' ')[1].split("/")[1]} ${monthList[int.parse(widget.postedTime!.split(' ')[1].split("/")[0]) - 1]}',
                      size: 15,
                      weight: FontWeight.w600,
                      color: kSecondaryColor.withOpacity(0.40),
                    ),
                  ],
                ),
                trailing: widget.isMyPost!
                    ? PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: MyText(
                                onTap: () => Get.to(
                                  () => EditPost(
                                    postModel: widget.postDocModel,
                                    // editPost: true,
                                    // postImage: widget.postImage![0],
                                    // title: widget.title,
                                  ),
                                ),
                                text: 'editPost'.tr,
                                size: 14,
                                color: kSecondaryColor,
                              ),
                            ),
                            PopupMenuItem(
                              child: MyText(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return CustomPopup(
                                        heading: 'Are you sure?',
                                        description:
                                            'This can\'t be undone. Are you sure you want to delete this post?',
                                        onCancel: () => Get.back(),
                                        onConfirm: () async {
                                          try {
                                            // Get.back();
                                            List<String> imageUrlsList = widget
                                                    .postDocModel?.postImages ??
                                                [];
                                            Get.back();
                                            Get.back();
                                            Get.dialog(loading());
                                            await posts
                                                .doc(
                                                    widget.postDocModel?.postID)
                                                .delete();
                                            Get.back();
                                            imageUrlsList.forEach(
                                              (element) async {
                                                await fstorage
                                                    .refFromURL(element)
                                                    .delete();
                                              },
                                            );
                                            // await posts.doc(addPostModel.value.postID).collection("comments").delete();
                                          } catch (e) {
                                            print(e);
                                            showMsg(
                                                context: context,
                                                msg:
                                                    "Something went wrong during post deletion. Please try again.");
                                            log("error in post deletion $e");
                                          }
                                        },
                                      );
                                    },
                                  );
                                  // Get.defaultDialog(
                                  //     title: "Are you sure?",
                                  //     content: Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 15, vertical: 0),
                                  //       child: Text(
                                  //           "This can't be undone. Are you sure you want to delete this post?"),
                                  //     ),
                                  //     textConfirm: "Yes",
                                  //     confirmTextColor: Colors.red,
                                  //     textCancel: "No",
                                  //     cancelTextColor: Colors.black,
                                  //     onConfirm: () async {
                                  //       try {
                                  //         // Get.back();
                                  //         List<String> imageUrlsList =
                                  //             widget.postDocModel?.postImages ??
                                  //                 [];
                                  //         Get.back();
                                  //         Get.back();
                                  //         Get.dialog(loading());
                                  //         await posts
                                  //             .doc(widget.postDocModel?.postID)
                                  //             .delete();
                                  //         Get.back();
                                  //         imageUrlsList
                                  //             .forEach((element) async {
                                  //           await fstorage
                                  //               .refFromURL(element)
                                  //               .delete();
                                  //         });
                                  //         // await posts.doc(addPostModel.value.postID).collection("comments").delete();
                                  //       } catch (e) {
                                  //         print(e);
                                  //         showMsg(
                                  //             context: context,
                                  //             msg:
                                  //                 "Something went wrong during post deletion. Please try again.");
                                  //         log("error in post deletion $e");
                                  //       }
                                  //     });
                                },
                                text: 'deletePost'.tr,
                                size: 14,
                                color: kSecondaryColor,
                              ),
                            ),
                          ];
                        },
                        child: Icon(
                          Icons.more_vert,
                          color: kDarkBlueColor.withOpacity(0.60),
                          size: 30,
                        ),
                      )
                    : SizedBox(),
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(
                () => PostDetails(
                  isMyPost: true,
                  isLikeByMe: widget.isLikeByMe,
                  postDocModel: widget.postDocModel,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    paddingTop: 13,
                    paddingLeft: 20,
                    paddingBottom: 5,
                    text: '${widget.title}',
                    size: 18,
                    maxLines: 3,
                    overFlow: TextOverflow.ellipsis,
                    color: kSecondaryColor,
                  ),
                  SizedBox(
                    height: 220,
                    child: Stack(
                      children: [
                        PageView.builder(
                          onPageChanged: (index) {
                            currentPost.value = index;
                            // homeController.getCurrentPostIndex(index);
                          },
                          physics: BouncingScrollPhysics(),
                          itemCount: widget.postImage!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  widget.postImage![index],
                                  height: Get.height,
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace,
                                  ) {
                                    return const Text(' ');
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return loading();
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        widget.postImage!.length == 1
                            ? SizedBox()
                            : Obx(() {
                                return Positioned(
                                  top: 10,
                                  right: 30,
                                  child: Container(
                                    height: 35,
                                    width: 46,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: kSecondaryColor.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: MyText(
                                        text:
                                            '${currentPost.value + 1}/${widget.postImage!.length}',
                                        size: 15,
                                        weight: FontWeight.w600,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20.0,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await ffstore
                              .collection(postsCollection)
                              .doc(widget.postID)
                              .update(
                            {
                              "likeCount": FieldValue.increment(
                                  widget.isLikeByMe! ? -1 : 1),
                              "likeIDs": !widget.isLikeByMe!
                                  ? FieldValue.arrayUnion(
                                      [auth.currentUser!.uid])
                                  : FieldValue.arrayRemove(
                                      [auth.currentUser!.uid]),
                            },
                          );
                          // await fs.collection(postsCollection).doc(postID).collection("likes")
                          //     .doc(auth.currentUser!.uid).set({
                          //   "likerId": auth.currentUser!.uid,
                          //   "postID": postID!,
                          // });
                          // update({
                          //   "likeCount" : FieldValue.increment(isLikeByMe! ? -1 : 1),
                          //   "likeIDs" : !isLikeByMe! ? FieldValue.arrayUnion([auth.currentUser!.uid]) : FieldValue.arrayRemove([auth.currentUser!.uid]),
                          // });
                        },
                        child: Image.asset(
                          //+this is giving us a small glitch because everytime for the first time app opens up,
                          //+ the red heart image is not loaded yet. which gives a small glitch on that first like
                          //+ but this hapens only when either no post is liked before or all post have been liked before
                          widget.isLikeByMe!
                              ? Assets.imagesHeartFull
                              : Assets.imagesHeartEmpty,
                          height: 24.0,
                          color: widget.isLikeByMe!
                              ? Color(0xffe31b23)
                              : kDarkBlueColor.withOpacity(0.60),
                        ),
                      ),
                      MyText(
                        text: widget.likeCount!,
                        size: 18,
                        color: kDarkBlueColor.withOpacity(0.60),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(
                          () => PostDetails(
                            isLikeByMe: widget.isLikeByMe,
                            postDocModel: widget.postDocModel,
                          ),
                        ),
                        child: Image.asset(
                          Assets.imagesComment,
                          height: 23.76,
                          color: kDarkBlueColor.withOpacity(0.60),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: ffstore
                            .collection(postsCollection)
                            .doc(widget.postID)
                            .collection("comments")
                            .snapshots(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          int previousCount = snapshot.data != null
                              ? snapshot.data!.docs.length
                              : 0;
                          log("inside stream-builder");
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            log("inside stream-builder in waiting state");
                            return MyText(
                              text: '$previousCount',
                              size: 18,
                              color: kDarkBlueColor.withOpacity(0.60),
                            );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.hasError) {
                              return MyText(
                                text: "$previousCount",
                                size: 18,
                                color: kDarkBlueColor.withOpacity(0.60),
                              );
                            } else if (snapshot.hasData) {
                              // log("inside hasData and ${snapshot.data!.docs}");
                              if (snapshot.data!.docs.length > 0) {
                                previousCount = snapshot.data!.docs.length;
                                return MyText(
                                  text: snapshot.data!.docs.length,
                                  size: 18,
                                  color: kDarkBlueColor.withOpacity(0.60),
                                );
                              } else {
                                return MyText(
                                  text: "$previousCount",
                                  size: 18,
                                  color: kDarkBlueColor.withOpacity(0.60),
                                );
                              }
                            } else {
                              log("in else of hasData done and: ${snapshot.connectionState} and"
                                  " snapshot.hasData: ${snapshot.hasData}");
                              return MyText(
                                text: '$previousCount',
                                size: 18,
                                color: kDarkBlueColor.withOpacity(0.60),
                              );
                            }
                          } else {
                            log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                            return MyText(
                              text: '$previousCount',
                              size: 18,
                              color: kDarkBlueColor.withOpacity(0.60),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      String shareLink =
                          await DynamicLinkHandler.buildDynamicLinkForPost(
                        postImageUrl: widget.postDocModel?.postImages![0] ??
                            "https://www.freeiconspng.com/uploads/no-image-icon-15.png",
                        postId: widget.postDocModel!.postID ?? "",
                        postTitle: widget.postDocModel!.postTitle ?? "No Title",
                        short: true,
                      );
                      log("fetched shareLink: $shareLink");
                      ShareResult sr = await Share.shareWithResult(shareLink);
                      log("ShareResult is: ${sr.status} sr.status == ShareResultStatus.success: ${sr.status == ShareResultStatus.success}");
                      log("ShareResult is: ${sr.status} sr.status == ShareResultStatus.dismissed: ${sr.status == ShareResultStatus.dismissed}");
                      log("ShareResult.raw is: ${sr.raw}");
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10.0,
                      children: [
                        Image.asset(
                          Assets.imagesShare,
                          height: 25.23,
                          color: kDarkBlueColor.withOpacity(0.60),
                        ),
                        // MyText(
                        //   text: '04',
                        //   size: 18,
                        //   color: kDarkBlueColor.withOpacity(0.60),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        Container(
          height: 1,
          color: kDarkBlueColor.withOpacity(0.14),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
