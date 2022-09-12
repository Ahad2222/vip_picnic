import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/i_followed_model/i_followed_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/profile/other_user_profile.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class Following extends StatefulWidget {
  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  //+ close this stream on dispose and also remove this stateless widget when your users stream is globally accessible
  //+ without any issues

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userDetailsModelStream;

  @override
  void initState() {
    // TODO: implement initState
    userDetailsModelStream =
        ffstore.collection(accountsCollection).doc(auth.currentUser!.uid).snapshots().listen((event) {
          userDetailsModel = UserDetailsModel.fromJson(event.data() ?? {});
          // setState(() {});
        });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    log("onDispose of search page is called");
    if (userDetailsModelStream != null) userDetailsModelStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 5,
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset(
              Assets.imagesArrowBack,
              height: 22.04,
            ),
          ),
        ),
        title: MyText(
          text: "Your Followers",
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: ffstore.collection(accountsCollection).doc(auth.currentUser!.uid).snapshots(),
        builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
            ) {
          // //log("inside stream-builder");
          // log(userDetailsModel.profileImageUrl!);
          if (snapshot.connectionState == ConnectionState.waiting) {
            // log("inside stream-builder in waiting state");
            return Center(child: const Text('No Users Found'));
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Some unknown error occurred');
            } else if (snapshot.hasData) {
              // log("inside hasData and ${snapshot.data!.docs}");
              if (snapshot.data!.exists) {
                userDetailsModel = UserDetailsModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                // var theyFollowedListToBeChecked =
                // userDetailsModel.TheyFollowed!.length > 0 ? userDetailsModel.TheyFollowed : ["something"];
                // followedListToBeChecked?.add(auth.currentUser?.uid ?? "");
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: ffstore.collection(accountsCollection).doc(auth.currentUser?.uid)
                      .collection(iFollowedCollection).snapshots(),
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                    //log("inside stream-builder");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      log("inside stream-builder in waiting state");
                      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kTertiaryColor)));
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
                              IFollowedModel umdl =
                              IFollowedModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                              return GestureDetector(
                                onTap: () async {
                                  await ffstore.collection(accountsCollection).doc(umdl.followedId).get().then((value) {
                                    UserDetailsModel otherUserDetailsModel = UserDetailsModel.fromJson(value.data() ?? {});
                                    Get.to(() => OtherUserProfile(otherUserModel: otherUserDetailsModel));
                                  });
                                },
                                child: SearchTiles(
                                  umdl: umdl,
                                  profileImage: umdl.followedImage,
                                  name: umdl.followedName,
                                  isFollowed: userDetailsModel.iFollowed != null
                                      ? userDetailsModel.iFollowed!.asMap().containsValue(umdl.followedId)
                                      ? true
                                      : false
                                      : false,
                                ),
                              );
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

              } else {
                return Center(child: const Text('No Users Found'));

              }
            } else {
              // log("in else of hasData done and: ${snapshot.connectionState} and"
              //     " snapshot.hasData: ${snapshot.hasData}");
              return Center(child: const Text('No Users Found'));

            }
          } else {
            log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
            return Center(child: const Text('No Users Found'));

          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchTiles extends StatelessWidget {
  SearchTiles({
    Key? key,
    this.umdl,
    this.profileImage,
    this.name,
    this.isFollowed = false,
  }) : super(key: key);

  String? profileImage, name;
  bool? isFollowed;
  IFollowedModel? umdl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
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
                      profileImage ?? "",
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
                text: '$name',
                size: 15,
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
                        onTap: !isFollowed!
                            ? () async {
                          await ffstore.collection(accountsCollection).doc(auth.currentUser!.uid).update({
                            "iFollowed": FieldValue.arrayUnion([umdl!.followedId]),
                          });
                          await ffstore.collection(accountsCollection).doc(umdl!.followedId).update({
                            "TheyFollowed": FieldValue.arrayUnion([auth.currentUser!.uid]),
                          });
                          IFollowedModel iFollowedProfile = IFollowedModel(
                            followedId: umdl!.followedId,
                            followedName: umdl!.followedName,
                            followedImage: umdl!.followedImage,
                            followedAt: DateTime.now().millisecondsSinceEpoch,
                          );

                          //+ cannot do this because for the TheyFollowed,
                          //+ I need follower info and not followed info
                          // IFollowedModel myProfileForFollowed = IFollowedModel(
                          //   followedId: userDetailsModel.uID,
                          //   followedName: userDetailsModel.fullName,
                          //   followedImage: userDetailsModel.profileImageUrl,
                          //   followedAt: DateTime.now().millisecondsSinceEpoch,
                          // );
                          await ffstore
                              .collection(accountsCollection)
                              .doc(auth.currentUser!.uid)
                              .collection("iFollowed")
                              .doc(umdl!.followedId)
                              .set(iFollowedProfile.toJson());
                          // await fs
                          //     .collection(accountsCollection)
                          //     .doc(umdl!.uID)
                          //     .collection("TheyFollowed")
                          //     .doc(userDetailsModel.uID)
                          //     .set(myProfileForFollowed.toJson());
                        }
                            : () async {
                          //+unfollow code goes here
                          await ffstore.collection(accountsCollection).doc(auth.currentUser!.uid).update({
                            "iFollowed": FieldValue.arrayRemove([umdl!.followedId]),
                          });
                          await ffstore.collection(accountsCollection).doc(umdl!.followedId).update({
                            "TheyFollowed": FieldValue.arrayRemove([auth.currentUser!.uid]),
                          });
                          await ffstore
                              .collection(accountsCollection)
                              .doc(auth.currentUser!.uid)
                              .collection("iFollowed")
                              .doc(umdl!.followedId)
                              .delete();
                          await ffstore
                              .collection(accountsCollection)
                              .doc(umdl!.followedId)
                              .collection("TheyFollowed")
                              .doc(userDetailsModel.uID)
                              .delete();
                        },
                        borderRadius: BorderRadius.circular(4),
                        splashColor: kSecondaryColor.withOpacity(0.05),
                        highlightColor: kSecondaryColor.withOpacity(0.05),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 3,
                          ),
                          child: MyText(
                            text: isFollowed! ? 'UnFollow' : 'Follow',
                            color: kSecondaryColor,
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
