import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/model/group_chat_models/group_chat_room_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/group_chat/g_chat_screen.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/widget/loading.dart';

class GroupChatController extends GetxController {
  static GroupChatController instance = Get.find();

  RxString userSearchText = "".obs;

  createGroupChatRoomAndStartConversation({
    required String groupName,
    required String groupImage,
    required groupDescription,
    required List<String> userIds,
    required String creatorId,
    required creatorName,
  }) async {
    loading();
    log("inside createChatRoomAndStartConversation and userDetailsModel.uID is: ${userDetailsModel.uID} and userDetailsModel.fullName is: ${userDetailsModel.fullName}");
    List<String> searchParameters = [];

    for (int i = 0; i < groupName.length; i++) {
      if (groupName[i] != " ") {
        searchParameters.add(groupName[i]);
        var wordUntil = groupName.substring(0, i);
        log("wordUntil: $wordUntil");
        searchParameters.add(wordUntil);
      }
    }

    String groupId = Uuid().v1();

    if (!userIds.asMap().containsValue(auth.currentUser?.uid)) {
    //+code for searching the chat heads
    //+to be put in the search streamBuilder
    // ffstore.collection(chatRoomCollection)
    //     .where("passengerId", isEqualTo: userDetailsModel.currentUserId)
    //     .where("searchParameters", arrayContains: "varToSearch").snapshots();



    await ffstore
        .collection(groupChatCollection)
        .where("createdById", isEqualTo: creatorId)
        .where("groupName", isEqualTo: groupName)
        .get()
        .then((value) async {
      if (value.docs.length > 0) {
        //+means a group created by me with same name is already there
        Get.back();
        // if (!value["notDeletedFor"].asMap().containsValue(auth.currentUser!.uid)) {
        //   await FirebaseFirestore.instance.collection('ChatRoom').doc(groupId).update({
        //     "notDeletedFor": FieldValue.arrayUnion([auth.currentUser!.uid])
        //   });
        //   Get.to(()> ChatScreen(docs: value.data()));
        // } else {
        //   Get.to(() => ChatScreen(docs: value.data()));
        // }
        // Get.to(() => ChatScreen(docs: value.data()));
      } else {
        List<String> notDeletedFor = userIds;
        notDeletedFor.add(creatorId);
        GroupChatRoomModel groupChatRoomModel = GroupChatRoomModel(
          createdAt: DateTime.now().millisecondsSinceEpoch,
          groupId: groupId,
          groupName: groupName,
          groupImage: groupImage,
          groupDescription: groupDescription,
          createdById: creatorId,
          createdByName: creatorName,
          lastMessage: "",
          lastMessageAt: DateTime.now().millisecondsSinceEpoch,
          lastMessageById: "",
          lastMessageByName: "",
          lastMessageType: "",
          users: userIds,
          groupAdmins: [creatorId],
          notDeletedFor: notDeletedFor,
        );

        try {
          await ffstore.collection(groupChatCollection).doc(groupId).set(groupChatRoomModel.toJson());
          Get.back();
          Get.to(() => GroupChat(docs: groupChatRoomModel.toJson()));
        } catch (e) {
          print(e);
        }
      }
    });
    } else {
      Get.back();
      Get.defaultDialog(title: 'Error', middleText: "You cannot add yourself to a group.");
      print('You cannot add yourself to a group.');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAGroupChatRoomInfo(String groupId) async {
    return FirebaseFirestore.instance.collection(chatRoomCollection).doc(groupId).get();
  }
}
