import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/story_model/story_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/story/story.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class EditStory extends StatefulWidget {
  @override
  State<EditStory> createState() => _EditStoryState();
}

class _EditStoryState extends State<EditStory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => Story(
              profileImage: userDetailsModel.profileImageUrl,
              name: userDetailsModel.fullName,
              storyPersonId: userDetailsModel.uID,
            ));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: IconButton(
              onPressed: () {
                Get.off(() => Story(
                      profileImage: userDetailsModel.profileImageUrl,
                      name: userDetailsModel.fullName,
                      storyPersonId: userDetailsModel.uID,
                    ));
              },
              icon: Image.asset(
                Assets.imagesArrowBack,
                height: 22.04,
              ),
            ),
          ),
          title: MyText(
            text: "Your Stories",
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ffstore
              .collection("Stories")
              .where("storyPersonId", isEqualTo: auth.currentUser?.uid)
              .where("createdAt",
                  isGreaterThan: DateTime.now().subtract(Duration(minutes: 1440)).millisecondsSinceEpoch)
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            // List<String> storyUser = [];
            // //log("inside stream-builder");
            if (snapshot.connectionState == ConnectionState.waiting) {
              // log("inside stream-builder in waiting state");
              return const SizedBox();
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const SizedBox();
              } else if (snapshot.hasData) {
                // log("inside hasData and ${snapshot.data!.docs}");
                if (snapshot.data!.docs.length > 0) {
                  // hasMyStory = true;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      StoryModel storyModel =
                          StoryModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                      return SearchTiles(
                        storyModel: storyModel,
                        profileImage: storyModel.storyImage,
                        docId: snapshot.data?.docs[index].id,
                        time: storyModel.createdAt,
                        name: storyModel.storyPersonName,
                        type: storyModel.mediaType,
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                // log("in else of hasData done and: ${snapshot.connectionState} and"
                //     " snapshot.hasData: ${snapshot.hasData}");
                return const SizedBox();
              }
            } else {
              // log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
              return const SizedBox();
            }
          },
        ),
        // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //   stream: ffstore
        //       .collection("Stories")
        //       .where("storyPersonId", isEqualTo: auth.currentUser?.uid)
        //       .where("createdAt",
        //       isGreaterThan:
        //       DateTime.now().subtract(Duration(minutes: 1440)).millisecondsSinceEpoch)
        //       .orderBy("createdAt", descending: true)
        //       .snapshots(),
        //   builder: (
        //       BuildContext context,
        //       AsyncSnapshot<QuerySnapshot> snapshot,
        //       ) {
        //     // //log("inside stream-builder");
        //     // log(userDetailsModel.profileImageUrl!);
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       // log("inside stream-builder in waiting state");
        //       return Center(child: const Text('No Users Found'));
        //     } else if (snapshot.connectionState == ConnectionState.active ||
        //         snapshot.connectionState == ConnectionState.done) {
        //       if (snapshot.hasError) {
        //         return const Text('Some unknown error occurred');
        //       } else if (snapshot.hasData) {
        //         // log("inside hasData and ${snapshot.data!.docs}");
        //         if (snapshot.data!.exists) {
        //           userDetailsModel = UserDetailsModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
        //           // var theyFollowedListToBeChecked =
        //           // userDetailsModel.TheyFollowed!.length > 0 ? userDetailsModel.TheyFollowed : ["something"];
        //           // followedListToBeChecked?.add(auth.currentUser?.uid ?? "");
        //           return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //             stream: ffstore.collection(accountsCollection).doc(auth.currentUser?.uid)
        //                 .collection(theyFollowedCollection).snapshots(),
        //             builder: (
        //                 BuildContext context,
        //                 AsyncSnapshot<QuerySnapshot> snapshot,
        //                 ) {
        //               //log("inside stream-builder");
        //               if (snapshot.connectionState == ConnectionState.waiting) {
        //                 log("inside stream-builder in waiting state");
        //                 return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kTertiaryColor)));
        //               } else if (snapshot.connectionState == ConnectionState.active ||
        //                   snapshot.connectionState == ConnectionState.done) {
        //                 if (snapshot.hasError) {
        //                   return const Text('Some unknown error occurred');
        //                 } else if (snapshot.hasData) {
        //                   // log("inside hasData and ${snapshot.data!.docs}");
        //                   if (snapshot.data!.docs.length > 0) {
        //                     return ListView.builder(
        //                       // shrinkWrap: true,
        //                       physics: BouncingScrollPhysics(),
        //                       padding: EdgeInsets.symmetric(
        //                         vertical: 20,
        //                       ),
        //                       itemCount: snapshot.data!.docs.length,
        //                       itemBuilder: (context, index) {
        //                         TheyFollowedModel umdl =
        //                         TheyFollowedModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
        //                         return GestureDetector(
        //                           onTap: () async {
        //                             await ffstore.collection(accountsCollection).doc(umdl.followerId).get().then((value) {
        //                               UserDetailsModel otherUserDetailsModel = UserDetailsModel.fromJson(value.data() ?? {});
        //                               Get.to(() => OtherUserProfile(otherUserModel: otherUserDetailsModel));
        //                             });
        //                           },
        //                           child: SearchTiles(
        //                             umdl: umdl,
        //                             profileImage: umdl.followerImageUrl,
        //                             name: umdl.followerName,
        //                             isFollowed: userDetailsModel.iFollowed != null
        //                                 ? userDetailsModel.iFollowed!.asMap().containsValue(umdl.followerId)
        //                                 ? true
        //                                 : false
        //                                 : false,
        //                           ),
        //                         );
        //                       },
        //                     );
        //                   } else {
        //                     return Center(child: const Text('No Users Found'));
        //                   }
        //                 } else {
        //                   log("in else of hasData done and: ${snapshot.connectionState} and"
        //                       " snapshot.hasData: ${snapshot.hasData}");
        //                   return Center(child: const Text('No Users Found'));
        //                 }
        //               } else {
        //                 log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
        //                 return Center(child: Text('Some Error occurred while fetching the posts'));
        //               }
        //             },
        //           );
        //
        //         } else {
        //           return Center(child: const Text('No Users Found'));
        //
        //         }
        //       } else {
        //         // log("in else of hasData done and: ${snapshot.connectionState} and"
        //         //     " snapshot.hasData: ${snapshot.hasData}");
        //         return Center(child: const Text('No Users Found'));
        //
        //       }
        //     } else {
        //       log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
        //       return Center(child: const Text('No Users Found'));
        //
        //     }
        //   },
        // ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchTiles extends StatelessWidget {
  SearchTiles({
    Key? key,
    this.storyModel,
    this.profileImage,
    this.name,
    this.type,
    this.time,
    this.docId,
  }) : super(key: key);

  String? profileImage, name, docId, type;
  StoryModel? storyModel = StoryModel();
  int? time = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      // height: 50,
      // width: Get.width,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Container(
                height: 38.81,
                width: 38.81,
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
                      storyModel?.mediaType == "Caption" ? userDetailsModel.profileImageUrl ?? "" : profileImage ?? "",
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
              title: MyText(
                text: 'Your story',
                size: 15,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              subtitle: MyText(
                text:
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(time ?? DateTime.now().millisecondsSinceEpoch)),
                size: 10,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: kBorderColor,
                        width: 1.0,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          Get.dialog(loading());
                          if (storyModel?.mediaType == "Image" || storyModel?.mediaType == "ImageWithCaption") {
                            String? url = storyModel?.storyImage ?? "";
                            await ffstore.collection(storiesCollection).doc(docId).delete();
                            Get.back();
                            await fstorage.refFromURL(url).delete();
                          } else if (storyModel?.mediaType == "Video" || storyModel?.mediaType == "VideoWithCaption") {
                            String? url = storyModel?.storyVideo ?? "";
                            String? thumbnailUrl = storyModel?.storyImage ?? "";
                            await ffstore.collection(storiesCollection).doc(docId).delete();
                            Get.back();
                            await fstorage.refFromURL(url).delete();
                            await fstorage.refFromURL(thumbnailUrl).delete();
                          } else {
                            await ffstore.collection(storiesCollection).doc(docId).delete();
                            Get.back();
                          }
                        },
                        borderRadius: BorderRadius.circular(4),
                        splashColor: kSecondaryColor.withOpacity(0.05),
                        highlightColor: kSecondaryColor.withOpacity(0.05),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 3,
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: kBorderColor.withOpacity(0.5),
            margin: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
          ),
        ],
      ),
    );
  }
}
