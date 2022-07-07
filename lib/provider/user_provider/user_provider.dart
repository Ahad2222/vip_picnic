import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  bool isKeepMeLoggedIn = false;

  void yesKeepLoggedIn() {
    isKeepMeLoggedIn = !isKeepMeLoggedIn;
    notifyListeners();
  }

  int? selectedAccountTypeIndex;

  void signupAccountType(
    String accountType,
    int index,
  ) {
    selectedAccountTypeIndex = index;
    notifyListeners();
  }
}
