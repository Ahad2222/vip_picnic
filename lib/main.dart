import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/config/theme/light_theme.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/controller/auth_controller/email_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/facebook_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/forgot_password_controller.dart';
import 'package:vip_picnic/controller/auth_controller/google_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/sign_up_controller.dart';
import 'package:vip_picnic/controller/chat_controller/chat_controller.dart';
import 'package:vip_picnic/controller/group_chat_controller/group_chat_controller.dart';
import 'package:vip_picnic/controller/home_controller/home_controller.dart';
import 'package:vip_picnic/controller/splash_screen_controller/splash_screen_controller.dart';
import 'package:vip_picnic/firebase_options.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/utils/localization.dart';
import 'package:vip_picnic/view/chat/group_chat/g_chat_screen.dart';
import 'package:vip_picnic/view/chat/simple_chat_screen.dart';
import 'package:vip_picnic/view/choose_language/choose_language.dart';
import 'package:vip_picnic/view/home/add_new_post.dart';
import 'package:vip_picnic/view/home/post_details.dart';
import 'package:vip_picnic/view/profile/other_user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:vip_picnic/view/widget/loading.dart';

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (Platform.isAndroid) PathProviderAndroid.registerWith();
  // if (Platform.isIOS) PathProviderIOS.registerWith();
  //
  // void selectNotification(String? payload) async {
  //   if (payload != null) {
  //     if (payload.isNotEmpty) {
  //       // var payloadData2 = PayloadData.fromJson(jsonDecode(payload));
  //       var payloadDecoded = jsonDecode(payload);
  //       var screenName = payloadDecoded["screenName"];
  //       if (screenName != null) {
  //         if (screenName.isNotEmpty) {
  //           print("Screen name is: $screenName");
  //           if (screenName == 'chatScreen') {
  //             print("Screen is Chat");
  //             String type = 'Nothing';
  //             String chatRoomId = 'Nothing';
  //             if (payloadDecoded['type'] != null) {
  //               type = payloadDecoded['type'];
  //               if (type == 'profileMatched') {
  //                 String likerId = payloadDecoded['likerId'];
  //                 String likedId = payloadDecoded['likedId'];
  //                 chatRoomId = chatController.getChatRoomId(likerId, likedId);
  //               } else {
  //                 print("Type is missed");
  //               }
  //             } else {
  //               chatRoomId = payloadDecoded["chatRoomId"];
  //             }
  //
  //             print("ChatRoom Id is: ${chatRoomId}");
  //             //We have chatRoomId here and we need to navigate to the ChatRoomScreen having same Id
  //             await fs.collection("ChatRoom").doc(chatRoomId).get().then((value) {
  //               Get.to(() => ChatScreen(docs: value.data(), isArchived: false));
  //             });
  //           } else if (screenName == 'profileScreen') {
  //             print("Screen is Profile");
  //             // print(payloadDecoded.toString());
  //             //+could be used for follower notification
  //             // fs.collection("MovingToProfile").doc().set({"Screen": screenName});
  //             print("Screen is Profile");
  //             // String followerId = payloadDecoded['id'];
  //             // print("follower id is " + followerId);
  //             //+ UserDetailsModel userLiker = await authController.getAUser(likerId);
  //             //+ Get.to(() => Home(showAbleUserData: userLiker));
  //           }
  //         } else {
  //           print("Screen name is null");
  //         }
  //       }
  //     } else {
  //       debugPrint("PayLoad is null");
  //     }
  //   }
  // }
  //
  // void onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
  //   // display a diaprint with the notification details, tap ok to go to another page
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (BuildContext context) => CupertinoAlertDialog(
  //   //     title: Text(title!),
  //   //     content: Column(
  //   //       children: [Text(body!), Text(payload.toString())],
  //   //     ),
  //   //     actions: [
  //   //       CupertinoDialogAction(
  //   //         isDefaultAction: true,
  //   //         child: Text('See ChatRoom'),
  //   //         onPressed: () async {
  //   //           debugPrint("Please check the payload data first");
  //   //         },
  //   //       )
  //   //     ],
  //   //   ),
  //   // );
  // }
  //
  //
  //
  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final String filePath = '${directory.path}/$fileName';
  //   final http.Response response = await http.get(Uri.parse(url));
  //   final File file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }
  //
  // print('Got a message whilst in the foreground!');
  // print('Message data: ${message.data}');
  //
  // print("onMessage function was used..");
  // bool imagePresent = false;
  // bool generalImagePresent = false;
  //
  // String imgUrl = 'https://via.placeholder.com/400x800';
  // String generalImageUrl = 'https://via.placeholder.com/400x800';
  // String screenName = 'No screen';
  // String type = 'type';
  // bool screenEnabled = false;
  // screenEnabled = message.data.containsKey('screenName');
  //
  // if (message != null) {
  //   if (message.data.isNotEmpty) {
  //     print("Is onMessage datapayload received");
  //     print("Message Data is" + message.data.toString());
  //     if (message.data.containsKey("type")) {
  //       type = message.data["type"];
  //       print("type: $type");
  //     }
  //     if (screenEnabled) {
  //       //Move to the screen which is needed to
  //       print("Screen is Enabled");
  //       screenName = message.data['screenName'];
  //       print("Screen name is: $screenName");
  //       //+ I/flutter (31547): Screen is Enabled
  //       log("message.notification: ${message.notification}");
  //       log("message.notification.data: ${message.notification != null ? message.notification?.title : "notification was null"}");
  //       log("message.notification.data: ${message.notification != null ? message.notification?.body : "notification was null"}");
  //       log("message.notification.data: ${message.notification != null ? message.notification?.android : "notification was null"}");
  //       if (message.notification != null && message.notification != {}) {
  //         String? longData = message.notification != null ? message.notification?.body : "";
  //         if (screenName == 'chatScreen' || screenName == 'profileScreen') {
  //           //Handling forground notification on chat notification
  //           imagePresent = message.data.containsKey('imageUrl');
  //           generalImagePresent = message.data.containsKey('generalImageUrl');
  //           if (imagePresent) {
  //             imgUrl = message.data['imageUrl'];
  //           }
  //           if (generalImagePresent) {
  //             generalImageUrl = message.data['generalImageUrl'];
  //           }
  //           //PictureConfig
  //           final largeIconPath = await _downloadAndSaveFile('${imgUrl}', 'largeIcon');
  //           final String bigPicturePath = await _downloadAndSaveFile('${generalImageUrl}', 'bigPicture');
  //
  //           final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
  //               FilePathAndroidBitmap(bigPicturePath),
  //               hideExpandedLargeIcon: true,
  //               contentTitle: '<b>${message.notification?.title}</b>',
  //               htmlFormatContentTitle: true,
  //               summaryText: '${message.notification?.body}',
  //               htmlFormatSummaryText: true);
  //
  //           final bigTextStyleInformation = BigTextStyleInformation(longData!);
  //
  //           print("Things take time");
  //
  //           final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //           AndroidNotificationDetails('vipPicnic', 'vip',
  //               channelDescription: 'Vibrate and show notification',
  //               importance: Importance.max,
  //               priority: Priority.high,
  //               icon: '@mipmap/launcher_icon',
  //               // largeIcon: FilePathAndroidBitmap(largeIconPath),
  //               styleInformation: bigTextStyleInformation,
  //               // vibrationPattern: vibrationPattern,
  //               enableLights: true,
  //               color: const Color.fromARGB(255, 255, 0, 0),
  //               ledColor: const Color.fromARGB(255, 255, 0, 0),
  //               ledOnMs: 1000,
  //               ledOffMs: 500);
  //
  //           const AndroidInitializationSettings initializationSettingsAndroid =
  //           AndroidInitializationSettings('launcher_icon');
  //           final IOSInitializationSettings initializationSettingsIOS =
  //           IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  //
  //           final InitializationSettings initializationSettings =
  //           InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //           await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //               onSelectNotification: selectNotification);
  //
  //           //We need to configure for the ios as well
  //           final NotificationDetails platformChannelSpecifics =
  //           NotificationDetails(android: androidPlatformChannelSpecifics);
  //           print("message.notification?.title  + ${message.notification?.title}");
  //           print("message.notification?.body ${message.notification?.body}");
  //           print("messageId: ${message.messageId}");
  //
  //           flutterLocalNotificationsPlugin.show(
  //             DateTime.now().millisecond,
  //             message.notification?.title,
  //             message.notification?.body,
  //             platformChannelSpecifics,
  //             payload: json.encode(message.data),
  //           );
  //         } else {
  //           print("Screen is in Else");
  //         }
  //       } else {
  //         print("Screen is in Else");
  //       }
  //     }
  //   } else {
  //     debugPrint("Notification Pay load data is Empty");
  //   }
  // } else {
  //   print("message was null in OnMessage");
  // }
  //
  // if (message.notification != null) {
  //   print('Message also contained a notification: ${message.notification}');
  // }
  //
  print("Handling a background message: ${message.messageId}");
}

