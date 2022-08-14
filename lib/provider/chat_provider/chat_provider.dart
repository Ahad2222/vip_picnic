import 'package:get/get.dart';

class ChatProvider extends GetxController {
  RxBool showSearch = false.obs;


  void showSearchBar() {
    showSearch.value = !showSearch.value;
  }
}
