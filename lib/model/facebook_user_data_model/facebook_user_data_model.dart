// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

FacebookUserDataModel facebookUserDataModelFromJson(String str) => FacebookUserDataModel.fromJson(json.decode(str));

String facebookUserDataModelToJson(FacebookUserDataModel data) => json.encode(data.toJson());

class FacebookUserDataModel {
  FacebookUserDataModel({
    this.name,
    this.email,
    this.picture,
    this.id,
  });

  String? name;
  String? email;
  Picture? picture;
  String? id;

  factory FacebookUserDataModel.fromJson(Map<String, dynamic> json) => FacebookUserDataModel(
    name: json["name"],
    email: json["email"],
    picture: Picture.fromJson(json.containsKey("picture") ? json["picture"] : {}),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "picture": picture?.toJson(),
    "id": id,
  };
}

class Picture {
  Picture({
    this.data,
  });

  Data? data;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    data: Data.fromJson(json.containsKey("data") ? json["data"] : {}),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.height,
    this.isSilhouette,
    this.url,
    this.width,
  });

  int? height;
  bool? isSilhouette;
  String? url;
  int? width;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    height: json.containsKey("height") ? json["height"] : 0,
    isSilhouette: json.containsKey("height") ? json["is_silhouette"] : false,
    url: json.containsKey("url") ? json["url"] : "",
    width: json.containsKey("url") ? json["width"] : 0,
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "is_silhouette": isSilhouette,
    "url": url,
    "width": width,
  };
}
