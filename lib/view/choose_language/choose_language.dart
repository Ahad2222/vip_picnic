import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/get_storage_data/get_storage_data.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/utils/localization.dart';
import 'package:vip_picnic/view/settings/settings.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class ChooseLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppBar(
        context,
        title: 'selectLanguage'.tr,
      ),
      body: Column(
        children: List.generate(
          languageController.languages.length,
          (index) {
            return Obx(() {
              return ListTile(
                onTap: () => languageController.selectedIndex(
                  index,
                  languageController.languages[index],
                ),
                title: MyText(
                  text: languageController.languages[index],
                  size: 16,
                  color: kSecondaryColor,
                ),
                trailing: languageController.currentIndex.value == index
                    ? Icon(Icons.check)
                    : SizedBox(),
              );
            });
          },
        ),
      ),
    );
  }
}

class ChooseLanguageController extends GetxController {
  static ChooseLanguageController instance =
      Get.find<ChooseLanguageController>();
  RxInt currentIndex = 0.obs;

  final List<String> languages = [
    'English',
    'Spanish',
    'Portuguese',
  ];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    currentIndex.value = await UserSimplePreference.getLanguageIndex() ?? 0;
    Localization().selectedLocale(languages[currentIndex.value]);
    update();
  }

  void selectedIndex(int index, String lang) async {
    currentIndex.value = index;
    await UserSimplePreference.setLanguageIndex(currentIndex.value);
    Localization().selectedLocale(languages[currentIndex.value]);
    update();
  }
}