FlutterUploader _uploader = FlutterUploader();

Future<void> backgroundHandler() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
  if (Platform.isIOS) SharedPreferencesIOS.registerWith();

  // Notice these instances belong to a forked isolate.
  var uploader = FlutterUploader();


  // Only show notifications for unprocessed uploads.
  SharedPreferences.getInstance().then((preferences) {
    var processed = preferences.getStringList('processed') ?? <String>[];

    log("after getting the processed list: ${processed}");

    if (Platform.isAndroid) {
      uploader.progress.listen((progress) {
        FirebaseFirestore.instance.collection("uploadProgress")
        .add({
      "progress.status": progress.status.description,
      "progress.progress": progress.progress,
      "progress.taskId": progress.taskId,
      "dateTime": DateTime.now(),
    });
        if (processed.contains(progress.taskId)) {
          return;
        }
        // AndroidNotificationDetails('vipPicnic', 'vip',
        //     channelDescription: 'Vibrate and show notification',
        //     importance: Importance.max,
        //     priority: Priority.high,
        //     icon: '@mipmap/launcher_icon',
        //     largeIcon: FilePathAndroidBitmap(largeIconPath),
        //     styleInformation: bigTextStyleInformation,
        //     // vibrationPattern: vibrationPattern,
        //     enableLights: true,
        //     color: const Color.fromARGB(255, 255, 0, 0),
        //     ledColor: const Color.fromARGB(255, 255, 0, 0),
        //     ledOnMs: 1000,
        //     ledOffMs: 500);

        flutterLocalNotificationsPlugin.show(
          progress.taskId.hashCode,
          'Background Uploading',
          'Upload in progress...',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'FlutterUploader.Example',
              'FlutterUploader',
              channelDescription: 'Vibrate and show Flutter Uploader notification',
              progress: progress.progress ?? 0,
              icon: 'ic_upload',
              enableVibration: false,
              importance: Importance.low,
              showProgress: true,
              onlyAlertOnce: true,
              maxProgress: 100,
              channelShowBadge: false,
            ),
            iOS: IOSNotificationDetails(),
          ),
        );
      });
    }

    uploader.result.listen((result) async {
      FirebaseFirestore.instance.collection("uploadResults")
          .add({
        "result.status": result.status?.description ?? "was null",
        "result.statusCode": result.statusCode,
        "result.response": result.response,
        "result.taskId": result.taskId,
        "dateTime": DateTime.now(),
      });
      List<String> isChatRoomOrGroupChatRoomList = jsonDecode(result.response ?? "")['id'].split("/");
      bool isChatRoom = isChatRoomOrGroupChatRoomList.asMap().containsValue("chatRooms");
      bool isGroupChatRoom = isChatRoomOrGroupChatRoomList.asMap().containsValue("groupChatRooms");
      if(isChatRoom){
        String chatRoomId = isChatRoomOrGroupChatRoomList[2];
        String fileName = isChatRoomOrGroupChatRoomList[3].split(".")[0];
        log("chatRoomId in upload result:  $chatRoomId");
        log("fileName in upload result:  $fileName");
        var ref = FirebaseStorage.instance
            .ref()
            .child("chatRooms/${chatRoomId}")
            .child("$fileName.mp4");
        String url = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId)
            .collection("messages").doc(fileName)
            .update({"message": url});
      }else if(isGroupChatRoom){
        String groupId = isChatRoomOrGroupChatRoomList[2];
        String fileName = isChatRoomOrGroupChatRoomList[3].split(".")[0];
        log("groupId in upload result:  $groupId");
        log("fileName in upload result:  $fileName");
        var ref = FirebaseStorage.instance
            .ref()
            .child("groupChatRooms/${groupId}")
            .child("$fileName.mp4");
        String url = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("GroupChatRoom").doc(groupId)
            .collection("messages").doc(fileName)
            .update({"message": url});
      }
      if (processed.contains(result.taskId)) {
        return;
      }

      processed.add(result.taskId);
      preferences.setStringList('processed', processed);

      flutterLocalNotificationsPlugin.cancel(result.taskId.hashCode);

      final successful = result.status == UploadTaskStatus.complete;

      var title = 'Upload Complete';
      if (result.status == UploadTaskStatus.failed) {
        title = 'Upload Failed';
      } else if (result.status == UploadTaskStatus.canceled) {
        title = 'Upload Canceled';
      }

      flutterLocalNotificationsPlugin
          .show(
        result.taskId.hashCode,
        'Background Uploading',
        title,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'FlutterUploader.Example',
            'FlutterUploader',
            channelDescription: 'Vibrate and show Flutter Uploader notification',
            icon: 'ic_upload',
            enableVibration: !successful,
            importance: result.status == UploadTaskStatus.failed
                ? Importance.high
                : Importance.min,
          ),
          iOS: IOSNotificationDetails(
            presentAlert: true,
          ),
        ),
      )
          .catchError((e, stack) {
        print('error while showing notification: $e, $stack');
      });
    });
  });
}

