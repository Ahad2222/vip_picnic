import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/message_bubbles.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

// ignore: must_be_immutable
class GroupChat extends StatelessWidget {
  GroupChat({
    Key? key,
    this.docs,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  Map<String, dynamic>? docs;

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
          text: '${"groupName"}',
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
          ListView.builder(
            shrinkWrap: true,
            padding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return MessageBubbles(
                receiveImage: Assets.imagesDummyProfileImage,
                msg: index == 0
                    ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
                    : index == 1
                    ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
                    : index == 2
                    ? 'Lorem Ipsum is simply dummy text of the printing and industry. '
                    : 'Thanks, i\'ll be there.',
                time: '11:21 AM',
                senderType: index == 0 ? 'sender' : 'receiver',
              );
            },
          ),
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
