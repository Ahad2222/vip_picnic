// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/image_preview.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

// ignore: must_be_immutable
class MessageBubbles extends StatelessWidget {
  MessageBubbles({
    Key? key,
    this.msg,
    this.time,
    this.receiveImage,
    this.senderType,
    this.mediaType,
  }) : super(key: key);

  String? msg, time, receiveImage, senderType, mediaType;

  @override
  Widget build(BuildContext context) {
    return mediaType == 'image'
        ? Row(
            mainAxisAlignment: senderType == 'sender'
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
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
        : IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                senderType == 'receiver'
                    ? profileImage(
                        context,
                        profileImage: receiveImage,
                        size: 53.0,
                      )
                    : SizedBox(),
                Expanded(
                  child: ChatBubble(
                    clipper: ChatBubbleClipper1(
                      type: senderType == 'receiver'
                          ? BubbleType.receiverBubble
                          : BubbleType.sendBubble,
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
                    backGroundColor: senderType == 'receiver'
                        ? Color(0xffE6ECF0)
                        : kGreenColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          paddingLeft: senderType == 'receiver' ? 30 : 13,
                          paddingRight: senderType == 'receiver' ? 13 : 30,
                          text: '$msg',
                          color: senderType == 'receiver'
                              ? kSecondaryColor
                              : kPrimaryColor,
                        ),
                        MyText(
                          paddingLeft: senderType == 'receiver' ? 30 : 13,
                          paddingRight: senderType == 'receiver' ? 13 : 30,
                          text: '$time',
                          paddingTop: 15,
                          align: TextAlign.end,
                          size: 10,
                          color: senderType == 'receiver'
                              ? kSecondaryColor
                              : kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                senderType == 'receiver'
                    ? SizedBox()
                    : profileImage(
                        context,
                        profileImage: userDetailsModel.profileImageUrl,
                        size: 53.0,
                      ),
              ],
            ),
          );
  }
}
