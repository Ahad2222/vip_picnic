
import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/edit_bottom_sheet.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        onTap: () => Navigator.pop(context),
        title: 'Edit Account',
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        children: [
          pickProfileImage(context),
          MyText(
            paddingTop: 15,
            paddingBottom: 40,
            align: TextAlign.center,
            text: 'Username',
            size: 20,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
          ETextField(
            labelText: 'Name:',
            initialValue: 'current name',
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Name',
                    selectedField: ETextField(
                      labelText: 'Name:',
                    ),
                    onSave: () {},
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Bio:',
            initialValue: 'Current Bio',
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Bio',
                    selectedField: ETextField(
                      labelText: 'Bio:',
                    ),
                    onSave: () {},
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Date of Birth:',
            initialValue: 'Current Date of Birth',
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Date of Birth',
                    selectedField: ETextField(
                      labelText: 'Date of Birth:',
                    ),
                    onSave: () {},
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Email:',
            initialValue: 'Current Email',
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Email',
                    selectedField: ETextField(
                      labelText: 'Email:',
                    ),
                    onSave: () {},
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Phone:',
            initialValue: 'Current Phone Number',
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Phone',
                    selectedField: ETextField(
                      labelText: 'Phone:',
                    ),
                    onSave: () {},
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Address:',
            initialValue: 'Current Address',
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Address',
                    selectedField: ETextField(
                      labelText: 'Address:',
                    ),
                    onSave: () {},
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          ETextField(
            labelText: 'Password:',
            initialValue: 'Current Password',
            isReadOnly: true,
            isEditAble: true,
            onEditTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return bottomSheetForEdit(
                    context,
                    title: 'Password',
                    selectedField: ETextField(
                      labelText: 'Password:',
                    ),
                    onSave: () {},
                  );
                },
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
    );
  }


  Widget pickProfileImage(
    BuildContext context,
  ) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 128,
            width: 128,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.16),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  Assets.imagesDummyProfileImage,
                  height: height(context, 1.0),
                  width: width(context, 1.0),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              Assets.imagesAdd,
              height: 37.22,
            ),
          ),
        ],
      ),
    );
  }
}
