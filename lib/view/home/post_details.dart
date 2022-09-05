import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/controller/home_controller/home_controller.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/comment_model/comment_model.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/dynamic_link_handler.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/edit_post.dart';
import 'package:vip_picnic/view/home/post_image_preview.dart';
import 'package:vip_picnic/view/profile/other_user_profile.dart';
import 'package:vip_picnic/view/widget/curved_header.dart';
import 'package:vip_picnic/view/widget/custom_popup.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';
import 'package:vip_picnic/view/widget/video_preview.dart';

// ignore: must_be_immutable
class PostDetails extends StatefulWidget {
  PostDetails({
    this.isLikeByMe = false,
    this.isMyPost = false,
    this.postDocModel,
  });

  bool? isLikeByMe;
  bool? isMyPost;
  AddPostModel? postDocModel;

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  Rx<AddPostModel> addPostModel = AddPostModel().obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? postDataListener;

  @override
  void initState() {
    // TODO: implement initState
    addPostModel.value = widget.postDocModel!;
    postDataListener = ffstore.collection(postsCollection).doc(widget.postDocModel!.postID).snapshots().listen((event) {
      addPostModel.value = AddPostModel.fromJson(event.data() ?? {});
      log("inside stream and addPostModel: ${addPostModel.toJson()}");
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (postDataListener != null) postDataListener?.cancel();
    log("after disposing post details listener");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.postDocModel!.postImages!.toString());
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverStack(
                  children: [
                    SliverAppBar(
                      centerTitle: true,
                      expandedHeight: 400,
                      elevation: 0,
                      leading: Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Image.asset(
                            Assets.imagesArrowBack,
                            height: 22.04,
                            color: kTertiaryColor,
                          ),
                        ),
                      ),
                      actions: [
                        widget.isMyPost!
                            ? PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 0,
                                      child: MyText(
                                        text: 'editPost'.tr,
                                        size: 14,
                                        color: kSecondaryColor,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: MyText(
                                        text: 'deletePost'.tr,
                                        size: 14,
                                        color: kSecondaryColor,
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 0) {
                                    log("onTap edit post clicked");
                                    Get.to(() => EditPost(postModel: addPostModel.value));
                                  } else if (value == 1) {
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
                                              List<String> imageUrlsList = widget.postDocModel?.postImages ?? [];
                                              List<String> videoUrlsList = widget.postDocModel?.postVideos ?? [];
                                              List<String> videoThumbnailsList =
                                                  widget.postDocModel?.thumbnailsUrls ?? [];
                                              Get.back();
                                              Get.back();
                                              // Get.back();
                                              Get.dialog(
                                                loading(),
                                              );
                                              await posts.doc(addPostModel.value.postID).delete();
                                              Get.back();
                                              // await posts.doc(addPostModel.value.postID).collection("comments").delete();
                                              // log("before starting image deletion: ${DateTime.now()}");
                                              imageUrlsList.forEach(
                                                (element) async {
                                                  // log("inside foreach before image deletion: ${DateTime.now()}");
                                                  await fstorage.refFromURL(element).delete();
                                                  // log("inside foreach after image deletion: ${DateTime.now()}");
                                                },
                                              );

                                              for (int i = 0; i < videoUrlsList.length; i++) {
                                                await fstorage.refFromURL(videoUrlsList[i]).delete();
                                                await fstorage.refFromURL(videoThumbnailsList[i]).delete();
                                              }

                                              // log("after foreach after deleting all images: ${DateTime.now()}");
                                            } catch (e) {
                                              print(e);
                                              showMsg(
                                                context: context,
                                                msg: "Something went wrong during post deletion. Please try again.",
                                              );
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
                                    //         List<String> imageUrlsList =
                                    //             widget.postDocModel
                                    //                     ?.postImages ??
                                    //                 [];
                                    //         Get.back();
                                    //         Get.back();
                                    //         Get.back();
                                    //         Get.dialog(loading());
                                    //         await posts
                                    //             .doc(
                                    //                 addPostModel.value.postID)
                                    //             .delete();
                                    //         Get.back();
                                    //         // await posts.doc(addPostModel.value.postID).collection("comments").delete();
                                    //         imageUrlsList
                                    //             .forEach((element) async {
                                    //           await fstorage
                                    //               .refFromURL(element)
                                    //               .delete();
                                    //         });
                                    //       } catch (e) {
                                    //         print(e);
                                    //         showMsg(
                                    //             context: context,
                                    //             msg:
                                    //                 "Something went wrong during post deletion. Please try again.");
                                    //         log("error in post deletion $e");
                                    //       }
                                    //     });
                                  }
                                },
                                child: Icon(
                                  Icons.more_vert,
                                  color: kDarkBlueColor.withOpacity(0.60),
                                  size: 30,
                                ),
                              )
                            : SizedBox(),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            widget.postDocModel?.postImages?.length == 0
                                ? Center(
                                    child: MyText(
                                      text: "${widget.postDocModel?.postTitle}",
                                      size: 16,
                                      paddingLeft: 15,
                                      paddingRight: 15,
                                      maxLines: 8,
                                      overFlow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : PageView.builder(
                                    onPageChanged: (index) => homeController.getCurrentPostIndex(index),
                                    itemCount: (widget.postDocModel?.postImages?.length ?? 0) +
                                        (widget.postDocModel?.postVideos?.length ?? 0),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if ((widget.postDocModel?.postImages?.length ?? 0) > 0 &&
                                          index < (widget.postDocModel?.postImages?.length ?? 0)) {
                                        return GestureDetector(
                                          onTap: () => Get.to(
                                            () => PostImagePreview(
                                              imageUrl: widget.postDocModel!.postImages![index],
                                            ),
                                          ),
                                          child: Image.network(
                                            widget.postDocModel?.postImages![index] ?? "",
                                            height: height(context, 1.0),
                                            width: width(context, 1.0),
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace,
                                            ) {
                                              return const Text('Error');
                                            },
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return loading();
                                              }
                                            },
                                          ),
                                        );
                                      } else {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16),
                                                child: Image.network(
                                                  widget.postDocModel?.thumbnailsUrls![
                                                          index - (widget.postDocModel?.postImages?.length ?? 0)] ??
                                                      "",
                                                  height: Get.height,
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
                                            // Container(
                                            //   height: Get.height,
                                            //   width: Get.width,
                                            //   child: ClipRRect(
                                            //     borderRadius: BorderRadius.circular(8),
                                            //     child: Image.network(
                                            //       widget.postDocModel?.thumbnailsUrls![index - (widget.postImage?.length ?? 0)] ?? "",
                                            //       height: Get.height,
                                            //       fit: BoxFit.cover,
                                            //       errorBuilder: (
                                            //           BuildContext context,
                                            //           Object exception,
                                            //           StackTrace? stackTrace,
                                            //           ) {
                                            //         return const Text(' ');
                                            //       },
                                            //       loadingBuilder: (context, child, loadingProgress) {
                                            //         if (loadingProgress == null) {
                                            //           return child;
                                            //         } else {
                                            //           return loading();
                                            //         }
                                            //       },
                                            //     ),
                                            //   ),
                                            // ),
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
                                                      Get.to(() => VideoPreview(
                                                            videoUrl: widget.postDocModel?.postVideos![
                                                                index - (widget.postDocModel?.postImages?.length ?? 0)],
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
                                          ],
                                        );
                                      }
                                    },
                                  ),
                            (widget.postDocModel?.postImages?.length ?? 0) +
                                            (widget.postDocModel?.postVideos?.length ?? 0) ==
                                        1 ||
                                    (widget.postDocModel?.postImages?.length ?? 0) +
                                            (widget.postDocModel?.postVideos?.length ?? 0) ==
                                        0
                                ? SizedBox()
                                : Obx(
                                    () {
                                      return Positioned(
                                        top: 50,
                                        right: 10,
                                        child: Container(
                                          height: 35,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: kSecondaryColor.withOpacity(0.5),
                                          ),
                                          child: Center(
                                            child: MyText(
                                              text: '${homeController.currentPost.value + 1}/'
                                                  '${(widget.postDocModel?.postImages?.length ?? 0) + (widget.postDocModel?.postVideos?.length ?? 0)}',
                                              size: 15,
                                              weight: FontWeight.w600,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            // Image.asset(
                            //   Assets.imagesGradientEffectTwo,
                            //   height: height(context, 1.0),
                            //   width: width(context, 1.0),
                            //   fit: BoxFit.cover,
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 390,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: kBlackColor.withOpacity(0.16),
                              blurRadius: 6,
                              offset: Offset(-0, -6),
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 30.0,
                          children: [
                            // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            //   stream: fs.collection(postsCollection).doc(postDocModel!.postID).snapshots(),
                            //   builder: (
                            //       BuildContext context,
                            //       AsyncSnapshot<DocumentSnapshot> snapshot,
                            //       ) {
                            //     int? previousCount = 0;
                            //     log("inside stream-builder");
                            //     if (snapshot.connectionState == ConnectionState.waiting) {
                            //       log("inside stream-builder in waiting state");
                            //       return MyText(
                            //         text: '$previousCount',
                            //         size: 18,
                            //         color: kDarkBlueColor.withOpacity(0.60),
                            //       );
                            //     } else if (snapshot.connectionState == ConnectionState.active ||
                            //         snapshot.connectionState == ConnectionState.done) {
                            //       if (snapshot.hasError) {
                            //         return MyText(
                            //           text: '0',
                            //           size: 18,
                            //           color: kDarkBlueColor.withOpacity(0.60),
                            //         );
                            //       } else if (snapshot.hasData) {
                            //         // log("inside hasData and ${snapshot.data!.docs}");
                            //         if (snapshot.data!.exists) {
                            //           AddPostModel addPostModel = AddPostModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                            //           previousCount = addPostModel.likeCount;
                            //           return MyText(
                            //             text: snapshot.data!.docs.length,
                            //             size: 18,
                            //             color: kDarkBlueColor.withOpacity(0.60),
                            //           );
                            //           // return ListView.builder(
                            //           //   // shrinkWrap: true,
                            //           //   physics: BouncingScrollPhysics(),
                            //           //   itemCount: snapshot.data!.docs.length,
                            //           //   itemBuilder: (BuildContext context, int index) {
                            //           //     AddPostModel addPostModel = AddPostModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                            //           //     log("addPostModel = ${addPostModel.toJson()}");
                            //           //     return ListView(
                            //           //       shrinkWrap: true,
                            //           //       physics: BouncingScrollPhysics(),
                            //           //       padding: EdgeInsets.symmetric(
                            //           //         vertical: 20,
                            //           //       ),
                            //           //       children: [
                            //           //         SizedBox(
                            //           //           height: 80,
                            //           //           child: ListView(
                            //           //             shrinkWrap: true,
                            //           //             scrollDirection: Axis.horizontal,
                            //           //             physics: const BouncingScrollPhysics(),
                            //           //             children: [
                            //           //               addStoryButton(context),
                            //           //               ListView.builder(
                            //           //                 shrinkWrap: true,
                            //           //                 scrollDirection: Axis.horizontal,
                            //           //                 itemCount: 6,
                            //           //                 padding: const EdgeInsets.only(
                            //           //                   right: 8,
                            //           //                 ),
                            //           //                 physics: const BouncingScrollPhysics(),
                            //           //                 itemBuilder: (context, index) {
                            //           //                   return stories(
                            //           //                     context,
                            //           //                     'assets/images/baby_shower.png',
                            //           //                     index.isOdd ? 'Khan' : 'Stephan',
                            //           //                     index,
                            //           //                   );
                            //           //                 },
                            //           //               ),
                            //           //             ],
                            //           //           ),
                            //           //         ),
                            //           //         ListView.builder(
                            //           //           shrinkWrap: true,
                            //           //           physics: BouncingScrollPhysics(),
                            //           //           padding: EdgeInsets.symmetric(
                            //           //             vertical: 30,
                            //           //           ),
                            //           //           itemCount: 4,
                            //           //           itemBuilder: (context, index) {
                            //           //             return PostWidget(
                            //           //               profileImage: Assets.imagesDummyProfileImage,
                            //           //               name: 'Username',
                            //           //               postedTime: '11 feb',
                            //           //               title: 'It was a great event 😀',
                            //           //               isMyPost: index.isOdd ? true : false,
                            //           //               postImage: Assets.imagesPicnicKids,
                            //           //             );
                            //           //           },
                            //           //         ),
                            //           //       ],
                            //           //     );
                            //           //   },
                            //           //
                            //           // );
                            //         } else {
                            //           return MyText(
                            //             text: '0',
                            //             size: 18,
                            //             color: kDarkBlueColor.withOpacity(0.60),
                            //           );
                            //         }
                            //       } else {
                            //         log("in else of hasData done and: ${snapshot.connectionState} and"
                            //             " snapshot.hasData: ${snapshot.hasData}");
                            //         return MyText(
                            //           text: '0',
                            //           size: 18,
                            //           color: kDarkBlueColor.withOpacity(0.60),
                            //         );
                            //       }
                            //     } else {
                            //       log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                            //       return MyText(
                            //         text: '0',
                            //         size: 18,
                            //         color: kDarkBlueColor.withOpacity(0.60),
                            //       );
                            //     }
                            //   },
                            // ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10.0,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await ffstore.collection(postsCollection).doc(widget.postDocModel!.postID).update({
                                      "likeCount": FieldValue.increment(widget.isLikeByMe! ? -1 : 1),
                                      "likeIDs":
                                          !addPostModel.value.likeIDs!.asMap().containsValue(auth.currentUser!.uid)
                                              ? FieldValue.arrayUnion([auth.currentUser!.uid])
                                              : FieldValue.arrayRemove([auth.currentUser!.uid]),
                                    });
                                  },
                                  child: Obx(() {
                                    return Image.asset(
                                      addPostModel.value.likeIDs!.asMap().containsValue(auth.currentUser!.uid)
                                          ? Assets.imagesHeartFull
                                          : Assets.imagesHeartEmpty,
                                      height: 24.0,
                                      color: addPostModel.value.likeIDs!.asMap().containsValue(auth.currentUser!.uid)
                                          ? Color(0xffe31b23)
                                          : kDarkBlueColor.withOpacity(0.60),
                                    );
                                  }),
                                ),
                                Obx(() {
                                  return MyText(
                                    text: addPostModel.value.likeIDs!.length,
                                    size: 18,
                                    color: kDarkBlueColor.withOpacity(0.60),
                                  );
                                }),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10.0,
                              children: [
                                Image.asset(
                                  Assets.imagesComment,
                                  height: 23.76,
                                  color: kDarkBlueColor.withOpacity(0.60),
                                ),
                                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                  stream: ffstore
                                      .collection(postsCollection)
                                      .doc(widget.postDocModel!.postID)
                                      .collection("comments")
                                      .snapshots(),
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot,
                                  ) {
                                    int previousCount = 0;
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
                                          text: '0',
                                          size: 18,
                                          color: kDarkBlueColor.withOpacity(0.60),
                                        );
                                      } else if (snapshot.hasData) {
                                        if (snapshot.data!.docs.length > 0) {
                                          previousCount = snapshot.data!.docs.length;
                                          return MyText(
                                            text: snapshot.data!.docs.length,
                                            size: 18,
                                            color: kDarkBlueColor.withOpacity(0.60),
                                          );
                                        } else {
                                          return MyText(
                                            text: '0',
                                            size: 18,
                                            color: kDarkBlueColor.withOpacity(0.60),
                                          );
                                        }
                                      } else {
                                        log("in else of hasData done and: ${snapshot.connectionState} and"
                                            " snapshot.hasData: ${snapshot.hasData}");
                                        return MyText(
                                          text: '0',
                                          size: 18,
                                          color: kDarkBlueColor.withOpacity(0.60),
                                        );
                                      }
                                    } else {
                                      log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                                      return MyText(
                                        text: '0',
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
                                String shareLink = await DynamicLinkHandler.buildDynamicLinkForPost(
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
                    ),
                  ],
                ),
              ];
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: ffstore
                        .collection(postsCollection)
                        .doc(widget.postDocModel!.postID)
                        .collection("comments")
                        .orderBy("createdAtMilliSeconds", descending: true)
                        .snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      log("inside stream-builder");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        log("inside stream-builder in waiting state");
                        return const Center(child: Text('Loading...'));
                      } else if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('No Comments Yet'));
                        } else if (snapshot.hasData) {
                          // log("inside hasData and ${snapshot.data!.docs}");
                          if (snapshot.data!.docs.length > 0) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                CommentModel cmdl =
                                    CommentModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                                return CommentsTiles(
                                  profileImage: cmdl.commenterImage,
                                  name: cmdl.commenterName,
                                  commentDocId: snapshot.data?.docs[index].id,
                                  postDocId: widget.postDocModel?.postID,
                                  commenterId: cmdl.commenterID,
                                  comment: cmdl.commentText,
                                );
                              },
                            );
                          } else {
                            return const Center(child: Text('No Comments Yet'));
                          }
                        } else {
                          log("in else of hasData done and: ${snapshot.connectionState} and"
                              " snapshot.hasData: ${snapshot.hasData}");
                          return const Center(child: Text('No Comments Yet'));
                        }
                      } else {
                        log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                        return const Center(child: Text('Loading...'));
                      }
                    },
                  ),
                ),
              ],
            ),
            scrollBehavior: ScrollBehavior(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              commentField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget commentField() {
    TextEditingController commentController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      color: kPrimaryColor,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: kSecondaryColor,
              controller: commentController,
              cursorWidth: 1.0,
              style: TextStyle(
                fontSize: 15,
                color: kSecondaryColor,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: kSecondaryColor,
                ),
                hintText: 'Write a message...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                fillColor: kLightBlueColor,
                filled: true,
                // prefixIcon: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () {},
                //       child: Image.asset(
                //         Assets.imagesEmoji,
                //         height: 19.31,
                //       ),
                //     ),
                //   ],
                // ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () async {
              var commentText = commentController.text.trim();
              commentController.clear();
              CommentModel cmdl = CommentModel(
                commentCount: 0,
                commentText: commentText,
                commenterID: auth.currentUser!.uid,
                commenterImage: userDetailsModel.profileImageUrl ?? "",
                commenterName: userDetailsModel.fullName ?? "",
                createdAt: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
                createdAtMilliSeconds: DateTime.now().millisecondsSinceEpoch,
                likeCount: 0,
                likeIDs: [],
                postID: addPostModel.value.postID,
              );
              await ffstore
                  .collection(postsCollection)
                  .doc(widget.postDocModel!.postID)
                  .collection("comments")
                  .add(cmdl.toJson());
            },
            child: Image.asset(
              Assets.imagesSend,
              height: 45.16,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CommentsTiles extends StatelessWidget {
  CommentsTiles({
    Key? key,
    this.profileImage,
    this.comment,
    this.commenterId,
    this.postDocId,
    this.commentDocId,
    this.name,
  }) : super(key: key);

  String? profileImage, comment, name, commenterId, postDocId, commentDocId;
  RxBool isBeingEdited = false.obs;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: Obx(() {
              return ListTile(
                //+open other user profile from here
                onTap: () async {
                  // UserDetailsModel otherUser = UserDetailsModel();
                  // loading();
                  try {
                    await ffstore.collection(accountsCollection).doc(commenterId).get().then(
                      (value) {
                        UserDetailsModel otherUser = UserDetailsModel.fromJson(value.data() ?? {});
                        Get.to(() => OtherUserProfile(otherUserModel: otherUser));
                      },
                    );
                  } catch (e) {
                    print(e);
                  }
                  // navigatorKey.currentState!.pop();
                },
                leading: Container(
                  height: 44.45,
                  width: 44.45,
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
                      ),
                    ),
                  ),
                ),
                title: MyText(
                  text: '$name',
                  size: 16,
                  weight: FontWeight.w600,
                  color: kSecondaryColor,
                ),
                subtitle: isBeingEdited.value
                    ? TextField(
                        cursorColor: kSecondaryColor,
                        controller: commentController,
                        cursorWidth: 1.0,
                        style: TextStyle(
                          fontSize: 14,
                          color: kSecondaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kSecondaryColor,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kSecondaryColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      )
                    : MyText(
                        text: '$comment',
                        size: 14,
                        color: kSecondaryColor,
                        paddingTop: 4,
                      ),
                trailing: commenterId == auth.currentUser?.uid
                    ? Wrap(
                  spacing: 13,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isBeingEdited.value
                          ?  () async {
                        isBeingEdited.value = false;
                        await ffstore.collection(postsCollection).doc(postDocId).collection(commentsCollection)
                            .doc(commentDocId).update({"commentText": commentController.text.trim()});
                      } : () {
                        commentController.text = comment ?? "";
                        isBeingEdited.value = true;
                      },
                      child: isBeingEdited.value
                          ? Image.asset(
                              Assets.imagesSend,
                              height: 30,
                            )
                          : Image.asset(
                              Assets.imagesEditIcon,
                              height: 18,
                            ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await ffstore.collection(postsCollection).doc(postDocId).collection(commentsCollection).doc(commentDocId).delete();
                      },
                      child: Image.asset(
                        Assets.imagesDeleteMsg,
                        height: 20,
                      ),
                    ),
                  ],
                )
                    : SizedBox(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
