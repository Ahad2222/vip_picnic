import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class SearchFriends extends StatefulWidget {
  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  //+ close this stream on dispose and also remove this stateless widget when your users stream is globally accessible
  //+ without any issues

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userDetailsModelStream;
  RxString searchText = "".obs;

  @override
  void initState() {
    // TODO: implement initState
    userDetailsModelStream = fs.collection("Accounts").doc(auth.currentUser!.uid).snapshots().listen((event) {
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
        title: SearchBar(
          textSize: 16,
          borderColor: Colors.transparent,
          fillColor: kSecondaryColor.withOpacity(0.05),
          onChanged: (value) {
            searchText.value = value.trim();
          },
        ),
      ),
      body: Obx(() {
        if(searchText.value != ""){
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: fs.collection("Accounts").where("userSearchParameters", arrayContains: searchText.value).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,) {
              log("inside stream-builder");
              if (snapshot.connectionState == ConnectionState.waiting) {
                log("inside stream-builder in waiting state");
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Some unknown error occurred');
                } else if (snapshot.hasData) {
                  log("inside hasData and ${snapshot.data!.docs}");
                  if (snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        UserDetailsModel umdl =
                        UserDetailsModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                        if(umdl.uID != auth.currentUser!.uid){
                          return SearchTiles(
                            umdl: umdl,
                            profileImage: umdl.profileImageUrl,
                            name: umdl.fullName,
                            isFollowed: userDetailsModel.iFollowed != null
                                ? userDetailsModel.iFollowed!.asMap().containsValue(umdl.uID)
                                ? true
                                : false
                                : false,
                          );
                        }else{
                          return SizedBox();
                        }
                      },
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
                    return Center(child: const Text('No Users Found'));
                  }
                } else {
                  log("in else of hasData done and: ${snapshot.connectionState} and"
                      " snapshot.hasData: ${snapshot.hasData}");
                  return Center(child: const Text('No Users Found'));
                }
              } else {
                log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                return Center(child: Text('Some Error occurred while fetching the users'));
              }
            },
          );
        }else{
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: fs.collection("Accounts").where("uID", isNotEqualTo: auth.currentUser!.uid).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,) {
              log("inside stream-builder");
              if (snapshot.connectionState == ConnectionState.waiting) {
                log("inside stream-builder in waiting state");
                return Center(child: CircularProgressIndicator());
              }
              else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Some unknown error occurred');
                } else if (snapshot.hasData) {
                  log("inside hasData and ${snapshot.data!.docs}");
                  if (snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        UserDetailsModel umdl =
                        UserDetailsModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                        return SearchTiles(
                          umdl: umdl,
                          profileImage: umdl.profileImageUrl,
                          name: umdl.fullName,
                          isFollowed: userDetailsModel.iFollowed != null
                              ? userDetailsModel.iFollowed!.asMap().containsValue(umdl.uID)
                              ? true
                              : false
                              : false,
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
        }
      }),
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
  UserDetailsModel? umdl;

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
                          await fs.collection("Accounts").doc(auth.currentUser!.uid).update({
                            "iFollowed": FieldValue.arrayUnion([umdl!.uID]),
                          });
                          await fs.collection("Accounts").doc(umdl!.uID).update({
                            "TheyFollowed": FieldValue.arrayUnion([auth.currentUser!.uid]),
                          });
                          await fs
                              .collection("Accounts")
                              .doc(auth.currentUser!.uid)
                              .collection("iFollowed")
                              .doc(umdl!.uID)
                              .set(umdl!.toJson());
                          await fs
                              .collection("Accounts")
                              .doc(umdl!.uID)
                              .collection("TheyFollowed")
                              .doc(userDetailsModel.uID)
                              .set(userDetailsModel.toJson());
                        }
                            : () async {
                          //+unfollow code goes here
                          await fs.collection("Accounts").doc(auth.currentUser!.uid).update({
                            "iFollowed": FieldValue.arrayRemove([umdl!.uID]),
                          });
                          await fs.collection("Accounts").doc(umdl!.uID).update({
                            "TheyFollowed": FieldValue.arrayRemove([auth.currentUser!.uid]),
                          });
                          await fs
                              .collection("Accounts")
                              .doc(auth.currentUser!.uid)
                              .collection("iFollowed")
                              .doc(umdl!.uID)
                              .delete();
                          await fs
                              .collection("Accounts")
                              .doc(umdl!.uID)
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
