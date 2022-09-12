// ignore: must_be_immutable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/widget/image_preview.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';
import 'package:vip_picnic/view/widget/video_preview.dart';

// ignore: must_be_immutable
class LeftMessageBubble extends StatelessWidget {
  LeftMessageBubble({Key? key, this.id, this.msg, this.thumbnail = "", this.time, this.receiveImage, this.type})
      : super(key: key);

  String? id, msg, time, receiveImage, type, thumbnail;
  // bool isRead = false, isReceived = false;
  RxBool isSelected = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (chatController.isDeleting.value) {
          if (type == "video" && msg == "Video being uploaded") {
            log("in cannot interrupt else");
            showMsg(
                context: context,
                msg: "You cannot interrupt an uploading video. "
                    "You may choose to delete it after it is uploaded.");
          } else {
            if (!isSelected.value) {
              isSelected.value = true;
              chatController.deleteMsgIdList.add(id);
              chatController.deleteLeftMsgIdList.add(id);
              if ((type == "image" || type == "video") &&
                  !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                chatController.deleteImageLinksList.add(msg);
                chatController.deleteImageIdsList.add(id);
              }
              log("inside chatController.isDeleting.value being true. and now selected this onTap "
                  "and id is: ${id} and  list: ${chatController.deleteMsgIdList} "
                  "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
                  "${chatController.deleteMsgIdList.asMap().containsValue(id)} ");
            } else {
              isSelected.value = false;
              log(" in on onTap contains before deletion \n "
                  " chatController.deleteMsgIdList.asMap().containsValue(id): "
                  " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
              chatController.deleteMsgIdList.remove(id);
              chatController.deleteLeftMsgIdList.remove(id);
              if ((type == "image" || type == "video") &&
                  chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                chatController.deleteImageLinksList.remove(msg);
                chatController.deleteImageIdsList.remove(id);
              }
              if (chatController.deleteMsgIdList.length == 0 && chatController.deleteAudioIdList.length == 0) {
                chatController.isDeleting.value = false;
              }
              log("deleting the id ${id} from list and list is: ${chatController.deleteMsgIdList}");
              log("checking in onTap contains after deletion \n "
                  " chatController.deleteMsgIdList.asMap().containsValue(id): "
                  " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
            }
          }
        } else {
          log("not deleting right now so tap is not gonna work");
        }
      },
      // : null,
      onLongPress: () {
        if (type == "video" && msg == "Video being uploaded") {
          log("in cannot interrupt else");
          showMsg(
              context: context,
              msg: "You cannot interrupt an uploading video. "
                  "You may choose to delete it after it is uploaded.");
        } else {
          if (!chatController.isDeleting.value) {
            isSelected.value = true;
            chatController.isDeleting.value = true;
            chatController.deleteMsgIdList.add(id);
            chatController.deleteLeftMsgIdList.add(id);
            if ((type == "image" || type == "video") &&
                !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
              chatController.deleteImageLinksList.add(msg);
              chatController.deleteImageIdsList.add(id);
            }
            log("inside chatController.isDeleting.value being false. and now selected this onLongPress"
                "and id is: ${id} and list is: ${chatController.deleteMsgIdList} and "
                "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
                "${chatController.deleteMsgIdList.asMap().containsValue(id)}");
          } else {
            // isSelected.value = !isSelected.value;
            if (!isSelected.value) {
              isSelected.value = true;
              log("inside  on LongPress chatController.isDeleting.value being true. and now selected this onTap "
                  "and id is: ${id} and  list: ${chatController.deleteMsgIdList} and "
                  "\n chatController.deleteMsgIdList.asMap().containsValue(id):"
                  " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
              chatController.deleteMsgIdList.add(id);
              chatController.deleteLeftMsgIdList.add(id);
              if ((type == "image" || type == "video") &&
                  !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                chatController.deleteImageLinksList.add(msg);
                chatController.deleteImageIdsList.add(id);
              }
            } else {
              isSelected.value = false;
              log("checking contains before deletion \n "
                  " chatController.deleteMsgIdList.asMap().containsValue(id): "
                  " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
              chatController.deleteMsgIdList.remove(id);
              chatController.deleteLeftMsgIdList.remove(id);
              if ((type == "image" || type == "video") &&
                  chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                chatController.deleteImageLinksList.remove(msg);
                chatController.deleteImageIdsList.remove(id);
              }
              if (chatController.deleteMsgIdList.length == 0 &&
                  chatController.deleteAudioIdList.length == 0 &&
                  chatController.deleteAudioIdList.length == 0) {
                chatController.isDeleting.value = false;
              }
              log("deleting the id on LongPress from list and list is: ${chatController.deleteMsgIdList}");
              log("checking contains after deletion \n "
                  " chatController.deleteMsgIdList.asMap().containsValue(id): "
                  " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
            }
            log("deleting on LongPress right now so onLongPress is  is not gonna work");
          }
        }
      },
      // : null,
      child: Obx(() {
        return Container(
          color: isSelected.value && chatController.deleteMsgIdList.asMap().containsValue(id)
              ? Colors.blue.withOpacity(0.2)
              : Colors.transparent,
          child: type == 'image'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'imagePreviewChatMedia',
                      transitionOnUserGestures: true,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreview(
                              imageUrl: msg,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 15,
                              ),
                              height: 150,
                              width: 150,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(8),
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
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    '$msg',
                                    height: 150,
                                    width: 150,
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
                            Positioned(
                              bottom: 2,
                              left: 20,
                              child: Container(
                                width: 150,
                                height: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyText(
                                      paddingLeft: 30,
                                      paddingRight: 15,
                                      text: '$time',
                                      paddingTop: 15,
                                      align: TextAlign.end,
                                      size: 10,
                                      color: kSecondaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : type == 'video'
                  ? msg == "Video being uploaded"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'videoPreviewChatMedia',
                              transitionOnUserGestures: true,
                              child: GestureDetector(
                                onTap: () {
                                  showMsg(
                                    context: context,
                                    msg: "Can't do that. This Video is still uploading",
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  height: 50,
                                  width: 250,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(8),
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
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        // '$thumbnail',
                                        height: 150,
                                        width: 250,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.cloud_upload_outlined),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(msg ?? "Video being uploaded"),
                                          ],
                                        ),
                                        // fit: BoxFit.cover,
                                        // loadingBuilder: (context, child, loadingProgress) {
                                        //   if (loadingProgress == null) {
                                        //     return child;
                                        //   } else {
                                        //     return loading();
                                        //   }
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'uploadedVideoPreviewChatMedia',
                              transitionOnUserGestures: true,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoPreview(
                                      videoUrl: msg,
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 15,
                                      ),
                                      height: 150,
                                      width: 150,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(8),
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
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(
                                            '$thumbnail',
                                            height: 150,
                                            width: 150,
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
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kBlackColor.withOpacity(0.5),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          Assets.imagesPlay,
                                          height: 18,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2,
                                      left: 20,
                                      child: Container(
                                        width: 150,
                                        height: 10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            MyText(
                                              paddingLeft: 30,
                                              paddingRight: 15,
                                              text: '$time',
                                              paddingTop: 15,
                                              align: TextAlign.end,
                                              size: 10,
                                              color: kSecondaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                  : IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileImage(
                            context,
                            profileImage: receiveImage,
                            size: 53.0,
                          ),
                          Expanded(
                            child: ChatBubble(
                              clipper: ChatBubbleClipper1(
                                type: BubbleType.receiverBubble,
                                radius: 6.0,
                                nipHeight: 18.88,
                                nipRadius: 0.0,
                              ),
                              elevation: 0,
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(
                                bottom: 45,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              backGroundColor: Color(0xffE6ECF0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    paddingLeft: 30,
                                    paddingRight: 13,
                                    text: '$msg',
                                    color: kSecondaryColor,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MyText(
                                        paddingLeft: 30,
                                        paddingRight: 15,
                                        text: '$time',
                                        paddingTop: 15,
                                        align: TextAlign.end,
                                        size: 10,
                                        color: kSecondaryColor,
                                      ),
                                      // (!isRead && !isReceived)
                                      //     ? Padding(
                                      //   padding: const EdgeInsets.only(left: 2.0, right: 15, bottom: 3),
                                      //   child: Image.asset(
                                      //     "assets/images/tick.png",
                                      //     width: 14,
                                      //     height: 10,
                                      //     color: Colors.grey,
                                      //   ),
                                      // )
                                      //     : Padding(
                                      //   padding: const EdgeInsets.only(left: 2.0, right: 15, bottom: 3),
                                      //   child: Image.asset(
                                      //     "assets/images/read.png",
                                      //     width: 14,
                                      //     height: 14,
                                      //     color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class RightMessageBubble extends StatelessWidget {
  RightMessageBubble(
      {Key? key,
      this.id,
      this.msg,
      this.thumbnail = "",
      this.sendByMe = true,
      this.time,
      this.receiveImage,
      this.type,
      this.isRead = false,
      this.isReceived = false})
      : super(key: key);

  String? id, msg, time, receiveImage, type, thumbnail;
  bool sendByMe, isRead = false, isReceived = false;
  RxBool isSelected = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: sendByMe
          ? () {
              if (chatController.isDeleting.value) {
                if (type == "video" && msg == "Video being uploaded") {
                  log("in cannot interrupt else");
                  showMsg(
                    context: context,
                    msg: "You cannot interrupt an uploading video. "
                        "You may choose to delete it for everyone, after it is uploaded.",
                  );
                } else {
                  if (!isSelected.value) {
                    isSelected.value = true;
                    chatController.deleteMsgIdList.add(id);
                    if ((type == "image" || type == "video") &&
                        !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                      // if (type == "video" && msg == "Video being uploaded") {
                      //   showMsg(
                      //       context: context,
                      //       msg: "You cannot interrupt an uploading video. "
                      //           "You may choose to delete it for everyone, after it is uploaded.");
                      // } else {
                      chatController.deleteImageLinksList.add(msg);
                      chatController.deleteImageIdsList.add(id);
                      // }
                    }
                    log("inside chatController.isDeleting.value being true. and now selected this onTap "
                        "and id is: $id and  list: ${chatController.deleteMsgIdList} "
                        "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
                        "${chatController.deleteMsgIdList.asMap().containsValue(id)} ");
                  } else {
                    isSelected.value = false;
                    log(" in on onTap contains before deletion \n "
                        " chatController.deleteMsgIdList.asMap().containsValue(id): "
                        " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
                    chatController.deleteMsgIdList.remove(id);
                    if ((type == "image" || type == "video") &&
                        chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                      chatController.deleteImageLinksList.remove(msg);
                      chatController.deleteImageIdsList.remove(id);
                    }
                    if (chatController.deleteMsgIdList.length == 0 && chatController.deleteAudioIdList.length == 0) {
                      chatController.isDeleting.value = false;
                    }
                    log("deleting the id $id from list and list is: ${chatController.deleteMsgIdList}");
                    log("checking in onTap contains after deletion \n "
                        " chatController.deleteMsgIdList.asMap().containsValue(id): "
                        " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
                  }
                }
              } else {
                log("not deleting right now so tap is not gonna work");
              }
            }
          : null,
      onLongPress: sendByMe
          ? () {
              if (type == "video" && msg == "Video being uploaded") {
                log("in cannot interrupt else");
                showMsg(
                    context: context,
                    msg: "You cannot interrupt an uploading video. "
                        "You may choose to delete it for everyone, after it is uploaded.");
              } else {
                if (!chatController.isDeleting.value) {
                  isSelected.value = true;
                  chatController.isDeleting.value = true;
                  if (!chatController.deleteMsgIdList.asMap().containsValue(id)) chatController.deleteMsgIdList.add(id);
                  if ((type == "image" || type == "video") &&
                      !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                    chatController.deleteImageLinksList.add(msg);
                    chatController.deleteImageIdsList.add(id);
                  }
                  log("inside chatController.isDeleting.value being false. and now selected this onLongPress"
                      "and id is: $id and list is: ${chatController.deleteMsgIdList} and "
                      "\n chatController.deleteMsgIdList.asMap().containsValue(id): "
                      "${chatController.deleteMsgIdList.asMap().containsValue(id)}");
                } else {
                  // isSelected.value = !isSelected.value;
                  if (!isSelected.value) {
                    isSelected.value = true;
                    log("inside  on LongPress chatController.isDeleting.value being true. and now selected this onTap "
                        "and id is: $id and  list: ${chatController.deleteMsgIdList} and "
                        "\n chatController.deleteMsgIdList.asMap().containsValue(id):"
                        " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
                    if (!chatController.deleteMsgIdList.asMap().containsValue(id))
                      chatController.deleteMsgIdList.add(id);
                    if ((type == "image" || type == "video") &&
                        !chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                      chatController.deleteImageLinksList.add(msg);
                      chatController.deleteImageIdsList.add(id);
                    }
                  } else {
                    isSelected.value = false;
                    log("checking contains before deletion \n "
                        " chatController.deleteMsgIdList.asMap().containsValue(id): "
                        " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
                    chatController.deleteMsgIdList.remove(id);
                    if ((type == "image" || type == "video") &&
                        chatController.deleteImageLinksList.asMap().containsValue(msg)) {
                      chatController.deleteImageLinksList.remove(msg);
                      chatController.deleteImageIdsList.remove(id);
                    }
                    if (chatController.deleteMsgIdList.length == 0 &&
                        chatController.deleteAudioIdList.length == 0 &&
                        chatController.deleteAudioIdList.length == 0) {
                      chatController.isDeleting.value = false;
                    }
                    log("deleting the id on LongPress from list and list is: ${chatController.deleteMsgIdList}");
                    log("checking contains after deletion \n "
                        " chatController.deleteMsgIdList.asMap().containsValue(id): "
                        " ${chatController.deleteMsgIdList.asMap().containsValue(id)}");
                  }
                  log("deleting on LongPress right now so onLongPress is  is not gonna work");
                }
              }
            }
          : null,
      child: Obx(() {
        return Container(
          color: isSelected.value && chatController.deleteMsgIdList.asMap().containsValue(id)
              ? Colors.blue.withOpacity(0.2)
              : Colors.transparent,
          child: type == 'image'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Hero(
                      tag: 'rightImagePreviewChatMedia',
                      transitionOnUserGestures: true,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreview(
                              imageUrl: msg,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 5,
                              ),
                              height: 150,
                              width: 150,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(8),
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
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    '$msg',
                                    height: 150,
                                    width: 150,
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
                            Positioned(
                              bottom: 12,
                              right: 3,
                              child: Container(
                                width: 150,
                                height: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyText(
                                      paddingLeft: 10,
                                      paddingRight: 5,
                                      text: '$time',
                                      paddingTop: 15,
                                      align: TextAlign.end,
                                      size: 10,
                                      color: kPrimaryColor,
                                    ),
                                    (!isRead && !isReceived)
                                        ? Padding(
                                            padding: const EdgeInsets.only(left: 4.0, right: 10),
                                            child: Image.asset(
                                              "assets/images/tick.png",
                                              width: 14,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(left: 4.0, right: 10),
                                            child: Image.asset(
                                              "assets/images/read.png",
                                              width: 14,
                                              height: 14,
                                              color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : type == 'video'
                  ? msg == "Video being uploaded"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Hero(
                              tag: 'rightVideoPreviewChatMedia',
                              transitionOnUserGestures: true,
                              child: GestureDetector(
                                onTap: () {
                                  showMsg(
                                    context: context,
                                    msg: "Can't do that. This Video is still uploading",
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  height: 50,
                                  width: 250,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(8),
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
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        // '$thumbnail',
                                        height: 150,
                                        width: 250,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.cloud_upload_outlined),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(msg ?? "Video being uploaded"),
                                          ],
                                        ),
                                        // fit: BoxFit.cover,
                                        // loadingBuilder: (context, child, loadingProgress) {
                                        //   if (loadingProgress == null) {
                                        //     return child;
                                        //   } else {
                                        //     return loading();
                                        //   }
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Hero(
                              tag: 'rightUploadVideoPreviewChatMedia',
                              transitionOnUserGestures: true,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoPreview(
                                      videoUrl: msg,
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 5,
                                      ),
                                      height: 150,
                                      width: 150,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(8),
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
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(
                                            '$thumbnail',
                                            height: 150,
                                            width: 150,
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
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kBlackColor.withOpacity(0.5),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          Assets.imagesPlay,
                                          height: 18,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      right: 3,
                                      child: Container(
                                        width: 150,
                                        height: 10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            MyText(
                                              paddingLeft: 10,
                                              paddingRight: 5,
                                              text: '$time',
                                              paddingTop: 15,
                                              align: TextAlign.end,
                                              size: 10,
                                              color: kPrimaryColor,
                                            ),
                                            (!isRead && !isReceived)
                                                ? Padding(
                                              padding: const EdgeInsets.only(left: 4.0, right: 10),
                                              child: Image.asset(
                                                "assets/images/tick.png",
                                                width: 14,
                                                height: 10,
                                                color: Colors.grey,
                                              ),
                                            )
                                                : Padding(
                                              padding: const EdgeInsets.only(left: 4.0, right: 10),
                                              child: Image.asset(
                                                "assets/images/read.png",
                                                width: 14,
                                                height: 14,
                                                color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                  : IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(),
                          Expanded(
                            child: ChatBubble(
                              clipper: ChatBubbleClipper1(
                                type: BubbleType.sendBubble,
                                radius: 6.0,
                                nipHeight: 18.88,
                                nipRadius: 0.0,
                              ),
                              elevation: 0,
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(
                                bottom: 45,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              backGroundColor: kGreenColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    paddingLeft: 13,
                                    paddingRight: 30,
                                    text: '$msg',
                                    color: kPrimaryColor,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MyText(
                                        paddingLeft: 10,
                                        paddingRight: 5,
                                        text: '$time',
                                        paddingTop: 15,
                                        align: TextAlign.end,
                                        size: 10,
                                        color: kPrimaryColor,
                                      ),
                                      (!isRead && !isReceived)
                                          ? Padding(
                                              padding: const EdgeInsets.only(left: 2.0, right: 25, bottom: 3),
                                              child: Image.asset(
                                                "assets/images/tick.png",
                                                width: 14,
                                                height: 10,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(left: 2.0, right: 25, bottom: 3),
                                              child: Image.asset(
                                                "assets/images/read.png",
                                                width: 14,
                                                height: 14,
                                                color: (isReceived && !isRead) ? Colors.grey : Colors.blue,
                                              ),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          profileImage(
                            context,
                            profileImage: userDetailsModel.profileImageUrl,
                            size: 53.0,
                          ),
                        ],
                      ),
                    ),
        );
      }),
    );
  }
}
