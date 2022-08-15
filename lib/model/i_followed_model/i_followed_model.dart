class IFollowedModel {
  String? followedId, followedName, followedImage;
  int? followedAt;

  IFollowedModel({
    this.followedId,
    this.followedName,
    this.followedImage,
    this.followedAt,
  });

  factory IFollowedModel.fromJson(Map<String, dynamic> json) => IFollowedModel(
        followedId: json['followedId'] ?? "",
        followedName: json['followedName'] ?? "",
        followedImage: json['followedImage'] ?? "",
        followedAt: json['followedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      );

  Map<String, dynamic> toJson() => {
        'followedId': followedId ?? "Id Placeholder",
        'followedName': followedName ?? "Name Placeholder",
        'followedImage': followedImage ?? "",
        'followedAt': followedAt ??  DateTime.now().millisecondsSinceEpoch,
      };
}
