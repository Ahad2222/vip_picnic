import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/group_chat/preview_group_chat_image.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/message_bubbles.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

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
  int i = 0;
  String imageUrl = '';
  bool isOpenedUp = true;

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

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? otherUserListener;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? chatRoomListener;

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

    // getUserDataFromChatRoomDB();
    // getRoomId();
    // getChatRoomStream();
    super.initState();

    // KeyboardVisibilityController().onChange.listen((event) {
    //   chatController.isKeyboardOpen.value = event;
    // });
    // isArchivedRoom.value = widget.isArchived!;
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
  //   // otherUserListener = await ffstore.collection("Accounts").doc(anotherUserID).snapshots().listen((event) {
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
      };
      // bool isDeletedFor = crm.value.notDeletedFor?.asMap().containsValue(anotherUserID) ?? false;
      // if (!isDeletedFor) {
      //   ffstore.collection("ChatRoom").doc(chatRoomID).update({
      //     "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
      //   });
      // }
      chatController.addConversationMessage(chatRoomID, time, "text", messageMap, messageText);
      // log("index is: ${lastIndex.value}");
    } else if (imageFile != null && (imageUrl != null || imageUrl != "")) {
      var time = DateTime.now().millisecondsSinceEpoch;

      Map<String, dynamic> messageMap = {
        "sendById": userDetailsModel.uID,
        "sendByName": userDetailsModel.fullName,
        // "receivedById": anotherUserID,
        // "receivedByName": anotherUserName,
        "message": imageUrl,
        "type": "image",
        'time': time,
        'isDeletedFor': [],
        "isRead": false,
        "isReadBy": [],
        "isReceived": false,
      };
      // bool isDeletedFor = crm.value.notDeletedFor?.asMap().containsValue(anotherUserID) ?? false;
      //
      // if (!isDeletedFor) {
      // /  ffstore.collection("ChatRoom").doc(chatRoomID).update({
      //     "notDeletedFor": FieldValue.arrayUnion([anotherUserID])
      //   });
      // }
      chatController.addConversationMessage(chatRoomID, time, "image", messageMap, imageUrl!);
      messageEditingController.value.text = "";

      imageUrl = "";
    }
    chatController.messageControllerText.value = "";
  }

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
      ffstore.collection(groupChatCollection).doc(chatRoomID).collection(messagesCollection).orderBy('time').snapshots(),
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
              return MessageBubbles(
                receiveImage: senderImage,
                msg: message,
                time: "${hour.toString()}:"
                    "${(min.toString().length < 2) ? "0${min.toString()}" : min.toString()} "
                    "${ampm}",
                senderType: !sendByMe ? 'receiver' : 'sender',
                mediaType: type,
              );
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
    return Scaffold(
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
            : MyText(
          //+docs!['groupName']
          text: '${widget.docs!['groupName'] ?? ""}',
          size: 19,
          color: kSecondaryColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 15,
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
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 387,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                MyText(
                                  text: 'Send invitation',
                                  size: 19,
                                  color: kSecondaryColor,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Image.asset(
                                    Assets.imagesRoundedClose,
                                    height: 22.44,
                                  ),
                                ),
                              ],
                            ),
                            SimpleTextField(
                              hintText: 'Type username,  email...',
                            ),
                            SimpleTextField(
                              maxLines: 5,
                              hintText: 'Message...',
                            ),
                            MyButton(
                              onTap: () {},
                              buttonText: 'Invite to the group',
                            ),
                          ],
                        ),
                      );
                    },
                    isScrollControlled: true,
                  );
                },
                child: Image.asset(
                  Assets.imagesInvite,
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
          //   padding:
          //   const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          //   physics: const BouncingScrollPhysics(),
          //   itemCount: 4,
          //   itemBuilder: (context, index) {
          //     return MessageBubbles(
          //       receiveImage: Assets.imagesDummyProfileImage,
          //       msg: index == 0
          //           ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
          //           : index == 1
          //           ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
          //           : index == 2
          //           ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
          //           : 'Thanks, i\'ll be there.',
          //       time: '11:21 AM',
          //       senderType: index == 0 ? 'sender' : 'receiver',
          //     );
          //   },
          // ),
          sendField(context),
        ],
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
