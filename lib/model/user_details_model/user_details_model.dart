class UserDetailsModel {
  static UserDetailsModel instance = UserDetailsModel();

  String? profileImageUrl;
  String? fullName;
  String? email;
  String? uID;
  String? password;
  String? phone;
  String? city;
  String? state;
  String? address;
  String? zip;
  String? accountType;
  String? createdAt;
  List<String>? userSearchParameters;
  List<String>? TheyFollowed;
  List<String>? iFollowed;
  String? fcmToken;
  DateTime? fcmCreatedAt;

  UserDetailsModel({
    this.profileImageUrl = '',
    this.fullName = '',
    this.email = '',
    this.uID = '',
    this.password = '',
    this.phone = '',
    this.city = '',
    this.state = '',
    this.address = '',
    this.zip = '',
    this.accountType = '',
    this.createdAt = '',
    this.userSearchParameters,
    this.TheyFollowed,
    this.iFollowed,
    this.fcmToken = '',
    this.fcmCreatedAt,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
        profileImageUrl: json['profileImageUrl'],
        fullName: json['fullName'],
        email: json['email'],
        uID: json['uID'],
        password: json['password'],
        phone: json['phone'],
        city: json['city'],
        state: json['state'],
        address: json['address'],
        zip: json['zip'],
        accountType: json['accountType'],
        createdAt: json['createdAt'],
        userSearchParameters:
            json['userSearchParameters'] != null ? List<String>.from(json['userSearchParameters'].map((x) => x)) : [],
        TheyFollowed: json['TheyFollowed'] != null ? List<String>.from(json['TheyFollowed'].map((x) => x)) : [],
        iFollowed: json['iFollowed'] != null ? List<String>.from(json['iFollowed'].map((x) => x)) : [],
        fcmToken: json["fcmToken"] ?? "",
        fcmCreatedAt: (json["fcmCreatedAt"] != null && json["fcmCreatedAt"] != "") ? DateTime.parse(json["fcmCreatedAt"]) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "profileImageUrl": profileImageUrl,
        'fullName': fullName,
        'email': email,
        'uID': uID,
        'password': password,
        'phone': phone,
        'city': city,
        'state': state,
        'address': address,
        'zip': zip,
        'accountType': accountType,
        'createdAt': createdAt,
        'userSearchParameters':
            userSearchParameters != null ? List<String>.from(userSearchParameters!.map((x) => x)) : [],
        'TheyFollowed': TheyFollowed != null ? List<String>.from(TheyFollowed!.map((x) => x)) : [],
        'iFollowed': iFollowed != null ? List<String>.from(iFollowed!.map((x) => x)) : [],
        "fcmToken": fcmToken ?? "",
        "fcmCreatedAt": fcmCreatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      };
}
