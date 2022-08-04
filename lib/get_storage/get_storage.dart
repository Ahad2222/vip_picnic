import 'package:get_storage/get_storage.dart';

class UserSimplePreference {
  static final pref = GetStorage();

  static const _keyProfileImageUrl = 'profileImageUrl';
  static const _keyFullName = 'fullName';
  static const _keyEmail = 'email';
  static const _keyPassword = 'password';
  static const _keyPhone = 'phoneNumber';
  static const _keyCity = 'city';
  static const _keyState = 'state';
  static const _keyAddress = 'address';
  static const _keyZip = 'zip';
  static const _keyAccountType = 'accountType';
  static const _keyCreatedAt = 'createdAt';

  static const _keyLanguageIndex = 'languageIndex';

  static Future setProfileImageUrl(String imageUrl) async {
    pref.write(_keyProfileImageUrl, imageUrl);
  }

  static Future getProfileImageUrl() async {
    pref.read(_keyProfileImageUrl);
  }

  static Future setFullName(String fullName) async {
    pref.write(_keyFullName, fullName);
  }

  static Future getFullName() async {
    pref.read(_keyFullName);
  }

  static Future setEmail(String email) async {
    pref.write(_keyEmail, email);
  }

  static Future getEmail() async {
    pref.read(_keyEmail);
  }

  static Future setPassword(String password) async {
    pref.write(_keyPassword, password);
  }

  static Future getPassword() async {
    pref.read(_keyPassword);
  }

  static Future setPhoneNumber(String phoneNumber) async {
    pref.write(_keyPhone, phoneNumber);
  }

  static Future getPhoneNumber() async {
    pref.read(_keyPhone);
  }

  static Future setCity(String city) async {
    pref.write(_keyCity, city);
  }

  static Future getCity() async {
    pref.read(_keyCity);
  }

  static Future setState(String state) async {
    pref.write(_keyState, state);
  }

  static Future getState() async {
    pref.read(_keyState);
  }

  static Future setAddress(String address) async {
    pref.write(_keyAddress, address);
  }

  static Future getAddress() async {
    pref.read(_keyAddress);
  }

  static Future setZip(String zip) async {
    pref.write(_keyZip, zip);
  }

  static Future getZip() async {
    pref.read(_keyZip);
  }

  static Future setAccountType(String accountType) async {
    pref.write(_keyAccountType, accountType);
  }

  static Future getAccountType() async {
    pref.read(_keyAccountType);
  }

  //Used for storing selected application language
  static Future setLanguageIndex(int index) async {
    pref.write(_keyLanguageIndex, index);
  }

  static Future getLanguageIndex() async {
    pref.read(_keyLanguageIndex);
  }
}
