import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/provider/chat_provider/chat_provider.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/message_bubbles.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({
    Key? key,
    this.receiveImage,
    this.receiveName,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var receiveImage, receiveName;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, ChatProvider, child) {
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
            title: ChatProvider.showSearch
                ? SearchBar()
                : Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      profileImage(
                        context,
                        size: 34.0,
                        profileImage: receiveImage,
                      ),
                      MyText(
                        text: '$receiveName',
                        size: 19,
                        color: kSecondaryColor,
                      ),
                    ],
                  ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () => ChatProvider.showSearchBar(),
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
              ListView.builder(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return MessageBubbles(
                    receiveImage: receiveImage,
                    msg: index.isEven
                        ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
                        : 'Thanks, i\'ll be there.',
                    time: '11:21 AM',
                    senderType: index.isEven ? 'receiver' : 'sender',
                  );
                },
              ),
              sendField(context),
            ],
          ),
        );
      },
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
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10.0,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  Assets.imagesAttachFiles,
                                  height: 20.53,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  Assets.imagesPhoto,
                                  height: 16.52,
                                ),
                              ),
                              SizedBox(),
                            ],
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
                Image.asset(
                  Assets.imagesSend,
                  height: 45.16,
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
        child: Image.asset(
          profileImage!,
          height: height(context, 1.0),
          width: width(context, 1.0),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
