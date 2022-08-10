class AddPostModel {
  static AddPostModel instance = AddPostModel();

  String? postID;
  String? uID;
  String? postBy;
  String? profileImage;
  String? postTitle;
  String? location;
  String? createdAt;
  List<String>? postImages;
  List<String>? taggedPeople;
  List<String>? likeIDs;
  int? commentCount;
  int? likeCount;
  int? shareCount;

  AddPostModel({
    this.postID = '',
    this.uID = '',
    this.postBy = '',
    this.profileImage = '',
    this.postTitle = '',
    this.location = '',
    this.createdAt,
    this.postImages,
    this.taggedPeople,
    this.likeIDs,
    this.commentCount = 0,
    this.likeCount = 0,
    this.shareCount = 0,
  });

  factory AddPostModel.fromJson(Map<String, dynamic> json) => AddPostModel(
        postID: json['postID'] ?? "",
        uID: json['uID'] ?? "",
        postBy: json['postBy'] ?? "",
        profileImage: json['profileImage'] ?? "",
        postTitle: json['postTitle'] ?? "",
        location: json['location'] ?? "",
        createdAt: json['createdAt'] ?? "",
        postImages: json['postImages'] != null ? List<String>.from(json['postImages'].map((x) => x)) : [],
        taggedPeople: json['taggedPeople'] != null ? List<String>.from(json['taggedPeople'].map((x) => x)) : [],
        likeIDs: json['likeIDs'] != null ? List<String>.from(json['likeIDs'].map((x) => x)) : [],
        commentCount: json['commentCount'],
        likeCount: json['likeCount'] ?? 0,
        shareCount: json['shareCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'postID': postID,
        'uID': uID,
        'postBy': postBy,
        'profileImage': profileImage,
        'postTitle': postTitle,
        'location': location,
        'createdAt': createdAt,
        'postImages': postImages != null ? List<String>.from(postImages!.map((x) => x)) : [],
        'taggedPeople': taggedPeople != null ? List<String>.from(taggedPeople!.map((x) => x)) : [],
        'likeIDs': likeIDs != null ? List<String>.from(likeIDs!.map((x) => x)) : [],
        'commentCount': commentCount,
        'likeCount': likeCount,
        'shareCount': shareCount,
      };
}
