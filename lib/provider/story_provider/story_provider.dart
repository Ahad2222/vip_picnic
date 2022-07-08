import 'package:flutter/cupertino.dart';

class StoryProvider with ChangeNotifier {
  bool? reaction = false;

  turnOffReactions() {
    reaction = !reaction!;
    notifyListeners();
  }
}
