import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/story_model/story_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/dynamic_link_handler.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/add_new_post.dart';
import 'package:vip_picnic/view/home/post_details.dart';
import 'package:vip_picnic/view/profile/other_user_profile.dart';
import 'package:vip_picnic/view/profile/profile.dart';
import 'package:vip_picnic/view/search_friends/search_friends.dart';
import 'package:vip_picnic/view/story/post_new_story.dart';
import 'package:vip_picnic/view/story/story.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/video_preview.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool hasMyStory = false;
  List<String> followsListToBeChunked = [];
  RxList<Stream<List<AddPostModel>>> chunckSizePostsStreamList = List<Stream<List<AddPostModel>>>.from([]).obs;
  RxList<Stream<List<StoryModel>>> chunckSizeStoriesStreamList = List<Stream<List<StoryModel>>>.from([]).obs;

  @override
  void initState() {
    // TODO: implement initState
    accounts.doc(auth.currentUser?.uid).snapshots().listen((event) {
      if (event.data() != null) {
        userDetailsModel = UserDetailsModel.fromJson(event.data() as Map<String, dynamic>);
        log("inside user data");
        followsListToBeChunked = [];
        followsListToBeChunked.addAll(userDetailsModel.iFollowed!);
        log("followsListToBeChunked = ${followsListToBeChunked}");
        chunckSizePostsStreamList.value = chunckSizePostsStream();
        log("chunckSizePostsStreamList.value returned : ${chunckSizePostsStreamList}");
        chunckSizeStoriesStreamList.value = chunckSizeStoriesStream();
        log("chunckSizePostsStreamList.value returned : ${chunckSizePostsStreamList}");
      }
    });

    super.initState();
  }

  List<Stream<List<AddPostModel>>> chunckSizePostsStream() {
    log("chunckSizePostsStream called");
    final List<List<String>> followersChunks = chunkSizeCollection(followsListToBeChunked);
    List<Stream<List<AddPostModel>>> streams = List<Stream<List<AddPostModel>>>.from([]);
    log("followersChunks: $followersChunks");
    followersChunks.forEach((chunck) => streams.add(ffstore
        .collection(postsCollection)
        .where("uID", whereIn: chunck)
        .orderBy("createdAtMilliSeconds", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => AddPostModel.fromJson(document.data())).toList(growable: false))));
    log("outside followersChunks before returning");
    log("sttreams:  $streams");
    return streams;
  }

  List<Stream<List<StoryModel>>> chunckSizeStoriesStream() {
    log("chunckSizeStoriesStream called");
    final List<List<String>> followersStoryChunks = chunkSizeCollection(followsListToBeChunked);
    List<Stream<List<StoryModel>>> streams = List<Stream<List<StoryModel>>>.from([]);
    log("followersChunks: $followersStoryChunks");
    followersStoryChunks.forEach((chunck) => streams.add(ffstore
        .collection("Stories")
        .where("storyPersonId", whereIn: chunck)
        .where("createdAt", isGreaterThan: DateTime.now().subtract(Duration(minutes: 1440)).millisecondsSinceEpoch)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((document) => StoryModel.fromJson(document.data())).toList(growable: false))));
    log("outside followersChunks before returning");
    log("sttreams:  $streams");
    return streams;
  }

  List<List<String>> chunkSizeCollection(List<String> followedList) {
    int counter = 0;
    int ongoingCounter = 0;
    bool isLessThanTen = false;
    List<List<String>> returnAbleChunkedList = [];
    List<String> midList = [];
    log("in followedlist");
    followedList.forEach((element) {
      if (counter == 0) {
        int difference = followedList.length - ongoingCounter;
        if (difference < 10) {
          // log("in difference if: $difference");
          isLessThanTen = true;
        }
      }
      midList.add(element);
      counter++;
      ongoingCounter++;
      if (counter == 10 || (isLessThanTen && ongoingCounter == followedList.length)) {
        returnAbleChunkedList.add(midList.toList());
        log("returnAbleChunkedList in counter 10 after adding new val is: $returnAbleChunkedList");
        midList.clear();
        counter = 0;
      }
    });
    log("returnAbleChunkedList: $returnAbleChunkedList before return");
    return returnAbleChunkedList;
  }

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
      //+ USE this part for the post and put a stream builder here
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.black,
        child: Column(
          children: [
            Container(
              height: 100,
              width: Get.width,
              child: Obx(() {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: chunckSizeStoriesStreamList.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<List<StoryModel>>(
                      stream: chunckSizeStoriesStreamList[index],
                      builder: (context, AsyncSnapshot<List<StoryModel>> snapshot) {
                        List<String> storyUser = [];
                        return Container(
                          height: Get.height,
                          width: Get.width,
                          color: Colors.blue,
                          child: ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              log("snapshot.data?.length: ${snapshot.data![index].storyPersonName}");
                              StoryModel storyModel = snapshot.data![index];
                              if (!storyUser.asMap().containsValue(storyModel.storyPersonId)) {
                                storyUser.add(storyModel.storyPersonId ?? "");
                                return GestureDetector(
                                  onTap: () => Get.to(
                                        () => Story(
                                      profileImage: storyModel.storyPersonImage,
                                      name: storyModel.storyPersonName,
                                      storyPersonId: storyModel.storyPersonId,
                                    ),
                                  ),
                                  child: stories(
                                    context,
                                    storyModel.storyPersonImage ?? "",
                                    storyModel.storyPersonId ?? "",
                                    storyModel.storyPersonName,
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                              //   Container(
                              //   height: 200,
                              //   width: Get.width,
                              //   color: Colors.pink,
                              // );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: chunckSizePostsStreamList.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<List<AddPostModel>>(
                      stream: chunckSizePostsStreamList[index],
                      builder: (context, AsyncSnapshot<List<AddPostModel>> snapshot) {
                        return Container(
                          height: Get.height,
                          width: Get.width,
                          color: Colors.blue,
                          child: ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              log("snapshot.data?.length: ${snapshot.data![index].postBy}");
                              AddPostModel addPostModel = snapshot.data![index];
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
                                postImage: addPostModel.postImages!,
                              );
                              //   Container(
                              //   height: 200,
                              //   width: Get.width,
                              //   color: Colors.pink,
                              // );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '',
        onPressed: () {
          homeController.selectedVideos.clear();
          homeController.videoIds.clear();
          homeController.selectedImages.clear();
          homeController.imagesToUpload.clear();
          homeController.thumbnailsUrls.clear();
          homeController.selectedVideosThumbnails.clear();
          homeController.descriptionCon.clear();
          homeController.tagCon.clear();
          homeController.locationCon.clear();
          homeController.taggedPeople = [];
          Navigator.pushNamed(context, AppLinks.addNewPost);
        },
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

  Widget stories(
    BuildContext context,
    String profileImage,
    String userId,
    name,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
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
                child: Image.network(
                  profileImage,
                  height: 47,
                  width: 47,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          MyText(
            text: userId == auth.currentUser?.uid ? "My Story" : name,
            size: 12,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ],
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
    this.isMyPost = false,
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
  List<String> monthList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

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
                            await ffstore.collection(accountsCollection).doc(widget.postDocModel!.uID).get().then(
                              (value) {
                                otherUser = UserDetailsModel.fromJson(value.data() ?? {});
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
                                loadingBuilder: (context, child, loadingProgress) {
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
                          await ffstore.collection(accountsCollection).doc(widget.postDocModel!.uID).get().then(
                            (value) {
                              otherUser = UserDetailsModel.fromJson(value.data() ?? {});
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
                        text: widget.isMyPost! ? 'yourPost'.tr : '${widget.name}',
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
                              onTap: () => Get.to(
                                () => AddNewPost(
                                  editPost: true,
                                  postImage: widget.postImage![0],
                                  title: widget.title,
                                ),
                              ),
                              child: MyText(
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
            ),
            GestureDetector(
              onTap: () => Get.to(
                () => PostDetails(
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
                  (widget.postDocModel?.postImages?.length ?? 0) > 0 ||
                          (widget.postDocModel?.postVideos?.length ?? 0) > 0
                      ? SizedBox(
                          height: 220,
                          child: Stack(
                            children: [
                              PageView.builder(
                                onPageChanged: (index) {
                                  currentPost.value = index;
                                  // homeController.getCurrentPostIndex(index);
                                },
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    (widget.postImage?.length ?? 0) + (widget.postDocModel?.postVideos?.length ?? 0),
                                itemBuilder: (context, index) {
                                  if ((widget.postImage?.length ?? 0) > 0 && index < (widget.postImage?.length ?? 0)) {
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
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return loading();
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    //+ this would be executed when there are no images
                                    //+ or images are there and index is out of their range.
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
                                              widget.postDocModel
                                                      ?.thumbnailsUrls![index - (widget.postImage?.length ?? 0)] ??
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
                                                        videoUrl: widget.postDocModel
                                                            ?.postVideos![index - (widget.postImage?.length ?? 0)],
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
                                        // Positioned(
                                        //   top: 10,
                                        //   right: 10,
                                        //   child: GestureDetector(
                                        //     onTap: () => homeController.removeVideo(0),
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
                                      ],
                                    );
                                  }
                                },
                              ),
                              (widget.postImage?.length ?? 0) + (widget.postDocModel?.postVideos?.length ?? 0) == 1
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
                                              text: '${currentPost.value + 1}/'
                                                  '${(widget.postImage?.length ?? 0) + (widget.postDocModel?.postVideos?.length ?? 0)}',
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
                        )
                      : SizedBox(),
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
                          await ffstore.collection(postsCollection).doc(widget.postID).update(
                            {
                              "likeCount": FieldValue.increment(widget.isLikeByMe! ? -1 : 1),
                              "likeIDs": !widget.isLikeByMe!
                                  ? FieldValue.arrayUnion([auth.currentUser!.uid])
                                  : FieldValue.arrayRemove([auth.currentUser!.uid]),
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
                          widget.isLikeByMe! ? Assets.imagesHeartFull : Assets.imagesHeartEmpty,
                          height: 24.0,
                          color: widget.isLikeByMe! ? Color(0xffe31b23) : kDarkBlueColor.withOpacity(0.60),
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
                        stream:
                            ffstore.collection(postsCollection).doc(widget.postID).collection("comments").snapshots(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          int previousCount = snapshot.data != null ? snapshot.data!.docs.length : 0;
                          //log("inside stream-builder");
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
                      Get.dialog(loading());
                      log("after log in sharing");
                      String shareLink = await DynamicLinkHandler.buildDynamicLinkForPost(
                        postImageUrl: (widget.postDocModel?.postImages?.length ?? 0) != 0
                            ? widget.postDocModel?.postImages![0] ??
                                "https://www.freeiconspng.com/uploads/no-image-icon-15.png"
                            : (widget.postDocModel?.thumbnailsUrls?.length ?? 0) != 0
                                ? widget.postDocModel?.thumbnailsUrls![0] ??
                                    "https://www.freeiconspng.com/uploads/no-image-icon-15.png"
                                : "https://www.freeiconspng.com/uploads/no-image-icon-15.png",
                        postId: widget.postDocModel!.postID ?? "",
                        postTitle: widget.postDocModel!.postTitle ?? "No Title",
                        short: true,
                      );
                      log("fetched shareLink: $shareLink");
                      ShareResult sr = await Share.shareWithResult(shareLink);
                      Get.back();
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
