import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';

class ChatRoomModel {
  ChatRoomModel({
    this.users,
    this.user1Model,
    this.user2Model,
    this.chatRoomId = "",
    this.notDeletedFor,
    this.isBlocked = false,
    this.blockedById = "",
    this.createdAt = 0,
    this.lastMessage = "",
    this.lastMessageAt = 0,
    this.lastMessageType = "",
  });

  bool? isBlocked;
  String? blockedById;
  UserDetailsModel? user1Model;
  UserDetailsModel? user2Model;
  String? chatRoomId;
  List<String>? users;
  List<String>? notDeletedFor;
  int? createdAt;
  int? lastMessageAt;
  String? lastMessage;
  String? lastMessageType;

  // Map<String, dynamic> chatRoomMap = {
  //   "users": users, //usersList containing Ids of users
  //   "chatRoomId": chatRoomId,
  //   "chaperoneId": authController.userModel.value.chaperoneId,
  //   'user1Model': user1Model.toJson(),
  //   'user2Model': user2Model.toJson(),
  //   'createdAt': Timestamp.now(),
  //   'lastMessageAt': Timestamp.now(),
  //   'lastMessage': ''
  // };


  ChatRoomModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> doc = documentSnapshot.data() as Map<String, dynamic>;
    isBlocked = doc["isBlocked"];
    blockedById = doc["blockedById"];
    user1Model = UserDetailsModel.fromJson(doc["user1Model"]);
    user2Model = UserDetailsModel.fromJson(doc["user2Model"]);
    chatRoomId = doc["chatRoomId"];
    createdAt = doc["createdAt"];
    lastMessageAt = doc["lastMessageAt"];
    lastMessage = doc["lastMessage"];
    lastMessageType = doc["lastMessageType"];
    users = List<String>.from(doc["users"]);
    notDeletedFor = List<String>.from(doc["notDeletedFor"]);
  }

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
