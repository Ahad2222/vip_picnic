import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/model/chat_models/chat_head_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/custom_popup.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

import '../../view/chat/simple_chat_screen.dart';

class ChatController extends GetxController {
  static ChatController instance = Get.find();

  RxBool showSearch = false.obs;

  RxBool isDeleting = false.obs;
  RxList deleteMsgIdList = [].obs;
  RxList deleteLeftMsgIdList = [].obs;
  RxList deleteAudioIdList = [].obs;
  RxList deleteAudioLinksList = [].obs;
  RxList deleteImageLinksList = [].obs;
  RxList deleteImageIdsList = [].obs;

  RxBool isPlayingMsg = false.obs;
  RxString selectedVoiceId = ''.obs;

  // RxBool isAudioBeingSent = false.obs;

  RxList<ChatHeadModel> chatHeads = RxList<ChatHeadModel>([]);

  RxString messageControllerText = "".obs;
  RxBool isActiveChat = true.obs;
  RxBool isKeyboardOpen = false.obs;
  RxBool isBlocked = false.obs;
  RxString blockedById = "".obs;

  // RxString selectedChatOption = "Active Chats".obs;
  // RxBool isRecordingAudio = false.obs;
  //
  // RxString minutes = '00'.obs;
  // RxString seconds = '00'.obs;
  // RxInt activeChatCount = 0.obs;
  // RxInt inActiveChatCount = 0.obs;
  RxDouble uploadProgress = 0.0.obs;

  //+ audio related code is commented out
/**/
  // Duration duration = Duration();
  // Timer? timer;

  // String? recordFilePath;
  // AudioPlayer? audioPlayer = AudioPlayer();

  // void selectedChatFiler(String value) {
  //   selectedChatOption.value = value;
  //   log('$selectedChatOption');
  //   update();
  // }
  //
  // void addTime() {
  //   final addSeconds = 1;
  //   final seconds = duration.inSeconds + addSeconds;
  //   duration = Duration(seconds: seconds);
  //   buildTime();
  // }
  //
  // void resetTimer() {
  //   duration = Duration();
  //   minutes.value = '00';
  //   seconds.value = '00';
  // }
  //
  // void startTimer() {
  //   timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  // }
  //
  // buildTime() {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   minutes.value = twoDigits(duration.inMinutes.remainder(60));
  //   seconds.value = twoDigits(duration.inSeconds.remainder(60));
  //   log('time is: ${minutes.value}:${seconds.value}');
  // }
  //
  // void recordingMode() {
  //   isRecordingAudio.value = !isRecordingAudio.value;
  //   if (isRecordingAudio.value) {
  //     log("inside if(isRecordingAudio.value)");
  //     startTimer();
  //     // buildTime();
  //   } else {
  //     log("the time is:: ${minutes.value}:${seconds.value}");
  //     timer!.cancel();
  //   }
  //   update();
  // }
  //
  // void isPlayingMode(String id) {
  //   selectedVoiceId.value = id;
  //   update();
  //   print('This is voice id $selectedVoiceId');
  //   // log("isPlayingMode called and now the isPlayingMsg.value is: ${isPlayingMsg}");
  // }
  //
  // Future loadFile(String url) async {
  //   final bytes = await readBytes(Uri.parse(url));
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/audio.mp3');
  //
  //   await file.writeAsBytes(bytes);
  //   if (await file.exists()) {
  //     log("${DateTime.now()}  before getting the file.");
  //     recordFilePath = file.path;
  //     chatController.isPlayingMode(url);
  //     log("${DateTime.now()} before play");
  //     await play().then((value) {
  //       log("${DateTime.now()} play completed");
  //       // chatController.isPlayingMode("fhjdk");
  //       //+ this is not working because we need to wait for as much time as is needed by the audio
  //     });
  //     chatController.isPlayingMode(url);
  //   }
  // }
  //
  // stopAudio() async {
  //   await audioPlayer!.stop();
  // }
  //
  // Future<void> play() async {
  //   if (recordFilePath != null && File(recordFilePath!).existsSync()) {
  //     await audioPlayer!.play(
  //       recordFilePath!,
  //       isLocal: true,
  //     );
  //   }
  // }

