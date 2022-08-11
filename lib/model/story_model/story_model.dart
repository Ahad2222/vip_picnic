class StoryModel {
  String? storyPersonName,
      storyPersonImage,
      storyPersonUID,
      storyTitle,
      mediaType,
      createdAt;
  List<String>? images;

  StoryModel({
    this.storyPersonName,
    this.storyPersonImage,
    this.storyPersonUID,
    this.storyTitle,
    this.mediaType,
    this.createdAt,
    this.images,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        storyPersonName: json['storyPersonName'] ?? "",
        storyPersonImage: json['storyPersonImage'] ?? "",
        storyPersonUID: json['storyPersonUID'] ?? "",
        storyTitle: json['storyTitle'] ?? "",
        mediaType: json['mediaType'] ?? "",
        createdAt: json['createdAt'] ?? "",
        images: json['images'] != null
            ? List<String>.from(json['images'].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'storyPersonName': storyPersonName,
        'storyPersonImage': storyPersonImage,
        'storyPersonUID': storyPersonUID,
        'storyTitle': storyTitle,
        'mediaType': mediaType,
        'createdAt': createdAt,
        'images':
            images != null ? List<String>.from(images!.map((x) => x)) : [],
      };
}
