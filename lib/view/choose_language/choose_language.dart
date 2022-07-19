import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/utils/localization.dart';
import 'package:vip_picnic/view/settings/settings.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class ChooseLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseLanguageController>(
      init: ChooseLanguageController(),
      builder: (controller) {
        return Scaffold(
          appBar: settingsAppBar(
            context,
            title: 'selectLanguage'.tr,
          ),
          body: Column(
            children: List.generate(
              controller.languages.length,
                  (index) {
                return ListTile(
                  onTap: () => controller.selectedIndex(
                    index,
                    controller.languages[index],
                  ),
                  title: MyText(
                    text: controller.languages[index],
                    size: 16,
                    color: kSecondaryColor,
                  ),
                  trailing: controller.currentIndex == index
                      ? Icon(Icons.check)
                      : SizedBox(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ChooseLanguageController extends GetxController {
  int currentIndex = 0;

  final List<String> languages = [
    'English',
    'Spanish',
    'Portuguese',
  ];

  void selectedIndex(int index, String lang) {
    currentIndex = index;
    Localization().selectedLocale(lang);
    update();
  }
}