  void showSearchBar() {
    showSearch.value = !showSearch.value;
  }

  Stream<List<ChatHeadModel>>? myChatHeadsList(String? myId) {
    log('my id in chatController before getting stream is is: $myId');
    var myid = myId;

    if (myid != null && myid != '') {
      return ffstore
          .collection('ChatRoom')
          .where('users', arrayContains: myId)
          .snapshots()
          .map((QuerySnapshot querySnap) {
        List<ChatHeadModel> myChats = [];
        // log('stream inside the myChatHeadsList Snapshot and querySnap.docs.length = ${querySnap.docs.length} and chatHeads.length = ${chatHeads.value.length}:');
        querySnap.docs.forEach((doc) {
          // log("querySnap.docs.length = ${querySnap.docs.length} and doc: $doc");
          if (doc["notDeletedFor"].asMap().containsValue(myId)) {
            // log("activeChatCount changed");
            ffstore
                .collection("ChatRoom")
                .doc(doc['chatRoomId'])
                .collection("chats")
                .where("isReceived", isEqualTo: false)
                .where("receivedById", isEqualTo: myId)
                .get()
                .then((value) {
              value.docs.forEach((element) {
                element.reference.update({'isReceived': true});
              });
            });
            myChats.add(ChatHeadModel.fromDocumentSnapshot(doc));
          }
        });
        update();
        chatHeads.refresh();
        update();
        return myChats;
      });
    } else {
      log("inside my chatHeads not null else");
      return null;
    }
  }

  messageReceivedStreamActivator(myId){
    ffstore
        .collection('ChatRoom')
        .where('users', arrayContains: myId)
        .snapshots()
        .map((QuerySnapshot querySnap) {
      List<ChatHeadModel> myChats = [];
      // log('stream inside the myChatHeadsList Snapshot and querySnap.docs.length = ${querySnap.docs.length} and chatHeads.length = ${chatHeads.value.length}:');
      querySnap.docs.forEach((doc) {
        // log("querySnap.docs.length = ${querySnap.docs.length} and doc: $doc");
        if (doc["notDeletedFor"].asMap().containsValue(myId)) {
          // log("activeChatCount changed");
          ffstore
              .collection("ChatRoom")
              .doc(doc['chatRoomId'])
              .collection("messages")
              .where("isReceived", isEqualTo: false)
              .where("receivedById", isEqualTo: myId)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              element.reference.update({'isReceived': true});
            });
          });
          myChats.add(ChatHeadModel.fromDocumentSnapshot(doc));
        }
      });
    });

    // ffstore
    //     .collection('ChatRoom')
    //     .where('users', arrayContains: myId)
    //     .snapshots()
    //     .map((QuerySnapshot querySnap) {
    //   List<ChatHeadModel> myChats = [];
    //   // log('stream inside the myChatHeadsList Snapshot and querySnap.docs.length = ${querySnap.docs.length} and chatHeads.length = ${chatHeads.value.length}:');
    //   querySnap.docs.forEach((doc) {
    //     // log("querySnap.docs.length = ${querySnap.docs.length} and doc: $doc");
    //     if (doc["notInActiveFor"].asMap().containsValue(myId) && doc["notDeletedFor"].asMap().containsValue(myId)) {
    //       // log("activeChatCount changed");
    //       activeChatCount++;
    //       // log("activeChatCount changed: $activeChatCount");
    //
    //       // log("stream in chatHeads if(doc[notInActiveFor].asMap().containsValue(myId) "
    //       //             //     "&& doc[notDeletedFor].asMap().containsValue(myId)) myInActiveChatHeadsList inside "
    //       //             //     "if querySnap.docs is: ${doc.data()}");
    //       //             // log("inside querySnap of chatHeads, myId is: $myId");
    //       /**/
    //       // Map<String, dynamic> tm = doc.data();
    //       // if(tm['user1Model']['id'] == myId || tm['user2Model']['id'] == myId){
    //       // log('stream inside if querySnap.docs is: ${doc.data()}');
    //       ffstore
    //           .collection("ChatRoom")
    //           .doc(doc['chatRoomId'])
    //           .collection("chats")
    //           .where("isReceived", isEqualTo: false)
    //           .where("receivedById", isEqualTo: myId)
    //           .get()
    //           .then((value) {
    //         value.docs.forEach((element) {
    //           element.reference.update({'isReceived': true});
    //         });
    //       });
    //       myChats.add(ChatHeadModel.fromDocumentSnapshot(doc));
    //     }
    //   });
    // });
  }

  getChatRoomId(String userID, String anotherUserID) {
    print("inside getChatRoomId a = $userID & b = $anotherUserID");
    var chatRoomId;
    if (userID.compareTo(anotherUserID) > 0) {
      chatRoomId = '$userID - $anotherUserID';
    } else {
      chatRoomId = '$anotherUserID - $userID';
    }
    return chatRoomId;
  }

