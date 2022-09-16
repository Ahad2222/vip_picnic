class AddonModel {
  String? name, image, description, unit;
  bool? status;
  int? price;
  int? createdAt;
  // List<String>? images;

  AddonModel({
    this.name,
    this.image,
    this.description,
    this.unit,
    this.price,
    this.status,
    this.createdAt,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) => AddonModel(
    name: json['name'] ?? "",
    image: json['image'] ?? "",
    description: json['description'] ?? "",
    unit: json['unit'] ?? "",
    price: json['price'] ?? 0,
    status: json['status'] ?? false,
    createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    // images: json['images'] != null ? List<String>.from(json['images'].map((x) => x)) : [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'status': status,
    'price': price,
    'unit': unit,
    'description': description,
    'createdAt': createdAt,
  };
}
