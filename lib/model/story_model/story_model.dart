class StoryModel {
  String? storyPersonName, storyPersonImage, storyPersonId, storyText, mediaType, storyImage;
  int? createdAt;
  // List<String>? images;

  StoryModel({
    this.storyPersonName,
    this.storyPersonImage,
    this.storyPersonId,
    this.storyText,
    this.storyImage,
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
        mediaType: json['mediaType'] ?? "",
        createdAt: json['createdAt'] ?? "",
        // images: json['images'] != null ? List<String>.from(json['images'].map((x) => x)) : [],
      );

  Map<String, dynamic> toJson() => {
        'storyPersonName': storyPersonName,
        'storyPersonImage': storyPersonImage,
        'storyPersonId': storyPersonId,
        'storyText': storyText,
        'storyImage': storyImage,
        'mediaType': mediaType,
        'createdAt': createdAt,
        // 'images': images != null ? List<String>.from(images!.map((x) => x)) : [],
      };
}
