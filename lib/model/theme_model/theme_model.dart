class ThemeModel {
  String? name, image, description;
  bool? status;
  int? createdAt;
  // List<String>? images;

  ThemeModel({
    this.name,
    this.image,
    this.status,
    this.description,
    this.createdAt,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
    name: json['name'] ?? "",
    image: json['image'] ?? "",
    description: json['description'] ?? "",
    status: json['status'] ?? false,
    createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    // images: json['images'] != null ? List<String>.from(json['images'].map((x) => x)) : [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'status': status,
    'description': description,
    'createdAt': createdAt,
  };
}
