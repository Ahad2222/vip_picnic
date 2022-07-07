import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  bool showSearch = false;


  void showSearchBar() {
    showSearch = !showSearch;
    notifyListeners();
  }
}
