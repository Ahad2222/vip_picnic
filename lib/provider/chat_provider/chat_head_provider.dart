import 'package:flutter/cupertino.dart';

class ChatHeadProvider with ChangeNotifier {
  bool showSearch = false;

  int currentTab = 0;

  List<String> tabs = [
    'Chat',
    'Groups',
  ];
  List<Widget> tabsData = [
    Container(),
    Container(),
  ];

  void selectedTab(int index){
    currentTab = index;
    notifyListeners();
  }

  void showSearchBar() {
    showSearch = !showSearch;
    notifyListeners();
  }
}
