import 'package:get/get.dart';

class ChatController extends GetxController {
  bool showSearch = false;

  void showSearchBar() {
    showSearch = !showSearch;
    update();
  }
}
