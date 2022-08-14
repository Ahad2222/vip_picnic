// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:hop_on_passenger/constant/all_controller.dart';
// import 'package:hop_on_passenger/model/chat_head_model.dart';
// import 'package:hop_on_passenger/widget/my_text.dart';
// import '../../constant/constant.dart';
// import '../../model/message_page.dart';
// import 'chat_screen.dart';
//
// class ChatHead extends StatefulWidget {
//   @override
//   _ChatHeadState createState() => _ChatHeadState();
// }
//
// class _ChatHeadState extends State<ChatHead> {
//   TextEditingController searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: KPrimaryColor,
//         appBar: AppBar(
//           title: Text(
//             "Message",
//             style: MediumBlackHeading,
//           ),
//           backgroundColor: KPrimaryColor,
//           leading: GestureDetector(
//             onTap: () {
//               Get.back();
//             },
//             child: Card(
//               margin: EdgeInsets.only(left: 15, bottom: 5),
//               child: Container(
//                 height: 35,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: KPrimaryColor,
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     "assets/Group 1 (2).png",
//                     height: 15.8,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           centerTitle: true,
//           elevation: 0,
//         ),
//         body: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10),
//           child: ListView(
//             children: [
//               SizedBox(height: 20.h),
//               //+Search Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: KGreyColor,
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: TextField(
//                   controller: searchController,
//                   style: inputText,
//                   cursorColor: KSecondaryColor,
//                   decoration: InputDecoration(
//                     prefixIcon: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           "assets/Vector - 2022-03-21T235828.129.png",
//                           height: 18.h,
//                         ),
//                       ],
//                     ),
//                     hintText: "Search here...",
//                     hintStyle: GreyLightTextSmall,
//                     contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               // searchController.text.trim().isEmpty
//               //     ?
//               StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                       stream: ffstore
//                           .collection(chatRoomCollection)
//                           .where('users', arrayContains: authController.passengerModel.value.currentUserId)
//                           .snapshots(),
//                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return SizedBox();
//                         } else if (snapshot.connectionState == ConnectionState.active ||
//                             snapshot.connectionState == ConnectionState.done) {
//                           if (snapshot.hasError) {
//                             return const Text('Error');
//                           } else if (snapshot.hasData) {
//                             return ListView.builder(
//                               itemCount: snapshot.data!.docs.length,
//                               shrinkWrap: true,
//                               padding: const EdgeInsets.symmetric(horizontal: 15),
//                               physics: const BouncingScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 var myId = authController.passengerModel.value.currentUserId;
//                                 Rx<ChatHeadModel> data = ChatHeadModel().obs;
//                                 QueryDocumentSnapshot<Object?>? doc = snapshot.data?.docs[index];
//
//                                 data.value = ChatHeadModel.fromDocumentSnapshot(doc!);
//                                 return Obx(() {
//                                   return ReadMessage(
//                                     img: data.value.driverModel?.imgUrl,
//                                     chatRoomId: data.value.chatRoomId,
//                                     message: data.value.lastMessage,
//                                     name:
//                                         "${data.value.driverModel?.firstName} ${data.value.driverModel?.lastName}",
//                                     time: data.value.lastMessageAt,
//                                   );
//                                 });
//                               },
//                             );
//                           } else {
//                             log("in else of hasData done and: ${snapshot.connectionState} and"
//                                 " snapshot.hasData: ${snapshot.hasData}");
//                             return SizedBox();
//                           }
//                         } else {
//                           log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
//                           return SizedBox();
//                         }
//                       },
//                     )
//                   // : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   //     // ffstore.collection(chatRoomCollection)
//                   //     //     .where("passengerId", isEqualTo: authController.passengerModel.value.currentUserId)
//                   //     //     .where("searchParameters", arrayContains: "varToSearch").snapshots();
//                   //
//                   //     stream: ffstore
//                   //         .collection(chatRoomCollection)
//                   //       .where('users', arrayContains: authController.passengerModel.value.currentUserId)
//                   //         .where("passengerId", isEqualTo: authController.passengerModel.value.currentUserId)
//                   //         .where("searchParameters", arrayContains: searchController.text)
//                   //         .snapshots(),
//                   //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   //       if (snapshot.connectionState == ConnectionState.waiting) {
//                   //         return SizedBox();
//                   //       } else if (snapshot.connectionState == ConnectionState.active ||
//                   //           snapshot.connectionState == ConnectionState.done) {
//                   //         if (snapshot.hasError) {
//                   //           return const Text('Error');
//                   //         } else if (snapshot.hasData) {
//                   //           return ListView.builder(
//                   //             itemCount: snapshot.data!.docs.length,
//                   //             shrinkWrap: true,
//                   //             padding: const EdgeInsets.symmetric(horizontal: 15),
//                   //             physics: const BouncingScrollPhysics(),
//                   //             itemBuilder: (context, index) {
//                   //               var myId = authController.passengerModel.value.currentUserId;
//                   //               Rx<ChatHeadModel> data = ChatHeadModel().obs;
//                   //               QueryDocumentSnapshot<Object?>? doc = snapshot.data?.docs[index];
//                   //
//                   //               data.value = ChatHeadModel.fromDocumentSnapshot(doc!);
//                   //               return Obx(() {
//                   //                 return ReadMessage(
//                   //                   img: data.value.driverModel?.imgUrl,
//                   //                   chatRoomId: data.value.chatRoomId,
//                   //                   message: data.value.lastMessage,
//                   //                   name:
//                   //                       "${data.value.driverModel?.firstName} ${data.value.driverModel?.lastName}",
//                   //                   time: data.value.lastMessageAt,
//                   //                 );
//                   //               });
//                   //             },
//                   //           );
//                   //         } else {
//                   //           log("in else of hasData done and: ${snapshot.connectionState} and"
//                   //               " snapshot.hasData: ${snapshot.hasData}");
//                   //           return SizedBox();
//                   //         }
//                   //       } else {
//                   //         log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
//                   //         return SizedBox();
//                   //       }
//                   //     },
//                   //   )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ReadMessage extends StatefulWidget {
//   const ReadMessage({
//     this.img,
//     this.chatRoomId,
//     this.name,
//     this.message,
//     this.time,
//   });
//
//   final img;
//   final chatRoomId;
//   final name;
//   final message;
//   final time;
//
//   @override
//   _ReadMessageState createState() => _ReadMessageState();
// }
//
// class _ReadMessageState extends State<ReadMessage> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         var chatRoomMap;
//         chatRoomMap = await chatController.getAChatRoomInfo(widget.chatRoomId);
//         Get.to(() => ChatScreen(docs: chatRoomMap), transition: Transition.leftToRight);
//         Get.to(ChatScreen(), transition: Transition.leftToRight);
//       },
//       child: Card(
//         margin: EdgeInsets.only(top: 10),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(9),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: Get.width * 0.8,
//                 child: ListTile(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 5),
//                   leading: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 50,
//                         width: 50,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: Image.network(
//                             widget.img,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   title: Container(
//                       width: Get.width * 0.30,
//                       child: Text(
//                         widget.name,
//                         style: BlackSmallStyle,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       )),
//                   subtitle: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                     stream: ffstore
//                         .collection(chatRoomCollection)
//                         .doc(widget.chatRoomId)
//                         .collection(messageCollection)
//                         .where("isRead", isEqualTo: false)
//                         .where("receivedById", isEqualTo: authController.passengerModel.value.currentUserId)
//                         .snapshots(),
//                     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                       log("inside streambuilder");
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         log("inside streambuilder in waiting state");
//                         return Text(
//                           widget.message,
//                           style: GreyLightTextSmall,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         );
//                       } else if (snapshot.connectionState == ConnectionState.active ||
//                           snapshot.connectionState == ConnectionState.done) {
//                         if (snapshot.hasError) {
//                           return const Text('Error');
//                         } else if (snapshot.hasData) {
//                           log("inside hasdata and ${snapshot.data!.docs}");
//                           if (snapshot.data!.docs.length > 0) {
//                             return Text(
//                               widget.message,
//                               style: BlackSmallTextStyle,
//                               // style: TextStyle(color: Colors.pink),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             );
//                           } else {
//                             return Text(
//                               widget.message,
//                               style: GreyLightTextSmall,
//                               // style: TextStyle(color: Colors.orange),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             );
//                           }
//                         } else {
//                           log("in else of hasData done and: ${snapshot.connectionState} and"
//                               " snapshot.hasData: ${snapshot.hasData}");
//                           return SizedBox();
//                         }
//                       } else {
//                         log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
//                         return SizedBox();
//                       }
//                     },
//                   ),
//                   trailing: Text(
//                     DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.time)).inMinutes <
//                             60
//                         ? "${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.time)).inMinutes} m ago"
//                         : DateTime.now()
//                                     .difference(DateTime.fromMillisecondsSinceEpoch(widget.time))
//                                     .inHours <
//                                 24
//                             ? "${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.time)).inHours} hrs ago"
//                             : "${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.time)).inDays} days ago",
//                     // "${DateTime.fromMillisecondsSinceEpoch(widget.time).toString().split(" ")[1].split(":")[0]}"
//                     //     ":"
//                     //     "${DateTime.fromMillisecondsSinceEpoch(widget.time).toString().split(" ")[1].split(":")[1]}",
//                     style: GreyLightTextSmall,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }