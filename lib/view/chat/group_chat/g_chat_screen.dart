import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/group_chat_models/group_chat_room_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/dynamic_link_handler.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/group_chat/preview_group_chat_image.dart';
import 'package:vip_picnic/view/chat/group_chat/preview_group_video.dart';
import 'package:vip_picnic/view/chat/group_chat/send_invitations.dart';
import 'package:vip_picnic/view/chat/preview_video.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/message_bubbles.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

// ignore: must_be_immutable
class GroupChat extends StatefulWidget {
  GroupChat({
    Key? key,
    this.docs,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  Map<String, dynamic>? docs;

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  Rx<TextEditingController> messageEditingController = TextEditingController().obs;
  ScrollController scrollController = ScrollController();

  String chatRoomID = "";
  File? imageFile;
  File? videoFile;

  int i = 0;
  String imageUrl = '';
  bool isOpenedUp = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  RxString userNameObsString = "".obs;
  String finalizedNameString = "";
  RxString selectedId = "".obs;
  Rx<GroupChatRoomModel> grm = GroupChatRoomModel().obs;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? groupChatRoomListener;


  // RxInt time = 0.obs;
  // Stream? chatMessageStream;
  // RxBool isDeleting = false;
  // String recordFilePath;
  // String userID = "";
  // String userName = "";
  // bool attachFiles = false;
  // bool emojiShowing = false;
  // RxBool isRecording = false.obs;
  // RxBool isSending = false.obs;
  // RxInt lastIndex = 0.obs;

  // Map<String, String> _paths = {};
  // String key = "";
  // String salt = "";
  // bool isWaiting = false;
  // bool isAssigned = false;
  // String imgPlaceholder =
  //     'https://thumbs.dreamstime.com/z/placeholder-icon-vector-isolated-white-background-your-web-mobile-app-design-placeholder-logo-concept-placeholder-icon-134071364.jpg';
  // List<String> monthsList = [
  //   'January',
  //   'February',
  //   'March',
  //   'April',
  //   'May',
  //   'June',
  //   'July',
  //   'August',
  //   'September',
  //   'October',
  //   'November',
  //   'December'
  // ];

  // RxInt lastMessageAt = 0.obs;
  // RxString lastMessage = "".obs;

  // final Rx<GroupChatRoomModel> crm = GroupChatRoomModel().obs;
  // Rx<UserDetailsModel> anotherUserModel = UserDetailsModel().obs;
  // final RxBool isMatchedOrNot = false.obs;
  // final RxString privacySettings = "Everyone".obs;
  // final String deleteFor = "Everyone";
  // RxBool isArchivedRoom = false.obs;
  // RxBool isPrivacyAllowed = true.obs;
  // StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? otherUserListener;
  // StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? chatRoomListener;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  @override
  void initState() {
    // TODO: implement initState
    log("passwd doc is: ${widget.docs}");
    isOpenedUp = true;
    chatRoomID = widget.docs!["groupId"];
    getChatRoomStream();
    // getUserDataFromChatRoomDB();
    // getRoomId();
    // getChatRoomStream();
    super.initState();
    // KeyboardVisibilityController().onChange.listen((event) {
    //   chatController.isKeyboardOpen.value = event;
    // });
    // isArchivedRoom.value = widget.isArchived!;
  }
  getChatRoomStream() async {
    // crm.value = ChatRoomModel.fromDocumentSnapshot(event);
    groupChatRoomListener = await ffstore
        .collection(groupChatCollection)
        .doc(widget.docs!["groupId"])
        .snapshots()
        .listen((event) {
      grm.value = GroupChatRoomModel.fromDocumentSnapshot(event);
      // isArchivedRoom.value = crm.value.inActiveFor.asMap().containsValue(authController.userModel.value.id);
      log("\n\n\n getChatRoomStream called \n\n\n");
    });
  }


  // getRoomId() async {
  //   // SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   // userID = userDetailsModel.uID!;
  //   // log("userID: $userID");
  //   // if (userDetailsModel.uID! != widget.docs!['user2Model']['uID']) {
  //   //   anotherUserID = widget.docs!['user2Model']['uID'];
  //   //   anotherUserName = widget.docs!['user2Model']['fullName'];
  //   //   anotherUserImage = widget.docs!['user2Model']['profileImageUrl'];
  //   // } else {
  //   //   anotherUserID = widget.docs!['user1Model']['uID'];
  //   //   anotherUserName = widget.docs!['user1Model']['fullName'];
  //   //   anotherUserImage = widget.docs!['user1Model']['profileImageUrl'];
  //   // }
  //   // log("anotherUserID: $anotherUserID");
  //   // log("anotherUserName: $anotherUserName");
  //   // log("anotherUserImage: $anotherUserImage");
  //
  //   // chatRoomID = chatController.getChatRoomId(userID, anotherUserID);
  //   // chatRoomID = widget.docs!["groupId"];
  //   // otherUserListener = await ffstore.collection(accountsCollection).doc(anotherUserID).snapshots().listen((event) {
  //   //   log("updating anotherUserModel");
  //   //   anotherUserModel.value = UserDetailsModel.fromJson(event.data() ?? {});
  //   // });
  // }

  // getUserDataFromChatRoomDB() async {
  //   log("CHanging the crm values from getUserDataFromChatRoomDB");
  //   await ffstore.collection("GroupChatRoom").doc(widget.docs!["groupId"]).get().then((value) {
  //     crm.value = GroupChatRoomModel.fromDocumentSnapshot(value);
  //     log("CHanging the crm values in get from getUserDataFromChatRoomDB");
  //   });
  //   await ffstore.collection("GroupChatRoom").doc(chatRoomID).snapshots().listen((event) {
  //     log("CHanging the crm values in snapshot from getUserDataFromChatRoomDB");
  //     crm.value = GroupChatRoomModel.fromDocumentSnapshot(event);
  //   });
  // }

  String? path;
  String? videoPath;

  Future getImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        path = xFile.path;
        // showLoading();
        Get.to(
          () => PreviewGroupChatImageScreen(
            imagePath: path,
            chatRoomId: widget.docs!["groupId"],
            userId: userDetailsModel.uID!,
          ),
        );
        // uploadImage();
      }
    });
  }

  Future getImageFromGallery() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        path = xFile.path;
        // showLoading();
        Get.to(
          () => PreviewGroupChatImageScreen(
            imagePath: path,
            chatRoomId: widget.docs!["groupId"],
            userId: userDetailsModel.uID!,
          ),
        );
        // uploadImage();
      }
    });
  }

  Future getVideoFromGallery() async {
    ImagePicker _picker = ImagePicker();
    await _picker
        .pickVideo(
      source: ImageSource.gallery,
    )
        .then((xFile) {
      if (xFile != null) {
        videoFile = File(xFile.path);
        videoPath = xFile.path;
        // showLoading();
        Get.to(
              () => PreviewGroupVideoScreen(
            videoPath: videoPath,
            chatRoomId: widget.docs!["groupId"],
            userId: userDetailsModel.uID!,
          ),
        );
        // uploadImage();
      }
    });
  }


  // Future uploadImage() async {
  //   String fileName = Uuid().v1();
  //   int status = 1;
  //   // Get.to(() => PreviewImageScreen(imagePath: path, fileName: fileName));
  //   Get.dialog(
  //     Container(
  //       color: kBlackColor,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //TODO: he will make it look better.
  //         // alignment: Alignment.center,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 15,
  //               vertical: 30,
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     print('clicked the x close button.');
  //                     Navigator.pop(context);
  //                   },
  //                   child: Icon(
  //                     Icons.clear,
  //                     color: Colors.red,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Container(
  //               child: Image.file(
  //                 imageFile!,
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 15,
  //               vertical: 30,
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () async {
  //                     loading();
  //                     var ref = FirebaseStorage.instance.ref().child(chatRoomID).child("$fileName.jpg");
  //                     var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
  //                       print('in uploading error and eoor is: $error'); // await FirebaseFirestore.instance
  //                       status = 0;
  //                     });
  //                     if (status == 1) {
  //                       imageUrl = await uploadTask.ref.getDownloadURL();
  //                       log('this is status 1');
  //                       print(imageUrl);
  //                       sendMessage(imageUrl);
  //                       Get.back();
  //                       Get.back();
  //                       // sendMessage(imageUrl);
  //                     }
  //                   },
  //                   child: Container(
  //                     height: 50,
  //                     width: 50,
  //                     padding: EdgeInsets.all(12),
  //                     decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50)),
  //                     child: Icon(
  //                       // FontAwesomeIcons.solidPaperPlane,
  //                       Icons.arrow_forward_rounded,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     barrierDismissible: false,
  //   );
  //   /**/
  // }

  // getChatRoomStream() async {
  //   // crm.value = ChatRoomModel.fromDocumentSnapshot(event);
  //   // chatRoomListener = await ffstore.collection("GroupChatRoom").doc(widget.docs!['groupId']).snapshots().listen((event) {
  //   //   lastMessageAt.value = event['lastMessageAt'];
  //   //   lastMessage.value = event['lastMessage'];
  //   //   // crm.value = GroupChatRoomModel.fromDocumentSnapshot(event);
  //   //   // isArchivedRoom.value = crm.value.inActiveFor.asMap().containsValue(authController.userModel.value.id);
  //   //   log("\n\n\n getChatRoomStream called and lastMessageAt: $lastMessageAt"
  //   //       " lastMessage: $lastMessage \n\n\n");
  //   // });
  // }

  sendMessage([String? imageUrl]) async {
    var messageText = messageEditingController.value.text;
    if (messageEditingController.value.text.isNotEmpty) {
      messageEditingController.value.text = "";
      // var encryptedMessage =
      print("inside the text part");
      var time = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> messageMap = {
        "sendById": userDetailsModel.uID,
        "sendByName": userDetailsModel.fullName,
        "sendByImage": userDetailsModel.profileImageUrl,
        // "receivedById": anotherUserID,
        // "receivedByName": anotherUserName,
        "message": messageText,
        "type": "text",
        'time': time,
        'isDeletedFor': [],
        "isRead": false,
        "isReadBy": [],
        "isReceived": false,
        "isReceivedBy": [],
      };
      // bool isDeletedFor = crm.value.notDeletedFor?.asMap().containsValue(anotherUserID) ?? false;
      // if (!isDeletedFor) {
      //   ffstore.collection("ChatRoom").doc(chatRoomID).update({
      //     "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
      //   });
      // }
      groupChatController.addConversationMessage(chatRoomID, time, "text", messageMap, messageText);
      // log("index is: ${lastIndex.value}");
    } else if (imageFile != null && (imageUrl != null || imageUrl != "")) {
      var time = DateTime.now().millisecondsSinceEpoch;

      Map<String, dynamic> messageMap = {
        "sendById": userDetailsModel.uID,
        "sendByName": userDetailsModel.fullName,
        "sendByImage": userDetailsModel.profileImageUrl,
        "message": imageUrl,
        "type": "image",
        'time': time,
        'isDeletedFor': [],
        "isRead": false,
        "isReadBy": [],
        "isReceived": false,
        "isReceivedBy": [],
      };
      // bool isDeletedFor = crm.value.notDeletedFor?.asMap().containsValue(anotherUserID) ?? false;
      //
      // if (!isDeletedFor) {
      // /  ffstore.collection("ChatRoom").doc(chatRoomID).update({
      //     "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
      //   });
      // }
      groupChatController.addConversationMessage(chatRoomID, time, "image", messageMap, imageUrl!);
      messageEditingController.value.text = "";

      imageUrl = "";
    }
    groupChatController.messageControllerText.value = "";
  }

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ffstore
          .collection(groupChatCollection)
          .doc(chatRoomID)
          .collection(messagesCollection)
          .orderBy('time')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // scrollController.animateTo(
          //   scrollController.position.maxScrollExtent,
          //   curve: Curves.easeOut,
          //   duration: const Duration(milliseconds: 500),
          // );
          // /*
          WidgetsBinding.instance?.addPostFrameCallback(
            (_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
                // scrollController.jumpTo(
                //   scrollController.position.maxScrollExtent,
                // curve: Curves.easeIn, duration: Duration(milliseconds: 1000)
                // );
              }
              // else {
              //    // setState(() => null);
              //  }
            },
          );
          // * */
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 80,
              left: 15,
              right: 15,
            ),
            controller: scrollController,
            // reverse: true,
            // shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = snapshot.data?.docs[index].data() as Map<String, dynamic>;
              print("snapshot.data.docs[index].data()[type] is: ${data["type"]}");
              //TODO: Beware, here the widgets to show data start.
              //TODO: Beware, here the widgets to show data start.
              String type = data["type"];
              String message = data["message"] != null ? data["message"] : "what is this?";
              bool sendByMe = userDetailsModel.uID == data["sendById"];
              String time = data["time"].toString();
              String senderImage = data["sendByImage"];
              bool isDeletedForMe = data["isDeletedFor"].contains(userDetailsModel.uID);
              bool isReceived = data['isReceivedBy'] != null ? data['isReceivedBy'].length == (grm.value.users?.length ?? 0) : false ;
              bool isRead = data['isReadBy'].length == (grm.value.users?.length ?? 0);

              var day = DateTime.fromMillisecondsSinceEpoch(
                int.parse(time),
              ).day.toString();
              var month = DateTime.fromMillisecondsSinceEpoch(
                int.parse(time),
              ).month.toString();
              var year = DateTime.fromMillisecondsSinceEpoch(
                int.parse(time),
              ).year.toString().substring(2);
              var date = day + '-' + month + '-' + year;
              var hour = DateTime.fromMillisecondsSinceEpoch(
                int.parse(time),
              ).hour;
              var min = DateTime.fromMillisecondsSinceEpoch(
                int.parse(time),
              ).minute;
              var ampm;
              if (hour > 12) {
                hour = hour % 12;
                ampm = 'pm';
              } else if (hour == 12) {
                ampm = 'pm';
              } else if (hour == 0) {
                hour = 12;
                ampm = 'am';
              } else {
                ampm = 'am';
              }
              if (!isDeletedForMe) {
                if (!sendByMe) {
                  return LeftMessageBubble(
                    id: snapshot.data?.docs[index].id,
                    receiveImage: senderImage,
                    msg: message,
                    time: "${hour.toString()}:"
                        "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                        "${ampm}",
                    type: type,
                    thumbnail: type == "video" ? data["thumbnail"] : "",
                  );
                } else {
                  return RightMessageBubble(
                    receiveImage: senderImage,
                    id: snapshot.data?.docs[index].id,
                    msg: message,
                    time: "${hour.toString()}:"
                        "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                        "${ampm}",
                    type: type,
                    isRead: isRead,
                    isReceived: isReceived,
                    thumbnail: type == "video" ? data["thumbnail"] : "",
                    sendByMe: true,
                  );
                }
              } else {
                return SizedBox();
              }
            },
          );
        } else {
          return Container(
            child: Center(
              child: Text("loading".tr + "..."),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (chatController.isDeleting.value) {
          chatController.isDeleting.value = false;
          chatController.deleteMsgIdList.clear();
          chatController.deleteLeftMsgIdList.clear();
          chatController.deleteAudioIdList.clear();
          chatController.deleteAudioLinksList.clear();
          chatController.deleteImageIdsList.clear();
          chatController.deleteImageLinksList.clear();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
          // title: chatController.showSearch.value
          //     ? SearchBar()
          //     : MyText(
          //         //+docs!['groupName']
          //         text: '${widget.docs!['groupName'] ?? ""}',
          //         size: 19,
          //         color: kSecondaryColor,
          //       ),
          title: MyText(
            //+docs!['groupName']
            text: '${widget.docs!['groupName'] ?? ""}',
            size: 19,
            color: kSecondaryColor,
          ),
          actions: [
            // Padding(
            //   padding: const EdgeInsets.only(
            //     right: 10,
            //     left: 15,
            //   ),
            //   child: Center(
            //     child: GestureDetector(
            //       onTap: () => chatController.showSearchBar(),
            //       //+ we can implement the search by putting an onChange on the send message field
            //       //+ but we might have to be very careful with the length of the search array being saved into it.
            //       child: Image.asset(
            //         Assets.imagesSearchWithBg,
            //         height: 35,
            //       ),
            //     ),
            //   ),
            // ),
            Obx(() {
              if (chatController.isDeleting.value) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // chatController.showSearchBar();
                        Get.bottomSheet(
                          Container(
                            height:
                            chatController.deleteLeftMsgIdList.length > 0
                                ? 150
                                : 200,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InkWell(
                                  child: Center(
                                    child: MyText(
                                      paddingTop: 12,
                                      text: 'Cancel',
                                      size: 16,
                                      paddingBottom: 12,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  splashColor: kBlackColor.withOpacity(0.05),
                                  highlightColor: kBlackColor.withOpacity(0.05),
                                  onTap: () {
                                    // Get.back();
                                    chatController.isDeleting.value = false;
                                    chatController.deleteMsgIdList.clear();
                                    chatController.deleteLeftMsgIdList.clear();
                                    chatController.deleteAudioIdList.clear();
                                    chatController.deleteAudioLinksList.clear();
                                    chatController.deleteImageIdsList.clear();
                                    chatController.deleteImageLinksList.clear();
                                    Get.back();
                                  },
                                ),
                                Container(
                                  height: 1,
                                  color: kSecondaryColor.withOpacity(0.2),
                                ),
                                InkWell(
                                  child: Center(
                                    child: MyText(
                                      paddingTop: 12,
                                      text: 'Delete for me',
                                      size: 16,
                                      paddingBottom: 12,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  splashColor: kBlackColor.withOpacity(0.05),
                                  highlightColor: kBlackColor.withOpacity(0.05),
                                  onTap: () async {
                                    int deleteCount = 0;
                                    Get.back();
                                    Get.dialog(loading());
                                    log("logging the list on delete button: ${chatController.deleteMsgIdList} ");
                                    // chatController.deleteMsgIdList.forEach((element) async {
                                    //   try {
                                    //     await ffstore
                                    //         .collection(groupChatCollection)
                                    //         .doc(widget.docs['groupId'])
                                    //         .collection('chats')
                                    //         .doc(element)
                                    //         .delete();
                                    //   } catch (e) {
                                    //     log("error is: $e");
                                    //     //+show an error widget/dialog/snackbar.
                                    //   }
                                    //   log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                    //   chatController.deleteMsgIdList.remove(element);
                                    //   log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                    // });
                                    log("initial deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                    // for (int i = 0; i < chatController.deleteAudioLinksList.length; i++) {
                                    //   deleteCount++;
                                    //   log("deleting through URL : ${chatController.deleteAudioLinksList[i]}");
                                    //   try {
                                    //     // await FirebaseStorage.instance
                                    //     //     .refFromURL(chatController.deleteAudioLinksList[i])
                                    //     //     .delete()
                                    //     //     .then((value) async {
                                    //     //   log("after deleting the audio from storage");
                                    //     await ffstore
                                    //         .collection(groupChatCollection)
                                    //         .doc(widget.docs!['groupId'])
                                    //         .collection('chats')
                                    //         .doc(chatController.deleteAudioIdList[i])
                                    //         .update({
                                    //       "isDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid])
                                    //     }).then((value) {
                                    //       log("after deleting the audio from storage");
                                    //       chatController.deleteMsgIdList
                                    //           .remove(chatController.deleteAudioIdList[i]);
                                    //       chatController.deleteAudioIdList.removeAt(i);
                                    //       chatController.deleteAudioLinksList.removeAt(i);
                                    //     });
                                    //     // });
                                    //   } catch (e) {
                                    //     log("error is: $e");
                                    //     //+show an error widget/dialog/snackbar.
                                    //   }
                                    // }
                                    for (int j = 0;
                                    j <
                                        chatController
                                            .deleteImageLinksList.length;
                                    j++) {
                                      deleteCount++;
                                      try {
                                        await ffstore
                                            .collection(groupChatCollection)
                                            .doc(widget.docs!['groupId'])
                                            .collection('messages')
                                            .doc(chatController
                                            .deleteImageIdsList[j])
                                            .update({
                                          "isDeletedFor": FieldValue.arrayUnion(
                                              [auth.currentUser?.uid])
                                        }).then((value) {
                                          log("after deleting the audio from storage");
                                          chatController.deleteMsgIdList.remove(
                                              chatController
                                                  .deleteImageIdsList[j]);
                                          chatController.deleteImageIdsList
                                              .removeAt(j);
                                          chatController.deleteImageLinksList
                                              .removeAt(j);
                                        });
                                        // });
                                      } catch (e) {
                                        log("error is: $e");
                                        //+show an error widget/dialog/snackbar.
                                      }
                                    }
                                    log("remaining deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                    chatController.deleteMsgIdList
                                        .forEach((element) async {
                                      deleteCount++;
                                      log("in deleteMsgIdList.forEach widget.docs!['groupId']: "
                                          "${widget.docs!['groupId']}");
                                      try {
                                        await ffstore
                                            .collection(groupChatCollection)
                                            .doc(widget.docs!['groupId'])
                                            .collection('messages')
                                            .doc(element)
                                            .update({
                                          "isDeletedFor": FieldValue.arrayUnion(
                                              [auth.currentUser?.uid])
                                        });
                                      } catch (e) {
                                        log("error is: $e");
                                        //+show an error widget/dialog/snackbar.
                                      }
                                      log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                      chatController.deleteMsgIdList
                                          .remove(element);
                                      log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                    });
                                    // chatController.deleteAudioIdList.forEach((element) async {
                                    //   try {
                                    //     await ffstore
                                    //         .collection(groupChatCollection)
                                    //         .doc(widget.docs['groupId'])
                                    //         .collection('chats')
                                    //         .doc(element)
                                    //         .delete();
                                    //   } catch (e) {
                                    //     log("error is: $e");
                                    //     //+show an error widget/dialog/snackbar.
                                    //   }
                                    // });
                                    chatController.isDeleting.value = false;
                                    chatController.deleteMsgIdList.clear();
                                    chatController.deleteAudioIdList.clear();
                                    chatController.deleteAudioLinksList.clear();
                                    chatController.deleteImageIdsList.clear();
                                    chatController.deleteImageLinksList.clear();
                                    Get.back();
                                    //
                                    // List a = [];
                                    // a.c
                                    //+ below code is for updating the last message for me.
                                    try {
                                      await ffstore
                                          .collection(groupChatCollection)
                                          .doc(chatRoomID)
                                          .collection("messages")
                                      // .where("isDeletedFor", whereIn: [
                                      //   [authController.userModel.value.id],
                                      //   [authController.userModel.value.id, anotherUserID]
                                      // ])
                                          .orderBy("time", descending: true)
                                          .get()
                                          .then((value) {
                                        log("in then of  update last message query is: ${value.docs.length}");
                                        if (value.docs.length > 0) {
                                          log("why not inside");
                                          // var firstEndDoc = value.docs.firstWhere((element) => element['message'] == "yyyy");
                                          var firstEndDoc = value.docs
                                              .firstWhereOrNull((element) =>
                                          !element['isDeletedFor']
                                              .contains(auth
                                              .currentUser?.uid));
                                          log("firstEndDoc: $firstEndDoc");
                                          if (firstEndDoc != null) {
                                            log("firstEndDoc is: ${firstEndDoc.data()}");
                                            // if(firstEndDoc['type'] == "text"){
                                            // }
                                            ffstore
                                                .collection(groupChatCollection)
                                                .doc(chatRoomID)
                                                .update({
                                              "lastMessageAt":
                                              firstEndDoc['time'],
                                              "lastMessage":
                                              firstEndDoc['message'],
                                              "lastMessageType":
                                              firstEndDoc['type'],
                                            });
                                          } else {
                                            ffstore
                                                .collection(groupChatCollection)
                                                .doc(chatRoomID)
                                                .update({
                                              "lastMessage": "",
                                              "lastMessageType": "text",
                                            });
                                          }
                                        } else {
                                          ffstore
                                              .collection(groupChatCollection)
                                              .doc(chatRoomID)
                                              .update({
                                            "lastMessage": "",
                                            "lastMessageType": "text",
                                          });
                                        }
                                      });
                                    } catch (e) {
                                      log("error in updating last message is: $e");
                                    }
                                  },
                                ),
                                Container(
                                  height: 1,
                                  color: kSecondaryColor.withOpacity(0.2),
                                ),
                                if (chatController.deleteLeftMsgIdList.length ==
                                    0)
                                  InkWell(
                                    child: Center(
                                      child: MyText(
                                        paddingTop: 12,
                                        text: 'Delete for everyone',
                                        size: 16,
                                        paddingBottom: 12,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    splashColor: kBlackColor.withOpacity(0.05),
                                    highlightColor:
                                    kBlackColor.withOpacity(0.05),
                                    onTap: () async {
                                      int deleteCount = 0;
                                      Get.back();
                                      Get.dialog(loading());
                                      log("logging the list on delete button: ${chatController.deleteMsgIdList} ");
                                      // chatController.deleteMsgIdList.forEach((element) async {
                                      //   try {
                                      //     await ffstore
                                      //         .collection(groupChatCollection)
                                      //         .doc(widget.docs['groupId'])
                                      //         .collection('chats')
                                      //         .doc(element)
                                      //         .delete();
                                      //   } catch (e) {
                                      //     log("error is: $e");
                                      //     //+show an error widget/dialog/snackbar.
                                      //   }
                                      //   log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                      //   chatController.deleteMsgIdList.remove(element);
                                      //   log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                      // });
                                      log("initial deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                      // for (int i = 0; i < chatController.deleteAudioLinksList.length; i++) {
                                      //   deleteCount++;
                                      //   log("deleting through URL : ${chatController.deleteAudioLinksList[i]}");
                                      //   try {
                                      //     await FirebaseStorage.instance
                                      //         .refFromURL(chatController.deleteAudioLinksList[i])
                                      //         .delete()
                                      //         .then((value) async {
                                      //       log("after deleting the audio from storage");
                                      //       await ffstore
                                      //           .collection(groupChatCollection)
                                      //           .doc(widget.docs!['groupId'])
                                      //           .collection('messages')
                                      //           .doc(chatController.deleteAudioIdList[i])
                                      //           .delete()
                                      //           .then((value) {
                                      //         log("after deleting the audio from storage");
                                      //         chatController.deleteMsgIdList
                                      //             .remove(chatController.deleteAudioIdList[i]);
                                      //         chatController.deleteAudioIdList.removeAt(i);
                                      //         chatController.deleteAudioLinksList.removeAt(i);
                                      //       });
                                      //     });
                                      //   } catch (e) {
                                      //     log("error is: $e");
                                      //     //+show an error widget/dialog/snackbar.
                                      //   }
                                      // }
                                      for (int j = 0;
                                      j <
                                          chatController
                                              .deleteImageLinksList.length;
                                      j++) {
                                        deleteCount++;
                                        try {
                                          await FirebaseStorage.instance
                                              .refFromURL(chatController
                                              .deleteImageLinksList[j])
                                              .delete()
                                              .then(
                                                (value) async {
                                              log("after deleting the audio from storage");
                                              await ffstore
                                                  .collection(groupChatCollection)
                                                  .doc(widget
                                                  .docs!['groupId'])
                                                  .collection('messages')
                                                  .doc(chatController
                                                  .deleteImageIdsList[j])
                                                  .delete()
                                                  .then(
                                                    (value) {
                                                  log("after deleting the audio from storage");
                                                  chatController.deleteMsgIdList
                                                      .remove(chatController
                                                      .deleteImageIdsList[j]);
                                                  chatController
                                                      .deleteImageIdsList
                                                      .removeAt(j);
                                                  chatController
                                                      .deleteImageLinksList
                                                      .removeAt(j);
                                                },
                                              );
                                            },
                                          );
                                        } catch (e) {
                                          log("error is: $e");
                                          //+show an error widget/dialog/snackbar.
                                        }
                                      }
                                      log("remaining deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                      chatController.deleteMsgIdList.forEach(
                                            (element) async {
                                          deleteCount++;

                                          try {
                                            await ffstore
                                                .collection(groupChatCollection)
                                                .doc(widget.docs!['groupId'])
                                                .collection('messages')
                                                .doc(element)
                                                .delete();
                                          } catch (e) {
                                            log("error is: $e");
                                            //+show an error widget/dialog/snackbar.
                                          }
                                          log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                          chatController.deleteMsgIdList
                                              .remove(element);
                                          log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                        },
                                      );
                                      // chatController.deleteAudioIdList.forEach((element) async {
                                      //   try {
                                      //     await ffstore
                                      //         .collection(groupChatCollection)
                                      //         .doc(widget.docs['groupId'])
                                      //         .collection('chats')
                                      //         .doc(element)
                                      //         .delete();
                                      //   } catch (e) {
                                      //     log("error is: $e");
                                      //     //+show an error widget/dialog/snackbar.
                                      //   }
                                      // });
                                      chatController.isDeleting.value = false;
                                      chatController.deleteMsgIdList.clear();
                                      chatController.deleteAudioIdList.clear();
                                      chatController.deleteAudioLinksList
                                          .clear();
                                      chatController.deleteImageIdsList.clear();
                                      chatController.deleteImageLinksList
                                          .clear();
                                      Get.back();

                                      try {
                                        ffstore
                                            .collection(groupChatCollection)
                                            .doc(chatRoomID)
                                            .collection("messages")
                                            .orderBy("time", descending: true)
                                            .get()
                                            .then(
                                              (value) {
                                            if (value.docs.length > 0) {
                                              var firstEndDoc = value.docs
                                                  .firstWhereOrNull((element) =>
                                              !element['isDeletedFor']
                                                  .contains(auth
                                                  .currentUser
                                                  ?.uid));
                                              if (firstEndDoc != null) {
                                                log("firstEndDoc is: ${firstEndDoc.data()}");
                                                ffstore
                                                    .collection(groupChatCollection)
                                                    .doc(chatRoomID)
                                                    .update(
                                                  {
                                                    "lastMessageAt":
                                                    firstEndDoc['time'],
                                                    "lastMessage":
                                                    firstEndDoc['message'],
                                                    "lastMessageType":
                                                    firstEndDoc['type'],
                                                  },
                                                );
                                              } else {
                                                log("in else of docsnot being greater than zero in updating the lastMessage");
                                                ffstore
                                                    .collection(groupChatCollection)
                                                    .doc(chatRoomID)
                                                    .update(
                                                  {
                                                    "lastMessage": "",
                                                    "lastMessageType": "text",
                                                  },
                                                );
                                              }
                                            } else {
                                              log("in else of docsnot being greater than zero in updating the lastMessage");
                                              ffstore
                                                  .collection(groupChatCollection)
                                                  .doc(chatRoomID)
                                                  .update(
                                                {
                                                  "lastMessage": "",
                                                  "lastMessageType": "text",
                                                },
                                              );
                                            }
                                          },
                                        );
                                      } catch (e) {
                                        log("error in updating last message is: $e");
                                      }
                                    },
                                  ),

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //
                                //     Expanded(
                                //       child: GradientButton(
                                //         buttonText: 'Cancel',
                                //         onTap: () {
                                //           // Get.back();
                                //           chatController.isDeleting.value =
                                //               false;
                                //           chatController.deleteMsgIdList
                                //               .clear();
                                //           chatController.deleteLeftMsgIdList
                                //               .clear();
                                //           chatController.deleteAudioIdList
                                //               .clear();
                                //           chatController
                                //               .deleteAudioLinksList
                                //               .clear();
                                //           chatController.deleteImageIdsList
                                //               .clear();
                                //           chatController
                                //               .deleteImageLinksList
                                //               .clear();
                                //           Get.back();
                                //         },
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Expanded(
                                //       child: GradientButton(
                                //         buttonText: 'Delete for Me',
                                //         onTap: () async {
                                //           int deleteCount = 0;
                                //           Get.back();
                                //           Get.dialog(loading());
                                //           log("logging the list on delete button: ${chatController.deleteMsgIdList} ");
                                //           // chatController.deleteMsgIdList.forEach((element) async {
                                //           //   try {
                                //           //     await ffstore
                                //           //         .collection(groupChatCollection)
                                //           //         .doc(widget.docs['groupId'])
                                //           //         .collection('chats')
                                //           //         .doc(element)
                                //           //         .delete();
                                //           //   } catch (e) {
                                //           //     log("error is: $e");
                                //           //     //+show an error widget/dialog/snackbar.
                                //           //   }
                                //           //   log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                //           //   chatController.deleteMsgIdList.remove(element);
                                //           //   log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                //           // });
                                //           log("initial deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                //           // for (int i = 0; i < chatController.deleteAudioLinksList.length; i++) {
                                //           //   deleteCount++;
                                //           //   log("deleting through URL : ${chatController.deleteAudioLinksList[i]}");
                                //           //   try {
                                //           //     // await FirebaseStorage.instance
                                //           //     //     .refFromURL(chatController.deleteAudioLinksList[i])
                                //           //     //     .delete()
                                //           //     //     .then((value) async {
                                //           //     //   log("after deleting the audio from storage");
                                //           //     await ffstore
                                //           //         .collection(groupChatCollection)
                                //           //         .doc(widget.docs!['groupId'])
                                //           //         .collection('chats')
                                //           //         .doc(chatController.deleteAudioIdList[i])
                                //           //         .update({
                                //           //       "isDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid])
                                //           //     }).then((value) {
                                //           //       log("after deleting the audio from storage");
                                //           //       chatController.deleteMsgIdList
                                //           //           .remove(chatController.deleteAudioIdList[i]);
                                //           //       chatController.deleteAudioIdList.removeAt(i);
                                //           //       chatController.deleteAudioLinksList.removeAt(i);
                                //           //     });
                                //           //     // });
                                //           //   } catch (e) {
                                //           //     log("error is: $e");
                                //           //     //+show an error widget/dialog/snackbar.
                                //           //   }
                                //           // }
                                //           for (int j = 0;
                                //               j <
                                //                   chatController
                                //                       .deleteImageLinksList
                                //                       .length;
                                //               j++) {
                                //             deleteCount++;
                                //             try {
                                //               await ffstore
                                //                   .collection(groupChatCollection)
                                //                   .doc(widget
                                //                       .docs!['groupId'])
                                //                   .collection('messages')
                                //                   .doc(chatController
                                //                       .deleteImageIdsList[j])
                                //                   .update({
                                //                 "isDeletedFor":
                                //                     FieldValue.arrayUnion([
                                //                   auth.currentUser?.uid
                                //                 ])
                                //               }).then((value) {
                                //                 log("after deleting the audio from storage");
                                //                 chatController
                                //                     .deleteMsgIdList
                                //                     .remove(chatController
                                //                         .deleteImageIdsList[j]);
                                //                 chatController
                                //                     .deleteImageIdsList
                                //                     .removeAt(j);
                                //                 chatController
                                //                     .deleteImageLinksList
                                //                     .removeAt(j);
                                //               });
                                //               // });
                                //             } catch (e) {
                                //               log("error is: $e");
                                //               //+show an error widget/dialog/snackbar.
                                //             }
                                //           }
                                //           log("remaining deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                //           chatController.deleteMsgIdList
                                //               .forEach((element) async {
                                //             deleteCount++;
                                //             log("in deleteMsgIdList.forEach widget.docs!['groupId']: "
                                //                 "${widget.docs!['groupId']}");
                                //             try {
                                //               await ffstore
                                //                   .collection(groupChatCollection)
                                //                   .doc(widget
                                //                       .docs!['groupId'])
                                //                   .collection('messages')
                                //                   .doc(element)
                                //                   .update({
                                //                 "isDeletedFor":
                                //                     FieldValue.arrayUnion([
                                //                   auth.currentUser?.uid
                                //                 ])
                                //               });
                                //             } catch (e) {
                                //               log("error is: $e");
                                //               //+show an error widget/dialog/snackbar.
                                //             }
                                //             log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                //             chatController.deleteMsgIdList
                                //                 .remove(element);
                                //             log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                //           });
                                //           // chatController.deleteAudioIdList.forEach((element) async {
                                //           //   try {
                                //           //     await ffstore
                                //           //         .collection(groupChatCollection)
                                //           //         .doc(widget.docs['groupId'])
                                //           //         .collection('chats')
                                //           //         .doc(element)
                                //           //         .delete();
                                //           //   } catch (e) {
                                //           //     log("error is: $e");
                                //           //     //+show an error widget/dialog/snackbar.
                                //           //   }
                                //           // });
                                //           chatController.isDeleting.value =
                                //               false;
                                //           chatController.deleteMsgIdList
                                //               .clear();
                                //           chatController.deleteAudioIdList
                                //               .clear();
                                //           chatController
                                //               .deleteAudioLinksList
                                //               .clear();
                                //           chatController.deleteImageIdsList
                                //               .clear();
                                //           chatController
                                //               .deleteImageLinksList
                                //               .clear();
                                //           Get.back();
                                //           //
                                //           // List a = [];
                                //           // a.c
                                //           //+ below code is for updating the last message for me.
                                //           try {
                                //             await ffstore
                                //                 .collection("ChatRoom")
                                //                 .doc(chatRoomID)
                                //                 .collection("messages")
                                //                 // .where("isDeletedFor", whereIn: [
                                //                 //   [authController.userModel.value.id],
                                //                 //   [authController.userModel.value.id, anotherUserID]
                                //                 // ])
                                //                 .orderBy("time",
                                //                     descending: true)
                                //                 .get()
                                //                 .then((value) {
                                //               log("in then of  update last message query is: ${value.docs.length}");
                                //               if (value.docs.length > 0) {
                                //                 log("why not inside");
                                //                 // var firstEndDoc = value.docs.firstWhere((element) => element['message'] == "yyyy");
                                //                 var firstEndDoc = value.docs
                                //                     .firstWhereOrNull(
                                //                         (element) => !element[
                                //                                 'isDeletedFor']
                                //                             .contains(auth
                                //                                 .currentUser
                                //                                 ?.uid));
                                //                 log("firstEndDoc: $firstEndDoc");
                                //                 if (firstEndDoc != null) {
                                //                   log("firstEndDoc is: ${firstEndDoc.data()}");
                                //                   // if(firstEndDoc['type'] == "text"){
                                //                   // }
                                //                   ffstore
                                //                       .collection(
                                //                           "ChatRoom")
                                //                       .doc(chatRoomID)
                                //                       .update({
                                //                     "lastMessageAt":
                                //                         firstEndDoc['time'],
                                //                     "lastMessage":
                                //                         firstEndDoc[
                                //                             'message'],
                                //                     "lastMessageType":
                                //                         firstEndDoc['type'],
                                //                   });
                                //                 } else {
                                //                   ffstore
                                //                       .collection(
                                //                           "ChatRoom")
                                //                       .doc(chatRoomID)
                                //                       .update({
                                //                     "lastMessage": "",
                                //                     "lastMessageType":
                                //                         "text",
                                //                   });
                                //                 }
                                //               } else {
                                //                 ffstore
                                //                     .collection("ChatRoom")
                                //                     .doc(chatRoomID)
                                //                     .update({
                                //                   "lastMessage": "",
                                //                   "lastMessageType": "text",
                                //                 });
                                //               }
                                //             });
                                //           } catch (e) {
                                //             log("error in updating last message is: $e");
                                //           }
                                //         },
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // if (chatController.deleteLeftMsgIdList.length ==
                                //     0)
                                //   Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //       Expanded(
                                //         child: GradientButton(
                                //           buttonText: 'Delete for everyone',
                                //           onTap: () async {
                                //             int deleteCount = 0;
                                //             Get.back();
                                //             Get.dialog(loading());
                                //             log("logging the list on delete button: ${chatController.deleteMsgIdList} ");
                                //             // chatController.deleteMsgIdList.forEach((element) async {
                                //             //   try {
                                //             //     await ffstore
                                //             //         .collection(groupChatCollection)
                                //             //         .doc(widget.docs['groupId'])
                                //             //         .collection('chats')
                                //             //         .doc(element)
                                //             //         .delete();
                                //             //   } catch (e) {
                                //             //     log("error is: $e");
                                //             //     //+show an error widget/dialog/snackbar.
                                //             //   }
                                //             //   log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                //             //   chatController.deleteMsgIdList.remove(element);
                                //             //   log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                //             // });
                                //             log("initial deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                //             // for (int i = 0; i < chatController.deleteAudioLinksList.length; i++) {
                                //             //   deleteCount++;
                                //             //   log("deleting through URL : ${chatController.deleteAudioLinksList[i]}");
                                //             //   try {
                                //             //     await FirebaseStorage.instance
                                //             //         .refFromURL(chatController.deleteAudioLinksList[i])
                                //             //         .delete()
                                //             //         .then((value) async {
                                //             //       log("after deleting the audio from storage");
                                //             //       await ffstore
                                //             //           .collection(groupChatCollection)
                                //             //           .doc(widget.docs!['groupId'])
                                //             //           .collection('messages')
                                //             //           .doc(chatController.deleteAudioIdList[i])
                                //             //           .delete()
                                //             //           .then((value) {
                                //             //         log("after deleting the audio from storage");
                                //             //         chatController.deleteMsgIdList
                                //             //             .remove(chatController.deleteAudioIdList[i]);
                                //             //         chatController.deleteAudioIdList.removeAt(i);
                                //             //         chatController.deleteAudioLinksList.removeAt(i);
                                //             //       });
                                //             //     });
                                //             //   } catch (e) {
                                //             //     log("error is: $e");
                                //             //     //+show an error widget/dialog/snackbar.
                                //             //   }
                                //             // }
                                //             for (int j = 0;
                                //                 j <
                                //                     chatController
                                //                         .deleteImageLinksList
                                //                         .length;
                                //                 j++) {
                                //               deleteCount++;
                                //               try {
                                //                 await FirebaseStorage.instance
                                //                     .refFromURL(chatController
                                //                         .deleteImageLinksList[j])
                                //                     .delete()
                                //                     .then(
                                //                   (value) async {
                                //                     log("after deleting the audio from storage");
                                //                     await ffstore
                                //                         .collection(groupChatCollection)
                                //                         .doc(widget.docs![
                                //                             'groupId'])
                                //                         .collection('messages')
                                //                         .doc(chatController
                                //                             .deleteImageIdsList[j])
                                //                         .delete()
                                //                         .then(
                                //                       (value) {
                                //                         log("after deleting the audio from storage");
                                //                         chatController
                                //                             .deleteMsgIdList
                                //                             .remove(chatController
                                //                                 .deleteImageIdsList[j]);
                                //                         chatController
                                //                             .deleteImageIdsList
                                //                             .removeAt(j);
                                //                         chatController
                                //                             .deleteImageLinksList
                                //                             .removeAt(j);
                                //                       },
                                //                     );
                                //                   },
                                //                 );
                                //               } catch (e) {
                                //                 log("error is: $e");
                                //                 //+show an error widget/dialog/snackbar.
                                //               }
                                //             }
                                //             log("remaining deleteMsgIdList: ${chatController.deleteMsgIdList}");
                                //             chatController.deleteMsgIdList
                                //                 .forEach(
                                //               (element) async {
                                //                 deleteCount++;
                                //
                                //                 try {
                                //                   await ffstore
                                //                       .collection(groupChatCollection)
                                //                       .doc(widget
                                //                           .docs!['groupId'])
                                //                       .collection('messages')
                                //                       .doc(element)
                                //                       .delete();
                                //                 } catch (e) {
                                //                   log("error is: $e");
                                //                   //+show an error widget/dialog/snackbar.
                                //                 }
                                //                 log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
                                //                 chatController.deleteMsgIdList
                                //                     .remove(element);
                                //                 log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
                                //               },
                                //             );
                                //             // chatController.deleteAudioIdList.forEach((element) async {
                                //             //   try {
                                //             //     await ffstore
                                //             //         .collection(groupChatCollection)
                                //             //         .doc(widget.docs['groupId'])
                                //             //         .collection('chats')
                                //             //         .doc(element)
                                //             //         .delete();
                                //             //   } catch (e) {
                                //             //     log("error is: $e");
                                //             //     //+show an error widget/dialog/snackbar.
                                //             //   }
                                //             // });
                                //             chatController.isDeleting.value =
                                //                 false;
                                //             chatController.deleteMsgIdList
                                //                 .clear();
                                //             chatController.deleteAudioIdList
                                //                 .clear();
                                //             chatController.deleteAudioLinksList
                                //                 .clear();
                                //             chatController.deleteImageIdsList
                                //                 .clear();
                                //             chatController.deleteImageLinksList
                                //                 .clear();
                                //             Get.back();
                                //
                                //             try {
                                //               ffstore
                                //                   .collection("ChatRoom")
                                //                   .doc(chatRoomID)
                                //                   .collection("messages")
                                //                   .orderBy("time",
                                //                       descending: true)
                                //                   .get()
                                //                   .then(
                                //                 (value) {
                                //                   if (value.docs.length > 0) {
                                //                     var firstEndDoc = value.docs
                                //                         .firstWhereOrNull(
                                //                             (element) => !element[
                                //                                     'isDeletedFor']
                                //                                 .contains(auth
                                //                                     .currentUser
                                //                                     ?.uid));
                                //                     if (firstEndDoc != null) {
                                //                       log("firstEndDoc is: ${firstEndDoc.data()}");
                                //                       ffstore
                                //                           .collection(
                                //                               "ChatRoom")
                                //                           .doc(chatRoomID)
                                //                           .update(
                                //                         {
                                //                           "lastMessageAt":
                                //                               firstEndDoc[
                                //                                   'time'],
                                //                           "lastMessage":
                                //                               firstEndDoc[
                                //                                   'message'],
                                //                           "lastMessageType":
                                //                               firstEndDoc[
                                //                                   'type'],
                                //                         },
                                //                       );
                                //                     } else {
                                //                       log("in else of docsnot being greater than zero in updating the lastMessage");
                                //                       ffstore
                                //                           .collection(
                                //                               "ChatRoom")
                                //                           .doc(chatRoomID)
                                //                           .update(
                                //                         {
                                //                           "lastMessage": "",
                                //                           "lastMessageType":
                                //                               "text",
                                //                         },
                                //                       );
                                //                     }
                                //                   } else {
                                //                     log("in else of docsnot being greater than zero in updating the lastMessage");
                                //                     ffstore
                                //                         .collection("ChatRoom")
                                //                         .doc(chatRoomID)
                                //                         .update(
                                //                       {
                                //                         "lastMessage": "",
                                //                         "lastMessageType":
                                //                             "text",
                                //                       },
                                //                     );
                                //                   }
                                //                 },
                                //               );
                                //             } catch (e) {
                                //               log("error in updating last message is: $e");
                                //             }
                                //           },
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                              ],
                            ),
                          ),
                          backgroundColor: kPrimaryColor,
                          isScrollControlled: true,
                        );
                      },
                      child: Image.asset(
                        Assets.imagesDeleteMsg,
                        height: 24,
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                              () => SendInvitations(
                            docs: widget.docs,
                          ),
                        );
                        // showModalBottomSheet(
                        //   backgroundColor: Colors.transparent,
                        //   elevation: 0,
                        //   context: context,
                        //   builder: (context) {
                        //     return Container(
                        //       height: 400,
                        //       padding: EdgeInsets.symmetric(
                        //         horizontal: 30,
                        //       ),
                        //       decoration: BoxDecoration(
                        //         color: kPrimaryColor,
                        //         borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(28),
                        //           topRight: Radius.circular(28),
                        //         ),
                        //       ),
                        //       child: SingleChildScrollView(
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             SizedBox(
                        //               height: 10,
                        //             ),
                        //             Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Container(),
                        //                 MyText(
                        //                   text: 'Send invitation',
                        //                   size: 19,
                        //                   color: kSecondaryColor,
                        //                 ),
                        //                 GestureDetector(
                        //                   onTap: () async {
                        //                     Navigator.pop(context);
                        //                   },
                        //                   child: Image.asset(
                        //                     Assets.imagesRoundedClose,
                        //                     height: 22.44,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             SizedBox(
                        //               height: 30,
                        //             ),
                        //             SimpleTextField(
                        //               hintText: 'Type username,  email...',
                        //               controller: userNameController,
                        //               onChanged: (value) {
                        //                 userNameObsString.value = value;
                        //               },
                        //             ),
                        //             SizedBox(
                        //               height: 10,
                        //             ),
                        //             Obx(() {
                        //               if (userNameObsString.value != "") {
                        //                 // List<String> tempList = selectedUsers.length > 0 ? List<String>.from(selectedUsers.keys.toList()) : ["check"];
                        //                 return StreamBuilder<
                        //                     QuerySnapshot<Map<String, dynamic>>>(
                        //                   stream: ffstore
                        //                       .collection(accountsCollection)
                        //                       .where("userSearchParameters",
                        //                           arrayContains:
                        //                               userNameObsString.value.trim())
                        //                       .limit(3)
                        //                       // .where("uID", whereNotIn: tempList)
                        //                       .snapshots(),
                        //                   builder: (
                        //                     BuildContext context,
                        //                     AsyncSnapshot<QuerySnapshot> snapshot,
                        //                   ) {
                        //                     //log("inside stream-builder");
                        //                     if (snapshot.connectionState ==
                        //                         ConnectionState.waiting) {
                        //                       log("inside stream-builder in waiting state");
                        //                       return Center(
                        //                           child: CircularProgressIndicator());
                        //                     } else if (snapshot.connectionState ==
                        //                             ConnectionState.active ||
                        //                         snapshot.connectionState ==
                        //                             ConnectionState.done) {
                        //                       if (snapshot.hasError) {
                        //                         return const Text(
                        //                             'Some unknown error occurred');
                        //                       } else if (snapshot.hasData) {
                        //                         // log("inside hasData and ${snapshot.data!.docs}");
                        //                         if (snapshot.data!.docs.length > 0) {
                        //                           return ListView.builder(
                        //                             shrinkWrap: true,
                        //                             physics: BouncingScrollPhysics(),
                        //                             padding: EdgeInsets.symmetric(
                        //                               horizontal: 15,
                        //                             ),
                        //                             itemCount:
                        //                                 snapshot.data!.docs.length,
                        //                             itemBuilder: (context, index) {
                        //                               UserDetailsModel umdl =
                        //                                   UserDetailsModel.fromJson(
                        //                                       snapshot.data!
                        //                                               .docs[index]
                        //                                               .data()
                        //                                           as Map<String,
                        //                                               dynamic>);
                        //                               return Obx(() {
                        //                                 if (selectedId.value ==
                        //                                         umdl.uID ||
                        //                                     umdl.uID ==
                        //                                         auth.currentUser
                        //                                             ?.uid) {
                        //                                   return SizedBox();
                        //                                 }
                        //                                 return contactTiles(
                        //                                   profileImage:
                        //                                       umdl.profileImageUrl,
                        //                                   name: umdl.fullName,
                        //                                   id: umdl.uID,
                        //                                   email: umdl.email,
                        //                                 );
                        //                               });
                        //                             },
                        //                           );
                        //                         } else {
                        //                           if (finalizedNameString == "") {
                        //                             return Center(
                        //                                 child: const Text(
                        //                                     'No Users Found'));
                        //                           }
                        //                           return SizedBox();
                        //                         }
                        //                       } else {
                        //                         log("in else of hasData done and: ${snapshot.connectionState} and"
                        //                             " snapshot.hasData: ${snapshot.hasData}");
                        //                         if (finalizedNameString == "") {
                        //                           return Center(
                        //                               child: const Text(
                        //                                   'No Users Found'));
                        //                         }
                        //                         return SizedBox();
                        //                       }
                        //                     } else {
                        //                       log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                        //                       return Center(
                        //                           child: Text(
                        //                               'Some Error occurred while fetching the posts'));
                        //                     }
                        //                   },
                        //                 );
                        //               }
                        //               return SizedBox();
                        //             }),
                        //             SizedBox(
                        //               height: 10,
                        //             ),
                        //             Padding(
                        //               padding: EdgeInsets.only(
                        //                   bottom: MediaQuery.of(context)
                        //                       .viewInsets
                        //                       .bottom),
                        //               child: SimpleTextField(
                        //                 maxLines: 5,
                        //                 hintText: 'Message...',
                        //                 controller: messageController,
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 20,
                        //             ),
                        //             MyButton(
                        //               onTap: () async {
                        //                 //+ put the code to present the option or just by default do both.
                        //                 //+ sending a notification and also open sharing sheet to share via
                        //                 //+ social media or something.
                        //                 if (finalizedNameString != "" &&
                        //                     messageController.text.trim() != "") {
                        //                   loading();
                        //                   GroupChatRoomModel groupChatModel =
                        //                       GroupChatRoomModel.fromJson(
                        //                           widget.docs ?? {});
                        //                   log("groupChatModel: ${groupChatModel.toJson()}");
                        //                   String shareLink = await DynamicLinkHandler
                        //                       .buildDynamicLinkGroupInvite(
                        //                     groupId: groupChatModel.groupId ?? "",
                        //                     groupName: groupChatModel.groupName ?? "",
                        //                     groupImage:
                        //                         groupChatModel.groupImage ?? "",
                        //                     groupInviteMessage:
                        //                         "${userDetailsModel.fullName} invited you to ${groupChatModel.groupName} "
                        //                         "group chat: ${messageController.text.trim()}.",
                        //                     short: true,
                        //                   );
                        //                   log("fetched shareLink: $shareLink");
                        //                   ShareResult sr =
                        //                       await Share.shareWithResult(shareLink);
                        //                   Get.back();
                        //                   await ffstore
                        //                       .collection(
                        //                           groupChatInvitationCollection)
                        //                       .add({
                        //                     "groupId": groupChatModel.groupId ?? "",
                        //                     "groupName":
                        //                         groupChatModel.groupName ?? "",
                        //                     "groupImage":
                        //                         groupChatModel.groupImage ?? "",
                        //                     "invitedId": selectedId.value,
                        //                     "invitedName":
                        //                         userNameController.text.trim(),
                        //                     "invitedById": userDetailsModel.uID,
                        //                     "invitedByName":
                        //                         userDetailsModel.fullName,
                        //                     "invitedAt":
                        //                         DateTime.now().millisecondsSinceEpoch,
                        //                   });
                        //                   log("ShareResult is: ${sr.status} sr.status == ShareResultStatus.success: ${sr.status == ShareResultStatus.success}");
                        //                   log("ShareResult is: ${sr.status} sr.status == ShareResultStatus.dismissed: ${sr.status == ShareResultStatus.dismissed}");
                        //                   log("ShareResult.raw is: ${sr.raw}");
                        //                 } else {
                        //                   showMsg(
                        //                       context: context,
                        //                       msg:
                        //                           "Please fill out both fields properly to send the invite.");
                        //                 }
                        //               },
                        //               buttonText: 'Invite to the group',
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   isScrollControlled: true,
                        // );
                      },
                      child: Image.asset(
                        Assets.imagesInvite,
                        height: 35,
                      ),
                    ),
                  ),
                );
              }
            }),

          ],
        ),
        body: Stack(
          children: [
            chatMessageList(),
            sendField(context),
          ],
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

  Widget sendField(
    BuildContext context,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        height: 80,
        width: width(context, 1.0),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.03),
              offset: const Offset(0, -1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor: kSecondaryColor,
                    controller: messageEditingController.value,
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
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                            ),
                            child: Wrap(
                              spacing: 10.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    getVideoFromGallery();
                                  },
                                  child: Image.asset(
                                    Assets.imagesFilm,
                                    color: kLightPurpleColor,
                                    height: 19.52,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    getImageFromGallery();
                                  },
                                  child: Image.asset(
                                    Assets.imagesPhoto,
                                    height: 16.52,
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  onTap: () {
                    sendMessage();
                  },
                  child: Image.asset(
                    Assets.imagesSend,
                    height: 45.16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
// Widget sendField(
//   BuildContext context,
// ) {
//   return Align(
//     alignment: Alignment.bottomCenter,
//     child: Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 15,
//       ),
//       height: 80,
//       width: width(context, 1.0),
//       decoration: BoxDecoration(
//         color: kPrimaryColor,
//         boxShadow: [
//           BoxShadow(
//             color: kBlackColor.withOpacity(0.03),
//             offset: const Offset(0, -1),
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   cursorColor: kSecondaryColor,
//                   cursorWidth: 1.0,
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: kSecondaryColor,
//                   ),
//                   decoration: InputDecoration(
//                     hintStyle: TextStyle(
//                       fontSize: 15,
//                       color: kSecondaryColor,
//                     ),
//                     hintText: 'Write a message...',
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 15,
//                     ),
//                     fillColor: kLightBlueColor,
//                     filled: true,
//                     prefixIcon: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {},
//                           child: Image.asset(
//                             Assets.imagesEmoji,
//                             height: 19.31,
//                           ),
//                         ),
//                       ],
//                     ),
//                     suffixIcon: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           spacing: 10.0,
//                           children: [
//                             GestureDetector(
//                               onTap: () {},
//                               child: Image.asset(
//                                 Assets.imagesAttachFiles,
//                                 height: 20.53,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {},
//                               child: Image.asset(
//                                 Assets.imagesPhoto,
//                                 height: 16.52,
//                               ),
//                             ),
//                             SizedBox(),
//                           ],
//                         ),
//                       ],
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(50),
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1.0,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(50),
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1.0,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(50),
//                       borderSide: BorderSide(
//                         color: Colors.red,
//                         width: 1.0,
//                       ),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(50),
//                       borderSide: BorderSide(
//                         color: Colors.red,
//                         width: 1.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 15,
//               ),
//               Image.asset(
//                 Assets.imagesSend,
//                 height: 45.16,
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
