import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/home.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

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
