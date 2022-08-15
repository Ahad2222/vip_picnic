import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    this.isObSecure = false,
    this.hintText,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.autoValidateMode,
  }) : super(key: key);

  String? hintText;
  bool? isObSecure;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  AutovalidateMode? autoValidateMode;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autoValidateMode,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: isObSecure!,
      obscuringCharacter: '*',
      cursorColor: kSecondaryColor,
      cursorWidth: 1.0,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 19,
        color: kGreyColor,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        fillColor: kPrimaryColor,
        filled: true,
        hintText: '$hintText',
        hintStyle: TextStyle(
          fontSize: 19,
          color: kGreyColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ETextField extends StatelessWidget {
  ETextField({
    Key? key,
    this.isObSecure = false,
    this.labelText,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.isReadOnly = false,
    this.isEditAble = false,
    this.autoValidateMode,
    this.keyboardType,
    this.onEditTap,
  }) : super(key: key);

  String? labelText, initialValue;
  bool? isObSecure, isReadOnly, isEditAble;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  AutovalidateMode? autoValidateMode;
  VoidCallback? onEditTap;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autoValidateMode,
      initialValue: initialValue,
      readOnly: isReadOnly!,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: isObSecure!,
      obscuringCharacter: '*',
      cursorColor: kSecondaryColor,
      cursorWidth: 1.0,
      style: TextStyle(
        fontSize: 16,
        color: kGreyColor,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        fillColor: kPrimaryColor,
        filled: true,
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(
              paddingLeft: 15,
              paddingRight: 10,
              text: labelText,
              size: 19,
              color: kGreyColor,
            ),
          ],
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: isEditAble! ? 50 : 0,
        ),
        suffixIcon: isEditAble!
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onEditTap,
                    child: Image.asset(
                      Assets.imagesEditIcon,
                      height: 16.03,
                    ),
                  ),
                ],
              )
            : SizedBox(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchBar extends StatelessWidget {
  SearchBar({
    Key? key,
    this.controller,
    this.onChanged,
    this.validator,
    this.onSearchTap,
    this.textSize = 14.0,
    this.fillColor = kPrimaryColor,
    this.borderColor = kBorderColor,
    this.isReadOnly = false,
    this.onTap,
  }) : super(key: key);

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  double? textSize;
  Color? fillColor, borderColor;
  bool? isReadOnly;
  FormFieldValidator<String>? validator;
  VoidCallback? onSearchTap;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly!,
      onTap: onTap,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      cursorColor: kSecondaryColor,
      cursorWidth: 1.0,
      style: TextStyle(
        fontSize: textSize,
        color: kSecondaryColor,
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontSize: textSize,
          color: kSecondaryColor,
        ),
        hintText: 'search'.tr,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        fillColor: fillColor,
        filled: true,
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onSearchTap,
              child: Image.asset(
                Assets.imagesSearch,
                height: 18.63,
              ),
            ),
          ],
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: borderColor!,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: borderColor!,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SimpleTextField extends StatelessWidget {
  SimpleTextField({
    Key? key,
    this.hintText,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.haveSuffix = false,
    this.suffix,
    this.maxLines = 1,
  }) : super(key: key);

  String? hintText, initialValue;
  int? maxLines;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  bool? haveSuffix;
  Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      cursorColor: kSecondaryColor,
      cursorWidth: 1.0,
      style: TextStyle(
        fontSize: 19,
        color: kBlackColor.withOpacity(0.40),
      ),
      decoration: InputDecoration(
        suffixIcon: suffix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        fillColor: kPrimaryColor,
        filled: true,
        hintText: '$hintText',
        hintStyle: TextStyle(
          fontSize: 19,
          color: kBlackColor.withOpacity(0.40),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
