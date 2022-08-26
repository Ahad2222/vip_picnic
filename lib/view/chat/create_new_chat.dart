import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/model/i_followed_model/i_followed_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class CreateNewChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        onTap: () => Get.back(),
        title: 'Select contact',
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ffstore
            .collection(accountsCollection)
            .doc(userDetailsModel.uID)
            .collection('iFollowed')
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          log("inside stream-builder");
          if (snapshot.connectionState == ConnectionState.waiting) {
            log("inside stream-builder in waiting state");
            return Center(child: CircularProgressIndicator());
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
                    horizontal: 15,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    IFollowedModel iFollowedModel = IFollowedModel.fromJson(
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>);
                    return contactTiles(
                      profileImage: iFollowedModel.followedImage,
                      name: iFollowedModel.followedName,
                      id: iFollowedModel.followedId,
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
            return Center(
                child: Text('Some Error occurred while fetching the posts'));
          }
        },
      ),
    );
  }

  Widget contactTiles({
    String? id,
    profileImage,
    name,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xffF5F5F6),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () async {
            UserDetailsModel umdl = UserDetailsModel();
            await ffstore.collection(accountsCollection).doc(id).get().then((value) {
              umdl = UserDetailsModel.fromJson(value.data() ?? {});
            });
            await chatController.createChatRoomAndStartConversation(
              user1Model: userDetailsModel,
              user2Model: umdl,
            );
          },
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          leading: Container(
            height: 56.4,
            width: 56.4,
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
                  profileImage,
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: MyText(
            text: name,
            size: 14,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }
}
