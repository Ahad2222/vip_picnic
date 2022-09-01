import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

Widget bottomSheetForEdit(
  BuildContext context, {
  String? title,
  Widget? selectedField,
  VoidCallback? onSave,
}) {
  return Padding(
    padding: MediaQuery.of(context).viewInsets,
    child: Container(
      height: 200,
      padding: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              MyText(
                text: 'Edit ${title}',
                size: 19,
                color: kSecondaryColor,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  Assets.imagesRoundedClose,
                  height: 22.44,
                ),
              ),
            ],
          ),
          selectedField!,
          MyButton(
            onTap: onSave,
            buttonText: 'Save',
          ),
        ],
      ),
    ),
  );
}
