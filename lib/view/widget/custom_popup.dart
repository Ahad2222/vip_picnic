import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class CustomPopup extends StatelessWidget {
  CustomPopup({
    Key? key,
    this.heading,
    this.description,
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);
  String? heading, description;
  VoidCallback? onCancel, onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: '$heading',
                  size: 18,
                  weight: FontWeight.w700,
                  color: kSecondaryColor,
                  align: TextAlign.center,
                  paddingBottom: 20,
                ),
                MyText(
                  size: 13,
                  align: TextAlign.center,
                  paddingBottom: 30,
                  text: '$description',
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        buttonHeight: 40,
                        textSize: 14,
                        iconSize: 10,
                        buttonColor: kGreyColor,
                        showIcon: false,
                        buttonText: 'Cancel',
                        onTap: onCancel,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MyButton(
                        showIcon: false,
                        buttonHeight: 40,
                        textSize: 14,
                        iconSize: 10,
                        buttonText: 'Confirm',
                        onTap: onConfirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
