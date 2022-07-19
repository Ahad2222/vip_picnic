import 'package:get/get.dart';

class UserProvider extends GetxController {
  bool isKeepMeLoggedIn = false;

  void yesKeepLoggedIn() {
    isKeepMeLoggedIn = !isKeepMeLoggedIn;
    update();
  }

  int? selectedAccountTypeIndex;

  void signupAccountType(
      String accountType,
      int index,
      ) {
    selectedAccountTypeIndex = index;
    update();
  }
}
