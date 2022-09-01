class TheyFollowedModel {
  String? followerId, followerName, followerImageUrl;
  int? followedAt;

  TheyFollowedModel({
    this.followerId,
    this.followerName,
    this.followerImageUrl,
    this.followedAt,
  });

  factory TheyFollowedModel.fromJson(Map<String, dynamic> json) => TheyFollowedModel(
    followerId: json['followerId'] ?? "",
    followerName: json['followerName'] ?? "",
    followerImageUrl: json['followerImageUrl'] ?? "",
    followedAt: json['followedAt'] ?? DateTime.now().millisecondsSinceEpoch,
  );

  Map<String, dynamic> toJson() => {
    'followerId': followerId ?? "Id Placeholder",
    'followerName': followerName ?? "Name Placeholder",
    'followerImageUrl': followerImageUrl ?? "",
    'followedAt': followedAt ??  DateTime.now().millisecondsSinceEpoch,
  };
}
