import 'package:get/get.dart';

class StoryController extends GetxController {
  bool? reaction = false;

  turnOffReactions() {
    reaction = !reaction!;
    update();
  }
}
