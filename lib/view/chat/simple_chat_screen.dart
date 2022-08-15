import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/chat_models/chat_room_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/provider/chat_provider/chat_provider.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/preview_image.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/message_bubbles.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

import '../widget/loading.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    this.receiveImage,
    this.receiveName,
    this.docs,
    this.isArchived = false,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var receiveImage, receiveName;
  Map<String, dynamic>? docs;
  bool? isArchived = false;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Rx<TextEditingController> messageEditingController =
      TextEditingController().obs;
  TextEditingController _tec = TextEditingController();
  ScrollController scrollController = ScrollController();

  // RxBool isDeleting = false;
  // String recordFilePath;
  String chatRoomID = "";
  String userID = "";
  String userName = "";
  String anotherUserID = "";
  String anotherUserName = "";
  String anotherUserImage = "";
  bool attachFiles = false;
  bool emojiShowing = false;
  RxBool isRecording = false.obs;
  RxBool isSending = false.obs;
  RxInt lastIndex = 0.obs;
  int i = 0;

  Map<String, String> _paths = {};

  String key = "";
  String salt = "";
  File? imageFile;
  bool isWaiting = false;
  bool isAssigned = false;
  String imageUrl = '';
  String imgPlaceholder =
      'https://thumbs.dreamstime.com/z/placeholder-icon-vector-isolated-white-background-your-web-mobile-app-design-placeholder-logo-concept-placeholder-icon-134071364.jpg';
  List<String> monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Stream? chatMessageStream;
  RxInt lastMessageAt = 0.obs;
  RxString lastMessage = "".obs;
  RxInt time = 0.obs;
  bool isOpenedUp = true;
  final Rx<ChatRoomModel> crm = ChatRoomModel().obs;
  Rx<UserDetailsModel> anotherUserModel = UserDetailsModel().obs;
  final RxBool isMatchedOrNot = false.obs;
  final RxString privacySettings = "Everyone".obs;
  final String deleteFor = "Everyone";
  RxBool isArchivedRoom = false.obs;
  RxBool isPrivacAllowed = true.obs;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? otherUserListener;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? chatRoomListener;

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  uploadAudio({String? minutes, String? seconds}) {
    log("'audio-time in uploadAudio': '${minutes}:${seconds}'");
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(
        '${chatRoomID}/audio${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');

    UploadTask task =
        firebaseStorageRef.putFile(File(chatController.recordFilePath ?? ""));
    task.then((value) async {
      print('##############done#########');
      // task.snapshotEvents.listen((event) {
      //   chatController.uploadProgress.value = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      //   log("progress iS: ${chatController.uploadProgress.value}");
      // });
      var audioURL = await value.ref.getDownloadURL();

      // chatController.uploadProgress.value =(value.totalBytes / value.bytesTransferred) * 100;
      // log("progress iS: ${chatController.uploadProgress.value}");
      String strVal = audioURL.toString();
      await sendAudioMsg(audioMsg: strVal, minutes: minutes, seconds: seconds);
      chatController.isAudioBeingSent.value = false;
    }).catchError((e) {
      print(e);
    });
  }

  sendAudioMsg({String? audioMsg, String? minutes, String? seconds}) async {
    log("'audio-time in sendAudioMsg': '${minutes}:${seconds}'");
    bool isAudioMsgEmpty = audioMsg?.isNotEmpty ?? false;
    if (isAudioMsgEmpty) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var time = DateTime.now().millisecondsSinceEpoch;

        Map<String, dynamic> messageMap = {
          "sendById": userDetailsModel.uID,
          "sendByName": userDetailsModel.fullName,
          "receivedById": anotherUserID,
          "receivedByName": anotherUserName,
          "message": audioMsg,
          'audio-time': '${minutes}:${seconds}',
          "type": "audio",
          'time': time,
          'isDeletedFor': [],
          "isRead": false,
          "isReceived": false,
        };
        bool isDeletedFor =
            crm.value.notDeletedFor?.asMap().containsValue(anotherUserID) ??
                false;
        if (!isDeletedFor) {
          fs.collection("ChatRoom").doc(chatRoomID).update({
            "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
          });
        }
        chatController.addConversationMessage(
            chatRoomID, time, "audio", messageMap, audioMsg!);
        messageEditingController.value.text = "";
        chatController.messageControllerText.value = "";
      }).then((value) {
        isSending.value = false;
      });
    } else {
      print("Hello");
    }
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      chatController.recordFilePath = await getFilePath();

      RecordMp3.instance.start(chatController.recordFilePath ?? "", (type) {});
    } else {
      await checkPermission();
      startRecord();
    }
  }

  //+stopAudio moved to chatcontroller

  void stopRecord({String? minutes, String? seconds}) async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      isSending.value = true;
      log("'audio-time in stopRecord': '${minutes}:${seconds}'");
      await uploadAudio(minutes: minutes, seconds: seconds);
      // isPlayingMsg.value = false;
    }
  }

  void stopRecordWithoutUpload() async {
    bool s = RecordMp3.instance.stop();
    // if (s) {
    //   // isSending.value = true;
    //   // await uploadAudio();
    //   // isPlayingMsg.value = false;
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    log("passwd doc is: ${widget.docs}");
    isOpenedUp = true;
    // getUserDataFromChatRoomDB();
    getRoomId();
    getChatRoomStream();
    super.initState();

    // KeyboardVisibilityController().onChange.listen((event) {
    //   chatController.isKeyboardOpen.value = event;
    // });
    isArchivedRoom.value = widget.isArchived!;
  }

  getRoomId() async {
    // SharedPreferences _prefs = await SharedPreferences.getInstance();
    userID = userDetailsModel.uID!;
    log("userID: $userID");
    if (userDetailsModel.uID! != widget.docs!['user2Model']['uID']) {
      anotherUserID = widget.docs!['user2Model']['uID'];
      anotherUserName = widget.docs!['user2Model']['fullName'];
      anotherUserImage = widget.docs!['user2Model']['profileImageUrl'];
    } else {
      anotherUserID = widget.docs!['user1Model']['uID'];
      anotherUserName = widget.docs!['user1Model']['fullName'];
      anotherUserImage = widget.docs!['user1Model']['profileImageUrl'];
    }
    log("anotherUserID: $anotherUserID");
    log("anotherUserName: $anotherUserName");
    log("anotherUserImage: $anotherUserImage");

    chatRoomID = chatController.getChatRoomId(userID, anotherUserID);
    otherUserListener = await fs
        .collection("Accounts")
        .doc(anotherUserID)
        .snapshots()
        .listen((event) {
      log("updating anotherUserModel");
      anotherUserModel.value = UserDetailsModel.fromJson(event.data() ?? {});

    });
  }

  getUserDataFromChatRoomDB() async {
    log("CHanging the crm values from getUserDataFromChatRoomDB");
    await fs
        .collection("ChatRoom")
        .doc(widget.docs!["chatRoomId"])
        .get()
        .then((value) {
      crm.value = ChatRoomModel.fromDocumentSnapshot(value);
      log("CHanging the crm values in get from getUserDataFromChatRoomDB");
    });
    await fs.collection("ChatRoom").doc(chatRoomID).snapshots().listen((event) {
      log("CHanging the crm values in snapshot from getUserDataFromChatRoomDB");
      crm.value = ChatRoomModel.fromDocumentSnapshot(event);
    });
  }


  String? path;

  Future getImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        path = xFile.path;
        // showLoading();
        Get.to(
              () => PreviewImageScreen(
            imagePath: path,
            anotherUserId: anotherUserID,
            anotherUserName: anotherUserName,
            chatRoomId: crm.value.chatRoomId,
            userId: userID,
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
              () => PreviewImageScreen(
            imagePath: path,
            anotherUserId: anotherUserID,
            anotherUserName: anotherUserName,
            chatRoomId: crm.value.chatRoomId,
            userId: userID,
          ),
        );
        // uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;
    // Get.to(() => PreviewImageScreen(imagePath: path, fileName: fileName));
    Get.dialog(
      Container(
        color: kBlackColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //TODO: he will make it look better.
          // alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('clicked the x close button.');
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Image.file(
                  imageFile!,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      loading();
                      var ref = FirebaseStorage.instance
                          .ref()
                          .child(chatRoomID)
                          .child("$fileName.jpg");
                      var uploadTask = await ref
                          .putFile(imageFile!)
                          .catchError((error) async {
                        print(
                            'in uploading error and eoor is: $error'); // await FirebaseFirestore.instance
                        status = 0;
                      });
                      if (status == 1) {
                        imageUrl = await uploadTask.ref.getDownloadURL();
                        log('this is status 1');
                        print(imageUrl);
                        sendMessage(imageUrl);
                        Get.back();
                        Get.back();
                        // sendMessage(imageUrl);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        // FontAwesomeIcons.solidPaperPlane,
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      barrierDismissible: false,
    );
    /**/
  }


  getChatRoomStream() async {
    // crm.value = ChatRoomModel.fromDocumentSnapshot(event);
    chatRoomListener = await fs
        .collection("ChatRoom")
        .doc(widget.docs!['chatRoomId'])
        .snapshots()
        .listen((event) {
      lastMessageAt.value = event['lastMessageAt'];
      lastMessage.value = event['lastMessage'];
      crm.value = ChatRoomModel.fromDocumentSnapshot(event);
      // isArchivedRoom.value = crm.value.inActiveFor.asMap().containsValue(authController.userModel.value.id);
      log("\n\n\n getChatRoomStream called and lastMessageAt: $lastMessageAt"
          " lastMessage: $lastMessage \n\n\n");
    });
  }

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
        "receivedById": anotherUserID,
        "receivedByName": anotherUserName,
        "message": messageText,
        "type": "text",
        'time': time,
        'isDeletedFor': [],
        "isRead": false,
        "isReceived": false,
      };
      bool isDeletedFor =
          crm.value.notDeletedFor?.asMap().containsValue(anotherUserID) ??
              false;
      if (!isDeletedFor) {
        fs.collection("ChatRoom").doc(chatRoomID).update({
          "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
        });
      }
      chatController.addConversationMessage(
          chatRoomID, time, "text", messageMap, messageText);
      log("index is: ${lastIndex.value}");
    } else if (imageFile != null && (imageUrl != null || imageUrl != "")) {
      var time = DateTime.now().millisecondsSinceEpoch;

      Map<String, dynamic> messageMap = {
        "sendById": userDetailsModel.uID,
        "sendByName": userDetailsModel.fullName,
        "receivedById": anotherUserID,
        "receivedByName": anotherUserName,
        "message": imageUrl,
        "type": "image",
        'time': time,
        'isDeletedFor': [],
        "isRead": false,
        "isReceived": false,
      };
      bool isDeletedFor =
          crm.value.notDeletedFor?.asMap().containsValue(anotherUserID) ??
              false;

      if (!isDeletedFor) {
        fs.collection("ChatRoom").doc(chatRoomID).update({
          "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
        });
      }
      chatController.addConversationMessage(
          chatRoomID, time, "image", messageMap, imageUrl!);
      // groupedItemScrollController.scrollTo(
      //   index: lastIndex.value,
      //   duration: Duration(microseconds: 300),
      //   curve: Curves.ease,
      // );
      // setState(() {});
      // scrollController.animateTo(scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 100), curve: Curves.ease);
      // setState(() {
      messageEditingController.value.text = "";

      imageUrl = "";
    }
    chatController.messageControllerText.value = "";
  }

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: fs
          .collection(chatRoomCollection)
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
                scrollController.jumpTo(
                  scrollController.position.maxScrollExtent,
                  // curve: Curves.easeIn, duration: Duration(milliseconds: 1000)
                );
              }
              // else {
              //    // setState(() => null);
              //  }
            },
          );
          // * */
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 15,
            ),
            controller: scrollController,
            // reverse: true,
            // shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  snapshot.data?.docs[index].data() as Map<String, dynamic>;
              print(
                  "snapshot.data.docs[index].data()[type] is: ${data["type"]}");
              //TODO: Beware, here the widgets to show data start.
              //TODO: Beware, here the widgets to show data start.
              String type = data["type"];
              String message =
                  data["message"] != null ? data["message"] : "what is this?";
              bool sendByMe = userDetailsModel.uID == data["sendById"];
              String time = data["time"].toString();

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
              switch (type) {
                case 'text':
                  return MessageBubbles(
                    receiveImage: anotherUserImage,
                    msg: message,
                    time: "${hour.toString()}:"
                        "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                        "${ampm}",
                    senderType: !sendByMe ? 'receiver' : 'sender',
                  );
                  // return sendByMe
                  //     ? RightBubble(
                  //         type: 'text',
                  //         time: "${hour.toString()}:"
                  //             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                  //             "${ampm}",
                  //         msg: message,
                  //       )
                  //     : LeftBubble(
                  //         personImage: anotherUserImage,
                  //         type: 'text',
                  //         time: "${hour.toString()}:"
                  //             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                  //             "${ampm}",
                  //         msg: message,
                  //       );
                  break;
                // case 'image':
                //   return MessageBubbles(
                //     receiveImage: widget.receiveImage,
                //     msg: index.isEven
                //         ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
                //         : 'Thanks, i\'ll be there.',
                //     time: '11:21 AM',
                //     senderType: !sendByMe ? 'receiver' : 'sender',
                //   );
                //   /**/
                //   // return sendByMe
                //   //     ? RightBubble(
                //   //         type: 'image',
                //   //         msg: message,
                //   //         time: "${hour.toString()}:"
                //   //             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                //   //             "${ampm}",
                //   //       )
                //   //     : LeftBubble(
                //   //         personImage: anotherUserImage,
                //   //         type: 'image',
                //   //         msg: message,
                //   //         time: "${hour.toString()}:"
                //   //             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                //   //             "${ampm}",
                //   //       );
                //   /**/
                //   break;
                default:
                  return Container();
              }
              // return MessageTile(
              //   type: snapshot.data.docs[index].data()["type"],
              //   message: messageSnap.data != null
              //       ? messageSnap.data
              //       : "what is this?",
              //   sendByMe: authController.userModel.value.id ==
              //       snapshot.data.docs[index].data()["sendById"],
              //   time: snapshot.data.docs[index].data()["time"].toString(),
              // );
            },
          );
        } else {
          return Container(
            child: Center(
              child: Text("Loading...."),
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
          title: chatController.showSearch.value
              ? SearchBar()
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0,
                  children: [
                    Obx(() {
                      return profileImage(
                        context,
                        size: 34.0,
                        profileImage:
                            anotherUserModel.value.profileImageUrl != null
                                ? anotherUserModel.value.profileImageUrl
                                : anotherUserImage,
                      );
                    }),
                    Obx(() {
                      return MyText(
                        text: anotherUserModel.value.fullName != null
                            ? anotherUserModel.value.fullName
                            : anotherUserName,
                        size: 19,
                        color: kSecondaryColor,
                      );
                    }),
                  ],
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () => chatController.showSearchBar(),
                  child: Image.asset(
                    Assets.imagesSearchWithBg,
                    height: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            chatMessageList(),
            // ListView.builder(
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            //   physics: const BouncingScrollPhysics(),
            //   itemCount: 4,
            //   itemBuilder: (context, index) {
            //     return MessageBubbles(
            //       receiveImage: widget.receiveImage,
            //       msg: index.isEven
            //           ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
            //           : 'Thanks, i\'ll be there.',
            //       time: '11:21 AM',
            //       senderType: index.isEven ? 'receiver' : 'sender',
            //     );
            //   },
            // ),
            sendField(context),
          ],
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
                          // SizedBox(
                          //   width: 50,
                          //   child: EmojiPicker(
                          //     onEmojiSelected: (category, emoji) {
                          //       // Do something when emoji is tapped (optional)
                          //     },
                          //     onBackspacePressed: () {
                          //       // Do something when the user taps the backspace button (optional)
                          //     },
                          //     textEditingController:
                          //         messageEditingController.value,
                          //     // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                          //     config: Config(
                          //       columns: 7,
                          //       emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          //       // Issue: https://github.com/flutter/flutter/issues/28894
                          //       verticalSpacing: 0,
                          //       horizontalSpacing: 0,
                          //       gridPadding: EdgeInsets.zero,
                          //       initCategory: Category.RECENT,
                          //       bgColor: Color(0xFFF2F2F2),
                          //       indicatorColor: Colors.blue,
                          //       iconColor: Colors.grey,
                          //       iconColorSelected: Colors.blue,
                          //       progressIndicatorColor: Colors.blue,
                          //       backspaceColor: Colors.blue,
                          //       skinToneDialogBgColor: Colors.white,
                          //       skinToneIndicatorColor: Colors.grey,
                          //       enableSkinTones: true,
                          //       showRecentsTab: true,
                          //       recentsLimit: 28,
                          //       noRecents: const Text(
                          //         'No Recent',
                          //         style: TextStyle(
                          //           fontSize: 20,
                          //           color: Colors.black26,
                          //         ),
                          //         textAlign: TextAlign.center,
                          //       ),
                          //       tabIndicatorAnimDuration: kTabScrollDuration,
                          //       categoryIcons: const CategoryIcons(),
                          //       buttonMode: ButtonMode.MATERIAL,
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              Assets.imagesEmoji,
                              height: 19.31,
                            ),
                          ),
                        ],
                      ),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              getImageFromGallery();
                            },
                            child: Image.asset(
                              Assets.imagesPhoto,
                              height: 16.52,
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
}

Widget profileImage(
  BuildContext context, {
  String? profileImage,
  double? size = 44.45,
}) {
  return Container(
    height: size,
    width: size,
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
        ),
      ),
    ),
  );
}
