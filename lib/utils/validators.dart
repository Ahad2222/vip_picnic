import 'package:get/get.dart';

String? emailValidator(String value) {
  if (!GetUtils.isEmail(value)) {
    return 'emailValidator'.tr;
  }
  return null;
}

String? passwordValidator(String value) {
  if (value.length < 6) {
    return 'passwordValidator'.tr;
  }
  return null;
}

String? emptyFieldValidator(String value) {
  if (value.isEmpty) {
    return 'emptyFieldValidator'.tr;
  }
  return null;
}

String? phoneValidator(String value) {
  if (value.length < 10 || value.length < 9) {
    return 'phoneValidator'.tr;
  }
  return null;
}
