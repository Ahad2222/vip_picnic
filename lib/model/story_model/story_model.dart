class StoryModel {
  String? storyPersonName, storyPersonImage, storyPersonId, storyText, mediaType, storyImage, storyVideo;
  int? createdAt;
  int? videoDuration;
  // List<String>? images;

  StoryModel({
    this.storyPersonName,
    this.storyPersonImage,
    this.storyPersonId,
    this.storyText,
    this.storyImage,
    this.storyVideo,
    this.videoDuration,
    // this.uploadUrl,
    this.mediaType,
    this.createdAt,
    // this.images,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        storyPersonName: json['storyPersonName'] ?? "",
        storyPersonImage: json['storyPersonImage'] ?? "",
        storyPersonId: json['storyPersonId'] ?? "",
        storyText: json['storyText'] ?? "",
        storyImage: json['storyImage'] ?? "",
        storyVideo: json['storyVideo'] ?? "",
        videoDuration: json['videoDuration'] ?? 0,
        // uploadUrl: json['uploadUrl'] ?? "",
        mediaType: json['mediaType'] ?? "",
        createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
        // images: json['images'] != null ? List<String>.from(json['images'].map((x) => x)) : [],
      );

  Map<String, dynamic> toJson() => {
        'storyPersonName': storyPersonName,
        'storyPersonImage': storyPersonImage,
        'storyPersonId': storyPersonId,
        'storyText': storyText,
        'storyImage': storyImage,
        'storyVideo': storyVideo,
        'videoDuration': videoDuration,
        // 'uploadUrl': uploadUrl,
        'mediaType': mediaType,
        'createdAt': createdAt,
        // 'images': images != null ? List<String>.from(images!.map((x) => x)) : [],
      };
}
