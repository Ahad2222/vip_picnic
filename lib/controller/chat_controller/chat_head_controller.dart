import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatHeadController extends GetxController {
  static ChatHeadController instance = Get.find<ChatHeadController>();
  bool showSearch = false;

  RxInt currentTab = 0.obs;

  TextEditingController chatHeadSearchController = TextEditingController();
  RxString chatHeadSearchTextObs = "".obs;

  List<String> tabs = [
    'Chat',
    'Groups',
  ];
  List<Widget> tabsData = [
    Container(),
    Container(),
  ];

  void selectedTab(int index){
    currentTab.value = index;
    update();
  }

  void showSearchBar() {
    showSearch = !showSearch;
    update();
  }
}
