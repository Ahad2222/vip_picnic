import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/my_posts.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 570,
              centerTitle: true,
              pinned: true,
              toolbarHeight: 75,
              backgroundColor: kPrimaryColor,
              floating: false,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Image.asset(
                  Assets.imagesArrowBack,
                  height: 22.04,
                ),
              ),
              title: MyText(
                text: 'profile'.tr,
                size: 20,
                color: kSecondaryColor,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    profileImage(context),
                    MyText(
                      text: userDetailsModel.fullName,
                      size: 20,
                      weight: FontWeight.w600,
                      color: kSecondaryColor,
                      align: TextAlign.center,
                      paddingTop: 15,
                    ),
                    MyText(
                      text: '@Username',
                      color: kSecondaryColor,
                      align: TextAlign.center,
                      paddingTop: 5,
                      paddingBottom: 30,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 30.0,
                      children: [
                        eventFollowingFollower(
                          count: 20,
                          title: 'events'.tr,
                        ),
                        Container(
                          height: 15,
                          width: 1,
                          color: kSecondaryColor,
                        ),
                        eventFollowingFollower(
                          count: 563,
                          title: 'following'.tr,
                        ),
                        Container(
                          height: 15,
                          width: 1,
                          color: kSecondaryColor,
                        ),
                        eventFollowingFollower(
                          count: 15,
                          title: 'followers'.tr,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profileButtons(
                          buttonText: 'editAccount'.tr,
                          onTap: () => Get.toNamed(
                            AppLinks.editProfile,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        profileButtons(
                          buttonText: 'yourPost'.tr,
                          onTap: () => Get.to(
                            () => MyPosts(),
                          ),
                        ),
                      ],
                    ),
                    bioBox(
                      bio:
                          'Musician since 2018, available to new events. Love plant and planet 🌱',
                    ),
                  ],
                ),
                collapseMode: CollapseMode.none,
              ),
            ),
          ];
        },
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ffstore
              .collection("Posts")
              .where("uID", isEqualTo: auth.currentUser!.uid)
              .snapshots(),
          builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
            log("inside stream-builder");
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              log("inside stream-builder in waiting state");
              return noPostYet();
            } else if (snapshot.connectionState ==
                ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Some unknown error occurred');
              } else if (snapshot.hasData) {
                // log("inside hasData and ${snapshot.data!.docs}");
                if (snapshot.data!.docs.length > 0) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                      mainAxisExtent: 124,
                    ),
                    itemCount:snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        (snapshot.data!.docs[index].data() as Map<String, dynamic>)["postImages"][0],
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
                      );
                    },
                  );
                  //   ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: BouncingScrollPhysics(),
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 30,
                  //   ),
                  //   itemCount: snapshot.data!.docs.length,
                  //   itemBuilder: (context, index) {
                  //     AddPostModel addPostModel =
                  //     AddPostModel.fromJson(
                  //         snapshot.data!.docs[index].data()
                  //         as Map<String, dynamic>);
                  //     return PostWidget(
                  //       postDocModel: addPostModel,
                  //       postID: addPostModel.postID,
                  //       isLikeByMe: addPostModel.likeIDs!
                  //           .asMap()
                  //           .containsValue(auth.currentUser!.uid),
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
                log("in else of hasData done and: ${snapshot.connectionState} and"
                    " snapshot.hasData: ${snapshot.hasData}");
                return noPostYet();
              }
            } else {
              log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
              return noPostYet();
            }
          },
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

  Widget bioBox({
    String? bio,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kSecondaryColor.withOpacity(0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'bio'.tr,
            size: 16,
            weight: FontWeight.w600,
            color: kSecondaryColor,
            paddingBottom: 7,
          ),
          MyText(
            text: bio,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget profileButtons({
    String? buttonText,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: kBorderColor,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          splashColor: kSecondaryColor.withOpacity(0.05),
          highlightColor: kSecondaryColor.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Center(
              child: MyText(
                text: buttonText,
                color: kSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget eventFollowingFollower({
    String? title,
    int? count,
  }) {
    return Column(
      children: [
        MyText(
          text: count,
          size: 18,
          weight: FontWeight.w600,
          color: kSecondaryColor,
        ),
        MyText(
          text: title,
          size: 12,
          color: kSecondaryColor,
        )
      ],
    );
  }

  Widget profileImage(
    BuildContext context,
  ) {
    return Center(
      child: Container(
        height: 128,
        width: 128,
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
    );
  }
}