//first time creating chat head
  createChatRoomAndStartConversation(
      {required UserDetailsModel user1Model,
      required UserDetailsModel user2Model}) async {
    loading();
    log("inside createChatRoomAndStartConversation and userDetailsModel.uID is: ${userDetailsModel.uID} and userDetailsModel.fullName is: ${userDetailsModel.fullName}");
    List<String> users;
    List<String> searchParameters = [];
    if (user2Model.uID != user1Model.uID) {
      users = [
        "${user1Model.uID}",
        "${user2Model.uID}",
      ];
      String chatRoomId =
          getChatRoomId(user1Model.uID ?? "", user2Model.uID ?? "");
      var anotherUserId = user1Model.uID == userDetailsModel.uID
          ? user2Model.uID
          : user1Model.uID;
      var anotherUserName = user1Model.uID == userDetailsModel.uID
          ? "${user2Model.fullName}"
          : "${user1Model.fullName}";

      var myName = "${userDetailsModel.fullName}";
      log("anotherUserId: $anotherUserId");

      for (int i = 0; i < anotherUserName.length; i++) {
        if (anotherUserName[i] != " ") {
          searchParameters.add(anotherUserName[i]);
          var wordUntil = anotherUserName.substring(0, i);
          log("wordUntil: $wordUntil");
          searchParameters.add(wordUntil);
        }
      }

      for (int i = 0; i < myName.length; i++) {
        if (myName[i] != " ") {
          searchParameters.add(myName[i]);
          var wordUntil = myName.substring(0, i);
          log("wordUntil: $wordUntil");
          searchParameters.add(wordUntil);
        }
      }

      //+code for searching the chat heads
      //+to be put in the search streamBuilder
      // ffstore.collection(chatRoomCollection)
      //     .where("passengerId", isEqualTo: userDetailsModel.currentUserId)
      //     .where("searchParameters", arrayContains: "varToSearch").snapshots();

      await ffstore
          .collection(chatRoomCollection)
          .doc(chatRoomId)
          .get()
          .then((value) async {
        if (value.exists) {
          //+means chat head is already created
          Get.back();
          if (!value["notDeletedFor"]
              .asMap()
              .containsValue(auth.currentUser!.uid)) {
            await FirebaseFirestore.instance
                .collection('ChatRoom')
                .doc(chatRoomId)
                .update({
              "notDeletedFor": FieldValue.arrayUnion([auth.currentUser!.uid])
            });
            Get.to(() => ChatScreen(docs: value.data()));
          } else {
            Get.to(() => ChatScreen(docs: value.data()));
          }
          // Get.to(() => ChatScreen(docs: value.data()));
        } else {
          Map<String, dynamic> chatRoomMap = {
            "users": users,
            "searchParameters": searchParameters,
            "chatRoomId": chatRoomId,
            "user1Id": user1Model.uID,
            "user2Id": user2Model.uID,
            'user1Model': user1Model.toJson(),
            'user2Model': user2Model.toJson(),
            'isBlocked': false,
            'blockedById': "",
            'notDeletedFor': users,
            // 'inActiveFor': [userDetailsModel.uID],
            // 'notInActiveFor': [user2Model.id],
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'lastMessageAt': DateTime.now().millisecondsSinceEpoch,
            'lastMessage': '',
          };
          await ffstore
              .collection(chatRoomCollection)
              .doc(chatRoomId)
              .set(chatRoomMap)
              .catchError((e) =>
                  print("error in generating an  chat  ${e.toString()}"));
          Get.back();
          Get.to(() => ChatScreen(docs: chatRoomMap));
        }
      });
    } else {
      Get.back();
      Get.defaultDialog(
        title: 'Error',
        middleText: "You cannot send message to yourself.",
      );
      print(
        'You can not send message to yourself.',
      );
    }
  }

  addConversationMessage(
      String chatRoomId, var time, String type, messageMap, String msg) async {
    log('called addConversationMessage');
    await FirebaseFirestore.instance
        .collection(chatRoomCollection)
        .doc(chatRoomId)
        .collection(messagesCollection)
        .add(messageMap)
        .then((value) async {
      await FirebaseFirestore.instance
          .collection(chatRoomCollection)
          .doc(chatRoomId)
          .update({
        'lastMessageAt': time,
        'lastMessage': msg,
        'lastMessageType': type,
      }).catchError((e) {
        log('\n\n\n\n error in updating last message and last message time ${e.toString()}');
      });
    }).catchError((e) {
      log('\n\n\n\n error in adding message ${e.toString()}');
    });
  }

  Future<void> deleteAChatRoom({String? chatRoomId}) async {
    // showLoading();
    log("inside chatRoom delete and chatRoom Id: $chatRoomId");
    try {
      log("inside chatRoom delete and chatRoom Id: $chatRoomId");
      await ffstore.collection("ChatRoom").doc(chatRoomId).update({
        "notDeletedFor": FieldValue.arrayRemove([auth.currentUser!.uid])
      }).then((value) async {
        await ffstore
            .collection(chatRoomCollection)
            .doc(chatRoomId)
            .collection(messagesCollection)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            element.reference.update({
              "isDeletedFor": FieldValue.arrayUnion([auth.currentUser!.uid])
            });
          });
        });
      });
    } catch (e) {
      // dismissLoadingWidget();
      // showErrorDialog(title: "Error!", description: "Some unexpected error occurred.");
      log("Following error was thrown in chat deletion: ${e.toString()}. Please try again.");
    }
  }

  //+0iSxhYZw7SUJRgTtQGf1bbJ8rxv1
  Future<void> deleteAGroupChatRoom({String? groupId}) async {
    // showLoading();
    log("inside groupId delete and chatRoom Id: $groupId");
    try {
      log("inside groupId delete and chatRoom Id: $groupId");
      await ffstore.collection(groupChatCollection).doc(groupId).update({
        "notDeletedFor": FieldValue.arrayRemove([auth.currentUser!.uid])
      }).then((value) async {
        await ffstore
            .collection(groupChatCollection)
            .doc(groupId)
            .collection(messagesCollection)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            element.reference.update({
              "isDeletedFor": FieldValue.arrayUnion([auth.currentUser!.uid])
            });
          });
        });
      });
    } catch (e) {
      // dismissLoadingWidget();
      // showErrorDialog(title: "Error!", description: "Some unexpected error occurred.");
      log("Following error was thrown in chat deletion: ${e.toString()}. Please try again.");
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAChatRoomInfo(
      String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection(chatRoomCollection)
        .doc(chatRoomId)
        .get();
  }

  getConversationMessage(String chatRoomId) async {
    return ffstore
        .collection(chatRoomCollection)
        .doc(chatRoomId)
        .collection(messagesCollection)
        .orderBy('time')
        .snapshots();
  }
}
