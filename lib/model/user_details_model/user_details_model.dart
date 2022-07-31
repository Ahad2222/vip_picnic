class UserDetailsModel {
  String? profileImageUrl;
  String? fullName;
  String? email;
  String? password;
  String? phone;
  String? city;
  String? state;
  String? address;
  String? zip;
  String? accountType;
  String? createdAt;

  UserDetailsModel({
    this.profileImageUrl = '',
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.phone = '',
    this.city = '',
    this.state = '',
    this.address = '',
    this.zip = '',
    this.accountType = '',
    this.createdAt = '',
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        profileImageUrl: json['profileImageUrl'],
        fullName: json['fullName'],
        email: json['email'],
        password: json['password'],
        phone: json['phone'],
        city: json['city'],
        state: json['state'],
        address: json['address'],
        zip: json['zip'],
        accountType: json['accountType'],
        createdAt: json['createdAt'],
      );

  Map<String, dynamic> toJson() => {
        "profileImageUrl": profileImageUrl,
        'fullName': fullName,
        'email': email,
        'password': password,
        'phone': phone,
        'city': city,
        'state': state,
        'address': address,
        'zip': zip,
        'accountType': accountType,
        'createdAt': createdAt,
      };
}
