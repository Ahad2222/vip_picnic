import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/settings/settings.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ReportProblem extends StatelessWidget {
  bool? haveImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: settingsAppBar(
        context,
        title: 'reportProblem'.tr,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kLightBlueColor,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: haveImage!
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/events.png',
                                height: height(context, 1.0),
                                width: width(context, 1.0),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              Assets.imagesUploadPicture,
                              height: 108.9,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: '${'description'.tr}...',
                  maxLines: 6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: MyButton(
              onTap: () {},
              buttonText: 'submit'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
