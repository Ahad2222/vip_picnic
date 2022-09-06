import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventController extends GetxController {
  static EventController instance = Get.find<EventController>();
  RxList<String> vipPackages = [
    'VIP 2 Star\'s Package (2 persons max)',
    'VIP 3 Star\'s Package (10 persons max)',
    'VIP 4 Star\'s Package (15 persons max)',
    'VIP 5 Star\'s Package (24 persons max)',
  ].obs;
  RxList<String> eventTheme = [
    'Picnic Kids',
    'Baby Shower',
    'Communion',
    'Wedding',
    'Birthday Party',
    'Gender Reveal',
    'Proposal Marriage',
    'Romantic Picnic',
    'Mother\'s Day',
  ].obs;
  List<String> eventType = [
    'Indoor',
    'Outdoor',
  ];
  RxList<int> noOfPersons = [for (int i = 1; i <= 100; i++) i].obs;
  RxList<String> foodPref = [
    'None',
    'Non-vegetarian',
    'Vegetarian',
    'Omnivores',
    'Halal',
  ].obs;
  RxList<String> drinkPref = [
    'None',
    'Spring Water',
    'Sparkling Water',
    'Fruit Juice',
    'Soft Drinks',
    'Alcohol',
  ].obs;
  RxList<String> startTime = [
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
  ].obs;

  RxList<String> duration = [
    '1 Hour',
    '2 Hours',
    '3 Hours',
    '4 Hours',
  ].obs;
  RxString selectedVipPackage = 'VIP 2 Star\'s Package (2 persons max)'.obs;
  RxString selectedTheme = 'Picnic Kids'.obs;
  RxString selectedEventType = 'Indoor'.obs;
  RxInt selectedNoOfPeoples = 2.obs;
  RxString selectedFoodPref = 'None'.obs;
  RxString selectedDrinkPref = 'None'.obs;
  RxString selectedStartTime = '11:00 AM'.obs;
  RxString selectedDuration = '1 Hour'.obs;
  RxString selectedEventDate = ''.obs;
  DateTime eventDate = DateTime.now();
  DateFormat? dateFormat;
  RxInt followers = 0.obs;
  RxInt champagne = 0.obs;
  RxInt wine = 0.obs;
  RxInt cake = 0.obs;
  RxInt candles = 0.obs;

  late TextEditingController detailsCon;
  late TextEditingController cityCon;
  late TextEditingController stateCon;
  late TextEditingController zipCon;
  late TextEditingController addressCon;

  void selectPackage(String value) {
    selectedVipPackage.value = value;
    update();
  }

  void selectEventType(String value) {
    selectedEventType.value = value;
    update();
  }

  void selectNoOfPeoples(int value) {
    selectedNoOfPeoples.value = value;
    update();
  }

  void selectFoodPref(String value) {
    selectedFoodPref.value = value;
    update();
  }

  void selectDrinkPref(String value) {
    selectedDrinkPref.value = value;
    update();
  }

  void selectStartTime(String value) {
    selectedStartTime.value = value;
    update();
  }

  void selectDuration(String value) {
    selectedDuration.value = value;
    update();
  }

  void selectEventDate(DateTime value) {
    eventDate = value;
    selectedEventDate.value = DateFormat.yMEd().format(eventDate).toString();
    update();
  }

  void addAddons(String type) {
    switch (type) {
      case 'Flowers':
        {
          followers++;
          update();
        }
        break;
      case 'Champagne':
        {
          champagne++;
          update();
        }
        break;
      case 'Wine':
        {
          wine++;
          update();
        }
        break;
      case 'Cake':
        {
          cake++;
          update();
        }
        break;
      case 'Candles':
        {
          candles++;
          update();
        }
        break;
    }
  }

  void removeAddons(String type) {
    switch (type) {
      case 'Flowers':
        {
          followers--;
          update();
        }
        break;
      case 'Champagne':
        {
          champagne--;
          update();
        }
        break;
      case 'Wine':
        {
          wine--;
          update();
        }
        break;
      case 'Cake':
        {
          cake--;
          update();
        }
        break;
      case 'Candles':
        {
          candles--;
          update();
        }
        break;
    }
  }
}
