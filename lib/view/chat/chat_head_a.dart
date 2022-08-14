import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/chat_models/chat_head_model.dart';
import 'package:vip_picnic/provider/chat_provider/chat_head_provider.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/chat/group_chat/g_chat_screen.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class ChatHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHeadProvider>(
      builder: (context, ChatHeadProvider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 75,
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 5,
              ),
              child: IconButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(
                      currentIndex: 0,
                    ),
                  ),
                  (route) => route.isCurrent,
                ),
                icon: Image.asset(
                  Assets.imagesArrowBack,
                  height: 22.04,
                ),
              ),
            ),
            title: ChatHeadProvider.showSearch
                ? SearchBar()
                : MyText(
                    text: 'Messages',
                    size: 20,
                    color: kSecondaryColor,
                  ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () => ChatHeadProvider.showSearchBar(),
                    child: Image.asset(
                      Assets.imagesSearchWithBg,
                      height: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Row(
                  children: List.generate(
                    ChatHeadProvider.tabs.length,
                    (index) {
                      return Container(
                        height: 44,
                        margin: EdgeInsets.only(
                          right: 10,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ChatHeadProvider.currentTab == index
                              ? kSecondaryColor
                              : kPrimaryColor,
                        ),
                        child: InkWell(
                          onTap: () => ChatHeadProvider.selectedTab(index),
                          child: Center(
                            child: MyText(
                              text: ChatHeadProvider.tabs[index],
                              size: 16,
                              color: ChatHeadProvider.currentTab == index
                                  ? kPrimaryColor
                                  : kSecondaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: ChatHeadProvider.currentTab == 0
                    ? SimpleChatHeads()
                    : GroupChatHeads(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: ChatHeadProvider.currentTab == 0
                ? () {}
                : () => Navigator.pushNamed(
                      context,
                      AppLinks.createNewGroup,
                    ),
            elevation: 1,
            highlightElevation: 1,
            splashColor: kPrimaryColor.withOpacity(0.1),
            backgroundColor: kGreenColor,
            child: Image.asset(
              Assets.imagesPlusIcon,
              height: 22.68,
            ),
          ),
        );
      },
    );
  }
}

class SimpleChatHeads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: fs.collection(chatRoomCollection)
          // .where("users", arrayContains: userDetailsModel.uID)
          .where("notDeletedFor", arrayContains: userDetailsModel.uID)
          .orderBy('lastMessageAt').snapshots(),
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
        log("inside stream-builder");
        if (snapshot.connectionState == ConnectionState.waiting) {
          log("inside stream-builder in waiting state");
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Some unknown error occurred');
          } else if (snapshot.hasData) {
            // log("inside hasData and ${snapshot.data!.docs}");
            if (snapshot.data!.docs.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  ChatHeadModel data = ChatHeadModel();
                  data = ChatHeadModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
                  return chatHeadTiles(
                    context,
                    profileImage:  data.user1Id != userDetailsModel.uID
                        ? data.user1model!.profileImageUrl
                        : data.user2model!.profileImageUrl,
                    name: data.user1Id != userDetailsModel.uID
                        ? data.user1model!.fullName
                        : data.user2model!.fullName,
                    msg: data.lastMessage,
                    time: data.lastMessageAt,
                  );
                },
              );
            } else {
              return SizedBox();
            }
          } else {
            log("in else of hasData done and: ${snapshot.connectionState} and"
                " snapshot.hasData: ${snapshot.hasData}");
            return SizedBox();
          }
        } else {
          log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
          return SizedBox();
        }
      },
    );
    // return ListView.builder(
    //   shrinkWrap: true,
    //   padding: EdgeInsets.symmetric(
    //     horizontal: 15,
    //   ),
    //   physics: BouncingScrollPhysics(),
    //   itemCount: 6,
    //   itemBuilder: (context, index) {
    //     return chatHeadTiles(
    //       context,
    //       profileImage: Assets.imagesProfileAvatar,
    //       name: 'Username',
    //       msg: 'Hi Good morning, how we...',
    //       time: 'Today',
    //     );
    //   },
    // );
  }

  Widget chatHeadTiles(
    BuildContext context, {
    String? profileImage,
    name,
    msg,
    time,
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                receiveImage: profileImage,
                receiveName: name,
              ),
            ),
          ),
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
                child: Image.asset(
                  '$profileImage',
                  height: height(context, 1.0),
                  width: width(context, 1.0),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: MyText(
            text: '$name',
            size: 14,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
          subtitle: MyText(
            paddingTop: 8,
            text: '$msg',
            size: 14,
            weight: FontWeight.w300,
            color: kSecondaryColor,
            maxLines: 1,
            overFlow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            children: [
              MyText(
                paddingTop: 5,
                text: '$time',
                weight: FontWeight.w300,
                color: kSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupChatHeads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      physics: BouncingScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return groupChatHeadsTiles(
          context,
          groupPhoto: Assets.imagesDummyImg,
          name: 'Event Name',
          totalMembers: '8',
          time: '11 March',
        );
      },
    );
  }

  Widget groupChatHeadsTiles(
    BuildContext context, {
    String? groupPhoto,
    name,
    totalMembers,
    time,
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GroupChat(
                groupName: name,
              ),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              '$groupPhoto',
              height: 56,
              width: 56,
              fit: BoxFit.cover,
            ),
          ),
          title: MyText(
            text: '$name',
            size: 14,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
          subtitle: MyText(
            paddingTop: 8,
            text: '$totalMembers members',
            size: 14,
            weight: FontWeight.w300,
            color: kSecondaryColor,
            maxLines: 1,
            overFlow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyText(
                paddingBottom: 5,
                text: '$time',
                weight: FontWeight.w300,
                color: kSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
