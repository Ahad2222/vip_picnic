class AddPostModel {
  static AddPostModel instance = AddPostModel();

  String? uID;
  String? postBy;
  String? profileImage;
  String? postTitle;
  String? location;
  String? createdAt;
  List<String>? postImages;
  List<String>? taggedPeople;
  int? commentCount;
  int? likeCount;
  int? shareCount;

  AddPostModel({
    this.uID = '',
    this.postBy = '',
    this.profileImage = '',
    this.postTitle = '',
    this.location = '',
    this.createdAt,
    this.postImages,
    this.taggedPeople,
    this.commentCount = 0,
    this.likeCount = 0,
    this.shareCount = 0,
  });

  factory AddPostModel.fromJson(Map<String, dynamic> json) => AddPostModel(
        uID: json['uID'],
        postBy: json['postBy'],
        profileImage: json['profileImage'],
        postTitle: json['postTitle'],
        location: json['location'],
        createdAt: json['createdAt'],
        postImages: json['postImages'],
        taggedPeople: json['taggedPeople'],
        commentCount: json['commentCount'],
        likeCount: json['likeCount'],
        shareCount: json['shareCount'],
      );

  Map<String, dynamic> toJson() => {
        'uID': uID,
        'postBy': postBy,
        'profileImage': profileImage,
        'postTitle': postTitle,
        'location': location,
        'createdAt': createdAt,
        'postImages': postImages,
        'taggedPeople': taggedPeople,
        'commentCount': commentCount,
        'likeCount': likeCount,
        'shareCount': shareCount,
      };
}
