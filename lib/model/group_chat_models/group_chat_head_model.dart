import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatHeadModel {
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
  List<String>? searchParameters;

  GroupChatHeadModel();

  GroupChatHeadModel.fromDocumentSnapshot(QueryDocumentSnapshot doc) {
    groupId = doc["groupId"];
    groupName = doc["groupName"];
    groupImage = doc["groupImage"];
    users = List<String>.from(doc["users"].map((x) => x));
    searchParameters = List<String>.from(doc["searchParameters"].map((x) => x));
    lastMessage = doc["lastMessage"];
    lastMessageAt = doc["lastMessageAt"];
    lastMessageType = doc["lastMessageType"];
  }
}