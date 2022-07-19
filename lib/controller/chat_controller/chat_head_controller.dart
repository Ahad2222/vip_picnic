import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatHeadController extends GetxController {
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
    update();
  }

  void showSearchBar() {
    showSearch = !showSearch;
    update();
  }
}