// void backgroundHandler() {
//   // Needed so that plugin communication works.
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // This uploader instance works within the isolate only.
//   FlutterUploader uploader = FlutterUploader();
//
//   // You have now access to:
//   uploader.progress.listen((progress) {
//     // upload progress
//     ffstore.collection("uploadProgress")
//         .add({
//       "progress.status": progress.status,
//       "progress.progress": progress.progress,
//       "progress.taskId": progress.taskId,
//       "dateTime": DateTime.now(),
//     });
//   });
//   uploader.result.listen((result) {
//     // upload results
//     ffstore.collection("uploadResults")
//         .add({
//       "result.status": result.status,
//       "result.statusCode": result.statusCode,
//       "result.response": result.response,
//       "result.taskId": result.taskId,
//       "dateTime": DateTime.now(),
//     });
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FlutterUploader().setBackgroundHandler(backgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // description
    importance: Importance.max,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("This simulator is authorized to accept android notification.");
  }

  debugPrint('User granted permission: ${settings.authorizationStatus}');

  await GetStorage.init();
  Get.put(SplashScreenController());
  Get.put(EmailAuthController());
  Get.put(GoogleAuthController());
  Get.put(SignupController());
  Get.put(ForgotPasswordController());
  Get.put(HomeController());
  Get.put(ChooseLanguageController());
  Get.put(ChatController());
  Get.put(GroupChatController());
  Get.put(FacebookAuthController());
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  void selectNotification(String? payload) async {
    if (payload != null) {
      if (payload.isNotEmpty) {
        // var payloadData2 = PayloadData.fromJson(jsonDecode(payload));
        var payloadDecoded = jsonDecode(payload);
        var screenName = payloadDecoded["screenName"];
        if (screenName != null) {
          if (screenName.isNotEmpty) {
            print("Screen name is: $screenName");
            if (screenName == 'chatScreen') {
              print("Screen is Chat");
              String type = 'Nothing';
              String chatRoomId = 'Nothing';
              if (payloadDecoded['type'] != null) {
                type = payloadDecoded['type'];
                if (type == 'profileMatched') {
                  String likerId = payloadDecoded['likerId'];
                  String likedId = payloadDecoded['likedId'];
                  chatRoomId = chatController.getChatRoomId(likerId, likedId);
                } else {
                  print("Type is missed");
                }
              } else {
                chatRoomId = payloadDecoded["chatRoomId"];
              }

              print("ChatRoom Id is: ${chatRoomId}");
              //We have chatRoomId here and we need to navigate to the ChatRoomScreen having same Id
              await ffstore.collection("ChatRoom").doc(chatRoomId).get().then((value) {
                Get.to(() => ChatScreen(docs: value.data(), isArchived: false));
              });
            } else if (screenName == 'profileScreen') {
              print("Screen is Profile");
              // print(payloadDecoded.toString());
              //+could be used for follower notification
              // fs.collection("MovingToProfile").doc().set({"Screen": screenName});
              String type = "Nothing";
              print("Screen is Profile");
              print("type is ${payloadDecoded['type']}");
              if (payloadDecoded['type'] != null) {
                type = payloadDecoded['type'];
                if (type == 'followerFollowed') {
                  UserDetailsModel? umdl;
                  await ffstore.collection(accountsCollection).doc(payloadDecoded['id']).get().then((value) {
                    umdl = UserDetailsModel.fromJson(value.data() ?? {});
                  });
                  Get.to(() => OtherUserProfile(
                        otherUserModel: umdl,
                      ));
                } else {
                  print("Type is missed");
                }
              }
              // String followerId = payloadDecoded['id'];
              // print("follower id is " + followerId);
              //+ UserDetailsModel userLiker = await authController.getAUser(likerId);
              //+ Get.to(() => Home(showAbleUserData: userLiker));
            } else if (screenName == 'groupChatScreen') {
              print("Screen is Group Chat");
              String groupId = 'Nothing';
              groupId = payloadDecoded["groupId"];
              print("ChatRoom Id is: ${groupId}");
              //We have chatRoomId here and we need to navigate to the ChatRoomScreen having same Id
              loading();
              await ffstore.collection(groupChatCollection).doc(groupId).update({
                "notDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid]),
                "users": FieldValue.arrayUnion([auth.currentUser?.uid]),
              });
              await groupChatController.getAGroupChatRoomInfo(groupId).then((value) {
                Get.back();
                Get.to(() => GroupChat(docs: value.data()));
              });
            } else if (screenName == "postScreen") {
              print("Screen is postScreen");
              String postId = 'Nothing';
              postId = payloadDecoded["postId"];
              await ffstore.collection(postsCollection).doc(postId).get().then((value) {
                AddPostModel addPostModel = AddPostModel.fromJson(value.data() ?? {});
                Get.to(() => PostDetails(
                      isLikeByMe: false,
                      postDocModel: addPostModel,
                    ));
              });
            }
          } else {
            print("Screen name is null");
          }
        }
      } else {
        debugPrint("PayLoad is null");
      }
    }
  }

  void onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
    // display a diaprint with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Column(
          children: [Text(body!), Text(payload.toString())],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('See ChatRoom'),
            onPressed: () async {
              debugPrint("Please check the payload data first");
            },
          )
        ],
      ),
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  getInitialMessageRun() async {
    print("getInitialMessage is being called from another method");
    await FirebaseMessaging.instance.getInitialMessage().then((message) async {
      //showAboutDiaprint(context: context, applicationName: "bilal saeed is mee");

      print("get Initial Message function is used.. ");

      String screenName = 'No screen';
      bool screenEnabled = false;
      if (message != null) {
        if (message.data != null) {
          print("Screen Name in initial is: ${message.data['screenName']}");
          if (message.data.isNotEmpty) {
            screenEnabled = message.data.containsKey('screenName');
            screenName = message.data['screenName'];
            screenEnabled = message.data.containsKey('screenName');
            screenName = message.data['screenName'];
            if (screenEnabled) {
              if (screenName == 'chatScreen') {
                print("Screen is Chat");
                String type = 'Nothing';
                String chatRoomId = 'Nothing';
                if (message.data['type'] != null) {
                  type = message.data['type'];
                  if (type == 'twoWayChat') {
                    String likerId = message.data['likerId'];
                    String likedId = message.data['likedId'];
                    chatRoomId = chatController.getChatRoomId(likerId, likedId);
                  } else if (type == "groupChat") {
                    //+handle group chat chatRoomId
                  } else {
                    print("Type is missed");
                  }
                } else {
                  chatRoomId = message.data['chatRoomId'];
                }
                //We have chatRoomId here and we need to navigate to the ChatRoomScreen having same Id
                await ffstore.collection("ChatRoom").doc(chatRoomId).get().then((value) async {
                  if (value.exists) {
                    print("ChatRoom Doc " + value.toString());
                    print("Navigating from onMessagePop to the ChatRoom 2");
                    print("Last Message was : ${value.data()!['lastMessage']}");
                    //+commented because I removed the generate route property feom get
                    try {
                      ffstore.collection("MovingToChat").doc().set({
                        "Screen": screenName,
                      });
                      if (Platform.isIOS) {
                        Future.delayed(Duration(seconds: 4), () => Get.to(() => ChatScreen(docs: value.data())));
                      } else {
                        Get.to(() => ChatScreen(docs: value.data()));
                      }
                    } catch (e) {
                      await ffstore.collection("Error in InitialMessage").doc().set({'Error': e.toString()});
                    }
                    // }
                  } else {
                    print("no doc exist for chat");
                  }
                });
              } else if (screenName == 'profileScreen') {
                //+could be used for follower notification
                // fs.collection("MovingToProfile").doc().set({"Screen": screenName});
                print("Screen is Profile");
                String type = "Nothing";
                if (message.data['type'] != null) {
                  type = message.data['type'];
                  if (type == 'followerFollowed') {
                    UserDetailsModel? umdl;
                    await ffstore.collection(accountsCollection).doc(message.data['id']).get().then((value) {
                      umdl = UserDetailsModel.fromJson(value.data() ?? {});
                    });
                    Get.to(() => OtherUserProfile(otherUserModel: umdl));
                  } else {
                    print("Type is missed");
                  }
                }

                //+ UserDetailsModel userLiker = await authController.getAUser(likerId);
                //+ Get.to(() => Home(showAbleUserData: userLiker));
              } else if (screenName == 'groupChatScreen') {
                print("Screen is Group Chat");
                String groupId = 'Nothing';
                groupId = message.data["groupId"];
                print("ChatRoom Id is: ${groupId}");
                //We have chatRoomId here and we need to navigate to the ChatRoomScreen having same Id
                loading();
                await ffstore.collection(groupChatCollection).doc(groupId).update({
                  "notDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid]),
                  "users": FieldValue.arrayUnion([auth.currentUser?.uid]),
                });
                await groupChatController.getAGroupChatRoomInfo(groupId).then((value) {
                  Get.back();
                  Get.to(() => GroupChat(docs: value.data()));
                });
              } else if (screenName == "postScreen") {
                print("Screen is postScreen");
                String postId = 'Nothing';
                postId = message.data["postId"];
                await ffstore.collection(postsCollection).doc(postId).get().then((value) {
                  AddPostModel addPostModel = AddPostModel.fromJson(value.data() ?? {});
                  Get.to(() => PostDetails(isLikeByMe: false, postDocModel: addPostModel));
                });
              } else {
                print("Screen is in Else method of getInitialMessage");
              }
            } else {
              debugPrint("Notification Pay load data is Empty");
            }
          } else {
            print("Screen isn't enabled");
          }
        } else {
          print("message data is null");
        }
      } else {
        print("...........message data is null in bahir wala else");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      print("onMessage function was used..");
      bool imagePresent = false;
      bool generalImagePresent = false;

      String imgUrl = 'https://via.placeholder.com/400x800';
      String generalImageUrl = 'https://via.placeholder.com/400x800';
      String screenName = 'No screen';
      String type = 'type';
      bool screenEnabled = false;
      screenEnabled = message.data.containsKey('screenName');

      if (message != null) {
        if (message.data.isNotEmpty) {
          print("Is onMessage datapayload received");
          print("Message Data is" + message.data.toString());
          if (message.data.containsKey("type")) {
            type = message.data["type"];
            print("type: $type");
          }
          if (screenEnabled) {
            //Move to the screen which is needed to
            print("Screen is Enabled");
            screenName = message.data['screenName'];
            print("Screen name is: $screenName");
            //+ I/flutter (31547): Screen is Enabled
            log("message.notification: ${message.notification}");
            log("message.notification.data: ${message.notification != null ? message.notification?.title : "notification was null"}");
            log("message.notification.data: ${message.notification != null ? message.notification?.body : "notification was null"}");
            log("message.notification.data: ${message.notification != null ? message.notification?.android : "notification was null"}");
            if (message.notification != null && message.notification != {}) {
              String? longData = message.notification != null ? message.notification?.body : "";
              if (screenName == 'chatScreen' ||
                  screenName == 'profileScreen' ||
                  screenName == 'groupChatScreen' ||
                  screenName == "postScreen") {
                //Handling forground notification on chat notification
                imagePresent = message.data.containsKey('imageUrl');
                generalImagePresent = message.data.containsKey('generalImageUrl');
                if (imagePresent) {
                  imgUrl = message.data['imageUrl'];
                }
                if (generalImagePresent) {
                  generalImageUrl = message.data['generalImageUrl'];
                }
                //PictureConfig
                final largeIconPath = await _downloadAndSaveFile('${imgUrl}', 'largeIcon');
                final String bigPicturePath = await _downloadAndSaveFile('${generalImageUrl}', 'bigPicture');

                final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
                    FilePathAndroidBitmap(bigPicturePath),
                    hideExpandedLargeIcon: true,
                    contentTitle: '<b>${message.notification?.title}</b>',
                    htmlFormatContentTitle: true,
                    summaryText: '${message.notification?.body}',
                    htmlFormatSummaryText: true);

                final bigTextStyleInformation = BigTextStyleInformation(longData!);

                print("Things take time");

                final AndroidNotificationDetails androidPlatformChannelSpecifics =
                    AndroidNotificationDetails('vipPicnic', 'vip',
                        channelDescription: 'Vibrate and show notification',
                        importance: Importance.max,
                        priority: Priority.high,
                        icon: '@mipmap/launcher_icon',
                        largeIcon: FilePathAndroidBitmap(largeIconPath),
                        styleInformation: bigTextStyleInformation,
                        // vibrationPattern: vibrationPattern,
                        enableLights: true,
                        color: const Color.fromARGB(255, 255, 0, 0),
                        ledColor: const Color.fromARGB(255, 255, 0, 0),
                        ledOnMs: 1000,
                        ledOffMs: 500);

                const AndroidInitializationSettings initializationSettingsAndroid =
                    AndroidInitializationSettings('launcher_icon');
                final IOSInitializationSettings initializationSettingsIOS =
                    IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

                final InitializationSettings initializationSettings =
                    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
                await flutterLocalNotificationsPlugin.initialize(initializationSettings,
                    onSelectNotification: selectNotification);

                //We need to configure for the ios as well
                final NotificationDetails platformChannelSpecifics =
                    NotificationDetails(android: androidPlatformChannelSpecifics);
                print("message.notification?.title  + ${message.notification?.title}");
                print("message.notification?.body ${message.notification?.body}");
                print("messageId: ${message.messageId}");

                flutterLocalNotificationsPlugin.show(
                  DateTime.now().millisecond,
                  message.notification?.title,
                  message.notification?.body,
                  platformChannelSpecifics,
                  payload: json.encode(message.data),
                );
              } else {
                print("Screen is in Else");
              }
            } else {
              print("Screen is in Else");
            }
          }
        } else {
          debugPrint("Notification Pay load data is Empty");
        }
      } else {
        print("message was null in OnMessage");
      }

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp function is used.. ");
      String screenName = 'No screen';
      bool screenEnabled = false;
      if (message != null) {
        if (message.data.isNotEmpty) {
          screenEnabled = message.data.containsKey('screenName');
          if (screenEnabled) {
            //Move to the screen which is needed to
            print("Screen is Enabled");
            screenName = message.data['screenName'];
            print("Screen name is: $screenName");

            if (screenName == 'chatScreen') {
              print("Screen is Chat");
              String type = 'Nothing';
              String chatRoomId = 'Nothing';
              if (message.data['type'] != null) {
                type = message.data['type'];
                if (type == 'twoWayChat') {
                  String likerId = message.data['likerId'];
                  String likedId = message.data['likedId'];
                  chatRoomId = chatController.getChatRoomId(likerId, likedId);
                } else if (type == "groupChat") {
                  //+handle group chat chatRoomId
                } else {
                  print("Type is missed");
                }
              } else {
                chatRoomId = message.data['chatRoomId'];
              }

              print("ChatRoom Id is: ${chatRoomId}");
              print("Navigating from onMessagePop to the ChatRoom in onMessageOpenedApp");
              //We have chatRoomId here and we need to navigate to the ChatRoomScreen having same Id
              await ffstore.collection("ChatRoom").doc(chatRoomId).get().then((value) async {
                if (value.exists) {
                  print("ChatRoom Doc " + value.toString());
                  print("Navigating from onMessagePop to the ChatRoom 2");
                  print("Last Message was : ${value.data()!['lastMessage']}");
                  final g = Get;
                  g.to(() => ChatScreen(docs: value.data(), isArchived: false));
                } else {
                  print("no doc exist for chat");
                }
              });
            } else if (screenName == 'profileScreen') {
              //+could be used for follower notification
              // fs.collection("MovingToProfile").doc().set({"Screen": screenName});
              print("Screen is Profile");
              String type = "Nothing";
              if (message.data['type'] != null) {
                type = message.data['type'];
                if (type == 'followerFollowed') {
                  UserDetailsModel? umdl;
                  await ffstore.collection(accountsCollection).doc(message.data['id']).get().then((value) {
                    umdl = UserDetailsModel.fromJson(value.data() ?? {});
                  });
                  Get.to(() => OtherUserProfile(otherUserModel: umdl));
                } else {
                  print("Type is missed");
                }
              }
            } else if (screenName == "postScreen") {
              print("Screen is postScreen");
              String postId = 'Nothing';
              postId = message.data["postId"];
              await ffstore.collection(postsCollection).doc(postId).get().then((value) {
                AddPostModel addPostModel = AddPostModel.fromJson(value.data() ?? {});
                Get.to(() => PostDetails(isLikeByMe: false, postDocModel: addPostModel));
              });
            } else {
              print("Screen is in Else");
            }
          }
        } else {
          print("Notification Pay load data is Empty");
        }
      } else {
        print("in message is null in onMessageOpenedApp");
      }
    });

    getInitialMessageRun();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      locale: Localization.locale,
      fallbackLocale: Localization.fallBackLocale,
      translations: Localization(),
      title: 'Vip Picnic',
      themeMode: ThemeMode.light,
      theme: lightTheme,
      initialRoute: AppLinks.splashScreen,
      getPages: Routes.pages,
    );
  }
}
