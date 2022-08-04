// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

// ignore: must_be_immutable
class MessageBubbles extends StatelessWidget {
  MessageBubbles({
    Key? key,
    this.msg,
    this.time,
    this.receiveImage,
    this.senderType,
  }) : super(key: key);

  String? msg, time, receiveImage, senderType;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
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
              backGroundColor:
              senderType == 'receiver' ? Color(0xffE6ECF0) : kGreenColor,
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
            profileImage: Assets.imagesDummyProfileImage,
            size: 53.0,
          ),
        ],
      ),
    );
  }
}