
import 'package:get_storage/get_storage.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';

class UserSimplePreference {
  static final pref = GetStorage();

  static const _keyProfileImageUrl = 'profileImageUrl';
  static const _keyFullName = 'fullName';
  static const _keyEmail = 'email';
  static const _keyUID = 'uID';
  static const _keyPassword = 'password';
  static const _keyPhone = 'phoneNumber';
  static const _keyCity = 'city';
  static const _keyState = 'state';
  static const _keyAddress = 'address';
  static const _keyZip = 'zip';
  static const _keyAccountType = 'accountType';
  static const _keyCreatedAt = 'createdAt';
  static const _keyLanguageIndex = 'languageIndex';
  static const _keyUserData = 'userData';
  static const _videoMessageDocsIdsList = 'videoMessageDocsIdsList';


  static Future setUserData(UserDetailsModel obj) async {
    await pref.write(_keyUserData, obj.toJson());
  }

  static Future getUserData() async {
    return pref.read(_keyUserData);
  }


  static Future setVideoMessageDocsIdsListData(List<String> videoMessageDocsIdsList) async {
    await pref.write(_videoMessageDocsIdsList, videoMessageDocsIdsList);
  }

  static Future getVideoMessageDocsIdsListData() async {
    return pref.read(_videoMessageDocsIdsList);
  }

  static Future setProfileImageUrl(String imageUrl) async {
    pref.write(_keyProfileImageUrl, imageUrl);
  }

  static Future getProfileImageUrl() async {
    await pref.read(_keyProfileImageUrl);
  }

  static Future setFullName(String fullName) async {
    await pref.write(_keyFullName, fullName);
  }

  static Future getFullName() async {
    return pref.read(_keyFullName);
  }

  static Future setEmail(String email) async {
    await pref.write(_keyEmail, email);
  }

  static Future getEmail() async {
    return pref.read(_keyEmail);
  }

  static Future setUID(String uID) async {
    await pref.write(_keyUID, uID);
  }

  static Future getUID() async {
    return pref.read(_keyUID);
  }

  static Future setPassword(String password) async {
    await pref.write(_keyPassword, password);
  }

  static Future getPassword() async {
    return pref.read(_keyPassword);
  }

  static Future setPhoneNumber(String phoneNumber) async {
    await pref.write(_keyPhone, phoneNumber);
  }

  static Future getPhoneNumber() async {
    return pref.read(_keyPhone);
  }

  static Future setCity(String city) async {
    await pref.write(_keyCity, city);
  }

  static Future getCity() async {
    return pref.read(_keyCity);
  }

  static Future setState(String state) async {
    await pref.write(_keyState, state);
  }

  static Future getState() async {
    return pref.read(_keyState);
  }

  static Future setAddress(String address) async {
    await pref.write(_keyAddress, address);
  }

  static Future getAddress() async {
    return pref.read(_keyAddress);
  }

  static Future setZip(String zip) async {
    await pref.write(_keyZip, zip);
  }

  static Future getZip() async {
    return pref.read(_keyZip);
  }

  static Future setAccountType(String accountType) async {
    await pref.write(_keyAccountType, accountType);
  }

  static Future getAccountType() async {
    return pref.read(_keyAccountType);
  }

  static Future setCreatedAt(String createdAt) async {
    await pref.write(_keyCreatedAt, createdAt);
  }

  static Future getCreatedAt() async {
    return pref.read(_keyCreatedAt);
  }

  //Used for storing selected application language
  static Future setLanguageIndex(int index) async {
    await pref.write(_keyLanguageIndex, index);
  }

  static Future getLanguageIndex() async {
    return pref.read(_keyLanguageIndex);
  }

}
