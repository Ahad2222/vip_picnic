class CommentModel {
  static CommentModel instance = CommentModel();

  String? postID;
  String? commenterID;
  String? commenterName;
  String? commenterImage;
  String? commentText;
  // String? location;
  String? createdAt;
  // List<String>? postImages;
  // List<String>? taggedPeople;
  List<String>? likeIDs;
  int? commentCount;
  int? likeCount;
  // int? shareCount;

  CommentModel({
    this.postID = '',
    this.commenterID = '',
    this.commenterName = '',
    this.commenterImage = '',
    this.commentText = '',
    // this.location = '',
    this.createdAt,
    // this.postImages,
    // this.taggedPeople,
    this.likeIDs,
    this.commentCount = 0,
    this.likeCount = 0,
    // this.shareCount = 0,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    postID: json['postID'] ?? "",
    commenterID: json['commenterID'] ?? "",
    commenterName: json['commenterName'] ?? "",
    commenterImage: json['profileImage'] ?? "",
    commentText: json['commentText'] ?? "",
    // location: json['location'] ?? "",
    createdAt: json['createdAt'] ?? "",
    // postImages: json['postImages'] != null ? List<String>.from(json['postImages'].map((x) => x)) : [],
    // taggedPeople: json['taggedPeople'] != null ? List<String>.from(json['taggedPeople'].map((x) => x)) : [],
    likeIDs: json['likeIDs'] != null ? List<String>.from(json['likeIDs'].map((x) => x)) : [],
    commentCount: json['commentCount'],
    likeCount: json['likeCount'] ?? 0,
    // shareCount: json['shareCount'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'postID': postID,
    'commenterID': commenterID,
    'commenterName': commenterName,
    'commenterImage': commenterImage,
    'commentText': commentText,
    // 'location': location,
    'createdAt': createdAt,
    // 'postImages': postImages != null ? List<String>.from(postImages!.map((x) => x)) : [],
    // 'taggedPeople': taggedPeople != null ? List<String>.from(taggedPeople!.map((x) => x)) : [],
    'likeIDs': likeIDs != null ? List<String>.from(likeIDs!.map((x) => x)) : [],
    'commentCount': commentCount,
    'likeCount': likeCount,
    // 'shareCount': shareCount,
  };
}
