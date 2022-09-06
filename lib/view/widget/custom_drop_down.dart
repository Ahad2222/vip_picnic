import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    Key? key,
    required this.heading,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  List items;
  var value;
  String heading;
  ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: '$heading',
            size: 12,
            weight: FontWeight.w600,
            paddingBottom: 8,
            paddingLeft: 5,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: MyText(
                text: heading,
                color: kGreyColor,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<dynamic>(
                      value: item,
                      child: MyText(
                        text: item,
                        size: 12,
                        weight: FontWeight.w500,
                        color: kGreyColor,
                      ),
                    ),
                  )
                  .toList(),
              value: value,
              onChanged: onChanged,
              icon: Icon(
                Icons.arrow_drop_down_sharp,
                color: kGreyColor,
                size: 20,
              ),
              isDense: true,
              isExpanded: true,
              buttonHeight: 50,
              buttonPadding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              buttonDecoration: BoxDecoration(
                boxShadow: [],
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: kBorderColor,
                ),
                color: kPrimaryColor,
              ),
              buttonElevation: 2,
              itemHeight: 40,
              itemPadding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              dropdownMaxHeight: 200,
              dropdownWidth: Get.width * 0.85,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kPrimaryColor,
              ),
              dropdownElevation: 4,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
              offset: const Offset(-2, -5),
            ),
          ),
        ],
      ),
    );
  }
}
