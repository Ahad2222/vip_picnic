import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatRoomModel {
  GroupChatRoomModel({
    this.groupId = "",
    this.groupName = "",
    this.groupImage = "",
    this.groupDescription = "",
    this.users,
    this.groupAdmins,
    // this.isReceivedBy,
    // this.isReadBy,
    this.notDeletedFor,
    this.searchParameters,
    this.createdAt = 0,
    this.createdById = "",
    this.createdByName = "",
    this.lastMessage = "",
    this.lastMessageById = "",
    this.lastMessageByName = "",
    this.lastMessageAt = 0,
    this.lastMessageType = "",
  });
  //+{
  //+ groupId,
  //+ group name,
  //+ users:[],
  //+ lastMessageById,
  //+ lastMessageByName,
  //+ lastMessageAt,
  //+ lastMessage,
  //+ createdAt,
  //+ notDeletedFor,
  //+ groupAdmins:[]
  //+ }

  String? groupId;
  String? groupName;
  String? groupImage;
  String? groupDescription;
  int? createdAt;
  String? createdById;
  String? createdByName;
  String? lastMessageById;
  String? lastMessageByName;
  String? lastMessage;
  int? lastMessageAt;
  String? lastMessageType;
  List<String>? users;
  List<String>? groupAdmins;
  List<String>? notDeletedFor;
  // List<String>? isReceivedBy;
  // List<String>? isReadBy;
  List<String>? searchParameters;



  GroupChatRoomModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    groupId = doc["groupId"];
    groupName = doc["groupName"];
    groupImage = doc["groupImage"];
    groupDescription = doc["groupDescription"];
    createdAt = doc["createdAt"];
    createdById = doc["createdById"];
    createdByName = doc["createdByName"];
    lastMessage = doc["lastMessage"];
    lastMessageById = doc["lastMessageById"];
    lastMessageByName = doc["lastMessageByName"];
    lastMessageAt = doc["lastMessageAt"];
    lastMessageType = doc["lastMessageType"];
    users = List<String>.from(doc["users"]);
    notDeletedFor = List<String>.from(doc["notDeletedFor"]);
    // isReceivedBy = List<String>.from(doc["isReceivedBy"]);
    // isReadBy = List<String>.from(doc["isReadBy"]);
    groupAdmins = List<String>.from(doc["groupAdmins"]);
    searchParameters = List<String>.from(doc["searchParameters"]);
  }

  factory GroupChatRoomModel.fromJson(Map<String, dynamic> doc) => GroupChatRoomModel(
    groupId: doc["groupId"],
    groupName: doc["groupName"],
    groupImage: doc["groupImage"],
    groupDescription: doc["groupDescription"],
    createdAt: doc["createdAt"],
    createdById: doc["createdById"],
    createdByName: doc["createdByName"],
    lastMessage: doc["lastMessage"],
    lastMessageById: doc["lastMessageById"],
    lastMessageByName: doc["lastMessageByName"],
    lastMessageAt: doc["lastMessageAt"],
    lastMessageType: doc["lastMessageType"],
    users: List<String>.from(doc["users"]),
    notDeletedFor: List<String>.from(doc["notDeletedFor"]),
    // isReceivedBy: List<String>.from(doc["isReceivedBy"]),
    // isReadBy: List<String>.from(doc["isReadBy"]),
    groupAdmins: List<String>.from(doc["groupAdmins"]),
    searchParameters: List<String>.from(doc["searchParameters"]),
  );

  Map<String, dynamic> toJson() => {
  "groupId": groupId,
  "groupName": groupName,
  "groupImage": groupImage,
  "groupDescription": groupDescription,
  "createdAt": createdAt,
  "createdById": createdById,
  "createdByName": createdByName,
  "lastMessage": lastMessage,
  "lastMessageById": lastMessageById,
  "lastMessageByName": lastMessageByName,
  "lastMessageAt": lastMessageAt,
  "lastMessageType": lastMessageType,
  "users": users != null ? List<String>.from(users!.map((x) => x)) : [],
  "notDeletedFor": notDeletedFor != null ? List<String>.from(notDeletedFor!.map((x) => x)) : [],
  // "isReceivedBy": isReceivedBy != null ? List<String>.from(isReceivedBy!.map((x) => x)) : [],
  // "isReadBy": isReadBy != null ? List<String>.from(isReadBy!.map((x) => x)) : [],
  "groupAdmins": groupAdmins != null ? List<String>.from(groupAdmins!.map((x) => x)) : [],
  "searchParameters": groupAdmins != null ? List<String>.from(searchParameters!.map((x) => x)) : [],
  };

// ChatHeadModel.fromJson(Map<String, dynamic> chatHeadMap) {
//   // Map<String, dynamic> doc = documentSnapshot.data();
//   user1Id = chatHeadMap["users"][0];
//   user2Id = chatHeadMap["users"][1];
//   user1ProfileImage = chatHeadMap["user1Map"];
//   personName = chatHeadMap["name"];
//   personAbout = chatHeadMap["about"];
//   profession = chatHeadMap["profession"];
//   distance = chatHeadMap["distance"];
//   time = chatHeadMap["time"];
//   tagsList = chatHeadMap["tagsList"];
// }
}
