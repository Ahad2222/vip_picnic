class AlertModel {
  String? forId, image, message, type, dataId;
  int? createdAt;
  // List<String>? images;

  AlertModel({
    this.forId,
    this.image,
    this.message,
    this.dataId,
    this.type,
    this.createdAt,
    // this.images,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
    forId: json['forId'] ?? "",
    image: json['image'] ?? "",
    message: json['message'] ?? "",
    dataId: json['dataId'] ?? "",
    type: json['type'] ?? "",
    createdAt: json['createdAt'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    'forId': forId,
    'image': image,
    'message': message,
    'dataId': dataId,
    'type': type,
    'createdAt': createdAt,
  };
}
