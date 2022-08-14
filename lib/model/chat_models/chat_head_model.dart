import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';

class ChatHeadModel {
  UserDetailsModel? user1Model;
  UserDetailsModel? user2Model;
  String? chatRoomId;
  String? user1Id;
  String? user2Id;
  String? lastMessage;
  var lastMessageAt;
  String? lastMessageType;
  List<String>? searchParameters;

  ChatHeadModel();

  ChatHeadModel.fromDocumentSnapshot(QueryDocumentSnapshot doc) {
    user1Model = UserDetailsModel.fromJson(doc["user1Model"]);
    user2Model = UserDetailsModel.fromJson(doc["user2Model"]);
    chatRoomId = doc["chatRoomId"];
    user1Id = doc["user1Id"];
    user2Id = doc["user2Id"];
    searchParameters = List<String>.from(doc["searchParameters"].map((x) => x));
    lastMessage = doc["lastMessage"];
    lastMessageAt = doc["lastMessageAt"];
    // lastMessageType = doc["lastMessageType"];
  }
}