// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:uuid/uuid.dart';
// import 'package:vip_picnic/model/chat_models/chat_room_model.dart';
// import 'package:vip_picnic/utils/instances.dart';
// import '../../controller/chat_controller/chat_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class ChatScreen extends StatefulWidget {
//   final docs;
//   bool videoCallPermission;
//   final bool isArchived;
//
//   // final bool isBlocked;
//   ChatScreen({this.videoCallPermission = false, this.docs, this.isArchived = false});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   Rx<TextEditingController> messageEditingController = TextEditingController().obs;
//   TextEditingController _tec = TextEditingController();
//   ScrollController scrollController = ScrollController();
//   GroupedItemScrollController groupedItemScrollController = GroupedItemScrollController();
//   ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
//
//   // RxBool isDeleting = false;
//   // String recordFilePath;
//   String chatRoomID = "";
//   String userID = "";
//   String userName = "";
//   String anotherUserID = "";
//   String anotherUserName = "";
//   String anotherUserImage = "";
//   bool attachFiles = false;
//   bool emojiShowing = false;
//   RxBool isRecording = false.obs;
//   RxBool isSending = false.obs;
//   RxInt lastIndex = 0.obs;
//   int i = 0;
//
//   Map<String, String> _paths = {};
//
//
//   String key = "";
//   String salt = "";
//   File? imageFile;
//   bool isWaiting = false;
//   bool isAssigned = false;
//   String imageUrl = '';
//   String imgPlaceholder =
//       'https://thumbs.dreamstime.com/z/placeholder-icon-vector-isolated-white-background-your-web-mobile-app-design-placeholder-logo-concept-placeholder-icon-134071364.jpg';
//   List<String> monthsList = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December'
//   ];
//
//   Stream? chatMessageStream;
//   RxInt lastMessageAt = 0.obs;
//   RxString lastMessage = "".obs;
//   RxInt time = 0.obs;
//   bool isOpenedUp = true;
//   final Rx<ChatRoomModel> crm = ChatRoomModel().obs;
//   final Rx<UserModel> anotherUserModel = UserModel().obs;
//   final RxBool isMatchedOrNot = false.obs;
//   final RxString privacySettings = "Everyone".obs;
//   final String deleteFor = "Everyone";
//   RxBool isArchivedRoom = false.obs;
//   RxBool isPrivacAllowed = true.obs;
//
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> otherUserListener;
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> chatRoomListener;
//
//   Future<bool> checkPermission() async {
//     if (!await Permission.microphone.isGranted) {
//       PermissionStatus status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   Future<String> getFilePath() async {
//     Directory storageDirectory = await getApplicationDocumentsDirectory();
//     String sdPath = storageDirectory.path + "/record";
//     var d = Directory(sdPath);
//     if (!d.existsSync()) {
//       d.createSync(recursive: true);
//     }
//     return sdPath + "/test_${i++}.mp3";
//   }
//
//   uploadAudio({String? minutes, String? seconds}) {
//     log("'audio-time in uploadAudio': '${minutes}:${seconds}'");
//     final firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('${chatRoomID}/audio${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
//
//     UploadTask task = firebaseStorageRef.putFile(File(chatController.recordFilePath ?? ""));
//     task.then((value) async {
//       print('##############done#########');
//       // task.snapshotEvents.listen((event) {
//       //   chatController.uploadProgress.value = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
//       //   log("progress iS: ${chatController.uploadProgress.value}");
//       // });
//       var audioURL = await value.ref.getDownloadURL();
//
//       // chatController.uploadProgress.value =(value.totalBytes / value.bytesTransferred) * 100;
//       // log("progress iS: ${chatController.uploadProgress.value}");
//       String strVal = audioURL.toString();
//       await sendAudioMsg(audioMsg: strVal, minutes: minutes, seconds: seconds);
//       chatController.isAudioBeingSent.value = false;
//     }).catchError((e) {
//       print(e);
//     });
//   }
//
//   sendAudioMsg({String audioMsg, String minutes, String seconds}) async {
//     log("'audio-time in sendAudioMsg': '${minutes}:${seconds}'");
//     if (audioMsg.isNotEmpty) {
//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         var time = DateTime.now().millisecondsSinceEpoch;
//
//         Map<String, dynamic> messageMap = {
//           "sendById": authController.userModel.value.id,
//           "sendByName": authController.userModel.value.name,
//           "receivedById": anotherUserID,
//           "receivedByName": anotherUserName,
//           "message": audioMsg,
//           'audio-time': '${minutes}:${seconds}',
//           "type": "audio",
//           'time': time,
//           'isDeletedFor': [],
//           "isRead": false,
//           "isReceived": false,
//         };
//         if (!crm.value.notDeletedFor.asMap().containsValue(anotherUserID)) {
//           ffstore.collection("ChatRoom").doc(chatRoomID).update({
//             "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
//           });
//         }
//         chatController.addConversationMessage(chatRoomID, time, "audio", messageMap, audioMsg);
//         messageEditingController.value.text = "";
//         chatController.messageControllerText.value = "";
//       }).then((value) {
//         isSending.value = false;
//       });
//     } else {
//       print("Hello");
//     }
//   }
//
//   //+load file moved to chatcontroller
//
//   void startRecord() async {
//     bool hasPermission = await checkPermission();
//     if (hasPermission) {
//       chatController.recordFilePath = await getFilePath();
//
//       RecordMp3.instance.start(chatController.recordFilePath, (type) {});
//     } else {
//       await checkPermission();
//       startRecord();
//     }
//   }
//
//   //+stopAudio moved to chatcontroller
//
//   void stopRecord({String minutes, String seconds}) async {
//     bool s = RecordMp3.instance.stop();
//     if (s) {
//       isSending.value = true;
//       log("'audio-time in stopRecord': '${minutes}:${seconds}'");
//       await uploadAudio(minutes: minutes, seconds: seconds);
//       // isPlayingMsg.value = false;
//     }
//   }
//
//   void stopRecordWithoutUpload() async {
//     bool s = RecordMp3.instance.stop();
//     // if (s) {
//     //   // isSending.value = true;
//     //   // await uploadAudio();
//     //   // isPlayingMsg.value = false;
//     // }
//   }
//
//   //+play method moved to chatController
//
//   /*_getFromGallery() async {
//     PickedFile pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery,
//       maxWidth: 1800,
//       maxHeight: 1800,
//     );
//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);
//     }
//   }*/
//
//   TextStyle simpleTextStyle() {
//     return TextStyle(fontSize: 16.0, color: Colors.green);
//   }
//
//   @override
//   void initState() {
//     // GET CHAT ROOM ID FOR CURRENT FROM CLOUD FIRESTORE
//     log("passwd doc is: ${widget.docs}");
//     isOpenedUp = true;
//     // getUserDataFromChatRoomDB();
//     getRoomId();
//     getChatRoomStream();
//     super.initState();
//
//     // KeyboardVisibilityController().onChange.listen((event) {
//     //   chatController.isKeyboardOpen.value = event;
//     // });
//     isArchivedRoom.value = widget.isArchived;
//
//     // widget.isArchived
//     //     ? chatController.getArchivedConversationMessage(chatRoomID).then((value) {
//     //   setState(() {
//     //     log("\n\n\n\n\n\ngetting conversation message without setState\n\n\n\n\n\n", time: DateTime.now());
//     //     chatMessageStream = value;
//     //   });
//     // })
//     //     :
//     chatController.getConversationMessage(chatRoomID).then((value) {
//       setState(() {
//         log("\n\n\n\n\n\ngetting conversation message without setState\n\n\n\n\n\n");
//         chatMessageStream = value;
//       });
//     });
//   }
//
//   getRoomId() async {
//     // SharedPreferences _prefs = await SharedPreferences.getInstance();
//     userID = authController.userModel.value.id;
//     if (authController.userModel.value.id != widget.docs['user2Model']['id']) {
//       anotherUserID = widget.docs['user2Model']['id'];
//       anotherUserName = widget.docs['user2Model']['name'];
//       anotherUserImage = widget.docs['user2Model']['primaryImageUrl'];
//     } else {
//       anotherUserID = widget.docs['user1Model']['id'];
//       anotherUserName = widget.docs['user1Model']['name'];
//       anotherUserImage = widget.docs['user1Model']['primaryImageUrl'];
//     }
//     /**/
//     // anotherUserID = authController.userModel.value.id != crm.value.user2Model.id
//     //     ? widget.docs['user2Model']['id']
//     //     : widget.docs['user1Model']['id'];
//     // anotherUserName = authController.userModel.value.id != crm.value.user2Model.id
//     //     ? widget.docs['user2Model']['name']
//     //     : widget.docs['user1Model']['name'];
//     // anotherUserImage = authController.userModel.value.id != crm.value.user2Model.id
//     //     ? widget.docs['user2Model']['primaryImageUrl']
//     //     : widget.docs['user1Model']['primaryImageUrl'];
//     /**/
//     // LOGIC TO SELECT DESIRED CHAT ROOM FROM CLOUD FIRESTORE
//     // if (userID.compareTo(anotherUserID) > 0) {
//     //   chatRoomID = '$userID - $anotherUserID';
//     // } else {
//     //   chatRoomID = '$anotherUserID - $userID';
//     // }
//     chatRoomID = chatController.getChatRoomId(userID, anotherUserID);
//     otherUserListener = await ffstore.collection("Users").doc(anotherUserID).snapshots().listen((event) {
//       anotherUserModel.value = UserModel.fromJson(event.data());
//       privacySettings.value = anotherUserModel.value.whoCanSendMeMessage;
//       if (privacySettings.value == "Everyone") {
//         isPrivacAllowed.value = true;
//       } else {
//         var LikesAndMatchesBox = Hive.box(likesAndMatchesBox);
//         if (LikesAndMatchesBox.containsKey(anotherUserID)) {
//           LikesAndMatchesBox.get(anotherUserID) == "IMatched"
//               ? isPrivacAllowed.value = true
//               : isPrivacAllowed.value = false;
//         } else {
//           isPrivacAllowed.value = false;
//         }
//       }
//     });
//   }
//
//   // bool getPrivacyStatus(){
//   //   var LikesAndMatchesBox = Hive.box("LikesAndMatches");
//   //   if(){}
//   //   return false;
//   // }
//   getUserDataFromChatRoomDB() async {
//     log("CHanging the crm values from getUserDataFromChatRoomDB");
//     await ffstore.collection("ChatRoom").doc(widget.docs["chatRoomId"]).get().then((value) {
//       crm.value = ChatRoomModel.fromDocumentSnapshot(value);
//       log("CHanging the crm values in get from getUserDataFromChatRoomDB");
//     });
//     await ffstore.collection("ChatRoom").doc(chatRoomID).snapshots().listen((event) {
//       log("CHanging the crm values in snapshot from getUserDataFromChatRoomDB");
//       crm.value = ChatRoomModel.fromDocumentSnapshot(event);
//     });
//   }
//
//   /*File? selectedImage;
//   XFile? image;
//
//   Future getImage(type) async {
//     if (type == "camera") {
//       image = await ImagePicker().pickImage(
//         source: ImageSource.camera,
//       );
//     } else {
//       image = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//       );
//     }
//     setState(() {
//       selectedImage = File(image.path);
//     });
//     Get.back();
//   }*/
//
//   String path;
//
//   Future getImageFromCamera() async {
//     ImagePicker _picker = ImagePicker();
//     await _picker.pickImage(source: ImageSource.camera).then((xFile) {
//       if (xFile != null) {
//         imageFile = File(xFile.path);
//         path = xFile.path;
//         // showLoading();
//         Get.to(
//               () => PreviewImageScreen(
//             imagePath: path,
//             anotherUserId: anotherUserID,
//             anotherUserName: anotherUserName,
//             chatRoomId: crm.value.chatRoomId,
//             userId: userID,
//           ),
//         );
//         // uploadImage();
//       }
//     });
//   }
//
//   Future getImageFromGallery() async {
//     ImagePicker _picker = ImagePicker();
//     await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
//       if (xFile != null) {
//         imageFile = File(xFile.path);
//         path = xFile.path;
//         // showLoading();
//         Get.to(
//               () => PreviewImageScreen(
//             imagePath: path,
//             anotherUserId: anotherUserID,
//             anotherUserName: anotherUserName,
//             chatRoomId: crm.value.chatRoomId,
//             userId: userID,
//           ),
//         );
//         // uploadImage();
//       }
//     });
//   }
//
//   Future uploadImage() async {
//     String fileName = Uuid().v1();
//     int status = 1;
//     // Get.to(() => PreviewImageScreen(imagePath: path, fileName: fileName));
//     dismissLoadingWidget();
//     Get.dialog(
//       Container(
//         color: kBlackColor,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //TODO: he will make it look better.
//           // alignment: Alignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 30,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       print('clicked the x close button.');
//                       Navigator.pop(context);
//                     },
//                     child: Icon(
//                       FontAwesomeIcons.times,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 child: Image.file(
//                   imageFile,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 30,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       showLoading();
//                       var ref = FirebaseStorage.instance.ref().child(chatRoomID).child("$fileName.jpg");
//                       var uploadTask = await ref.putFile(imageFile).catchError((error) async {
//                         print('in uploading error and eoor is: $error'); // await FirebaseFirestore.instance
//                         status = 0;
//                       });
//                       if (status == 1) {
//                         imageUrl = await uploadTask.ref.getDownloadURL();
//                         log('this is status 1');
//                         print(imageUrl);
//                         sendMessage(imageUrl);
//                         Get.back();
//                         dismissLoadingWidget();
//                         // sendMessage(imageUrl);
//                       }
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 50,
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50)),
//                       child: Icon(
//                         FontAwesomeIcons.solidPaperPlane,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       barrierDismissible: false,
//     );
//     /**/
//
//     // setState(() {
//     //   print('after popping the circular progress page.');
//     //   dismissLoadingWidget();
//     //   showDialog(
//     //     context: context,
//     //     barrierDismissible: false,
//     //     builder: (BuildContext context) {
//     //       print('after popping and inside the stack building.');
//     //       return Container(
//     //         color: kBlackColor,
//     //         child: Column(
//     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //           //TODO: he will make it look better.
//     //           // alignment: Alignment.center,
//     //           children: [
//     //             Padding(
//     //               padding: const EdgeInsets.symmetric(
//     //                 horizontal: 15,
//     //                 vertical: 30,
//     //               ),
//     //               child: Row(
//     //                 mainAxisAlignment: MainAxisAlignment.end,
//     //                 children: [
//     //                   GestureDetector(
//     //                     onTap: () {
//     //                       print('clicked the x close button.');
//     //                       Navigator.pop(context);
//     //                     },
//     //                     child: Icon(
//     //                       FontAwesomeIcons.times,
//     //                       color: Colors.red,
//     //                     ),
//     //                   ),
//     //                 ],
//     //               ),
//     //             ),
//     //             Expanded(
//     //               child: Container(
//     //                 child: Image.file(
//     //                   imageFile,
//     //                 ),
//     //               ),
//     //             ),
//     //             Padding(
//     //               padding: const EdgeInsets.symmetric(
//     //                 horizontal: 15,
//     //                 vertical: 30,
//     //               ),
//     //               child: Row(
//     //                 mainAxisAlignment: MainAxisAlignment.end,
//     //                 children: [
//     //                   GestureDetector(
//     //                     onTap: () async {
//     //                       showLoading();
//     //                       var ref = FirebaseStorage.instance.ref().child(chatRoomID).child("$fileName.jpg");
//     //                       var uploadTask = await ref.putFile(imageFile).catchError((error) async {
//     //                         print('in uploading error and eoor is: $error'); // await FirebaseFirestore.instance
//     //                         status = 0;
//     //                       });
//     //
//     //                       if (status == 1) {
//     //                         imageUrl = await uploadTask.ref.getDownloadURL();
//     //                         log('this is status 1');
//     //                         print(imageUrl);
//     //                         sendMessage(imageUrl);
//     //                         Navigator.pop(context);
//     //                         dismissLoadingWidget();
//     //                         // sendMessage(imageUrl);
//     //                       }
//     //                     },
//     //                     child: Container(
//     //                       height: 50,
//     //                       width: 50,
//     //                       padding: EdgeInsets.all(12),
//     //                       decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50)),
//     //                       child: Icon(
//     //                         FontAwesomeIcons.solidPaperPlane,
//     //                         color: Colors.white,
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ],
//     //               ),
//     //             )
//     //           ],
//     //         ),
//     //       );
//     //     },
//     //   );
//     // });
//   }
//
//   //+chatMessageList old method. Might need it later if sticky chat doesn't work.
//   /**/
//   // Widget chatMessageList() {
//   //   return
//   //       // isWaiting
//   //       //   ? Container(
//   //       // color: Colors.transparent,
//   //       //       child: Center(
//   //       //       child: CircularProgressIndicator(),
//   //       //     ))
//   //       //   :
//   //       StreamBuilder(
//   //     stream: chatMessageStream,
//   //     builder: (context, snapshot) {
//   //       if (snapshot.hasData) {
//   //         // scrollController.animateTo(
//   //         //   scrollController.position.maxScrollExtent,
//   //         //   curve: Curves.easeOut,
//   //         //   duration: const Duration(milliseconds: 500),
//   //         // );
//   //         // /*
//   //         WidgetsBinding.instance.addPostFrameCallback((_) {
//   //           if (scrollController.hasClients) {
//   //             scrollController.jumpTo(
//   //               scrollController.position.maxScrollExtent,
//   //               // curve: Curves.easeIn, duration: Duration(milliseconds: 1000)
//   //             );
//   //           }
//   //           // else {
//   //           //    // setState(() => null);
//   //           //  }
//   //         });
//   //         // * */
//   //         return ListView.builder(
//   //           padding: const EdgeInsets.symmetric(
//   //             vertical: 15,
//   //           ),
//   //           controller: scrollController,
//   //           // reverse: true,
//   //           // shrinkWrap: true,
//   //           itemCount: snapshot.data.docs.length,
//   //           itemBuilder: (context, index) {
//   //             // if (index == snapshot.data.docs.length) {
//   //             //   if (MediaQuery
//   //             //       .of(context)
//   //             //       .viewInsets
//   //             //       .bottom != 0) {
//   //             //     log("inside keyboard visible");
//   //             //     return Container(
//   //             //       height: 150,
//   //             //     );
//   //             //   }
//   //             //   return Container(
//   //             //     height: 60,
//   //             //   );
//   //             // }
//   //             // if (messageSnap.connectionState == ConnectionState.none && messageSnap.hasData == null) {
//   //             //   print("messageSnap.data is ${messageSnap.data}");
//   //             //   //print('project snapshot data is: ${messageSnap.data}');
//   //             //   return Container();
//   //             // }
//   //             // print("messageSnap.data is ${messageSnap.data}");
//   //             print("snapshot.data.docs[index].data()[type] is: ${snapshot.data.docs[index].data()["type"]}");
//   //             //TODO: Beware, here the widgets to show data start.
//   //             //TODO: Beware, here the widgets to show data start.
//   //             String type = snapshot.data.docs[index].data()["type"];
//   //             String message = snapshot.data.docs[index].data()["message"] != null
//   //                 ? snapshot.data.docs[index].data()["message"]
//   //                 : "what is this?";
//   //             bool sendByMe = authController.userModel.value.id == snapshot.data.docs[index].data()["sendById"];
//   //             String time = snapshot.data.docs[index].data()["time"].toString();
//   //
//   //             var day = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).day.toString();
//   //             var month = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).month.toString();
//   //             var year = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).year.toString().substring(2);
//   //             var date = day + '-' + month + '-' + year;
//   //             var hour = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).hour;
//   //             var min = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).minute;
//   //             var ampm;
//   //             if (hour > 12) {
//   //               hour = hour % 12;
//   //               ampm = 'pm';
//   //             } else if (hour == 12) {
//   //               ampm = 'pm';
//   //             } else if (hour == 0) {
//   //               hour = 12;
//   //               ampm = 'am';
//   //             } else {
//   //               ampm = 'am';
//   //             }
//   //             switch (type) {
//   //               case 'text':
//   //                 return sendByMe
//   //                     ? RightBubble(
//   //                         type: 'text',
//   //                         time: "${hour.toString()}:"
//   //                             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                             "${ampm}",
//   //                         msg: message,
//   //                       )
//   //                     : LeftBubble(
//   //                         personImage: anotherUserImage,
//   //                         type: 'text',
//   //                         time: "${hour.toString()}:"
//   //                             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                             "${ampm}",
//   //                         msg: message,
//   //                       );
//   //                 break;
//   //               case 'audio':
//   //                 return Container(
//   //                   width: MediaQuery.of(context).size.width * 0.5,
//   //                   margin: EdgeInsets.only(
//   //                     left: ((sendByMe) ? 64 : 10),
//   //                     right: ((sendByMe) ? 10 : 64),
//   //                     bottom: 15,
//   //                   ),
//   //                   padding: const EdgeInsets.symmetric(
//   //                     horizontal: 13,
//   //                     vertical: 10,
//   //                   ),
//   //                   decoration: BoxDecoration(
//   //                     boxShadow: [
//   //                       sendByMe
//   //                           ? BoxShadow()
//   //                           : BoxShadow(
//   //                               offset: const Offset(0, 0),
//   //                               blurRadius: 10,
//   //                               color: Color(0xff111111).withOpacity(0.06),
//   //                             ),
//   //                     ],
//   //                     color: sendByMe ? kSecondaryColor : kPrimaryColor,
//   //                     borderRadius: BorderRadius.only(
//   //                       // topLeft: Radius.circular(10),
//   //                       topRight: Radius.circular(10),
//   //                       topLeft: Radius.circular(10),
//   //                       bottomLeft: Radius.circular(sendByMe ? 10 : 0),
//   //                       bottomRight: Radius.circular(sendByMe ? 0 : 10),
//   //                     ),
//   //                   ),
//   //                   child: Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     crossAxisAlignment: CrossAxisAlignment.end,
//   //                     children: [
//   //                       // !sendByMe
//   //                       //     ? ClipRRect(
//   //                       //         borderRadius:
//   //                       //             BorderRadius.circular(100),
//   //                       //         child: CachedNetworkImage(
//   //                       //           width: 45,
//   //                       //           height: 45,
//   //                       //           fit: BoxFit.cover,
//   //                       //           imageUrl: (anotherUserImage !=
//   //                       //                       null ||
//   //                       //                   anotherUserImage != '')
//   //                       //               ? anotherUserImage
//   //                       //               : imgPlaceholder,
//   //                       //           progressIndicatorBuilder:
//   //                       //               (context, url,
//   //                       //                       downloadProgress) =>
//   //                       //                   Center(
//   //                       //             child:
//   //                       //                 CircularProgressIndicator(
//   //                       //               value:
//   //                       //                   downloadProgress.progress,
//   //                       //               color: kSecondaryColor,
//   //                       //             ),
//   //                       //           ),
//   //                       //           errorWidget:
//   //                       //               (context, url, error) =>
//   //                       //                   Icon(Icons.error),
//   //                       //         ),
//   //                       //         // Image.network(
//   //                       //         //   anotherUserImage,
//   //                       //         //   width: 45,
//   //                       //         //   height: 45,
//   //                       //         //   fit: BoxFit.cover,
//   //                       //         // ),
//   //                       //       )
//   //                       //     : Container(),
//   //                       Expanded(
//   //                         child: Row(
//   //                           children: [
//   //                             Obx(() {
//   //                               log("in onTap  before checking "
//   //                                   "chatController.isPlayingMsg.value: "
//   //                                   "${chatController.isPlayingMsg.value}");
//   //                               return GestureDetector(
//   //                                 onTap: !chatController.isPlayingMsg.value
//   //                                     ? () {
//   //                                         print('This is from Message ID $message');
//   //                                         log("onTap called");
//   //                                         log("in onTap  before checking "
//   //                                             "chatController.isPlayingMsg.value: "
//   //                                             "${chatController.isPlayingMsg.value}");
//   //                                         // if (!chatController.isPlayingMsg
//   //                                         //     .value) {
//   //                                         log("in onTap isPlaying being false "
//   //                                             "chatController.isPlayingMsg.value: "
//   //                                             "${chatController.isPlayingMsg.value}");
//   //                                         chatController.isPlayingMsg.value = true;
//   //                                         _loadFile(message);
//   //                                       }
//   //                                     : () async {
//   //                                         log("onSecondary called or in else");
//   //                                         // stopRecord();
//   //                                         await stopAudio();
//   //                                         log("in playing message being true before turning false "
//   //                                             "chatController.isPlayingMsg.value: "
//   //                                             "${chatController.isPlayingMsg.value}");
//   //                                         chatController.isPlayingMsg.value = false;
//   //                                         log("chatController.isPlayingMsg.value: "
//   //                                             "${chatController.isPlayingMsg.value}");
//   //                                         chatController.isPlayingMode("fhjdk");
//   //                                       },
//   //                                 child: Obx(() {
//   //                                   return Icon(
//   //                                     (chatController.selectedVoiceId == message &&
//   //                                                 chatController.selectedVoiceId != "fhjdk") ==
//   //                                             message
//   //                                         ? Icons.cancel
//   //                                         : Icons.play_arrow,
//   //                                     color: sendByMe ? kPrimaryColor : kBlackColor,
//   //                                   );
//   //                                 }),
//   //                               );
//   //                             }),
//   //                             const SizedBox(
//   //                               width: 10,
//   //                             ),
//   //                             // Column(
//   //                             //   children: [
//   //                             Text(
//   //                               'Audio ${time}',
//   //                               maxLines: 1,
//   //                               overflow: TextOverflow.ellipsis,
//   //                               style: TextStyle(
//   //                                 color: sendByMe ? kPrimaryColor : kBlackColor,
//   //                               ),
//   //                             ),
//   //                             //+ this can be added to show the audio time but not right now
//   //                             // Text(
//   //                             //   '${snapshot.data.docs[index].data()["audio-time"].toString()}',
//   //                             //   maxLines: 1,
//   //                             //   overflow: TextOverflow.ellipsis,
//   //                             //   style: TextStyle(
//   //                             //     color: sendByMe
//   //                             //         ? kPrimaryColor
//   //                             //         : kBlackColor,
//   //                             //   ),
//   //                             // ),
//   //                             // ],
//   //                             // ),
//   //                           ],
//   //                         ),
//   //                       ),
//   //                       MyText(
//   //                         text: "${hour.toString()}:"
//   //                             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                             "${ampm}",
//   //                         size: 12,
//   //                         fontFamily: 'Roboto',
//   //                         color: sendByMe ? kPrimaryColor.withOpacity(0.60) : kBlackColor.withOpacity(0.60),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 );
//   //                 break;
//   //               case 'image':
//   //                 return sendByMe
//   //                     ? RightBubble(
//   //                         type: 'image',
//   //                         msg: message,
//   //                         time: "${hour.toString()}:"
//   //                             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                             "${ampm}",
//   //                       )
//   //                     : LeftBubble(
//   //                         personImage: anotherUserImage,
//   //                         type: 'image',
//   //                         msg: message,
//   //                         time: "${hour.toString()}:"
//   //                             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                             "${ampm}",
//   //                       );
//   //                 //   Container(
//   //                 //   padding: EdgeInsets.only(
//   //                 //       top: 8,
//   //                 //       bottom: 8,
//   //                 //       left: sendByMe ? 0 : 24,
//   //                 //       right: sendByMe ? 24 : 0),
//   //                 //   alignment: sendByMe
//   //                 //       ? Alignment.centerRight
//   //                 //       : Alignment.centerLeft,
//   //                 //   child: Container(
//   //                 //       margin: sendByMe
//   //                 //           ? EdgeInsets.only(left: 30)
//   //                 //           : EdgeInsets.only(right: 30),
//   //                 //       padding: EdgeInsets.only(
//   //                 //           top: 5, bottom: 5, left: 5, right: 5),
//   //                 //       decoration: BoxDecoration(
//   //                 //           borderRadius: sendByMe
//   //                 //               ? BorderRadius.only(
//   //                 //                   //topLeft: Radius.circular(0),
//   //                 //                   topRight: Radius.circular(20),
//   //                 //                   bottomLeft: Radius.circular(20))
//   //                 //               : BorderRadius.only(
//   //                 //                   topLeft: Radius.circular(20),
//   //                 //                   //topRight: Radius.circular(20),
//   //                 //                   bottomRight: Radius.circular(20)),
//   //                 //           color: sendByMe
//   //                 //               ? Colors.green
//   //                 //               : Colors.grey[600]),
//   //                 //       child: GestureDetector(
//   //                 //         onTap: () {
//   //                 //           setState(() {
//   //                 //             // Navigator.pop(context);
//   //                 //             showDialog(
//   //                 //                 context: context,
//   //                 //                 barrierDismissible: false,
//   //                 //                 builder: (BuildContext context) {
//   //                 //                   return Stack(
//   //                 //                     children: [
//   //                 //                       // Positioned(
//   //                 //                       //   top: 0,
//   //                 //                       //   right: 0,
//   //                 //                       //   left: 0,
//   //                 //                       //   child: Expanded(
//   //                 //                       //       child: PhotoView(
//   //                 //                       //         imageProvider: NetworkImage(
//   //                 //                       //           widget.message == "what is this?"
//   //                 //                       //               ? imgPlaceholder
//   //                 //                       //               : widget.message,
//   //                 //                       //           // fit: BoxFit.fill,
//   //                 //                       //         ),
//   //                 //                       //       )),
//   //                 //                       // ),
//   //                 //                       Positioned(
//   //                 //                         top: 0,
//   //                 //                         right: 0,
//   //                 //                         child: Padding(
//   //                 //                           padding: const EdgeInsets
//   //                 //                               .fromLTRB(0, 8, 8, 0),
//   //                 //                           child: GestureDetector(
//   //                 //                             onTap: () {
//   //                 //                               Navigator.pop(context);
//   //                 //                             },
//   //                 //                             child: Icon(
//   //                 //                               FontAwesomeIcons.times,
//   //                 //                               color: Colors.red,
//   //                 //                             ),
//   //                 //                           ),
//   //                 //                         ),
//   //                 //                       ),
//   //                 //                     ],
//   //                 //                   );
//   //                 //                 });
//   //                 //             //   Navigator.push(
//   //                 //             //       context,
//   //                 //             //       MaterialPageRoute(
//   //                 //             //           builder: (context) => ImagePreview(image: imageUrl,)));
//   //                 //             //   isWaiting = false;
//   //                 //           });
//   //                 //         },
//   //                 //         child: Container(
//   //                 //           height: 170,
//   //                 //           width: 120,
//   //                 //           // width: MediaQuery.of(context).size.width - 25,
//   //                 //           decoration: BoxDecoration(
//   //                 //             border: Border.all(
//   //                 //               color: sendByMe
//   //                 //                   ? Colors.green
//   //                 //                   : Colors.grey[600],
//   //                 //               width: 2,
//   //                 //             ),
//   //                 //             borderRadius: BorderRadius.all(
//   //                 //               Radius.circular(20),
//   //                 //             ),
//   //                 //           ),
//   //                 //           child: ClipRRect(
//   //                 //             borderRadius: BorderRadius.circular(20.0),
//   //                 //             child: Image.network(
//   //                 //               message == "what is this?"
//   //                 //                   ? imgPlaceholder
//   //                 //                   : message,
//   //                 //               fit: BoxFit.fill,
//   //                 //               loadingBuilder: (BuildContext context,
//   //                 //                   Widget child,
//   //                 //                   ImageChunkEvent loadingProgress) {
//   //                 //                 if (loadingProgress == null)
//   //                 //                   return child;
//   //                 //                 return Center(
//   //                 //                   child: CircularProgressIndicator(
//   //                 //                     valueColor:
//   //                 //                         new AlwaysStoppedAnimation<
//   //                 //                             Color>(Colors.green),
//   //                 //                     value: loadingProgress
//   //                 //                                 .expectedTotalBytes !=
//   //                 //                             null
//   //                 //                         ? loadingProgress
//   //                 //                                 .cumulativeBytesLoaded /
//   //                 //                             loadingProgress
//   //                 //                                 .expectedTotalBytes
//   //                 //                         : null,
//   //                 //                   ),
//   //                 //                 );
//   //                 //               },
//   //                 //             ),
//   //                 //           ),
//   //                 //         ),
//   //                 //       )
//   //                 //       // Text(widget.message,
//   //                 //       //     textAlign: TextAlign.start, style: chatRoomTileStyle()),
//   //                 //       ),
//   //                 // );
//   //                 break;
//   //               default:
//   //                 return Container();
//   //             }
//   //             // return MessageTile(
//   //             //   type: snapshot.data.docs[index].data()["type"],
//   //             //   message: messageSnap.data != null
//   //             //       ? messageSnap.data
//   //             //       : "what is this?",
//   //             //   sendByMe: authController.userModel.value.id ==
//   //             //       snapshot.data.docs[index].data()["sendById"],
//   //             //   time: snapshot.data.docs[index].data()["time"].toString(),
//   //             // );
//   //           },
//   //         );
//   //       } else {
//   //         return Container(
//   //           child: Center(
//   //             child: Text("Loading...."),
//   //           ),
//   //         );
//   //       }
//   //     },
//   //   );
//   // }
//
//   getChatRoomStream() async {
//     // crm.value = ChatRoomModel.fromDocumentSnapshot(event);
//     chatRoomListener = await ffstore.collection("ChatRoom").doc(widget.docs['chatRoomId']).snapshots().listen((event) {
//       lastMessageAt.value = event['lastMessageAt'];
//       lastMessage.value = event['lastMessage'];
//       crm.value = ChatRoomModel.fromDocumentSnapshot(event);
//       isArchivedRoom.value = crm.value.inActiveFor.asMap().containsValue(authController.userModel.value.id);
//       log("\n\n\n getChatRoomStream called and lastMessageAt: $lastMessageAt"
//           " lastMessage: $lastMessage \n\n\n");
//     });
//   }
//
//   Widget nonStickyGroupedChatMessageList() {
//     return StreamBuilder(
//       stream: chatMessageStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (scrollController.hasClients) {
//               scrollController.jumpTo(
//                 scrollController.position.maxScrollExtent,
//                 // curve: Curves.easeIn, duration: Duration(milliseconds: 1000)
//               );
//             }
//           });
//           // WidgetsBinding.instance.addPostFrameCallback((_) {
//           //   if (isOpenedUp) {
//           //     log("calling addPostFrameCallback and "
//           //         "itemPositionsListener.itemPositions.value: ${itemPositionsListener.itemPositions.value}");
//           //     Future.delayed(
//           //         Duration(milliseconds: 100),
//           //         () => groupedItemScrollController.scrollTo(
//           //               // index: itemPositionsListener.itemPositions.value.last.index,
//           //               index: lastIndex.value,
//           //               duration: Duration(milliseconds: 500),
//           //               curve: Curves.easeIn,
//           //             ));
//           //     isOpenedUp = false;
//           //   } else {
//           //     log("calling addPostFrameCallback and "
//           //         "itemPositionsListener.itemPositions.value: ${itemPositionsListener.itemPositions.value}");
//           //     groupedItemScrollController.scrollTo(
//           //       index: itemPositionsListener.itemPositions.value.last.index,
//           //       // index: lastIndex.value,
//           //       duration: Duration(milliseconds: 100),
//           //       // curve: Curves.easeIn,
//           //     );
//           //   }
//           // });
//           // * */
//           return GroupedListView<dynamic, String>(
//             elements: snapshot.data.docs,
//             // itemScrollController: groupedItemScrollController,
//             controller: scrollController,
//             sort: false,
//             scrollDirection: Axis.vertical,
//             // itemPositionsListener: itemPositionsListener,
//             itemComparator: (element1, element2) => element1['time'].compareTo(element2['time']),
//             floatingHeader: false,
//             groupBy: (dynamic element) =>
//             "${monthsList[DateTime.fromMillisecondsSinceEpoch(element['time']).month - 1]} "
//                 "${DateTime.fromMillisecondsSinceEpoch(element['time']).day}, "
//                 "${DateTime.fromMillisecondsSinceEpoch(element['time']).year}",
//             groupComparator: (String value1, String value2) => value2.compareTo(value1),
//             groupSeparatorBuilder: (dynamic element) {
//               bool isToday =
//                   "${monthsList[DateTime.now().month - 1]} ${DateTime.now().day}, ${DateTime.now().year}" == element;
//               // log("element type: ${element.runtimeType}");
//               // log("element type: ${element}");
//               //
//               final yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
//               // log("element type: ${element}");
//               // log("element type: ${monthsList[DateTime.now().month-1]}");
//               // log("element type: ${DateTime.now().month}");
//               // log("element type: ${monthsList[yesterday.month-1]} ${yesterday.day +1}, ${yesterday.year}");
//               final yesterdayHere = "${monthsList[yesterday.month - 1]} ${yesterday.day}, ${yesterday.year}";
//               final checkDate = element;
//               // log("checkDate = element: ${yesterdayHere == element}");
//               // log("yesterdayHere: ${yesterdayHere} and element: $element");
//               // log("yesterdayHere: ${yesterdayHere} and element: $element");
//               return SizedBox(
//                 height: 35,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Container(
//                     height: 35,
//                     width: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(
//                         color: Colors.white,
//                       ),
//                       borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: MyText(
//                         text: !isToday
//                             ? checkDate == yesterdayHere
//                             ? "Yesterday"
//                             : element
//                             : "Today",
//                         align: TextAlign.center,
//                         size: 12,
//                         color: kSecondaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             itemBuilder: (context, dynamic element) {
//               //+maybe just use the normal list separator builder instead of this one.
//               //+maybe just use the normal list separator builder instead of this one.
//               //+TODO: maybe just use the normal list separator builder instead of this one.
//               //+TODO: maybe just use the normal list separator builder instead of this one.
//               lastIndex.value = snapshot.data.docs.indexWhere(
//                       (element) => (element["message"] == lastMessage.value && element["time"] == lastMessageAt.value));
//               // log("lastIndex.value: ${lastIndex.value}"
//               //     " \n element['message']: ${element["message"]}"
//               //     " \n lastMessage: ${lastMessage}"
//               //     " \n lastMessageAt: ${lastMessageAt}");
//               // log("  && element[time] == widget.docs['lastMessageAt']:  "
//               //     "${element["time"] == widget.docs['lastMessageAt']}");
//               // if (messageSnap.connectionState == ConnectionState.none && messageSnap.hasData == null) {
//               //   print("messageSnap.data is ${messageSnap.data}");
//               //   //print('project snapshot data is: ${messageSnap.data}');
//               //   return Container();
//               // }
//               // print("messageSnap.data is ${messageSnap.data}");
//               // print("snapshot.data.docs[index].data()[type] is: ${element.data()["type"]}");
//               //+TODO: Beware, here the widgets to show data start.
//               //+TODO: Beware, here the widgets to show data start.
//               String type = element.data()["type"];
//               String message = element.data()["message"] != null ? element.data()["message"] : "what is this?";
//               bool sendByMe = authController.userModel.value.id == element.data()["sendById"];
//
//               if (!sendByMe) {
//                 element.reference.update({'isRead': true});
//                 // log("updating the isRead of element: ${element.data()["message"]}");
//               }
//               bool isDeletedForMe = element.data()["isDeletedFor"].contains(authController.userModel.value.id);
//               String time = element.data()["time"].toString();
//
//               var day = DateTime.fromMillisecondsSinceEpoch(
//                 int.parse(time),
//               ).day.toString();
//               var month = DateTime.fromMillisecondsSinceEpoch(
//                 int.parse(time),
//               ).month.toString();
//               var year = DateTime.fromMillisecondsSinceEpoch(
//                 int.parse(time),
//               ).year.toString().substring(2);
//               var date = day + '-' + month + '-' + year;
//               var hour = DateTime.fromMillisecondsSinceEpoch(
//                 int.parse(time),
//               ).hour;
//               var min = DateTime.fromMillisecondsSinceEpoch(
//                 int.parse(time),
//               ).minute;
//               var ampm;
//               if (hour > 12) {
//                 hour = hour % 12;
//                 ampm = 'pm';
//               } else if (hour == 12) {
//                 ampm = 'pm';
//               } else if (hour == 0) {
//                 hour = 12;
//                 ampm = 'am';
//               } else {
//                 ampm = 'am';
//               }
//               switch (type) {
//                 case 'text':
//                   return (!isDeletedForMe)
//                       ? (sendByMe)
//                       ? RightBubble(
//                     type: 'text',
//                     time: "${hour.toString()}:"
//                         "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//                         "${ampm}",
//                     msg: message,
//                     id: element.id,
//                     sendByMe: sendByMe,
//                     isRead: element['isRead'],
//                     isReceived: element['isReceived'],
//                   )
//                       : LeftBubble(
//                     personImage: anotherUserImage,
//                     type: 'text',
//                     time: "${hour.toString()}:"
//                         "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//                         "${ampm}",
//                     msg: message,
//                     id: element.id,
//                     sendByMe: sendByMe,
//                     focusNode: focusNode,
//                     isRead: element['isRead'],
//                     isReceived: element['isReceived'],
//                   )
//                       : SizedBox();
//                   break;
//                 case 'audio':
//                   return (!isDeletedForMe)
//                       ? AudioWidget(
//                     id: element.id,
//                     message: message,
//                     sendByMe: sendByMe,
//                     time: "${hour.toString()}:"
//                         "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//                         "${ampm}",
//                     type: 'audio',
//                     audioTime: element['audio-time'],
//                     isRead: element['isRead'],
//                     isReceived: element['isReceived'],
//                   )
//                       : SizedBox();
//                   break;
//                 case 'image':
//                   return (!isDeletedForMe)
//                       ? sendByMe
//                       ? RightBubble(
//                     type: 'image',
//                     msg: message,
//                     time: "${hour.toString()}:"
//                         "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//                         "${ampm}",
//                     id: element.id,
//                     sendByMe: sendByMe,
//                     isRead: element['isRead'],
//                     isReceived: element['isReceived'],
//                   )
//                       : LeftBubble(
//                     personImage: anotherUserImage,
//                     type: 'image',
//                     msg: message,
//                     time: "${hour.toString()}:"
//                         "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//                         "${ampm}",
//                     id: element.id,
//                     sendByMe: sendByMe,
//                     focusNode: focusNode,
//                     isRead: element['isRead'],
//                     isReceived: element['isReceived'],
//                   )
//                       : SizedBox();
//                   break;
//                 default:
//                   return Container();
//               }
//             },
//             order: GroupedListOrder.ASC, // optional
//           );
//           /**/
//         } else {
//           return Container(
//             child: Center(
//               child: Text("Loading...."),
//             ),
//           );
//         }
//       },
//     );
//   }
//
//   // Widget stickyGroupedChatMessageList() {
//   //   return StreamBuilder(
//   //     stream: chatMessageStream,
//   //     builder: (context, snapshot) {
//   //       if (snapshot.hasData) {
//   //         WidgetsBinding.instance.addPostFrameCallback((_) {
//   //           if (isOpenedUp) {
//   //             log("calling addPostFrameCallback and "
//   //                 "itemPositionsListener.itemPositions.value: ${itemPositionsListener.itemPositions.value}");
//   //             Future.delayed(
//   //                 Duration(milliseconds: 100),
//   //                 () => groupedItemScrollController.scrollTo(
//   //                       // index: itemPositionsListener.itemPositions.value.last.index,
//   //                       index: lastIndex.value,
//   //                       duration: Duration(milliseconds: 500),
//   //                       curve: Curves.easeIn,
//   //                     ));
//   //             isOpenedUp = false;
//   //           } else {
//   //             log("calling addPostFrameCallback and "
//   //                 "itemPositionsListener.itemPositions.value: ${itemPositionsListener.itemPositions.value}");
//   //             groupedItemScrollController.scrollTo(
//   //               index: itemPositionsListener.itemPositions.value.last.index,
//   //               // index: lastIndex.value,
//   //               duration: Duration(milliseconds: 100),
//   //               // curve: Curves.easeIn,
//   //             );
//   //           }
//   //         });
//   //         // * */
//   //         return StickyGroupedListView<dynamic, String>(
//   //           elements: snapshot.data.docs,
//   //           itemScrollController: groupedItemScrollController,
//   //           scrollDirection: Axis.vertical,
//   //           itemPositionsListener: itemPositionsListener,
//   //           itemComparator: (element1, element2) => element1['time'].compareTo(element2['time']),
//   //           floatingHeader: true,
//   //           groupBy: (dynamic element) => "${monthsList[DateTime.fromMillisecondsSinceEpoch(element['time']).month]} "
//   //               "${DateTime.fromMillisecondsSinceEpoch(element['time']).day}, "
//   //               "${DateTime.fromMillisecondsSinceEpoch(element['time']).year}",
//   //           groupComparator: (String value1, String value2) => value1.compareTo(value2),
//   //           groupSeparatorBuilder: (dynamic element) {
//   //             bool isToday = "${monthsList[DateTime.now().month]} ${DateTime.now().day}, ${DateTime.now().year}" ==
//   //                 "${monthsList[DateTime.fromMillisecondsSinceEpoch(element['time']).month]} "
//   //                     "${DateTime.fromMillisecondsSinceEpoch(element['time']).day}, "
//   //                     "${DateTime.fromMillisecondsSinceEpoch(element['time']).year}";
//   //
//   //             final yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
//   //             final checkDate = DateTime(
//   //                 DateTime.fromMillisecondsSinceEpoch(element['time']).year,
//   //                 DateTime.fromMillisecondsSinceEpoch(element['time']).month,
//   //                 DateTime.fromMillisecondsSinceEpoch(element['time']).day);
//   //             return SizedBox(
//   //               height: 35,
//   //               child: Align(
//   //                 alignment: Alignment.center,
//   //                 child: Container(
//   //                   width: 120,
//   //                   decoration: BoxDecoration(
//   //                     color: Colors.white,
//   //                     border: Border.all(
//   //                       color: Colors.white,
//   //                     ),
//   //                     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//   //                   ),
//   //                   child: Padding(
//   //                     padding: const EdgeInsets.all(8.0),
//   //                     child: MyText(
//   //                       text: !isToday
//   //                           ? checkDate == yesterday
//   //                               ? "Yesterday"
//   //                               : "${monthsList[DateTime.fromMillisecondsSinceEpoch(element['time']).month]} "
//   //                                   "${DateTime.fromMillisecondsSinceEpoch(element['time']).day}, "
//   //                                   "${DateTime.fromMillisecondsSinceEpoch(element['time']).year}"
//   //                           : "Today",
//   //                       align: TextAlign.center,
//   //                       color: kSecondaryColor,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //             );
//   //           },
//   //           itemBuilder: (context, dynamic element) {
//   //             //+maybe just use the normal list separator builder instead of this one.
//   //             //+maybe just use the normal list separator builder instead of this one.
//   //             //+TODO: maybe just use the normal list separator builder instead of this one.
//   //             //+TODO: maybe just use the normal list separator builder instead of this one.
//   //             lastIndex.value = snapshot.data.docs.indexWhere(
//   //                 (element) => (element["message"] == lastMessage.value && element["time"] == lastMessageAt.value));
//   //             // log("lastIndex.value: ${lastIndex.value}"
//   //             //     " \n element['message']: ${element["message"]}"
//   //             //     " \n lastMessage: ${lastMessage}"
//   //             //     " \n lastMessageAt: ${lastMessageAt}");
//   //             // log("  && element[time] == widget.docs['lastMessageAt']:  "
//   //             //     "${element["time"] == widget.docs['lastMessageAt']}");
//   //             // if (messageSnap.connectionState == ConnectionState.none && messageSnap.hasData == null) {
//   //             //   print("messageSnap.data is ${messageSnap.data}");
//   //             //   //print('project snapshot data is: ${messageSnap.data}');
//   //             //   return Container();
//   //             // }
//   //             // print("messageSnap.data is ${messageSnap.data}");
//   //             // print("snapshot.data.docs[index].data()[type] is: ${element.data()["type"]}");
//   //             //+TODO: Beware, here the widgets to show data start.
//   //             //+TODO: Beware, here the widgets to show data start.
//   //             String type = element.data()["type"];
//   //             String message = element.data()["message"] != null ? element.data()["message"] : "what is this?";
//   //             bool sendByMe = authController.userModel.value.id == element.data()["sendById"];
//   //
//   //             bool isDeletedForMe = element.data()["isDeletedFor"].contains(authController.userModel.value.id);
//   //             String time = element.data()["time"].toString();
//   //
//   //             var day = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).day.toString();
//   //             var month = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).month.toString();
//   //             var year = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).year.toString().substring(2);
//   //             var date = day + '-' + month + '-' + year;
//   //             var hour = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).hour;
//   //             var min = DateTime.fromMillisecondsSinceEpoch(
//   //               int.parse(time),
//   //             ).minute;
//   //             var ampm;
//   //             if (hour > 12) {
//   //               hour = hour % 12;
//   //               ampm = 'pm';
//   //             } else if (hour == 12) {
//   //               ampm = 'pm';
//   //             } else if (hour == 0) {
//   //               hour = 12;
//   //               ampm = 'am';
//   //             } else {
//   //               ampm = 'am';
//   //             }
//   //             switch (type) {
//   //               case 'text':
//   //                 return (!isDeletedForMe)
//   //                     ? (sendByMe)
//   //                         ? RightBubble(
//   //                             type: 'text',
//   //                             time: "${hour.toString()}:"
//   //                                 "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                                 "${ampm}",
//   //                             msg: message,
//   //                             id: element.id,
//   //                             sendByMe: sendByMe,
//   //                             isRead: element['isRead'],
//   //                           )
//   //                         : LeftBubble(
//   //                             personImage: anotherUserImage,
//   //                             type: 'text',
//   //                             time: "${hour.toString()}:"
//   //                                 "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                                 "${ampm}",
//   //                             msg: message,
//   //                             id: element.id,
//   //                             sendByMe: sendByMe,
//   //                             focusNode: focusNode,
//   //                             isRead: element['isRead'],
//   //                           )
//   //                     : SizedBox();
//   //                 break;
//   //               case 'audio':
//   //                 return (!isDeletedForMe)
//   //                     ? AudioWidget(
//   //                         id: element.id,
//   //                         message: message,
//   //                         sendByMe: sendByMe,
//   //                         time: "${hour.toString()}:"
//   //                             "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                             "${ampm}",
//   //                         type: 'audio',
//   //                       )
//   //                     : SizedBox();
//   //                 break;
//   //               case 'image':
//   //                 return (!isDeletedForMe)
//   //                     ? sendByMe
//   //                         ? RightBubble(
//   //                             type: 'image',
//   //                             msg: message,
//   //                             time: "${hour.toString()}:"
//   //                                 "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                                 "${ampm}",
//   //                             id: element.id,
//   //                             sendByMe: sendByMe,
//   //                             isRead: element['isRead'],
//   //                           )
//   //                         : LeftBubble(
//   //                             personImage: anotherUserImage,
//   //                             type: 'image',
//   //                             msg: message,
//   //                             time: "${hour.toString()}:"
//   //                                 "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//   //                                 "${ampm}",
//   //                             id: element.id,
//   //                             sendByMe: sendByMe,
//   //                             focusNode: focusNode,
//   //                             isRead: element['isRead'],
//   //                           )
//   //                     : SizedBox();
//   //                 break;
//   //               default:
//   //                 return Container();
//   //             }
//   //           },
//   //           order: StickyGroupedListOrder.ASC, // optional
//   //         );
//   //         /**/
//   //       } else {
//   //         return Container(
//   //           child: Center(
//   //             child: Text("Loading...."),
//   //           ),
//   //         );
//   //       }
//   //     },
//   //   );
//   // }
//
//   sendMessage([String imageUrl]) async {
//     var messageText = messageEditingController.value.text;
//     if (messageEditingController.value.text.isNotEmpty) {
//       messageEditingController.value.text = "";
//       // var encryptedMessage =
//       print("inside the text part");
//       var time = DateTime.now().millisecondsSinceEpoch;
//       Map<String, dynamic> messageMap = {
//         "sendById": authController.userModel.value.id,
//         "sendByName": authController.userModel.value.name,
//         "receivedById": anotherUserID,
//         "receivedByName": anotherUserName,
//         "message": messageText,
//         "type": "text",
//         'time': time,
//         'isDeletedFor': [],
//         "isRead": false,
//         "isReceived": false,
//       };
//       if (!crm.value.notDeletedFor.asMap().containsValue(anotherUserID)) {
//         ffstore.collection("ChatRoom").doc(chatRoomID).update({
//           "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
//         });
//       }
//       chatController.addConversationMessage(chatRoomID, time, "text", messageMap, messageText);
//       log("index is: ${lastIndex.value}");
//     } else if (imageFile != null && (imageUrl != null || imageUrl != "")) {
//       var time = DateTime.now().millisecondsSinceEpoch;
//
//       Map<String, dynamic> messageMap = {
//         "sendById": authController.userModel.value.id,
//         "sendByName": authController.userModel.value.name,
//         "receivedById": anotherUserID,
//         "receivedByName": anotherUserName,
//         "message": imageUrl,
//         "type": "image",
//         'time': time,
//         'isDeletedFor': [],
//         "isRead": false,
//         "isReceived": false,
//       };
//       if (!crm.value.notDeletedFor.asMap().containsValue(anotherUserID)) {
//         ffstore.collection("ChatRoom").doc(chatRoomID).update({
//           "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
//         });
//       }
//       chatController.addConversationMessage(chatRoomID, time, "image", messageMap, imageUrl);
//       // groupedItemScrollController.scrollTo(
//       //   index: lastIndex.value,
//       //   duration: Duration(microseconds: 300),
//       //   curve: Curves.ease,
//       // );
//       // setState(() {});
//       // scrollController.animateTo(scrollController.position.maxScrollExtent,
//       //     duration: Duration(milliseconds: 100), curve: Curves.ease);
//       // setState(() {
//       messageEditingController.value.text = "";
//
//       imageUrl = "";
//     }
//     chatController.messageControllerText.value = "";
//   }
//
//   final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
//   final focusNode = FocusNode();
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     log("chat on dispose called.");
//     // otherUserListener.cancel();
//     // chatRoomListener.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (chatController.isDeleting.value) {
//           chatController.isDeleting.value = false;
//           chatController.deleteMsgIdList.clear();
//           chatController.deleteAudioIdList.clear();
//           chatController.deleteAudioLinksList.clear();
//           chatController.deleteImageIdsList.clear();
//           chatController.deleteImageLinksList.clear();
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: GetBuilder<ChatController>(
//           init: Get.put(ChatController()),
//           builder: (logic) {
//             return Scaffold(
//               resizeToAvoidBottomInset: true,
//               key: _key,
//               endDrawer: MyDrawer(),
//               appBar: AppBar(
//                 leadingWidth: 0.0,
//                 title: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   // crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Get.back(),
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 'assets/new_images/back_icon_new.png',
//                                 height: 16,
//                                 color: kBlackColor,
//                               ),
//                               const SizedBox(width: 15),
//                             ],
//                           ),
//                         ),
//
//                         GestureDetector(
//                           onTap: () async {
//                             UserModel umdl = await authController.getAUser(anotherUserID);
//                             Get.to(() => Home(showAbleUserData: umdl));
//                           },
//                           child: Row(
//                             children: [
//                               //+AppBar Image
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(100),
//                                 child: Obx(() {
//                                   return CachedNetworkImage(
//                                     width: 32,
//                                     height: 32,
//                                     fit: BoxFit.cover,
//                                     imageUrl: (anotherUserModel.value.primaryImageUrl != null &&
//                                         anotherUserModel.value.primaryImageUrl != '')
//                                         ? anotherUserModel.value.primaryImageUrl
//                                         : anotherUserImage,
//                                     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                       child: CircularProgressIndicator(
//                                         value: downloadProgress.progress,
//                                         color: kSecondaryColor,
//                                       ),
//                                     ),
//                                     errorWidget: (context, exception, stackTrace) {
//                                       return Image.asset(
//                                         "assets/new_images/warning_new.png",
//                                         height: 25,
//                                       );
//                                     },
//                                   );
//                                 }),
//                               ),
//                               SizedBox(
//                                 width: Get.width * 0.35,
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Obx(() {
//                                         return MyText(
//                                           paddingLeft: 10,
//                                           text: anotherUserModel.value.name != null
//                                               ? anotherUserModel.value.name
//                                               : anotherUserName,
//                                           maxlines: 1,
//                                           overFlow: TextOverflow.ellipsis,
//                                           size: 16,
//                                           weight: FontWeight.w600,
//                                           color: kBlackColor.withOpacity(0.60),
//                                         );
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   Obx(() {
//                     if (chatController.isDeleting.value) {
//                       return IconButton(
//                         onPressed: () async {
//                           Get.dialog(
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   margin: const EdgeInsets.symmetric(
//                                     horizontal: 15,
//                                   ),
//                                   child: Container(
//                                     height: 264,
//                                     padding: const EdgeInsets.all(20),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Image.asset(
//                                           'assets/new_images/warning_new.png',
//                                           height: 64,
//                                           fit: BoxFit.cover,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Expanded(
//                                               child: GradientButton(
//                                                 buttonText: 'Cancel',
//                                                 onTap: () {
//                                                   // Get.back();
//                                                   chatController.isDeleting.value = false;
//                                                   chatController.deleteMsgIdList.clear();
//                                                   chatController.deleteAudioIdList.clear();
//                                                   chatController.deleteAudioLinksList.clear();
//                                                   chatController.deleteImageIdsList.clear();
//                                                   chatController.deleteImageLinksList.clear();
//                                                   Get.back();
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Expanded(
//                                               child: GradientButton(
//                                                 buttonText: 'Delete for Me',
//                                                 onTap: () async {
//                                                   int deleteCount = 0;
//                                                   Get.back();
//                                                   showLoading();
//                                                   log("logging the list on delete button: ${chatController.deleteMsgIdList} ");
//                                                   // chatController.deleteMsgIdList.forEach((element) async {
//                                                   //   try {
//                                                   //     await ffstore
//                                                   //         .collection('ChatRoom')
//                                                   //         .doc(widget.docs['chatRoomId'])
//                                                   //         .collection('chats')
//                                                   //         .doc(element)
//                                                   //         .delete();
//                                                   //   } catch (e) {
//                                                   //     log("error is: $e");
//                                                   //     //+show an error widget/dialog/snackbar.
//                                                   //   }
//                                                   //   log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
//                                                   //   chatController.deleteMsgIdList.remove(element);
//                                                   //   log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
//                                                   // });
//                                                   log("initial deleteMsgIdList: ${chatController.deleteMsgIdList}");
//                                                   for (int i = 0; i < chatController.deleteAudioLinksList.length; i++) {
//                                                     deleteCount++;
//                                                     log("deleting through URL : ${chatController.deleteAudioLinksList[i]}");
//                                                     try {
//                                                       // await FirebaseStorage.instance
//                                                       //     .refFromURL(chatController.deleteAudioLinksList[i])
//                                                       //     .delete()
//                                                       //     .then((value) async {
//                                                       //   log("after deleting the audio from storage");
//                                                       await ffstore
//                                                           .collection('ChatRoom')
//                                                           .doc(widget.docs['chatRoomId'])
//                                                           .collection('chats')
//                                                           .doc(chatController.deleteAudioIdList[i])
//                                                           .update({
//                                                         "isDeletedFor": FieldValue.arrayUnion([auth.currentUser.uid])
//                                                       }).then((value) {
//                                                         log("after deleting the audio from storage");
//                                                         chatController.deleteMsgIdList
//                                                             .remove(chatController.deleteAudioIdList[i]);
//                                                         chatController.deleteAudioIdList.removeAt(i);
//                                                         chatController.deleteAudioLinksList.removeAt(i);
//                                                       });
//                                                       // });
//                                                     } catch (e) {
//                                                       log("error is: $e");
//                                                       //+show an error widget/dialog/snackbar.
//                                                     }
//                                                   }
//                                                   for (int j = 0; j < chatController.deleteImageLinksList.length; j++) {
//                                                     deleteCount++;
//                                                     try {
//                                                       // await FirebaseStorage.instance
//                                                       //     .refFromURL(chatController.deleteImageLinksList[i])
//                                                       //     .delete()
//                                                       //     .then((value) async {
//                                                       //   log("after deleting the audio from storage");
//                                                       await ffstore
//                                                           .collection('ChatRoom')
//                                                           .doc(widget.docs['chatRoomId'])
//                                                           .collection('chats')
//                                                           .doc(chatController.deleteImageIdsList[i])
//                                                           .update({
//                                                         "isDeletedFor": FieldValue.arrayUnion([auth.currentUser.uid])
//                                                       }).then((value) {
//                                                         log("after deleting the audio from storage");
//                                                         chatController.deleteMsgIdList
//                                                             .remove(chatController.deleteImageIdsList[i]);
//                                                         chatController.deleteImageIdsList.removeAt(i);
//                                                         chatController.deleteImageLinksList.removeAt(i);
//                                                       });
//                                                       // });
//                                                     } catch (e) {
//                                                       log("error is: $e");
//                                                       //+show an error widget/dialog/snackbar.
//                                                     }
//                                                   }
//                                                   log("remaining deleteMsgIdList: ${chatController.deleteMsgIdList}");
//                                                   chatController.deleteMsgIdList.forEach((element) async {
//                                                     deleteCount++;
//
//                                                     try {
//                                                       await ffstore
//                                                           .collection('ChatRoom')
//                                                           .doc(widget.docs['chatRoomId'])
//                                                           .collection('chats')
//                                                           .doc(element)
//                                                           .update({
//                                                         "isDeletedFor": FieldValue.arrayUnion([auth.currentUser.uid])
//                                                       });
//                                                     } catch (e) {
//                                                       log("error is: $e");
//                                                       //+show an error widget/dialog/snackbar.
//                                                     }
//                                                     log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
//                                                     chatController.deleteMsgIdList.remove(element);
//                                                     log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
//                                                   });
//                                                   // chatController.deleteAudioIdList.forEach((element) async {
//                                                   //   try {
//                                                   //     await ffstore
//                                                   //         .collection('ChatRoom')
//                                                   //         .doc(widget.docs['chatRoomId'])
//                                                   //         .collection('chats')
//                                                   //         .doc(element)
//                                                   //         .delete();
//                                                   //   } catch (e) {
//                                                   //     log("error is: $e");
//                                                   //     //+show an error widget/dialog/snackbar.
//                                                   //   }
//                                                   // });
//                                                   chatController.isDeleting.value = false;
//                                                   chatController.deleteMsgIdList.clear();
//                                                   chatController.deleteAudioIdList.clear();
//                                                   chatController.deleteAudioLinksList.clear();
//                                                   chatController.deleteImageIdsList.clear();
//                                                   chatController.deleteImageLinksList.clear();
//                                                   dismissLoadingWidget();
//                                                   //
//                                                   // List a = [];
//                                                   // a.c
//                                                   try {
//                                                     await ffstore
//                                                         .collection("ChatRoom")
//                                                         .doc(chatRoomID)
//                                                         .collection("chats")
//                                                     // .where("isDeletedFor", whereIn: [
//                                                     //   [authController.userModel.value.id],
//                                                     //   [authController.userModel.value.id, anotherUserID]
//                                                     // ])
//                                                         .orderBy("time", descending: true)
//                                                         .get()
//                                                         .then((value) {
//                                                       log("in then of  update last message query is: ${value.docs.length}");
//                                                       if (value.docs.length > 0) {
//                                                         log("why not inside");
//                                                         // var firstEndDoc = value.docs.firstWhere((element) => element['message'] == "yyyy");
//                                                         var firstEndDoc = value.docs.firstWhere(
//                                                                 (element) => !element['isDeletedFor']
//                                                                 .contains(authController.userModel.value.id),
//                                                             orElse: () => null);
//                                                         log("firstEndDoc: $firstEndDoc");
//                                                         if (firstEndDoc != null) {
//                                                           log("firstEndDoc is: ${firstEndDoc.data()}");
//                                                           // if(firstEndDoc['type'] == "text"){
//                                                           // }
//                                                           ffstore.collection("ChatRoom").doc(chatRoomID).update({
//                                                             "lastMessageAt": firstEndDoc['time'],
//                                                             "lastMessage": firstEndDoc['message'],
//                                                             "lastMessageType": firstEndDoc['type'],
//                                                           });
//                                                         } else {
//                                                           ffstore.collection("ChatRoom").doc(chatRoomID).update({
//                                                             "lastMessage": "",
//                                                             "lastMessageType": "text",
//                                                           });
//                                                         }
//                                                       } else {
//                                                         ffstore.collection("ChatRoom").doc(chatRoomID).update({
//                                                           "lastMessage": "",
//                                                           "lastMessageType": "text",
//                                                         });
//                                                       }
//                                                     });
//                                                   } catch (e) {
//                                                     log("error in updating last message is: $e");
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Expanded(
//                                               child: GradientButton(
//                                                 buttonText: 'Delete for everyone',
//                                                 onTap: () async {
//                                                   int deleteCount = 0;
//                                                   Get.back();
//                                                   showLoading();
//                                                   log("logging the list on delete button: ${chatController.deleteMsgIdList} ");
//                                                   // chatController.deleteMsgIdList.forEach((element) async {
//                                                   //   try {
//                                                   //     await ffstore
//                                                   //         .collection('ChatRoom')
//                                                   //         .doc(widget.docs['chatRoomId'])
//                                                   //         .collection('chats')
//                                                   //         .doc(element)
//                                                   //         .delete();
//                                                   //   } catch (e) {
//                                                   //     log("error is: $e");
//                                                   //     //+show an error widget/dialog/snackbar.
//                                                   //   }
//                                                   //   log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
//                                                   //   chatController.deleteMsgIdList.remove(element);
//                                                   //   log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
//                                                   // });
//                                                   log("initial deleteMsgIdList: ${chatController.deleteMsgIdList}");
//                                                   for (int i = 0; i < chatController.deleteAudioLinksList.length; i++) {
//                                                     deleteCount++;
//                                                     log("deleting through URL : ${chatController.deleteAudioLinksList[i]}");
//                                                     try {
//                                                       await FirebaseStorage.instance
//                                                           .refFromURL(chatController.deleteAudioLinksList[i])
//                                                           .delete()
//                                                           .then((value) async {
//                                                         log("after deleting the audio from storage");
//                                                         await ffstore
//                                                             .collection('ChatRoom')
//                                                             .doc(widget.docs['chatRoomId'])
//                                                             .collection('chats')
//                                                             .doc(chatController.deleteAudioIdList[i])
//                                                             .delete()
//                                                             .then((value) {
//                                                           log("after deleting the audio from storage");
//                                                           chatController.deleteMsgIdList
//                                                               .remove(chatController.deleteAudioIdList[i]);
//                                                           chatController.deleteAudioIdList.removeAt(i);
//                                                           chatController.deleteAudioLinksList.removeAt(i);
//                                                         });
//                                                       });
//                                                     } catch (e) {
//                                                       log("error is: $e");
//                                                       //+show an error widget/dialog/snackbar.
//                                                     }
//                                                   }
//                                                   for (int j = 0; j < chatController.deleteImageLinksList.length; j++) {
//                                                     deleteCount++;
//                                                     try {
//                                                       await FirebaseStorage.instance
//                                                           .refFromURL(chatController.deleteImageLinksList[i])
//                                                           .delete()
//                                                           .then((value) async {
//                                                         log("after deleting the audio from storage");
//                                                         await ffstore
//                                                             .collection('ChatRoom')
//                                                             .doc(widget.docs['chatRoomId'])
//                                                             .collection('chats')
//                                                             .doc(chatController.deleteImageIdsList[i])
//                                                             .delete()
//                                                             .then((value) {
//                                                           log("after deleting the audio from storage");
//                                                           chatController.deleteMsgIdList
//                                                               .remove(chatController.deleteImageIdsList[i]);
//                                                           chatController.deleteImageIdsList.removeAt(i);
//                                                           chatController.deleteImageLinksList.removeAt(i);
//                                                         });
//                                                       });
//                                                     } catch (e) {
//                                                       log("error is: $e");
//                                                       //+show an error widget/dialog/snackbar.
//                                                     }
//                                                   }
//                                                   log("remaining deleteMsgIdList: ${chatController.deleteMsgIdList}");
//                                                   chatController.deleteMsgIdList.forEach((element) async {
//                                                     deleteCount++;
//
//                                                     try {
//                                                       await ffstore
//                                                           .collection('ChatRoom')
//                                                           .doc(widget.docs['chatRoomId'])
//                                                           .collection('chats')
//                                                           .doc(element)
//                                                           .delete();
//                                                     } catch (e) {
//                                                       log("error is: $e");
//                                                       //+show an error widget/dialog/snackbar.
//                                                     }
//                                                     log("deleted: $element and list before deletion is: ${chatController.deleteMsgIdList}");
//                                                     chatController.deleteMsgIdList.remove(element);
//                                                     log("deleted: $element and list after deletion is: ${chatController.deleteMsgIdList}");
//                                                   });
//                                                   // chatController.deleteAudioIdList.forEach((element) async {
//                                                   //   try {
//                                                   //     await ffstore
//                                                   //         .collection('ChatRoom')
//                                                   //         .doc(widget.docs['chatRoomId'])
//                                                   //         .collection('chats')
//                                                   //         .doc(element)
//                                                   //         .delete();
//                                                   //   } catch (e) {
//                                                   //     log("error is: $e");
//                                                   //     //+show an error widget/dialog/snackbar.
//                                                   //   }
//                                                   // });
//                                                   chatController.isDeleting.value = false;
//                                                   chatController.deleteMsgIdList.clear();
//                                                   chatController.deleteAudioIdList.clear();
//                                                   chatController.deleteAudioLinksList.clear();
//                                                   chatController.deleteImageIdsList.clear();
//                                                   chatController.deleteImageLinksList.clear();
//                                                   dismissLoadingWidget();
//
//                                                   try {
//                                                     ffstore
//                                                         .collection("ChatRoom")
//                                                         .doc(chatRoomID)
//                                                         .collection("chats")
//                                                         .orderBy("time", descending: true)
//                                                         .get()
//                                                         .then((value) {
//                                                       if (value.docs.length > 0) {
//                                                         var firstEndDoc = value.docs.firstWhere(
//                                                                 (element) => !element['isDeletedFor']
//                                                                 .contains(authController.userModel.value.id),
//                                                             orElse: null);
//                                                         if (firstEndDoc != null) {
//                                                           log("firstEndDoc is: ${firstEndDoc.data()}");
//                                                           ffstore.collection("ChatRoom").doc(chatRoomID).update({
//                                                             "lastMessageAt": firstEndDoc['time'],
//                                                             "lastMessage": firstEndDoc['message'],
//                                                             "lastMessageType": firstEndDoc['type'],
//                                                           });
//                                                         } else {
//                                                           log("in else of docsnot being greater than zero in updating the lastMessage");
//                                                           ffstore.collection("ChatRoom").doc(chatRoomID).update({
//                                                             "lastMessage": "",
//                                                             "lastMessageType": "text",
//                                                           });
//                                                         }
//                                                       } else {
//                                                         log("in else of docsnot being greater than zero in updating the lastMessage");
//                                                         ffstore.collection("ChatRoom").doc(chatRoomID).update({
//                                                           "lastMessage": "",
//                                                           "lastMessageType": "text",
//                                                         });
//                                                       }
//                                                     });
//                                                   } catch (e) {
//                                                     log("error in updating last message is: $e");
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             barrierDismissible: false,
//                           );
//
//                           // if(deleteFor == "Everyone"){}else{}
//                         },
//                         icon: Image.asset(
//                           'assets/images/bx_bxs-trash.png',
//                           height: 25,
//                           color: kSecondaryColor,
//                         ),
//                       );
//                     } else {
//                       return Obx(() {
//                         return Row(
//                           children: [
//                             !isArchivedRoom.value && !authController.isChaperone
//                                 ? IconButton(
//                               onPressed: () async {
//                                 Map<String, dynamic> chaperoneMap;
//                                 // UserModel user = await authController.getAUser(anotherUserID);
//                                 //+also add code here for sending Chaperone request
//                                 if (!anotherUserModel.value.isOnCall) {
//                                   if (anotherUserModel.value.voiceCallAllowed) {
//                                     log("inside isvoice call aallowed");
//                                     /**/
//                                     //+starting the chaperone request code.
//                                     if (anotherUserModel.value.isChaperoneEnabled) {
//                                       // showLoading();
//                                       Get.dialog(
//                                         CallDialog(
//                                           imageRequesterUrl: anotherUserImage,
//                                           isBothImage: false,
//                                         ),
//                                       );
//                                       log("inside isChaperoneEnabled");
//                                       await ffstore
//                                           .collection("Chaperone")
//                                           .doc(anotherUserModel.value.chaperoneId)
//                                           .collection("Requests")
//                                           .doc(widget.docs["chatRoomId"])
//                                           .get()
//                                           .then((value) async {
//                                         Map<String, dynamic> chapRequestMap = value.data();
//                                         if (value.exists) {
//                                           switch (chapRequestMap["requestTimeStatus"]) {
//                                             case "acceptedForAlways":
//                                               if (chapRequestMap["requestType"] == "Voice Call Request") {
//                                                 var token = await GetToken().getTokenMethod(
//                                                     widget.docs["chatRoomId"], authController.userModel.value.id);
//                                                 log("token before if in chatScreen is: $token");
//                                                 if (token != null && token != "") {
//                                                   Map<String, dynamic> voiceCallMap = {
//                                                     "sendById": authController.userModel.value.id,
//                                                     "sendByName": authController.userModel.value.name,
//                                                     "sendByImage": authController.userModel.value.primaryImageUrl,
//                                                     "receivedByImage": anotherUserImage,
//                                                     "receivedById": anotherUserID,
//                                                     "receivedByName": anotherUserName,
//                                                     "type": "voiceCall",
//                                                     'time': DateTime.now().millisecondsSinceEpoch,
//                                                     "isRead": false,
//                                                     'senderCallResponse': "Initiated",
//                                                     'receiverCallResponse': "Incoming",
//                                                     'callInitiationDateTime':
//                                                     DateTime.now().millisecondsSinceEpoch.toString(),
//                                                     'callResponseDateTime':
//                                                     DateTime.now().millisecondsSinceEpoch.toString(),
//                                                   };
//                                                   try {
//                                                     await ffstore
//                                                         .collection("ChatRoom")
//                                                         .doc(widget.docs['chatRoomId'])
//                                                         .collection("calls")
//                                                         .add(voiceCallMap)
//                                                         .then((value) async {
//                                                       // dismissLoadingWidget();
//                                                       CallDocModel passableAbleCdm =
//                                                       CallDocModel.fromJson(voiceCallMap);
//                                                       currentChannel = widget.docs["chatRoomId"];
//                                                       Get.back();
//                                                       Get.to(
//                                                             () => VoiceCall(
//                                                           toCallName: anotherUserModel.value.name,
//                                                           toCallImageUrl: anotherUserModel.value.primaryImageUrl,
//                                                           token: token,
//                                                           channelName: widget.docs["chatRoomId"],
//                                                           docId: value.id,
//                                                           callDoc: passableAbleCdm,
//                                                         ),
//                                                       );
//                                                     });
//                                                   } on FirebaseException catch (e) {
//                                                     dismissLoadingWidget();
//                                                     showErrorDialog(
//                                                       title: "Error in Video Call",
//                                                       description: "$e",
//                                                     );
//                                                   }
//                                                 } else {
//                                                   dismissLoadingWidget();
//                                                   showErrorDialog(
//                                                       title: "Token Error!",
//                                                       description: "Couldn't get a token from the server.");
//                                                   log("token is null: $token");
//                                                 }
//                                               } else {
//                                                 Get.back();
//                                                 showErrorDialog(
//                                                     title: "Video Call Request Accepted!",
//                                                     description: "Your video call request is already accepted. "
//                                                         "And you can only contact via that.");
//                                                 log("Video Call Request Accepted! and not Voice call");
//                                               }
//                                               break;
//                                             case "acceptedForOnce":
//                                               if (chapRequestMap["requestType"] == "Voice Call Request") {
//                                                 var token = await GetToken().getTokenMethod(
//                                                     widget.docs["chatRoomId"], authController.userModel.value.id);
//                                                 log("token before if in chatScreen is: $token");
//                                                 if (token != null && token != "") {
//                                                   Map<String, dynamic> voiceCallMap = {
//                                                     "sendById": authController.userModel.value.id,
//                                                     "sendByName": authController.userModel.value.name,
//                                                     "sendByImage": authController.userModel.value.primaryImageUrl,
//                                                     "receivedByImage": anotherUserImage,
//                                                     "receivedById": anotherUserID,
//                                                     "receivedByName": anotherUserName,
//                                                     "type": "voiceCall",
//                                                     'time': DateTime.now().millisecondsSinceEpoch,
//                                                     "isRead": false,
//                                                     'senderCallResponse': "Initiated",
//                                                     'receiverCallResponse': "Incoming",
//                                                     'callInitiationDateTime':
//                                                     DateTime.now().millisecondsSinceEpoch.toString(),
//                                                     'callResponseDateTime':
//                                                     DateTime.now().millisecondsSinceEpoch.toString(),
//                                                   };
//                                                   try {
//                                                     await ffstore
//                                                         .collection("ChatRoom")
//                                                         .doc(widget.docs['chatRoomId'])
//                                                         .collection("calls")
//                                                         .add(voiceCallMap)
//                                                         .then((value) async {
//                                                       CallDocModel passableAbleCdm =
//                                                       CallDocModel.fromJson(voiceCallMap);
//                                                       currentChannel = widget.docs["chatRoomId"];
//                                                       Get.back();
//                                                       Get.to(
//                                                             () => VoiceCall(
//                                                           toCallName: anotherUserModel.value.name,
//                                                           toCallImageUrl: anotherUserModel.value.primaryImageUrl,
//                                                           token: token,
//                                                           channelName: widget.docs["chatRoomId"],
//                                                           docId: value.id,
//                                                           callDoc: passableAbleCdm,
//                                                         ),
//                                                       );
//                                                     });
//                                                   } on FirebaseException catch (e) {
//                                                     Get.back();
//                                                     showErrorDialog(
//                                                       title: "Error in Video Call",
//                                                       description: "$e",
//                                                     );
//                                                   }
//                                                 } else {
//                                                   dismissLoadingWidget();
//                                                   showErrorDialog(
//                                                       title: "Token Error!",
//                                                       description: "Couldn't get a token from the server.");
//                                                   log("token is null: $token");
//                                                 }
//                                               } else {
//                                                 Get.back();
//                                                 showErrorDialog(
//                                                     title: "Video Call Request Accepted!",
//                                                     description: "Your video call request is already accepted. "
//                                                         "And you can only contact via that.");
//                                                 log("Video Call Request Accepted! and not Voice call");
//                                               }
//                                               break;
//                                             case "declined":
//                                               dismissLoadingWidget();
//                                               //+ show the Default dialog saying your request is declined
//                                               //+= also think about removing the match from the list as
//                                               //+ soon as this dialog is shown or by user input.
//                                               showErrorDialog(
//                                                   title: "Request Declined",
//                                                   description:
//                                                   "Sorry, Your request has been declined by the chaperone. ");
//                                               break;
//                                             case "waiting":
//                                               dismissLoadingWidget();
//                                               //+ show the Default dialog saying wait for approval
//                                               showErrorDialog(
//                                                 title: "Awaiting Approval",
//                                                 description:
//                                                 "Sorry, Your request is not approved yet by the chaperone. "
//                                                     "Please wait for approval. As soon as your request is approved, "
//                                                     "you will be notified.",
//                                                 height: 300,
//                                               );
//                                               break;
//                                             default:
//                                               dismissLoadingWidget();
//                                               showErrorDialog(
//                                                   title: "Error!",
//                                                   description:
//                                                   "Some unexpected event occurred. Please try again.");
//                                           // lo()
//                                           }
//                                         } else {
//                                           await ffstore
//                                               .collection("Chaperone")
//                                               .doc(anotherUserModel.value.chaperoneId)
//                                               .get()
//                                               .then((value) {
//                                             chaperoneMap = value.data();
//                                           });
//                                           await ffstore
//                                               .collection("Chaperone")
//                                               .doc(anotherUserModel.value.chaperoneId)
//                                               .collection("Requests")
//                                               .doc(widget.docs["chatRoomId"])
//                                               .set({
//                                             "requesterId": authController.userModel.value.id,
//                                             "requesterToId": anotherUserModel.value.id,
//                                             "requesterName": authController.userModel.value.name,
//                                             "requesterImage": authController.userModel.value.primaryImageUrl,
//                                             "requesterPhone": authController.userModel.value.phoneNumber,
//                                             "requesterToPhone": anotherUserModel.value.phoneNumber,
//                                             "requesterToName": anotherUserModel.value.name,
//                                             "requesterToImageUrl": anotherUserModel.value.primaryImageUrl,
//                                             "requestTimeStatus": "waiting",
//                                             "requestType": "Voice Call Request",
//                                             "chatRoomId": widget.docs["chatRoomId"],
//                                             //+other options are "Voice Call Request" &"Video Call Request"
//                                             "status": "waiting",
//                                           }).then((value) async {
//                                             dismissLoadingWidget();
//                                             Get.dialog(ChaperoneRequestSend());
//                                             log("chapMap is: ${chaperoneMap["contact"]}");
//                                             //+after this send a message to chaperone.
//                                             //+though main question is should this be loading or not.
//                                             //+i think this should show a loading indicator.
//                                             int output = await twilioSendMessage.sendSMS(
//                                                 toNumber: chaperoneMap["contact"],
//                                                 messageBody:
//                                                 '${authController.userModel.value.name} have sent a Voice Call Request to '
//                                                     '${anotherUserModel.value.name}. '
//                                                     'Please go onto the requests page to approve or disapprove the request. '
//                                                     'You may also join the Call.'
//                                               //+ we can implement dynamic link here to send the chap to a specific page.
//                                               //+ but that's a lot of hassle. just ignore that.
//                                               // 'Please click the link below to go onto the requests page to approve or disapprove the request'
//                                               // '${_link}'
//                                             );
//                                             log("\n\n output is $output");
//                                           });
//                                         }
//                                       });
//                                     } else {
//                                       // showLoading();
//                                       Get.dialog(
//                                         CallDialog(
//                                           imageRequesterUrl: anotherUserImage,
//                                           isBothImage: false,
//                                         ),
//                                       );
//                                       var token = await GetToken().getTokenMethod(
//                                           widget.docs["chatRoomId"], authController.userModel.value.id);
//                                       log("token before if in chatScreen is: $token");
//                                       if (token != null && token != "") {
//                                         Map<String, dynamic> voiceCallMap = {
//                                           "sendById": authController.userModel.value.id,
//                                           "sendByName": authController.userModel.value.name,
//                                           "sendByImage": authController.userModel.value.primaryImageUrl,
//                                           "receivedByImage": anotherUserImage,
//                                           "receivedById": anotherUserID,
//                                           "receivedByName": anotherUserName,
//                                           "type": "voiceCall",
//                                           'time': DateTime.now().millisecondsSinceEpoch,
//                                           "isRead": false,
//                                           'senderCallResponse': "Initiated",
//                                           'receiverCallResponse': "Incoming",
//                                           'callInitiationDateTime':
//                                           DateTime.now().millisecondsSinceEpoch.toString(),
//                                           'callResponseDateTime':
//                                           DateTime.now().millisecondsSinceEpoch.toString(),
//                                         };
//                                         try {
//                                           await ffstore
//                                               .collection("ChatRoom")
//                                               .doc(widget.docs['chatRoomId'])
//                                               .collection("calls")
//                                               .add(voiceCallMap)
//                                               .then((value) async {
//                                             // dismissLoadingWidget();
//                                             CallDocModel passableAbleCdm = CallDocModel.fromJson(voiceCallMap);
//                                             currentChannel = widget.docs["chatRoomId"];
//                                             Get.back();
//                                             Get.to(
//                                                   () => VoiceCall(
//                                                 toCallName: anotherUserModel.value.name,
//                                                 toCallImageUrl: anotherUserModel.value.primaryImageUrl,
//                                                 token: token,
//                                                 channelName: widget.docs["chatRoomId"],
//                                                 docId: value.id,
//                                                 callDoc: passableAbleCdm,
//                                               ),
//                                             );
//                                           });
//                                         } on FirebaseException catch (e) {
//                                           dismissLoadingWidget();
//                                           showErrorDialog(
//                                             title: "Error in Video Call",
//                                             description: "$e",
//                                           );
//                                         }
//                                       } else {
//                                         dismissLoadingWidget();
//                                         showErrorDialog(
//                                             title: "Token Error!",
//                                             description: "Couldn't get a token from the server.");
//                                         log("token is null: $token");
//                                       }
//                                     }
//                                     /**/
//                                   } else {
//                                     showErrorDialog(
//                                         title: "Not Allowed!",
//                                         description:
//                                         "$anotherUserName does not want to take any calls right now");
//                                     log("Voice call is not allowed by other user");
//                                   }
//                                 } else {
//                                   showErrorDialog(
//                                       title: "User is already on another Call",
//                                       description: "Please try again later");
//                                 }
//                               },
//                               icon: Image.asset(
//                                 'assets/new_images/audio_call_cion.png',
//                                 height: 15,
//                               ),
//                             )
//                                 : Container(),
//                             !isArchivedRoom.value && !authController.isChaperone
//                                 ? IconButton(
//                               onPressed: () async {
//                                 // showLoading();
//                                 Get.dialog(
//                                   CallDialog(
//                                     imageRequesterUrl: anotherUserImage,
//                                     isBothImage: false,
//                                   ),
//                                 );
//                                 // UserModel user = await authController.getAUser(anotherUserID);
//                                 if (anotherUserModel.value.isOnCall) {
//                                   showErrorDialog(
//                                       title: "User is already on another Call",
//                                       description: "Please try again later");
//                                 } else {
//                                   if (anotherUserModel.value.videoCallAllowed) {
//                                     if (anotherUserModel.value.isChaperoneEnabled) {
//                                       await ffstore
//                                           .collection("Chaperone")
//                                           .doc(anotherUserModel.value.chaperoneId)
//                                           .collection("Requests")
//                                           .doc(widget.docs["chatRoomId"])
//                                           .get()
//                                           .then((value) async {
//                                         Map<String, dynamic> chapMap = value.data();
//                                         if (value.exists) {
//                                           switch (chapMap["requestTimeStatus"]) {
//                                             case "acceptedForAlways":
//                                               if (chapMap["requestType"] == "Video Call Request") {
//                                                 currentChannel = widget.docs["chatRoomId"];
//                                                 var time = DateTime.now().millisecondsSinceEpoch;
//                                                 Map<String, dynamic> videoCallMap = {
//                                                   "sendById": authController.userModel.value.id,
//                                                   "sendByName": authController.userModel.value.name,
//                                                   "sendByImage": authController.userModel.value.primaryImageUrl,
//                                                   "receivedByImage": anotherUserImage,
//                                                   "receivedById": anotherUserID,
//                                                   "receivedByName": anotherUserName,
//                                                   "type": "videoCall",
//                                                   'time': time,
//                                                   "isRead": false,
//                                                   'senderCallResponse': "Initiated",
//                                                   'receiverCallResponse': "Incoming",
//                                                   'callInitiationDateTime':
//                                                   DateTime.now().millisecondsSinceEpoch.toString(),
//                                                   'callResponseDateTime':
//                                                   DateTime.now().millisecondsSinceEpoch.toString(),
//                                                 };
//                                                 try {
//                                                   await ffstore
//                                                       .collection("ChatRoom")
//                                                       .doc(widget.docs['chatRoomId'])
//                                                       .collection("calls")
//                                                       .add(videoCallMap)
//                                                       .then((value) async {
//                                                     CallDocModel passableAbleCdm =
//                                                     CallDocModel.fromJson(videoCallMap);
//                                                     currentChannel = widget.docs["chatRoomId"];
//                                                     Get.back();
//                                                     Get.to(
//                                                           () => VideoCallAgoraUIKit(
//                                                         anotherUserName: anotherUserName,
//                                                         anotherUserId: anotherUserID,
//                                                         anotherUserImage: anotherUserImage,
//                                                         token: "",
//                                                         channelName: widget.docs["chatRoomId"],
//                                                         docId: value.id,
//                                                         callDoc: passableAbleCdm,
//                                                       ),
//                                                     );
//                                                   });
//                                                 } on FirebaseException catch (e) {
//                                                   Get.back();
//                                                   showErrorDialog(
//                                                     title: "Error in Video Call",
//                                                     description: "$e",
//                                                   );
//                                                 }
//                                               } else {
//                                                 Get.back();
//                                                 showErrorDialog(
//                                                     title: "Voice Call Request Accepted!",
//                                                     description: "Your voice call request is already accepted. "
//                                                         "And you can only contact via that.");
//                                                 log("Voice Call Request Accepted! and not Voice call");
//                                               }
//                                               break;
//                                             case "acceptedForOnce":
//                                             // dismissLoadingWidget();
//                                             //+ just get the token means call the getToken method
//                                             //+ and then navigate to Videocall page with token
//                                               if (chapMap["requestType"] == "Video Call Request") {
//                                                 currentChannel = widget.docs["chatRoomId"];
//                                                 var time = DateTime.now().millisecondsSinceEpoch;
//                                                 Map<String, dynamic> videoCallMap = {
//                                                   "sendById": authController.userModel.value.id,
//                                                   "sendByName": authController.userModel.value.name,
//                                                   "sendByImage": authController.userModel.value.primaryImageUrl,
//                                                   "receivedByImage": anotherUserImage,
//                                                   "receivedById": anotherUserID,
//                                                   "receivedByName": anotherUserName,
//                                                   "type": "videoCall",
//                                                   'time': time,
//                                                   "isRead": false,
//                                                   'senderCallResponse': "Initiated",
//                                                   'receiverCallResponse': "Incoming",
//                                                   'callInitiationDateTime':
//                                                   DateTime.now().millisecondsSinceEpoch.toString(),
//                                                   'callResponseDateTime':
//                                                   DateTime.now().millisecondsSinceEpoch.toString(),
//                                                 };
//                                                 try {
//                                                   await ffstore
//                                                       .collection("ChatRoom")
//                                                       .doc(widget.docs['chatRoomId'])
//                                                       .collection("calls")
//                                                       .add(videoCallMap)
//                                                       .then((value) async {
//                                                     CallDocModel passableAbleCdm =
//                                                     CallDocModel.fromJson(videoCallMap);
//                                                     currentChannel = widget.docs["chatRoomId"];
//                                                     Get.back();
//                                                     Get.to(
//                                                           () => VideoCallAgoraUIKit(
//                                                         anotherUserName: anotherUserName,
//                                                         anotherUserId: anotherUserID,
//                                                         anotherUserImage: anotherUserImage,
//                                                         token: "",
//                                                         channelName: widget.docs["chatRoomId"],
//                                                         docId: value.id,
//                                                         callDoc: passableAbleCdm,
//                                                       ),
//                                                     );
//                                                   });
//                                                 } on FirebaseException catch (e) {
//                                                   Get.back();
//                                                   showErrorDialog(
//                                                     title: "Error in Video Call",
//                                                     description: "$e",
//                                                   );
//                                                 }
//                                               } else {
//                                                 Get.back();
//                                                 showErrorDialog(
//                                                     title: "Voice Call Request Accepted!",
//                                                     description: "Your voice call request is already accepted. "
//                                                         "And you can only contact via that.");
//                                                 log("Voice Call Request Accepted! and not Voice call");
//                                               }
//                                               break;
//                                             case "declined":
//                                               dismissLoadingWidget();
//                                               //+ show the Default dialog saying your request is declined
//                                               //+= also think about removing the match from the list as
//                                               //+ soon as this dialog is shown or by user input.
//                                               showErrorDialog(
//                                                   title: "Request Declined",
//                                                   description:
//                                                   "Sorry, Your request has been declined by the chaperone. ");
//                                               break;
//                                             case "waiting":
//                                               dismissLoadingWidget();
//                                               //+ show the Default dialog saying wait for approval
//                                               showErrorDialog(
//                                                 title: "Awaiting Approval",
//                                                 description:
//                                                 "Sorry, Your request is not approved yet by the chaperone. "
//                                                     "Please wait for approval. As soon as your request is approved, "
//                                                     "you will be notified.",
//                                                 height: 300,
//                                               );
//                                               break;
//                                             default:
//                                               dismissLoadingWidget();
//                                               showErrorDialog(
//                                                   title: "Error!",
//                                                   description:
//                                                   "Some unexpected event occurred. Please try again.");
//                                               print("The error on Call is:");
//                                           }
//                                         } else {
//                                           await ffstore
//                                               .collection("Chaperone")
//                                               .doc(anotherUserModel.value.chaperoneId)
//                                               .collection("Requests")
//                                               .doc(widget.docs["chatRoomId"])
//                                               .set({
//                                             "requesterId": authController.userModel.value.id,
//                                             "requesterName": authController.userModel.value.name,
//                                             "requesterImage": authController.userModel.value.primaryImageUrl,
//                                             "requesterToId": anotherUserModel.value.id,
//                                             "requesterPhone": authController.userModel.value.phoneNumber,
//                                             "requesterToPhone": anotherUserModel.value.phoneNumber,
//                                             "requesterToName": anotherUserModel.value.name,
//                                             "requesterToImageUrl": anotherUserModel.value.primaryImageUrl,
//                                             "requestTimeStatus": "waiting",
//                                             "chatRoomId": widget.docs["chatRoomId"],
//                                             "requestType": "Video Call Request",
//                                             //+other options are "Voice Call Request" &"Video Call Request"
//                                             "status": "waiting",
//                                           });
//                                           dismissLoadingWidget();
//                                           Get.dialog(ChaperoneRequestSend());
//                                           DocumentSnapshot chapDoc = await ffstore
//                                               .collection("Chaperone")
//                                               .doc(anotherUserModel.value.chaperoneId)
//                                               .get();
//                                           ChaperoneModel chapMap = ChaperoneModel.fromJson(chapDoc.data());
//                                           log("chapMap is: ${chapMap.contact}");
//                                           //+after this send a message to chaperone.
//                                           //+though main question is should this be loading or not.
//                                           //+i think this should show a loading indicator.
//                                           int output = await twilioSendMessage.sendSMS(
//                                               toNumber: chapMap.contact,
//                                               messageBody:
//                                               '${authController.userModel.value.name} have sent a Video Call Request to '
//                                                   '${anotherUserModel.value.name}. '
//                                                   'Please go onto the requests page to approve or disapprove the request. '
//                                                   'You may also join the Call.'
//                                             //+ we can implement dynamic link here to send the chap to a specific page.
//                                             //+ but that's a lot of hassle. just ignore that.
//                                             // 'Please click the link below to go onto the requests page to approve or disapprove the request'
//                                             // '${_link}'
//                                           );
//                                           log("\n\n output is $output");
//
//                                         }
//                                       });
//                                     } else {
//                                       currentChannel = widget.docs["chatRoomId"];
//                                       var time = DateTime.now().millisecondsSinceEpoch;
//                                       Map<String, dynamic> videoCallMap = {
//                                         "sendById": authController.userModel.value.id,
//                                         "sendByName": authController.userModel.value.name,
//                                         "sendByImage": authController.userModel.value.primaryImageUrl,
//                                         "receivedByImage": anotherUserImage,
//                                         "receivedById": anotherUserID,
//                                         "receivedByName": anotherUserName,
//                                         "type": "videoCall",
//                                         'time': time,
//                                         "isRead": false,
//                                         'senderCallResponse': "Initiated",
//                                         'receiverCallResponse': "Incoming",
//                                         'callInitiationDateTime':
//                                         DateTime.now().millisecondsSinceEpoch.toString(),
//                                         'callResponseDateTime': DateTime.now().millisecondsSinceEpoch.toString(),
//                                       };
//                                       try {
//                                         await ffstore
//                                             .collection("ChatRoom")
//                                             .doc(widget.docs['chatRoomId'])
//                                             .collection("calls")
//                                             .add(videoCallMap)
//                                             .then((value) async {
//                                           CallDocModel passableAbleCdm =
//                                           CallDocModel.fromJson(videoCallMap);
//                                           Get.back();
//                                           Get.to(
//                                                 () => VideoCallAgoraUIKit(
//                                               anotherUserName: anotherUserModel.value.name,
//                                               anotherUserId: anotherUserModel.value.id,
//                                               anotherUserImage: anotherUserModel.value.primaryImageUrl,
//                                               token: "",
//                                               channelName: widget.docs["chatRoomId"],
//                                               docId: value.id,
//                                               callDoc: passableAbleCdm,
//                                             ),
//                                           );
//                                         });
//                                       } on FirebaseException catch (e) {
//                                         dismissLoadingWidget();
//                                         showErrorDialog(
//                                           title: "Error in Video Call",
//                                           description: "$e",
//                                         );
//                                       }
//                                     }
//                                   } else {
//                                     dismissLoadingWidget();
//                                     showErrorDialog(
//                                         title: "Not Allowed!",
//                                         description:
//                                         "$anotherUserName does not want to take any video calls right now");
//                                     log("Video call is not allowed by other user");
//                                   }
//                                 }
//                                 //+also add code here for sending Chaperone request
//                               },
//                               icon: Image.asset(
//                                 'assets/new_images/video_call_icon.png',
//                                 height: 15,
//                               ),
//                             )
//                                 : Container(),
//                           ],
//                         );
//                       });
//                     }
//                   }),
//                   IconButton(
//                     onPressed: () => _key.currentState.openEndDrawer(),
//                     icon: Image.asset(
//                       'assets/new_images/filter_icon_new.png',
//                       height: 15,
//                     ),
//                   ),
//                 ],
//               ),
//               body: WillPopScope(
//                 child: widget.videoCallPermission == true
//                     ? VideoCallPermission(
//                   //+What is this?
//                   //+What is this?
//                   //+What is this?
//                   //+What is this?
//                   //+What is this?
//                   onYesTap: () {
//                     setState(() {
//                       widget.videoCallPermission = false;
//                       Get.dialog(VideoCallApproved());
//                     });
//                   },
//                 )
//                     : Container(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                       // child: stickyGroupedChatMessageList(),
//                                       child: nonStickyGroupedChatMessageList(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Obx(() {
//                         if (!authController.isChaperone &&
//                             !isArchivedRoom.value &&
//                             !crm.value.isBlocked &&
//                             isPrivacAllowed.value) {
//                           return Obx(() {
//                             return Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                                 height: 70,
//                                 width: Get.width,
//                                 decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0xff111111).withOpacity(0.06),
//                                       blurRadius: 24,
//                                       offset: const Offset(0, 0),
//                                     ),
//                                   ],
//                                   color: kPrimaryColor,
//                                 ),
//                                 child: logic.isRecordingAudio.value || chatController.isAudioBeingSent.value
//                                     ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () async {
//                                         await stopRecordWithoutUpload();
//                                         logic.resetTimer();
//                                         logic.recordingMode();
//                                         log("inside delete icon clicked");
//                                       },
//                                       child: Image.asset(
//                                         'assets/new_images/deletee.png',
//                                         height: 20,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Obx(() {
//                                             if (chatController.isAudioBeingSent.value) {
//                                               return MyText(
//                                                 text: 'Sending',
//                                                 size: 13,
//                                                 color: kBlackColor,
//                                               );
//                                             }
//                                             return MyText(
//                                               text: 'Recording',
//                                               size: 13,
//                                               color: kBlackColor,
//                                             );
//                                           }),
//                                           Obx(() {
//                                             if (chatController.isAudioBeingSent.value) {
//                                               return SizedBox(
//                                                 height: 20,
//                                                 width: 20,
//                                                 child: CircularProgressIndicator(
//                                                   valueColor: const AlwaysStoppedAnimation<Color>(
//                                                     kSecondaryColor,
//                                                   ),
//                                                 ),
//                                               );
//                                             }
//                                             return MyText(
//                                               text: '${logic.minutes}:${logic.seconds}',
//                                               size: 14,
//                                               weight: FontWeight.w500,
//                                               color: kSecondaryColor,
//                                             );
//                                           }),
//                                         ],
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         chatController.isAudioBeingSent.value = true;
//                                         await stopRecord(
//                                             minutes: logic.minutes.value, seconds: logic.seconds.value);
//                                         log("'audio-time in before reset': '${logic.minutes.value}:${logic.seconds.value}'");
//                                         logic.resetTimer();
//                                         log("'audio-time in after reset': '${logic.minutes.value}:${logic.seconds.value}'");
//                                         // logic.isRecordingAudio.value = false;
//                                         logic.recordingMode();
//                                         log("inside send icon clicked");
//                                       },
//                                       child: Icon(
//                                         Icons.send,
//                                         color: kSecondaryColor,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                                     : Row(
//                                   children: [
//                                     // GestureDetector(
//                                     //   onTap: () => setState(() {
//                                     //     attachFiles = true;
//                                     //   }),
//                                     //   child: Image.asset(
//                                     //     'assets/images/akar-icons_circle-plus.png',
//                                     //     height: 25,
//                                     //   ),
//                                     // ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         //+From Gallary
//                                         getImageFromGallery();
//                                       },
//                                       child: Image.asset(
//                                         'assets/new_images/pic_image.png',
//                                         height: 18,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 15,
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         //+getCamImage();
//                                         getImageFromCamera();
//
//                                         /**/
//                                         // Navigator.push(
//                                         //   context,
//                                         //   MaterialPageRoute(
//                                         //     builder: (context) => Cam(
//                                         //       anotherUserId: anotherUserID,
//                                         //       anotherUserName: anotherUserName,
//                                         //       userId: userID,
//                                         //       chatRoomId: chatRoomID,
//                                         //     ),
//                                         //   ),
//                                         // );
//                                       },
//                                       child: Image.asset(
//                                         'assets/new_images/cap_image.png',
//                                         height: 19.27,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Obx(
//                                             () => Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 15,
//                                           ),
//                                           child: TextFormField(
//                                             focusNode: controller.focusNode,
//                                             // focusNode: focusNode,
//                                             controller: messageEditingController.value,
//                                             textAlignVertical: TextAlignVertical.center,
//                                             cursorColor: kDarkGreyColor.withOpacity(0.4),
//                                             style: TextStyle(
//                                               color: kGreyColor.withOpacity(0.72),
//                                               fontSize: 13,
//                                             ),
//                                             onChanged: (text) {
//                                               logic.messageControllerText.value = text;
//                                               log("logic.messageControllerText.value is: "
//                                                   "${logic.messageControllerText.value}");
//                                             },
//                                             decoration: chatScreenPageTextFieldDecoration,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Obx(
//                                           () => Container(
//                                         // margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
//                                         decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: isRecording.value ? Colors.black12 : Colors.white,
//                                               spreadRadius: 4,
//                                             )
//                                           ],
//                                           color: isRecording.value ? ktPrimaryColor : Colors.transparent,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: logic.messageControllerText.value == ''
//                                             ? GestureDetector(
//                                           onTap: () {
//                                             //+ audio message sending started at onTap of mic
//                                             startRecord();
//                                             logic.recordingMode();
//                                           },
//                                           onLongPress: () {
//                                             //+ audio message sending started at onLongPress of mic
//                                             startRecord();
//                                             logic.recordingMode();
//                                             // isRecording.value = true;
//                                             // _loadFile(doc['content']);
//                                           },
//                                           // onLongPressEnd: (details) {
//                                           //   stopRecord();
//                                           //   // setState(() {
//                                           //   log("onLongPress end");
//                                           //   // isRecording.value = false;
//                                           //   // });
//                                           // },
//                                           // onSecondaryTap: () {
//                                           //   stopRecord();
//                                           // },
//                                           child: Image.asset(
//                                             'assets/images/majesticons_microphone-line.png',
//                                             height: 22,
//                                             color: kBlackColor.withOpacity(0.30),
//                                           ),
//                                         )
//                                             : IconButton(
//                                           onPressed: () async {
//                                             log('\n\n\n\n clicked send\n\n\n');
//                                             await sendMessage();
//                                             // groupedItemScrollController.scrollTo(
//                                             //   index: lastIndex.value,
//                                             //   duration: Duration(microseconds: 300),
//                                             //   curve: Curves.ease,
//                                             // );
//                                             logic.messageControllerText.value = '';
//                                           },
//                                           icon: Icon(
//                                             Icons.send_rounded,
//                                             color: kBlackColor.withOpacity(0.30),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     // Expanded(
//                                     //   child: Row(
//                                     //     mainAxisAlignment:
//                                     //         MainAxisAlignment.spaceBetween,
//                                     //     children: [
//                                     //
//                                     //       // GestureDetector(
//                                     //       //   onTap: () {
//                                     //       //     controller.isEmojiVisible.value =
//                                     //       //         !controller.isEmojiVisible.value;
//                                     //       //     controller.focusNode.unfocus();
//                                     //       //     controller.focusNode.canRequestFocus =
//                                     //       //         true;
//                                     //       //   },
//                                     //       //   child: Image.asset(
//                                     //       //     'assets/images/bi_emoji-heart-eyes.png',
//                                     //       //     height: 25,
//                                     //       //   ),
//                                     //       // ),
//                                     //       IconButton(
//                                     //           onPressed: () {
//                                     //             log('\n\n\n\n clicked send\n\n\n');
//                                     //             sendMessage();
//                                     //           },
//                                     //           icon: Icon(Icons.send_rounded)),
//                                     //     ],
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           });
//                         } else {
//                           if (!crm.value.isBlocked) {
//                             //+if it is not blocked then check for whether it's a chaperone
//                             if (!authController.isChaperone) {
//                               //+ if it is not a chaperone then it is inactive chat
//                               if (!isPrivacAllowed.value) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                                   child: Container(
//                                     color: kSecondaryColor,
//                                     // height: 100,
//                                     // width: 50,
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                                       child: Center(
//                                         child: Text(
//                                           "Privacy settings changed. "
//                                               "You cannot send message to this user due to change in privacy settings .",
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                                   child: Container(
//                                     color: kSecondaryColor,
//                                     // height: 100,
//                                     // width: 50,
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                                       child: Center(
//                                         child: Text(
//                                           "This chat is inactive. "
//                                               "You cannot send message to an Inactive Chat",
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }
//                             } else {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                                 child: Container(
//                                   color: kSecondaryColor,
//                                   // height: 100,
//                                   // width: 50,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                                     child: Center(
//                                       child: Text(
//                                         "You are a Chaperone. "
//                                             "You cannot send any messages.",
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }
//                           } else {
//                             //+if it is blocked
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                               child: Container(
//                                 color: kSecondaryColor,
//                                 // height: 100,
//                                 // width: 50,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                                   child: Center(
//                                     child: Text(
//                                       "This chat is blocked",
//                                       // "by ${(crm.value.blockedById == authController.userModel.value.id) ? "you" : anotherUserName}",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         }
//                         // return (!authController.isChaperone && !widget.isArchived && !crm.value.isBlocked)
//                         //     ? Obx(() {
//                         //   return Align(
//                         //     alignment: Alignment.bottomCenter,
//                         //     child: Container(
//                         //       padding: const EdgeInsets.symmetric(horizontal: 15),
//                         //       height: 70,
//                         //       width: Get.width,
//                         //       decoration: BoxDecoration(
//                         //         boxShadow: [
//                         //           BoxShadow(
//                         //             color: Color(0xff111111).withOpacity(0.06),
//                         //             blurRadius: 24,
//                         //             offset: const Offset(0, 0),
//                         //           ),
//                         //         ],
//                         //         color: kPrimaryColor,
//                         //       ),
//                         //       child: logic.isRecordingAudio.value
//                         //           ? Row(
//                         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //         children: [
//                         //           GestureDetector(
//                         //             onTap: () async {
//                         //               await stopRecordWithoutUpload();
//                         //               logic.resetTimer();
//                         //               logic.recordingMode();
//                         //               log("inside delete icon clicked");
//                         //             },
//                         //             child: Image.asset(
//                         //               'assets/new_images/deletee.png',
//                         //               height: 20,
//                         //             ),
//                         //           ),
//                         //           Expanded(
//                         //             child: Column(
//                         //               mainAxisAlignment: MainAxisAlignment.center,
//                         //               children: [
//                         //                 MyText(
//                         //                   text: 'Recording',
//                         //                   size: 13,
//                         //                   color: kBlackColor,
//                         //                 ),
//                         //                 Obx(() {
//                         //                   return MyText(
//                         //                     text: '${logic.minutes}:${logic.seconds}',
//                         //                     size: 14,
//                         //                     weight: FontWeight.w500,
//                         //                     color: kSecondaryColor,
//                         //                   );
//                         //                 }),
//                         //               ],
//                         //             ),
//                         //           ),
//                         //           GestureDetector(
//                         //             onTap: () async {
//                         //               await stopRecord(
//                         //                   minutes: logic.minutes.value, seconds: logic.seconds.value);
//                         //               log("'audio-time in before reset': '${logic.minutes.value}:${logic.seconds.value}'");
//                         //               logic.resetTimer();
//                         //               log("'audio-time in after reset': '${logic.minutes.value}:${logic.seconds.value}'");
//                         //               // logic.isRecordingAudio.value = false;
//                         //               logic.recordingMode();
//                         //               log("inside send icon clicked");
//                         //             },
//                         //             child: Icon(
//                         //               Icons.send,
//                         //               color: kSecondaryColor,
//                         //             ),
//                         //           ),
//                         //         ],
//                         //       )
//                         //           : Row(
//                         //         children: [
//                         //           // GestureDetector(
//                         //           //   onTap: () => setState(() {
//                         //           //     attachFiles = true;
//                         //           //   }),
//                         //           //   child: Image.asset(
//                         //           //     'assets/images/akar-icons_circle-plus.png',
//                         //           //     height: 25,
//                         //           //   ),
//                         //           // ),
//                         //           GestureDetector(
//                         //             onTap: () {
//                         //               getImage();
//                         //             },
//                         //             child: Image.asset(
//                         //               'assets/new_images/pic_image.png',
//                         //               height: 18,
//                         //             ),
//                         //           ),
//                         //           const SizedBox(
//                         //             width: 15,
//                         //           ),
//                         //           GestureDetector(
//                         //             onTap: () {
//                         //               //+getCamImage();
//                         //               getImage();
//                         //
//                         //               /**/
//                         //               // Navigator.push(
//                         //               //   context,
//                         //               //   MaterialPageRoute(
//                         //               //     builder: (context) => Cam(
//                         //               //       anotherUserId: anotherUserID,
//                         //               //       anotherUserName: anotherUserName,
//                         //               //       userId: userID,
//                         //               //       chatRoomId: chatRoomID,
//                         //               //     ),
//                         //               //   ),
//                         //               // );
//                         //             },
//                         //             child: Image.asset(
//                         //               'assets/new_images/cap_image.png',
//                         //               height: 19.27,
//                         //             ),
//                         //           ),
//                         //           Expanded(
//                         //             child: Obx(
//                         //                   () => Padding(
//                         //                 padding: const EdgeInsets.symmetric(
//                         //                   horizontal: 15,
//                         //                 ),
//                         //                 child: TextFormField(
//                         //                   focusNode: controller.focusNode,
//                         //                   controller: messageEditingController.value,
//                         //                   textAlignVertical: TextAlignVertical.center,
//                         //                   cursorColor: kDarkGreyColor.withOpacity(0.4),
//                         //                   style: TextStyle(
//                         //                     color: kGreyColor.withOpacity(0.72),
//                         //                     fontSize: 13,
//                         //                   ),
//                         //                   onChanged: (text) {
//                         //                     logic.messageControllerText.value = text;
//                         //                     log("logic.messageControllerText.value is: "
//                         //                         "${logic.messageControllerText.value}");
//                         //                   },
//                         //                   decoration: InputDecoration(
//                         //                     fillColor: kPrimaryColor,
//                         //                     filled: true,
//                         //                     hintText: 'Type a message...',
//                         //                     hintStyle: TextStyle(
//                         //                       color: kGreyColor.withOpacity(0.72),
//                         //                       fontSize: 13,
//                         //                     ),
//                         //                     contentPadding: const EdgeInsets.symmetric(
//                         //                       horizontal: 15,
//                         //                     ),
//                         //                     enabledBorder: OutlineInputBorder(
//                         //                       borderRadius: BorderRadius.circular(
//                         //                         9,
//                         //                       ),
//                         //                       borderSide: BorderSide(
//                         //                         color: kLightGreyColor2,
//                         //                         width: 1.0,
//                         //                       ),
//                         //                     ),
//                         //                     focusedBorder: OutlineInputBorder(
//                         //                       borderRadius: BorderRadius.circular(
//                         //                         9,
//                         //                       ),
//                         //                       borderSide: BorderSide(
//                         //                         color: kLightGreyColor2,
//                         //                         width: 1.0,
//                         //                       ),
//                         //                     ),
//                         //                   ),
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //           Obx(
//                         //                 () => Container(
//                         //               // margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
//                         //               decoration: BoxDecoration(
//                         //                 boxShadow: [
//                         //                   BoxShadow(
//                         //                     color: isRecording.value ? Colors.black12 : Colors.white,
//                         //                     spreadRadius: 4,
//                         //                   )
//                         //                 ],
//                         //                 color: isRecording.value ? ktPrimaryColor : Colors.transparent,
//                         //                 shape: BoxShape.circle,
//                         //               ),
//                         //               child: logic.messageControllerText.value == ''
//                         //                   ? GestureDetector(
//                         //                 onTap: () {
//                         //                   startRecord();
//                         //                   logic.recordingMode();
//                         //                 },
//                         //                 onLongPress: () {
//                         //                   startRecord();
//                         //                   isRecording.value = true;
//                         //                   // _loadFile(doc['content']);
//                         //                 },
//                         //                 onLongPressEnd: (details) {
//                         //                   stopRecord();
//                         //                   // setState(() {
//                         //                   isRecording.value = false;
//                         //                   // });
//                         //                 },
//                         //                 // onSecondaryTap: () {
//                         //                 //   stopRecord();
//                         //                 // },
//                         //                 child: Image.asset(
//                         //                   'assets/images/majesticons_microphone-line.png',
//                         //                   height: 22,
//                         //                   color: kBlackColor.withOpacity(0.30),
//                         //                 ),
//                         //               )
//                         //                   : IconButton(
//                         //                 onPressed: () async {
//                         //                   log('\n\n\n\n clicked send\n\n\n');
//                         //                   await sendMessage();
//                         //                   // groupedItemScrollController.scrollTo(
//                         //                   //   index: lastIndex.value,
//                         //                   //   duration: Duration(microseconds: 300),
//                         //                   //   curve: Curves.ease,
//                         //                   // );
//                         //                   logic.messageControllerText.value = '';
//                         //                 },
//                         //                 icon: Icon(
//                         //                   Icons.send_rounded,
//                         //                   color: kBlackColor.withOpacity(0.30),
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //           // Expanded(
//                         //           //   child: Row(
//                         //           //     mainAxisAlignment:
//                         //           //         MainAxisAlignment.spaceBetween,
//                         //           //     children: [
//                         //           //
//                         //           //       // GestureDetector(
//                         //           //       //   onTap: () {
//                         //           //       //     controller.isEmojiVisible.value =
//                         //           //       //         !controller.isEmojiVisible.value;
//                         //           //       //     controller.focusNode.unfocus();
//                         //           //       //     controller.focusNode.canRequestFocus =
//                         //           //       //         true;
//                         //           //       //   },
//                         //           //       //   child: Image.asset(
//                         //           //       //     'assets/images/bi_emoji-heart-eyes.png',
//                         //           //       //     height: 25,
//                         //           //       //   ),
//                         //           //       // ),
//                         //           //       IconButton(
//                         //           //           onPressed: () {
//                         //           //             log('\n\n\n\n clicked send\n\n\n');
//                         //           //             sendMessage();
//                         //           //           },
//                         //           //           icon: Icon(Icons.send_rounded)),
//                         //           //     ],
//                         //           //   ),
//                         //           // ),
//                         //         ],
//                         //       ),
//                         //     ),
//                         //   );
//                         // })
//                         //     : !widget.docs["isBlocked"]
//                         // //+if it is not blocked then check for whether it's a chaperone
//                         //     ? !authController.isChaperone
//                         // //+ if it is not a chaperone then it is inactive chat
//                         //     ? Padding(
//                         //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                         //   child: Container(
//                         //     color: kSecondaryColor,
//                         //     // height: 100,
//                         //     // width: 50,
//                         //     child: Padding(
//                         //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                         //       child: Center(
//                         //         child: Text("This chat is inactive. "
//                         //             "You cannot send message to an Inactive Chat"),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // )
//                         // //+if it is a chaperone
//                         //     : Padding(
//                         //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                         //   child: Container(
//                         //     color: kSecondaryColor,
//                         //     // height: 100,
//                         //     // width: 50,
//                         //     child: Padding(
//                         //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                         //       child: Center(
//                         //         child: Text("You are a Chaperone. "
//                         //             "You cannot send any messages."),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // )
//                         // //+if it is blocked
//                         //     : Padding(
//                         //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                         //   child: Container(
//                         //     color: kSecondaryColor,
//                         //     // height: 100,
//                         //     // width: 50,
//                         //     child: Padding(
//                         //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                         //       child: Center(
//                         //         child: Text("This chat is blocked by "
//                         //             "${(widget.docs["blockedById"] == authController.userModel.value.id) ? "you" : anotherUserName}"),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // );
//                       }),
//                     ],
//                   ),
//                 ),
//                 onWillPop: () {
//                   if (controller.isEmojiVisible.value) {
//                     controller.isEmojiVisible.value = false;
//                   } else {
//                     Navigator.pop(context);
//                   }
//                   return Future.value(false);
//                 },
//               ),
//               // floatingActionButton: chatController.isDeleting.value
//               //     ? FloatingActionButton(
//               //         heroTag: "DELETEMESSAGESBUTTON",
//               //         onPressed: () {
//               //           //+delete the selected messages.
//               //           log("logging the list on delete button: ${chatController.deleteMsgIdList} ");
//               //           chatController.isDeleting.value = false;
//               //           chatController.deleteMsgIdList.clear();
//               //         }, // isExtended: true,
//               //         child: Image.asset(
//               //           'assets/images/bx_bxs-trash.png',
//               //           height: 24,
//               //           color: Colors.white,
//               //         ),
//               //         backgroundColor: kSecondaryColor.withOpacity(0.5),
//               //       )
//               //     : null,
//             );
//           }),
//     );
//   }
//
//   Widget timeBubble(String time) {
//     return Column(
//       children: [
//         Container(
//           height: 24,
//           width: 90,
//           margin: const EdgeInsets.only(top: 20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             color: kPrimaryColor,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xffABABAB).withOpacity(0.35),
//                 blurRadius: 10,
//                 spreadRadius: 0.0,
//                 offset: const Offset(0.0, 8.0),
//               ),
//             ],
//           ),
//           child: Center(
//             child: MyText(
//               text: time,
//               size: 12,
//               maxlines: 1,
//               overFlow: TextOverflow.ellipsis,
//               color: kSecondaryColor,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void openFile(PlatformFile file) {
//     OpenFile.open(file.path);
//   }
//
//   Future<File> saveFilePermanently(PlatformFile file) async {
//     final appStorage = await getApplicationDocumentsDirectory();
//     final newFile = File('${appStorage.path}/${file.name}');
//     return File(file.path).copy(newFile.path);
//   }
//
//   void openFiles(List<PlatformFile> files) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => FilesPage(
//           files: files,
//           onOpenedFile: openFile,
//         ),
//       ),
//     );
//   }
// }
//
// class AudioWidget extends StatelessWidget {
//   // var time, message, type, id, sendByMe;
//   final String time;
//   final String message;
//   final String type;
//   final String id;
//   final String audioTime;
//   final bool sendByMe;
//   final RxBool isSelected = false.obs;
//   final RxBool isPlaying = false.obs;
//   final RxBool isLoading = false.obs;
//   bool isRead = false;
//   bool isReceived = false;
//   String recordFilePath = "";
//   RxString selectedVoiceId = ''.obs;
//   RxDouble bytesRead = 0.0.obs;
//   Rx<Duration> duration = Duration.zero.obs;
//   Rx<Duration> position = Duration.zero.obs;
//   final audioPlayer = AudioPlayer();
//
//   AudioWidget({
//     Key key,
//     this.time,
//     this.message,
//     this.type,
//     this.id,
//     this.sendByMe,
//     this.audioTime,
//     this.isRead,
//     this.isReceived,
//   }) : super(key: key);
//
//   // void isPlayingMode(String id) {
//   //   selectedVoiceId.value = id;
//   //   // update();
//   //   print('This is voice id $selectedVoiceId');
//   //   // log("isPlayingMode called and now the isPlayingMsg.value is: ${isPlayingMsg}");
//   // }
//
//   Future loadFile(String url) async {
//     isLoading.value = true;
//     final bytes = await readBytes(Uri.parse(url));
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/audio.mp3');
//
//     await file.writeAsBytes(bytes);
//     if (await file.exists()) {
//       log("${DateTime.now()}  before getting the file.");
//       recordFilePath = file.path;
//       isLoading.value = false;
//       isPlaying.value = true;
//       // chatController.isPlayingMode(url);
//       log("${DateTime.now()} before play");
//
//       await play();
//       log("${DateTime.now()} play completed");
//       final timeList = audioTime.split(":");
//       final minuteSeconds = int.parse(timeList[0]) * 60;
//       log("minuteSeconds + int.parse(timeList[1] : ${minuteSeconds + int.parse(timeList[1])}");
//       // Future.delayed(Duration(seconds: minuteSeconds + int.parse(timeList[1])), () async {
//       //   log("${DateTime.now()} executing stopp");
//       //   await audioPlayer.stop();
//       //   isPlaying.value = false;
//       // });
//       // chatController.isPlayingMode("fhjdk");
//       //+ this is not working because we need to wait for as much time as is needed by the audio
//       // chatController.isPlayingMode(url);
//     }
//   }
//
//   stopAudio() async {
//     await audioPlayer.stop();
//     isPlaying.value = false;
//   }
//
//   Future<void> play() async {
//     log("play caled and recordFilePath: $recordFilePath");
//     try {
//       audioPlayer.onDurationChanged.listen((Duration d) {
//         log('Max duration: $d');
//         duration.value = d;
//         // setState(() => duration = d);
//       });
//
//       audioPlayer.onAudioPositionChanged.listen((Duration p) {
//         log('Current position: $p');
//         position.value = p;
//       });
//
//       audioPlayer.onPlayerStateChanged.listen((s) {
//         log('Current player state: $s');
//         if (s == AudioPlayerState.STOPPED || s == AudioPlayerState.COMPLETED) {
//           // audioPlayer.stop();
//           isPlaying.value = false;
//           position.value = Duration.zero;
//           duration.value = Duration.zero;
//         }
//         // setState(() => playerState = s);
//       });
//       audioPlayer.onPlayerCompletion.listen((event) {
//         log("on Player Complete");
//         // onComplete();
//         //   position = duration;
//       });
//
//       if (recordFilePath != null && File(recordFilePath).existsSync()) {
//         log("inside playing if $recordFilePath");
//         await audioPlayer.play(
//           recordFilePath,
//           isLocal: true,
//         );
//       }
//     } catch (e) {
//       log("eror in playing is: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // isSelected.value = false;
//     return GestureDetector(
//       onTap: !authController.isChaperone && sendByMe
//           ? () {
//         if (chatController.isDeleting.value) {
//           if (!isSelected.value) {
//             isSelected.value = true;
//             if (!chatController.deleteAudioIdList.asMap().containsValue(id))
//               chatController.deleteAudioIdList.add(id);
//             if (!chatController.deleteAudioLinksList.asMap().containsValue(id))
//               chatController.deleteAudioLinksList.add(message);
//             log("inside chatController.isDeleting.value being true. and now selected this onTap "
//                 "and id is: $id and  list: ${chatController.deleteAudioIdList} "
//                 "\n chatController.deleteAudioIdList.asMap().containsValue(id): "
//                 "${chatController.deleteAudioIdList.asMap().containsValue(id)} ");
//           } else {
//             isSelected.value = false;
//             log(" in on onTap contains before deletion \n "
//                 " chatController.deleteAudioIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteAudioIdList.asMap().containsValue(id)}");
//             chatController.deleteAudioIdList.remove(id);
//             chatController.deleteAudioLinksList.remove(message);
//             if (chatController.deleteMsgIdList.length == 0 && chatController.deleteAudioIdList.length == 0) {
//               chatController.isDeleting.value = false;
//             }
//             log("deleting the id $id from list and list is: ${chatController.deleteAudioIdList}");
//             log("checking in onTap contains after deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteAudioIdList.asMap().containsValue(id)}");
//           }
//         } else {
//           log("not deleting right now so tap is not gonna work");
//         }
//       }
//           : null,
//       onLongPress: !authController.isChaperone && sendByMe
//           ? () {
//         if (!chatController.isDeleting.value) {
//           isSelected.value = true;
//           chatController.isDeleting.value = true;
//           if (!chatController.deleteAudioIdList.asMap().containsValue(id))
//             chatController.deleteAudioIdList.add(id);
//           if (!chatController.deleteAudioLinksList.asMap().containsValue(id))
//             chatController.deleteAudioLinksList.add(message);
//           log("inside chatController.isDeleting.value being false. and now selected this onLongPress"
//               "and id is: $id and list is: ${chatController.deleteAudioIdList} and "
//               "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
//               "${chatController.deleteAudioIdList.asMap().containsValue(id)}");
//         } else {
//           // isSelected.value = !isSelected.value;
//           if (!isSelected.value) {
//             isSelected.value = true;
//             log("inside  on LongPress chatController.isDeleting.value being true. and now selected this onTap "
//                 "and id is: $id and  list: ${chatController.deleteMsgIdList} and "
//                 "\n chatController.deleteMsgIdList.asMap().containsValue(id):"
//                 " ${chatController.deleteAudioIdList.asMap().containsValue(id)}");
//             if (!chatController.deleteAudioIdList.asMap().containsValue(id))
//               chatController.deleteAudioIdList.add(id);
//             if (!chatController.deleteAudioLinksList.asMap().containsValue(id))
//               chatController.deleteAudioLinksList.add(message);
//           } else {
//             isSelected.value = false;
//             log("checking contains before deletion \n "
//                 " chatController.deleteAudioIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteAudioIdList.asMap().containsValue(id)}");
//             chatController.deleteAudioIdList.remove(id);
//             chatController.deleteAudioLinksList.remove(message);
//             if (chatController.deleteMsgIdList.length == 0 && chatController.deleteAudioIdList.length == 0) {
//               chatController.isDeleting.value = false;
//             }
//             log("deleting the id on LongPress from list and list is: ${chatController.deleteMsgIdList}");
//             log("checking contains after deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteAudioIdList.asMap().containsValue(id)}");
//           }
//           log("deleting on LongPress right now so onLongPress is  is not gonna work");
//         }
//       }
//           : null,
//       child: Obx(() {
//         return Container(
//           color: isSelected.value && chatController.deleteAudioIdList.asMap().containsValue(id)
//               ? Colors.blue.withOpacity(0.2)
//               : Colors.transparent,
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.5,
//             margin: EdgeInsets.only(
//               left: ((sendByMe) ? 64 : 10),
//               right: ((sendByMe) ? 10 : 64),
//               bottom: 15,
//             ),
//             padding: EdgeInsets.symmetric(
//               horizontal: 13,
//               vertical: isPlaying.value ? 0 : 10,
//             ),
//             decoration: BoxDecoration(
//               boxShadow: [
//                 sendByMe
//                     ? BoxShadow()
//                     : BoxShadow(
//                   offset: const Offset(0, 0),
//                   blurRadius: 10,
//                   color: Color(0xff111111).withOpacity(0.06),
//                 ),
//               ],
//               color: sendByMe ? kSecondaryColor : kPrimaryColor,
//               borderRadius: BorderRadius.only(
//                 // topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//                 topLeft: Radius.circular(10),
//                 bottomLeft: Radius.circular(sendByMe ? 10 : 0),
//                 bottomRight: Radius.circular(sendByMe ? 0 : 10),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Obx(() {
//                         log("in onTap  before checking "
//                             "chatController.isPlayingMsg.value: "
//                             "${isPlaying.value}");
//                         return GestureDetector(
//                           onTap: !isPlaying.value
//                               ? () {
//                             print('This is from Message ID $message');
//                             log("onTap called");
//                             log("in onTap  before checking "
//                                 "chatController.isPlayingMsg.value: "
//                                 "${isPlaying.value}");
//                             // if (!chatController.isPlayingMsg
//                             //     .value) {
//                             log("in onTap isPlaying being false "
//                                 "chatController.isPlayingMsg.value: "
//                                 "${isPlaying.value}");
//                             // isPlaying.value = true;
//                             loadFile(message);
//                           }
//                               : () async {
//                             log("onSecondary called or in else");
//                             // stopRecord();
//                             await stopAudio();
//                             log("in playing message being true before turning false "
//                                 "chatController.isPlayingMsg.value: "
//                                 "${isPlaying.value}");
//                             isPlaying.value = false;
//                             log("chatController.isPlayingMsg.value: "
//                                 "${isPlaying.value}");
//                             // chatController.isPlayingMode("fhjdk");
//                           },
//                           child: Obx(() {
//                             if (!isLoading.value) {
//                               return Obx(() {
//                                 return Icon(
//                                   isPlaying.value && !isLoading.value ? Icons.cancel : Icons.play_arrow,
//                                   color: sendByMe ? kPrimaryColor : kBlackColor,
//                                 );
//                               });
//                             } else {
//                               return SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(sendByMe ? Colors.white : kBlackColor),
//                                   strokeWidth: 2,
//                                   // value: loadingProgress.expectedTotalBytes != null
//                                   //     ? loadingProgress.cumulativeBytesLoaded /
//                                   //     loadingProgress.expectedTotalBytes
//                                   //     : null,
//                                 ),
//                               );
//                               //   CircularPercentIndicator(
//                               //   radius: 30.0,
//                               //   lineWidth: 10.0,
//                               //   animation: true,
//                               //   percent: 0.7,
//                               //   center: new Text(
//                               //     "70.0%",
//                               //     style:
//                               //     new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//                               //   ),
//                               //   footer: new Text(
//                               //     "Sales this week",
//                               //     style:
//                               //     new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
//                               //   ),
//                               //   circularStrokeCap: CircularStrokeCap.round,
//                               //   progressColor: Colors.purple,
//                               // );
//                             }
//                           }),
//                         );
//                       }),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       // Column(
//                       //   children: [
//                       Obx(() {
//                         if (isPlaying.value) {
//                           return Expanded(
//                             child: SliderTheme(
//                               data: SliderThemeData(
//                                 trackHeight: 3.0,
//                                 trackShape: CustomTrackShape(),
//                                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
//                               ),
//                               child: Slider(
//                                 thumbColor: Colors.white,
//                                 min: 0,
//                                 max: duration.value.inSeconds.toDouble(),
//                                 value: position.value.inSeconds.toDouble(),
//                                 onChanged: (double value) async {
//                                   final position = Duration(seconds: value.toInt());
//                                   await chatController.audioPlayer.seek(position);
//                                 },
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Text(
//                             'Audio ${audioTime}',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: sendByMe ? kPrimaryColor : kBlackColor,
//                             ),
//                           );
//                         }
//                       }),
//                       // isPlaying.value
//                       //     ? Slider(
//                       //         min: 0,
//                       //         max: duration.value.inSeconds.toDouble(),
//                       //         value: position.value.inSeconds.toDouble(),
//                       //         onChanged: (double value) {},
//                       //       )
//                       //     : Text(
//                       //         'Audio ${time}',
//                       //         maxLines: 1,
//                       //         overflow: TextOverflow.ellipsis,
//                       //         style: TextStyle(
//                       //           color: sendByMe ? kPrimaryColor : kBlackColor,
//                       //         ),
//                       //       ),
//                       //+ this can be added to show the audio time but not right now
//                       // Text(
//                       //   '${snapshot.data.docs[index].data()["audio-time"].toString()}',
//                       //   maxLines: 1,
//                       //   overflow: TextOverflow.ellipsis,
//                       //   style: TextStyle(
//                       //     color: sendByMe
//                       //         ? kPrimaryColor
//                       //         : kBlackColor,
//                       //   ),
//                       // ),
//                       // ],
//                       // ),
//                     ],
//                   ),
//                 ),
//                 MyText(
//                   text: time,
//                   // "${hour.toString()}:"
//                   //     "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
//                   //     "${ampm}",
//                   size: 12,
//                   fontFamily: 'Roboto',
//                   color: sendByMe ? kPrimaryColor.withOpacity(0.60) : kBlackColor.withOpacity(0.60),
//                 ),
//                 sendByMe
//                     ? (!isRead && !isReceived)
//                     ? Padding(
//                   padding: const EdgeInsets.only(left: 4.0),
//                   child: Image.asset(
//                     "assets/images/tick.png",
//                     width: 14,
//                     height: 10,
//                     color: Colors.grey,
//                   ),
//                 )
//                     : Padding(
//                   padding: const EdgeInsets.only(left: 4.0),
//                   child: Image.asset(
//                     "assets/images/read.png",
//                     width: 14,
//                     height: 14,
//                     color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
//                   ),
//                 )
//                     : SizedBox(),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class RightBubble extends StatelessWidget {
//   RightBubble({
//     this.time,
//     this.sendByMe,
//     this.msg,
//     this.type,
//     this.id,
//     this.isRead,
//     this.isReceived,
//   });
//
//   var time, msg, type, id, sendByMe;
//   RxBool isSelected = false.obs;
//   bool isRead = false;
//   bool isReceived = false;
//   String imgPlaceholder =
//       'https://thumbs.dreamstime.com/z/placeholder-icon-vector-isolated-white-background-your-web-mobile-app-design-placeholder-logo-concept-placeholder-icon-134071364.jpg';
//
//   @override
//   Widget build(BuildContext context) {
//     // isSelected.value = false;
//     return GestureDetector(
//       onTap: sendByMe && !authController.isChaperone
//           ? () {
//         if (chatController.isDeleting.value) {
//           if (!isSelected.value) {
//             isSelected.value = true;
//             chatController.deleteMsgIdList.add(id);
//             if (type == "image" && !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.add(msg);
//               chatController.deleteImageIdsList.add(id);
//             }
//             log("inside chatController.isDeleting.value being true. and now selected this onTap "
//                 "and id is: $id and  list: ${chatController.deleteMsgIdList} "
//                 "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 "${chatController.deleteMsgIdList.asMap().containsValue(id)} ");
//           } else {
//             isSelected.value = false;
//             log(" in on onTap contains before deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//             chatController.deleteMsgIdList.remove(id);
//             if (type == "image" && chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.remove(msg);
//               chatController.deleteImageIdsList.remove(id);
//             }
//             if (chatController.deleteMsgIdList.length == 0 && chatController.deleteAudioIdList.length == 0) {
//               chatController.isDeleting.value = false;
//             }
//             log("deleting the id $id from list and list is: ${chatController.deleteMsgIdList}");
//             log("checking in onTap contains after deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//           }
//         } else {
//           log("not deleting right now so tap is not gonna work");
//         }
//       }
//           : null,
//       onLongPress: sendByMe && !authController.isChaperone
//           ? () {
//         if (!chatController.isDeleting.value) {
//           isSelected.value = true;
//           chatController.isDeleting.value = true;
//           if (!chatController.deleteMsgIdList.asMap().containsValue(id)) chatController.deleteMsgIdList.add(id);
//           if (type == "image" && !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//             chatController.deleteImageLinksList.add(msg);
//             chatController.deleteImageIdsList.add(id);
//           }
//           log("inside chatController.isDeleting.value being false. and now selected this onLongPress"
//               "and id is: $id and list is: ${chatController.deleteMsgIdList} and "
//               "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
//               "${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//         } else {
//           // isSelected.value = !isSelected.value;
//           if (!isSelected.value) {
//             isSelected.value = true;
//             log("inside  on LongPress chatController.isDeleting.value being true. and now selected this onTap "
//                 "and id is: $id and  list: ${chatController.deleteMsgIdList} and "
//                 "\n chatController.deleteMsgIdList.asMap().containsValue(id):"
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//             if (!chatController.deleteMsgIdList.asMap().containsValue(id)) chatController.deleteMsgIdList.add(id);
//             if (type == "image" && !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.add(msg);
//               chatController.deleteImageIdsList.add(id);
//             }
//           } else {
//             isSelected.value = false;
//             log("checking contains before deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//             chatController.deleteMsgIdList.remove(id);
//             if (type == "image" && chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.remove(msg);
//               chatController.deleteImageIdsList.remove(id);
//             }
//             if (chatController.deleteMsgIdList.length == 0 &&
//                 chatController.deleteAudioIdList.length == 0 &&
//                 chatController.deleteAudioIdList.length == 0) {
//               chatController.isDeleting.value = false;
//             }
//             log("deleting the id on LongPress from list and list is: ${chatController.deleteMsgIdList}");
//             log("checking contains after deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//           }
//           log("deleting on LongPress right now so onLongPress is  is not gonna work");
//         }
//       }
//           : null,
//       child: Obx(() {
//         return Container(
//           color: isSelected.value && chatController.deleteMsgIdList.asMap().containsValue(id)
//               ? Colors.blue.withOpacity(0.2)
//               : Colors.transparent,
//           child: Align(
//             alignment: Alignment.topRight,
//             child: Container(
//               margin: const EdgeInsets.only(left: 50, right: 10, bottom: 10, top: 10),
//               padding: EdgeInsets.symmetric(
//                 horizontal: type == 'text' ? 13 : 2,
//                 vertical: type == 'text' ? 10 : 2,
//               ),
//               decoration: BoxDecoration(
//                 color: kSecondaryColor,
//                 borderRadius: BorderRadius.only(
//                   // topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                   topLeft: Radius.circular(10),
//                   bottomLeft: Radius.circular(10),
//                   bottomRight: Radius.circular(0),
//                 ),
//               ),
//               child: Wrap(
//                 alignment: WrapAlignment.end,
//                 crossAxisAlignment: WrapCrossAlignment.end,
//                 children: [
//                   type == 'text'
//                       ? MyText(
//                     text: msg,
//                     size: 14,
//                     color: kPrimaryColor,
//                     paddingRight: 10,
//                     // align: TextAlign.justify,
//                   )
//                       : Stack(
//                     children: [
//                       ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10),
//                             bottomLeft: Radius.circular(10),
//                           ),
//                           child: GestureDetector(
//                             onTap: !chatController.isDeleting.value
//                                 ? () {
//                               Get.to(() => FullImage(imagePath: msg));
//                             }
//                                 : null,
//                             child: Image.network(
//                               msg == "what is this?" ? imgPlaceholder : msg,
//                               height: 250,
//                               width: 250,
//                               fit: BoxFit.cover,
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) {
//                                   return child;
//                                 }
//                                 return SizedBox(
//                                   height: 250,
//                                   width: 250,
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                                       value: loadingProgress.expectedTotalBytes != null
//                                           ? loadingProgress.cumulativeBytesLoaded /
//                                           loadingProgress.expectedTotalBytes
//                                           : null,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (context, exception, stackTrace) {
//                                 return Container(
//                                   height: 250,
//                                   width: 250,
//                                   child: Center(
//                                     child: Text(
//                                       '     Could not load image.\n Please connect to network.',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           )),
//                       /* CachedNetworkImage(
//                               height: 250,
//                               width: 250,
//                               fit: BoxFit.cover,
//                               imageUrl: msg == "what is this?" ? imgPlaceholder : msg,
//                               progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                 child: CircularProgressIndicator(
//                                   value: downloadProgress.progress,
//                                   color: kSecondaryColor,
//                                 ),
//                               ),
//                               errorWidget: (context, url, error) => Icon(Icons.error),
//                             ),*/
//
//                       Positioned(
//                         bottom: 2,
//                         right: 3,
//                         child: SizedBox(
//                           width: 230,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               MyText(
//                                 //+ time add krna ha yahan pr
//                                 text: time,
//                                 size: 12,
//                                 fontFamily: 'Roboto',
//                                 color: kPrimaryColor,
//                                 weight: FontWeight.w500,
//                               ),
//                               sendByMe
//                                   ? (!isRead && !isReceived)
//                                   ? Padding(
//                                 padding: const EdgeInsets.only(left: 4.0),
//                                 child: Image.asset(
//                                   "assets/images/tick.png",
//                                   width: 14,
//                                   height: 10,
//                                   color: Colors.grey,
//                                 ),
//                               )
//                                   : Padding(
//                                 padding: const EdgeInsets.only(left: 4.0),
//                                 child: Image.asset(
//                                   "assets/images/read.png",
//                                   width: 14,
//                                   height: 14,
//                                   color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
//                                 ),
//                               )
//                                   : SizedBox(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   type == 'text'
//                       ? MyText(
//                     //+ time add krna ha yahan pr
//                     text: time,
//                     size: 12,
//                     fontFamily: 'Roboto',
//                     color: kPrimaryColor,
//                     weight: FontWeight.w500,
//                   )
//                       : SizedBox(),
//                   sendByMe && type == "text"
//                       ? (!isRead && !isReceived)
//                       ? Padding(
//                     padding: const EdgeInsets.only(left: 4.0),
//                     child: Image.asset(
//                       "assets/images/tick.png",
//                       width: 14,
//                       height: 10,
//                       color: Colors.grey,
//                     ),
//                   )
//                       : Padding(
//                     padding: const EdgeInsets.only(left: 4.0),
//                     child: Image.asset(
//                       "assets/images/read.png",
//                       width: 14,
//                       height: 14,
//                       color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
//                     ),
//                   )
//                       : SizedBox(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class LeftBubble extends StatelessWidget {
//   var personImage, time, msg, type, id, sendByMe;
//   bool isRead;
//   bool isReceived;
//   final FocusNode focusNode;
//
//   LeftBubble({
//     this.personImage,
//     this.time,
//     this.msg,
//     this.type,
//     this.id,
//     this.sendByMe,
//     this.focusNode,
//     this.isRead,
//     this.isReceived,
//   });
//
//   RxBool isSelected = false.obs;
//
//   String imgPlaceholder =
//       'https://thumbs.dreamstime.com/z/placeholder-icon-vector-isolated-white-background-your-web-mobile-app-design-placeholder-logo-concept-placeholder-icon-134071364.jpg';
//
//   @override
//   Widget build(BuildContext context) {
//     isSelected.value = false;
//     return GestureDetector(
//       onTap: sendByMe
//           ? () {
//         if (chatController.isDeleting.value) {
//           if (!isSelected.value) {
//             isSelected.value = true;
//             chatController.deleteMsgIdList.add(id);
//             if (type == "image" && !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.add(msg);
//               chatController.deleteImageIdsList.add(id);
//             }
//             log("inside chatController.isDeleting.value being true. and now selected this onTap "
//                 "and id is: ${id} and  list: ${chatController.deleteMsgIdList} "
//                 "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 "${chatController.deleteMsgIdList.asMap().containsValue(id)} ");
//           } else {
//             isSelected.value = false;
//             log(" in on onTap contains before deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//             chatController.deleteMsgIdList.remove(id);
//             if (type == "image" && chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.remove(msg);
//               chatController.deleteImageIdsList.remove(id);
//             }
//             if (chatController.deleteMsgIdList.length == 0 && chatController.deleteAudioIdList.length == 0) {
//               chatController.isDeleting.value = false;
//             }
//             log("deleting the id ${id} from list and list is: ${chatController.deleteMsgIdList}");
//             log("checking in onTap contains after deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//           }
//         } else {
//           log("not deleting right now so tap is not gonna work");
//         }
//       }
//           : null,
//       onLongPress: sendByMe
//           ? () {
//         if (!chatController.isDeleting.value) {
//           isSelected.value = true;
//           chatController.isDeleting.value = true;
//           chatController.deleteMsgIdList.add(id);
//           if (type == "image" && !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//             chatController.deleteImageLinksList.add(msg);
//             chatController.deleteImageIdsList.add(id);
//           }
//           log("inside chatController.isDeleting.value being false. and now selected this onLongPress"
//               "and id is: ${id} and list is: ${chatController.deleteMsgIdList} and "
//               "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
//               "${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//         } else {
//           // isSelected.value = !isSelected.value;
//           if (!isSelected.value) {
//             isSelected.value = true;
//             log("inside  on LongPress chatController.isDeleting.value being true. and now selected this onTap "
//                 "and id is: ${id} and  list: ${chatController.deleteMsgIdList} and "
//                 "\n chatController.deleteMsgIdList.asMap().containsValue(id):"
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//             chatController.deleteMsgIdList.add(id);
//             if (type == "image" && !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.add(msg);
//               chatController.deleteImageIdsList.add(id);
//             }
//           } else {
//             isSelected.value = false;
//             log("checking contains before deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//             chatController.deleteMsgIdList.remove(id);
//             if (type == "image" && chatController.deleteImageLinksList.asMap().containsValue(msg)) {
//               chatController.deleteImageLinksList.remove(msg);
//               chatController.deleteImageIdsList.remove(id);
//             }
//             if (chatController.deleteMsgIdList.length == 0 &&
//                 chatController.deleteAudioIdList.length == 0 &&
//                 chatController.deleteAudioIdList.length == 0) {
//               chatController.isDeleting.value = false;
//             }
//             log("deleting the id on LongPress from list and list is: ${chatController.deleteMsgIdList}");
//             log("checking contains after deletion \n "
//                 " chatController.deleteMsgIdList.asMap().containsValue(id): "
//                 " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
//           }
//           log("deleting on LongPress right now so onLongPress is  is not gonna work");
//         }
//       }
//           : null,
//       child: Obx(() {
//         //+Here Adding Swipe_WALA
//         /* onRightSwipe: () {
//           print('Callback from Swipe To Right');
//           focusNode.requestFocus();
//           setState(() {});
//         },*/
//         return Container(
//           color: isSelected.value && chatController.deleteMsgIdList.asMap().containsValue(id)
//               ? Colors.blue.withOpacity(0.2)
//               : Colors.transparent,
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               margin: const EdgeInsets.only(
//                 left: 10,
//                 right: 50,
//                 bottom: 10,
//                 top: 10,
//               ),
//               padding: EdgeInsets.symmetric(
//                 horizontal: type == 'text' ? 13 : 0,
//                 vertical: type == 'text' ? 10 : 0,
//               ),
//               decoration: BoxDecoration(
//                 color: kPrimaryColor,
//                 borderRadius: BorderRadius.only(
//                   // topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                   topLeft: Radius.circular(10),
//                   bottomLeft: Radius.circular(0),
//                   bottomRight: Radius.circular(10),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: const Offset(0, 0),
//                     blurRadius: 10,
//                     color: Color(0xff111111).withOpacity(0.06),
//                   ),
//                 ],
//               ),
//               child: Wrap(
//                 alignment: WrapAlignment.end,
//                 crossAxisAlignment: WrapCrossAlignment.end,
//                 children: [
//                   type == 'text'
//                       ? MyText(
//                     text: msg,
//                     size: 14,
//                     color: Color(0xff434343),
//                     paddingRight: 10,
//                   )
//                       : Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         // topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                         topLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                     ),
//                     child: Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             // topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10),
//                             topLeft: Radius.circular(10),
//                             bottomRight: Radius.circular(10),
//                           ),
//                           child: GestureDetector(
//                             onTap: () {
//                               Get.to(() => FullImage(imagePath: msg));
//                             },
//                             child: Image.network(
//                               msg == "what is this?" ? imgPlaceholder : msg,
//                               height: 250,
//                               width: 250,
//                               fit: BoxFit.cover,
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) {
//                                   return child;
//                                 }
//                                 return SizedBox(
//                                   height: 250,
//                                   width: 250,
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       valueColor: const AlwaysStoppedAnimation<Color>(kSecondaryColor),
//                                       value: loadingProgress.expectedTotalBytes != null
//                                           ? loadingProgress.cumulativeBytesLoaded /
//                                           loadingProgress.expectedTotalBytes
//                                           : null,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (context, exception, stackTrace) {
//                                 return Container(
//                                   height: 250,
//                                   width: 250,
//                                   child: Center(
//                                     child: Text(
//                                       '     Could not load image.\n Please connect to network.',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           /* Image.network(
//                                 msg == "what is this?" ? imgPlaceholder : msg,
//                                 height: 300,
//                                 width: Get.width * 0.75,
//                                 fit: BoxFit.fill,
//                                 loadingBuilder: (BuildContext context,
//                                     Widget child,
//                                     ImageChunkEvent loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Center(
//                                     child: CircularProgressIndicator(
//                                       valueColor:
//                                           new AlwaysStoppedAnimation<Color>(
//                                               Colors.green),
//                                       value: loadingProgress.expectedTotalBytes !=
//                                               null
//                                           ? loadingProgress
//                                                   .cumulativeBytesLoaded /
//                                               loadingProgress.expectedTotalBytes
//                                           : null,
//                                     ),
//                                   );
//                                 },
//                               ),*/
//                         ),
//                         Positioned(
//                           bottom: 2,
//                           right: 3,
//                           child: MyText(
//                             text: time,
//                             size: 12,
//                             fontFamily: 'Roboto',
//                             color: kBlackColor,
//                             weight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   type == 'text'
//                       ? MyText(
//                     //+ text: time.toString(),
//                     text: time,
//                     size: 12,
//                     fontFamily: 'Roboto',
//                     color: kBlackColor.withOpacity(0.3),
//                     weight: FontWeight.w500,
//                   )
//                       : SizedBox(),
//                   sendByMe
//                       ? (!isRead && !isReceived)
//                       ? Image.asset(
//                     "assets/images/tick.png",
//                     width: 14,
//                     height: 14,
//                     color: Colors.grey,
//                   )
//                       : Image.asset(
//                     "assets/images/read.png",
//                     width: 14,
//                     height: 14,
//                     color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
//                   )
//                       : SizedBox(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
