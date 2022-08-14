import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/dynamic_link_handler.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/add_new_post.dart';
import 'package:vip_picnic/view/home/post_details.dart';
import 'package:vip_picnic/view/profile/profile.dart';
import 'package:vip_picnic/view/search_friends/search_friends.dart';
import 'package:vip_picnic/view/story/post_new_story.dart';
import 'package:vip_picnic/view/story/story.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log('${userDetailsModel.profileImageUrl!} Main BUILD');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        leadingWidth: 85,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(
                AppLinks.profile,
              ),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      userDetailsModel.profileImageUrl!,
                      height: height(context, 1.0),
                      width: width(context, 1.0),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: MyText(
          text: 'welcome'.tr,
          size: 20,
          color: kSecondaryColor,
        ),
        bottom: PreferredSize(
          preferredSize: Size(0, 70),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: SearchBar(
              isReadOnly: true,
              onTap: () => Get.to(
                () => SearchFriends(),
              ),
              textSize: 16,
              borderColor: Colors.transparent,
              fillColor: kSecondaryColor.withOpacity(0.05),
            ),
          ),
        ),
      ),
      //+ USE this part for the post and put a streambuilder here
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        children: [
          SizedBox(
            height: 80,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                addStoryButton(context),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return stories(
                      context,
                      'assets/images/baby_shower.png',
                      index.isOdd ? 'Khan' : 'Stephan',
                      index,
                    );
                  },
                ),
              ],
            ),
          ),
          /**/ //+ starting stream builder
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: fs.collection("Accounts").doc(auth.currentUser!.uid).snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot,
            ) {
              log("inside stream-builder");
              log(userDetailsModel.profileImageUrl!);
              if (snapshot.connectionState == ConnectionState.waiting) {
                log("inside stream-builder in waiting state");
                return noPostYet();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Some unknown error occurred');
                } else if (snapshot.hasData) {
                  // log("inside hasData and ${snapshot.data!.docs}");
                  if (snapshot.data!.exists) {
                    userDetailsModel = UserDetailsModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                    var followedListToBeChecked =
                        userDetailsModel.iFollowed!.length > 0 ? userDetailsModel.iFollowed : ["something"];
                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: fs.collection("Posts").where("uID", whereIn: followedListToBeChecked).snapshots(),
                        builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot,
                            ) {
                          log("inside stream-builder");
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            log("inside stream-builder in waiting state");
                            return noPostYet();
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
                                    vertical: 30,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    AddPostModel addPostModel =
                                    AddPostModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                                    return PostWidget(
                                      postDocModel: addPostModel,
                                      postID: addPostModel.postID,
                                      isLikeByMe: addPostModel.likeIDs!.asMap().containsValue(auth.currentUser!.uid),
                                      profileImage: addPostModel.profileImage,
                                      name: addPostModel.postBy,
                                      postedTime: addPostModel.createdAt,
                                      title: addPostModel.postTitle,
                                      likeCount: addPostModel.likeIDs!.length,
                                      isMyPost: false,
                                      postImage: addPostModel.postImages![0],
                                    );
                                  },
                                );
                              } else {
                                return noPostYet();
                              }
                            } else {
                              log("in else of hasData done and: ${snapshot.connectionState} and"
                                  " snapshot.hasData: ${snapshot.hasData}");
                              return noPostYet();
                            }
                          } else {
                            log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                            return noPostYet();
                          }
                        },
                      );
                  } else {
                    return noPostYet();
                  }
                } else {
                  log("in else of hasData done and: ${snapshot.connectionState} and"
                      " snapshot.hasData: ${snapshot.hasData}");
                  return noPostYet();
                }
              } else {
                log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                return Center(child: Text('Some Error occurred while fetching the posts'));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '',
        onPressed: () => Navigator.pushNamed(
          context,
          AppLinks.addNewPost,
        ),
        elevation: 5,
        highlightElevation: 1,
        splashColor: kPrimaryColor.withOpacity(0.1),
        backgroundColor: kSecondaryColor,
        child: Image.asset(
          Assets.imagesPlusIcon,
          height: 22.68,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  Widget noPostYet() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
      ),
      child: Center(
        child: Image.asset(Assets.imagesNoPostYet),
      ),
    );
  }

  Widget stories(
    BuildContext context,
    String profileImage,
    name,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      child: GestureDetector(
        onTap: () => Get.to(
          () => Story(
            profileImage: profileImage,
            name: name,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.imagesStoryBg,
                  height: 55,
                  width: 55,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    profileImage,
                    height: 47,
                    width: 47,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            MyText(
              text: name,
              size: 12,
              weight: FontWeight.w600,
              color: kSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget addStoryButton(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 7,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.to(
              () => PostNewStory(),
            ),
            child: Image.asset(
              Assets.imagesAddStory,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
          MyText(
            text: 'addStory'.tr,
            size: 12,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
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
    this.isMyPost = false,
    this.isLikeByMe = false,
  }) : super(key: key);

  String? postID, profileImage, name, postedTime, title, postImage;
  int? likeCount;
  AddPostModel? postDocModel;

  bool? isMyPost, isLikeByMe;

  List<String> monthList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: () => Get.to(
                    () => Profile(
                      isMyProfile: isMyPost! ? true : false,
                    ),
                  ),
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
                      child: isMyPost!
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userDetailsModel.profileImageUrl!,
                                height: height(context, 1.0),
                                width: width(context, 1.0),
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                profileImage!,
                                height: height(context, 1.0),
                                width: width(context, 1.0),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    MyText(
                      text: isMyPost! ? 'yourPost'.tr : '$name',
                      size: 17,
                      weight: FontWeight.w600,
                      color: kSecondaryColor,
                      paddingBottom: 4,
                    ),
                    MyText(
                      //+ 8/4/2022
                      text:
                          '  •  ${postedTime!.split(' ')[1].split("/")[0]} ${monthList[int.parse(postedTime!.split(' ')[1].split("/")[1]) - 1]}',
                      size: 15,
                      weight: FontWeight.w600,
                      color: kSecondaryColor.withOpacity(0.40),
                    ),
                  ],
                ),
                trailing: isMyPost!
                    ? PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: MyText(
                                onTap: () => Get.to(
                                  () => AddNewPost(
                                    editPost: true,
                                    postImage: postImage,
                                    title: title,
                                  ),
                                ),
                                text: 'editPost'.tr,
                                size: 14,
                                color: kSecondaryColor,
                              ),
                            ),
                            PopupMenuItem(
                              child: MyText(
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
              GestureDetector(
                onTap: () => Get.to(
                  () => PostDetails(
                    isLikeByMe: isLikeByMe,
                    postDocModel: postDocModel,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      paddingTop: 13,
                      paddingLeft: 5,
                      paddingBottom: 5,
                      text: '$title',
                      size: 18,
                      maxLines: 3,
                      overFlow: TextOverflow.ellipsis,
                      color: kSecondaryColor,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        postImage!,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20.0,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await fs.collection("Posts").doc(postID).update({
                            "likeCount": FieldValue.increment(isLikeByMe! ? -1 : 1),
                            "likeIDs": !isLikeByMe!
                                ? FieldValue.arrayUnion([auth.currentUser!.uid])
                                : FieldValue.arrayRemove([auth.currentUser!.uid]),
                          });
                          // await fs.collection("Posts").doc(postID).collection("likes")
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
                          isLikeByMe! ? Assets.imagesHeartFull : Assets.imagesHeartEmpty,
                          height: 24.0,
                          color: isLikeByMe! ? Color(0xffe31b23) : kDarkBlueColor.withOpacity(0.60),
                        ),
                      ),
                      MyText(
                        text: likeCount!,
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
                        onTap: () async {
                          UserDetailsModel umdl = UserDetailsModel();
                          await fs.collection("Accounts").doc(postDocModel!.uID).get().then((value) {
                            umdl = UserDetailsModel.fromJson(value.data() ?? {});
                          });
                          await chatController.createChatRoomAndStartConversation(user1Model: userDetailsModel, user2Model: umdl);
                        },
                        child: Image.asset(
                          Assets.imagesComment,
                          height: 23.76,
                          color: kDarkBlueColor.withOpacity(0.60),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: fs.collection("Posts").doc(postID).collection("comments").snapshots(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          int previousCount = snapshot.data != null ? snapshot.data!.docs.length : 0;
                          log("inside stream-builder");
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            log("inside stream-builder in waiting state");
                            return MyText(
                              text: '$previousCount',
                              size: 18,
                              color: kDarkBlueColor.withOpacity(0.60),
                            );
                          } else if (snapshot.connectionState == ConnectionState.active ||
                              snapshot.connectionState == ConnectionState.done) {
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
                                // return ListView.builder(
                                //   // shrinkWrap: true,
                                //   physics: BouncingScrollPhysics(),
                                //   itemCount: snapshot.data!.docs.length,
                                //   itemBuilder: (BuildContext context, int index) {
                                //     AddPostModel addPostModel = AddPostModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                                //     log("addPostModel = ${addPostModel.toJson()}");
                                //     return ListView(
                                //       shrinkWrap: true,
                                //       physics: BouncingScrollPhysics(),
                                //       padding: EdgeInsets.symmetric(
                                //         vertical: 20,
                                //       ),
                                //       children: [
                                //         SizedBox(
                                //           height: 80,
                                //           child: ListView(
                                //             shrinkWrap: true,
                                //             scrollDirection: Axis.horizontal,
                                //             physics: const BouncingScrollPhysics(),
                                //             children: [
                                //               addStoryButton(context),
                                //               ListView.builder(
                                //                 shrinkWrap: true,
                                //                 scrollDirection: Axis.horizontal,
                                //                 itemCount: 6,
                                //                 padding: const EdgeInsets.only(
                                //                   right: 8,
                                //                 ),
                                //                 physics: const BouncingScrollPhysics(),
                                //                 itemBuilder: (context, index) {
                                //                   return stories(
                                //                     context,
                                //                     'assets/images/baby_shower.png',
                                //                     index.isOdd ? 'Khan' : 'Stephan',
                                //                     index,
                                //                   );
                                //                 },
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //         ListView.builder(
                                //           shrinkWrap: true,
                                //           physics: BouncingScrollPhysics(),
                                //           padding: EdgeInsets.symmetric(
                                //             vertical: 30,
                                //           ),
                                //           itemCount: 4,
                                //           itemBuilder: (context, index) {
                                //             return PostWidget(
                                //               profileImage: Assets.imagesDummyProfileImage,
                                //               name: 'Username',
                                //               postedTime: '11 feb',
                                //               title: 'It was a great event 😀',
                                //               isMyPost: index.isOdd ? true : false,
                                //               postImage: Assets.imagesPicnicKids,
                                //             );
                                //           },
                                //         ),
                                //       ],
                                //     );
                                //   },
                                //
                                // );
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
                      String shareLink = await DynamicLinkHandler.buildDynamicLink(
                        postImageUrl: postDocModel?.postImages![0] ?? "https://www.freeiconspng.com/uploads/no-image-icon-15.png",
                        postId: postDocModel!.postID ?? "",
                        postTitle: postDocModel!.postTitle ?? "No Title",
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
                        MyText(
                          text: '04',
                          size: 18,
                          color: kDarkBlueColor.withOpacity(0.60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
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
