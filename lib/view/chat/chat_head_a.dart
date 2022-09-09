import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/chat_models/chat_head_model.dart';
import 'package:vip_picnic/model/group_chat_models/group_chat_head_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/chat/create_new_chat.dart';
import 'package:vip_picnic/view/chat/group_chat/g_chat_screen.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/widget/custom_popup.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class ChatHead extends StatefulWidget {
  @override
  State<ChatHead> createState() => _ChatHeadState();
}

class _ChatHeadState extends State<ChatHead> {
  bool showSearch = false;
  int currentTab = 0;

  void selectedTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  void showSearchBar() {
    setState(() {
      showSearch = !showSearch;
    });
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
        title: MyText(
          text: 'messages'.tr,
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
                onTap: () {},
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
                2,
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
                      color:
                          currentTab == index ? kSecondaryColor : kPrimaryColor,
                    ),
                    child: InkWell(
                      onTap: () => selectedTab(index),
                      child: Center(
                        child: MyText(
                          text: index == 0 ? 'chat'.tr : 'group'.tr,
                          size: 16,
                          color: currentTab == index
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
            child: currentTab == 0 ? SimpleChatHeads() : GroupChatHeads(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "NewChatButton",
        onPressed: currentTab == 0
            ? () => Get.to(
                  () => CreateNewChat(),
                )
            : () => Get.toNamed(
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
  }
}

class SimpleChatHeads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ffstore
          .collection(chatRoomCollection)
          // .where("users", arrayContains: userDetailsModel.uID)
          .where("notDeletedFor", arrayContains: userDetailsModel.uID)
          .orderBy('lastMessageAt', descending: true)
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        //log("inside stream-builder");
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
                  data = ChatHeadModel.fromDocumentSnapshot(
                      snapshot.data!.docs[index]);
                  return chatHeadTiles(
                    context,
                    profileImage: data.user1Id != userDetailsModel.uID
                        ? data.user1Model!.profileImageUrl
                        : data.user2Model!.profileImageUrl,
                    name: data.user1Id != userDetailsModel.uID
                        ? data.user1Model!.fullName
                        : data.user2Model!.fullName,
                    msg: data.lastMessage,
                    time: data.lastMessageAt,
                    docs: snapshot.data!.docs[index].data()
                        as Map<String, dynamic>,
                    chatRoomId: data.chatRoomId,
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
  }

  Widget chatHeadTiles(BuildContext context,
      {String? profileImage,
      name,
      msg,
      time,
      chatRoomId,
      Map<String, dynamic>? docs}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return CustomPopup(
                            heading: 'Are you Sure?',
                            description:
                                'This can\'t be undone. Are you sure you want to delete this chat?',
                            onCancel: () => Get.back(),
                            onConfirm: () async {
                              try {
                                Get.back();
                                await chatController.deleteAChatRoom(
                                    chatRoomId: chatRoomId);
                              } catch (e) {
                                print(e);
                                showMsg(
                                    context: context,
                                    msg:
                                        "Something went wrong during chat deletion. Please try again.");
                                log("error in chat deletion $e");
                              }
                            },
                          );
                        },
                      );
                      // Get.defaultDialog(
                      //   title: "Are you sure?",
                      //   content: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 15, vertical: 0),
                      //     child: Text(
                      //         "This can't be undone. Are you sure you want to delete this chat?"),
                      //   ),
                      //   textConfirm: "Yes",
                      //   confirmTextColor: Colors.red,
                      //   textCancel: "No",
                      //   cancelTextColor: Colors.black,
                      //   onConfirm: () async {
                      //     try {
                      //       await chatController.deleteAChatRoom(
                      //           chatRoomId: chatRoomId);
                      //     } catch (e) {
                      //       print(e);
                      //       showMsg(
                      //           context: context,
                      //           msg:
                      //               "Something went wrong during chat deletion. Please try again.");
                      //       log("error in chat deletion $e");
                      //     }
                      //   },
                      // );
                    },
                    child: Container(
                      height: 51,
                      width: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.red.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Image.asset(
                          Assets.imagesDeleteMsg,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        child: Container(
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
                    docs: docs,
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
                    child: Image.network(
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
                    text:
                        "${DateTime.fromMillisecondsSinceEpoch(time).toString().split(" ")[1].split(":")[0]}"
                        ":"
                        "${DateTime.fromMillisecondsSinceEpoch(time).toString().split(" ")[1].split(":")[1]}",
                    weight: FontWeight.w300,
                    color: kSecondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GroupChatHeads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ffstore
          .collection(groupChatCollection)
          // .where("users", arrayContains: userDetailsModel.uID)
          .where("notDeletedFor", arrayContains: userDetailsModel.uID)
          .orderBy('lastMessageAt', descending: true)
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        //log("inside stream-builder");
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
                  GroupChatHeadModel data = GroupChatHeadModel();
                  data = GroupChatHeadModel.fromDocumentSnapshot(
                      snapshot.data!.docs[index]);
                  return groupChatHeadsTiles(
                    context,
                    groupId: data.groupId,
                    groupPhoto: data.groupImage,
                    name: data.groupName,
                    totalMembers: data.users?.length,
                    time: data.lastMessageAt,
                  );
                  // return chatHeadTiles(
                  //   context,
                  //   profileImage: data.user1Id != userDetailsModel.uID
                  //       ? data.user1Model!.profileImageUrl
                  //       : data.user2Model!.profileImageUrl,
                  //   name: data.user1Id != userDetailsModel.uID
                  //       ? data.user1Model!.fullName
                  //       : data.user2Model!.fullName,
                  //   msg: data.lastMessage,
                  //   time: data.lastMessageAt,
                  //   docs: snapshot.data!.docs[index].data()
                  //   as Map<String, dynamic>,
                  // );
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
  }

  Widget groupChatHeadsTiles(
    BuildContext context, {
    String? groupId,
    String? groupPhoto,
    name,
    totalMembers,
    time,
  }) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return CustomPopup(
                          heading: 'Are you Sure?',
                          description:
                              'This can\'t be undone. Are you sure you want to delete this chat?',
                          onCancel: () => Get.back(),
                          onConfirm: () async {
                            try {
                              Get.back();
                              await chatController.deleteAGroupChatRoom(
                                  groupId: groupId);
                            } catch (e) {
                              print(e);
                              showMsg(
                                  context: context,
                                  msg:
                                  "Something went wrong during chat deletion. Please try again.");
                              log("error in chat deletion $e");
                            }
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 51,
                    width: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Image.asset(
                        Assets.imagesDeleteMsg,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Container(
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
            onTap: () async {
              log("clicked on group chat head");
              try {
                await groupChatController
                    .getAGroupChatRoomInfo(groupId!)
                    .then((value) => Get.to(() => GroupChat(
                          docs: value.data(),
                        )));
              } catch (e) {
                log("error in getting the group chat info is: $e");
                showMsg(
                    context: context,
                    msg: "Please make sure you are connected to internet");
              }
              //     Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => GroupChat(),
              //   ),
              // ),
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
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
                  text:
                      "${DateTime.fromMillisecondsSinceEpoch(time).toString().split(" ")[1].split(":")[0]}"
                      ":"
                      "${DateTime.fromMillisecondsSinceEpoch(time).toString().split(" ")[1].split(":")[1]}",
                  weight: FontWeight.w300,
                  color: kSecondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
