import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/chat/group_chat/g_chat_screen.dart';
import 'package:vip_picnic/view/home/post_details.dart';
import 'package:vip_picnic/view/widget/loading.dart';

class DynamicLinkHandler {
  static Future<String> buildDynamicLinkForPost(
      {required String postTitle, required String postImageUrl, required String postId, bool short = false}) async {
    String url = "https://vippicnicapp.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/posts?id=$postId'),
      androidParameters: AndroidParameters(
        packageName: "com.example.vip_picnic",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.example.vipPicnic",
        minimumVersion: '0',
      ),
      socialMetaTagParameters:
          SocialMetaTagParameters(description: '', imageUrl: Uri.parse("$postImageUrl"), title: postTitle),
    );

    String finalUrl = "";
    if (short) {
      final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      finalUrl = dynamicUrl.shortUrl.toString();
      log("generated short-url is: $finalUrl");
    } else {
      final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
      finalUrl = dynamicLink.toString();
      log("generated long-url is: $finalUrl");
    }
    log("generated url before return is: $finalUrl");
    return finalUrl;
    // String? desc = '${dynamicUrl.shortUrl.toString()}';
    // await Share.share(desc, subject: title,);
  }

  static Future<String> buildDynamicLinkGroupInvite(
      {required String groupName,
      required String groupInviteMessage,
      required String groupImage,
      required String groupId,
      bool short = false}) async {
    String url = "https://vippicnicapp.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/groupInvite?id=$groupId'),
      androidParameters: AndroidParameters(
        packageName: "com.example.vip_picnic",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.example.vipPicnic",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: groupInviteMessage, imageUrl: Uri.parse("$groupImage"), title: groupName),
    );

    String finalUrl = "";
    if (short) {
      final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      finalUrl = dynamicUrl.shortUrl.toString();
      log("generated short-url for group invite is: $finalUrl");
    } else {
      final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
      finalUrl = dynamicLink.toString();
      log("generated long-url  for group invite is: $finalUrl");
    }
    log("generated url before return  for group invite is: $finalUrl");
    return finalUrl;
    // String? desc = '${dynamicUrl.shortUrl.toString()}';
    // await Share.share(desc, subject: title,);
  }

  static Future<void> initDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      final Uri deepLink = dynamicLinkData.link;
      bool isPost = deepLink.pathSegments.contains("posts");
      bool isGroupInvite = deepLink.pathSegments.contains("groupInvite");
      log("pathSegments: ${deepLink.pathSegments}");
      log("isGroupInvite: ${isGroupInvite}");

      if (isPost) {
        String? id = deepLink.queryParameters['id'];
        log("id in isPost: $id");
        try {
          if (id != "") {
            await ffstore.collection(postsCollection).doc(id).get().then((value) {
              Get.to(
                () => PostDetails(
                  postDocModel: AddPostModel.fromJson(value.data() ?? {}),
                ),
              );
            });
          } else {
            log("id was empty");
          }
        } catch (e) {
          log("Error in fetching the post model and going to post doc: $e");
        }
      } else if (isGroupInvite) {
        String? groupId = deepLink.queryParameters['id'];
        log("groupId in isGroupInvite: $groupId");

        try {
          if (groupId != "") {
            loading();
            await ffstore.collection(groupChatCollection).doc(groupId).update({
              "notDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid]),
              "users": FieldValue.arrayUnion([auth.currentUser?.uid]),
            });
            await groupChatController.getAGroupChatRoomInfo(groupId!).then((value) {
              Get.back();
              Get.to(() => GroupChat(docs: value.data()));
            });
          } else {
            log("groupId was empty");
          }
        } catch (e) {
          log("Error in fetching the Group chat info and going to Group chat page is doc: $e");
        }
      }
      // Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      log("Error in listening to onLink is: ${error.toString()}");
      // Handle errors
    });

    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      bool isPost = deepLink.pathSegments.contains("posts");
      bool isGroupInvite = deepLink.pathSegments.contains("groupInvite");
      log("pathSegments: ${deepLink.pathSegments}");
      log("isGroupInvite: ${isGroupInvite}");

      if (isPost) {
        String? id = deepLink.queryParameters['id'];
        log("id in isPost: $id");

        try {
          if (id != "") {
            await ffstore.collection(postsCollection).doc(id).get().then((value) {
              Get.to(
                () => PostDetails(
                  postDocModel: AddPostModel.fromJson(value.data() ?? {}),
                ),
              );
            });
          } else {
            log("id was empty");
          }
        } catch (e) {
          log("Error in fetching the post model and going to post doc: $e");
        }
      }else if (isGroupInvite) {
        String? groupId = deepLink.queryParameters['id'];
        log("groupId in isGroupInvite: $groupId");

        try {
          if (groupId != "") {
            loading();
            await ffstore.collection(groupChatCollection).doc(groupId).update({
              "notDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid]),
              "users": FieldValue.arrayUnion([auth.currentUser?.uid]),
            });
            await groupChatController.getAGroupChatRoomInfo(groupId!).then((value) {
              Get.back();
              Get.to(() => GroupChat(docs: value.data()));
            });
          } else {
            log("groupId was empty");
          }
        } catch (e) {
          log("Error in fetching the Group chat info and going to Group chat page is doc: $e");
        }
      }
    }
  }
}
