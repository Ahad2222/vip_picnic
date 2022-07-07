import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class CreateNewGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(
        title: 'New Group',
        onTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
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
                      child: Image.asset(
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
                  hintText: 'Description...',
                  maxLines: 6,
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Type Username to add...',
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
              buttonText: 'create group',
            ),
          ),
        ],
      ),
    );
  }
}
