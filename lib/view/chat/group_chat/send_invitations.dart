import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/model/group_chat_models/group_chat_room_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/dynamic_link_handler.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class SendInvitations extends StatelessWidget {
  SendInvitations({
    this.docs,
  });

  TextEditingController userNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  RxString userNameObsString = "".obs;
  String finalizedNameString = "";
  RxString selectedId = "".obs;
  Map<String, dynamic>? docs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Send Invitation',
        onTap: () => Get.back(),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          SimpleTextField(
            hintText: 'Type username,  email...',
            controller: userNameController,
            onChanged: (value) {
              userNameObsString.value = value;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            if (userNameObsString.value != "") {
              // List<String> tempList = selectedUsers.length > 0 ? List<String>.from(selectedUsers.keys.toList()) : ["check"];
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: ffstore
                    .collection(accountsCollection)
                    .where("userSearchParameters",
                        arrayContains: userNameObsString.value.trim())
                    .limit(3)
                    // .where("uID", whereNotIn: tempList)
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  //log("inside stream-builder");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    log("inside stream-builder in waiting state");
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
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
                            UserDetailsModel umdl = UserDetailsModel.fromJson(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);
                            return Obx(() {
                              if (selectedId.value == umdl.uID ||
                                  umdl.uID == auth.currentUser?.uid) {
                                return SizedBox();
                              }
                              return contactTiles(
                                profileImage: umdl.profileImageUrl,
                                name: umdl.fullName,
                                id: umdl.uID,
                                email: umdl.email,
                              );
                            });
                          },
                        );
                      } else {
                        if (finalizedNameString == "") {
                          return Center(child: const Text('No Users Found'));
                        }
                        return SizedBox();
                      }
                    } else {
                      log("in else of hasData done and: ${snapshot.connectionState} and"
                          " snapshot.hasData: ${snapshot.hasData}");
                      if (finalizedNameString == "") {
                        return Center(child: const Text('No Users Found'));
                      }
                      return SizedBox();
                    }
                  } else {
                    log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                    return Center(
                        child: Text(
                            'Some Error occurred while fetching the posts'));
                  }
                },
              );
            }
            return SizedBox();
          }),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SimpleTextField(
              maxLines: 5,
              hintText: 'Message...',
              controller: messageController,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: kPrimaryColor,
        elevation: 0,
        child: Container(
          height: 70,
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyButton(
                onTap: () async {
                  //+ put the code to present the option or just by default do both.
                  //+ sending a notification and also open sharing sheet to share via
                  //+ social media or something.
                  if (finalizedNameString != "" &&
                      messageController.text.trim() != "") {
                    Get.dialog(loading());
                    GroupChatRoomModel groupChatModel =
                        GroupChatRoomModel.fromJson(docs ?? {});
                    log("groupChatModel: ${groupChatModel.toJson()}");
                    String shareLink =
                        await DynamicLinkHandler.buildDynamicLinkGroupInvite(
                      groupId: groupChatModel.groupId ?? "",
                      groupName: groupChatModel.groupName ?? "",
                      groupImage: groupChatModel.groupImage ?? "",
                      groupInviteMessage:
                          "${userDetailsModel.fullName} invited you to ${groupChatModel.groupName} "
                          "group chat: ${messageController.text.trim()}.",
                      short: true,
                    );
                    Get.back();
                    log("fetched shareLink: $shareLink");
                    ShareResult sr = await Share.shareWithResult(shareLink);
                    Get.back();
                    await ffstore
                        .collection(groupChatInvitationCollection)
                        .add({
                      "groupId": groupChatModel.groupId ?? "",
                      "groupName": groupChatModel.groupName ?? "",
                      "groupImage": groupChatModel.groupImage ?? "",
                      "invitedId": selectedId.value,
                      "invitedName": userNameController.text.trim(),
                      "invitedById": userDetailsModel.uID,
                      "invitedByName": userDetailsModel.fullName,
                      "invitedAt": DateTime.now().millisecondsSinceEpoch,
                    });
                    log("ShareResult is: ${sr.status} sr.status == ShareResultStatus.success: ${sr.status == ShareResultStatus.success}");
                    log("ShareResult is: ${sr.status} sr.status == ShareResultStatus.dismissed: ${sr.status == ShareResultStatus.dismissed}");
                    log("ShareResult.raw is: ${sr.raw}");
                  } else {
                    showMsg(
                        context: context,
                        msg:
                            "Please fill out both fields properly to send the invite.");
                  }
                },
                buttonText: 'Invite to the group',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactTiles({
    String? id,
    profileImage,
    name,
    email,
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
            //+add it to the lists
            selectedId.value = id!;
            userNameController.text = name;
            finalizedNameString = name;
            userNameObsString.value = "";
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
          subtitle: MyText(
            text: email,
            size: 11,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }
}
