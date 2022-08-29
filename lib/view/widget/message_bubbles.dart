// ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
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
  LeftMessageBubble({
    Key? key,
    this.msg,
    this.thumbnail = "",
    this.time,
    this.receiveImage,
    this.mediaType,
  }) : super(key: key);

  String? msg, time, receiveImage, mediaType, thumbnail;

  @override
  Widget build(BuildContext context) {
    return mediaType == 'image'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: 'chatMedia',
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
                  child: Container(
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
                ),
              ),
            ],
          )
        : mediaType == 'video'
            ? msg == "Video being uploaded"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'chatMedia',
                        transitionOnUserGestures: true,
                        child: GestureDetector(
                          onTap: () {
                            showMsg(
                              context: context,
                              msg:
                                  "Can't do that. This Video is still uploading",
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
                        tag: 'chatMedia',
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
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
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
                            MyText(
                              paddingLeft: 30,
                              paddingRight: 13,
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
              );
  }
}

// ignore: must_be_immutable
class RightMessageBubble extends StatelessWidget {
  RightMessageBubble({
    Key? key,
    this.msg,
    this.thumbnail = "",
    this.time,
    this.receiveImage,
    this.mediaType,
  }) : super(key: key);

  String? msg, time, receiveImage, mediaType, thumbnail;

  @override
  Widget build(BuildContext context) {
    return mediaType == 'image'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Hero(
                tag: 'chatMedia',
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
                  child: Container(
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
                ),
              ),
            ],
          )
        : mediaType == 'video'
            ? msg == "Video being uploaded"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Hero(
                        tag: 'chatMedia',
                        transitionOnUserGestures: true,
                        child: GestureDetector(
                          onTap: () {
                            showMsg(
                              context: context,
                              msg:
                                  "Can't do that. This Video is still uploading",
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
                        tag: 'chatMedia',
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
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
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
                            MyText(
                              paddingLeft: 13,
                              paddingRight: 30,
                              text: '$time',
                              paddingTop: 15,
                              align: TextAlign.end,
                              size: 10,
                              color: kPrimaryColor,
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
              );
  }
}
