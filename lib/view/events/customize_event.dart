import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/curved_header.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class CustomizeEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverStack(
              children: [
                SliverAppBar(
                  centerTitle: true,
                  expandedHeight: 294,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Image.asset(
                        Assets.imagesArrowBack,
                        height: 22.04,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  title: MyText(
                    text: 'Customize your event',
                    size: 19,
                    color: kPrimaryColor,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Image.asset(
                          Assets.imagesCustomize,
                          height: height(context, 1.0),
                          width: width(context, 1.0),
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          Assets.imagesGradientEffectTwo,
                          height: height(context, 1.0),
                          width: width(context, 1.0),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                curvedHeader(),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                physics: BouncingScrollPhysics(),
                children: [
                  MyText(
                    text: 'How it works?',
                    size: 19,
                    weight: FontWeight.w600,
                    paddingBottom: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: kSecondaryColor,
                        decoration: TextDecoration.none,
                        fontFamily: GoogleFonts.openSans().fontFamily,
                      ),
                      children: [
                        TextSpan(
                          text: 'Book and Payment? ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' Book at least 15 days in advance, with a 50% deposit (transfer) and the remainder on the day of the event.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: kSecondaryColor,
                        decoration: TextDecoration.none,
                        fontFamily: GoogleFonts.openSans().fontFamily,
                      ),
                      children: [
                        TextSpan(
                          text: 'Don\'t found something?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text:
                          ' If you want something that is not on our list, write in the "message field" and we will be happy to make your wish come true.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ETextField(
                    labelText: 'Event type:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Event type',
                            selectedField: ETextField(
                              labelText: 'Event type:',
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
                    labelText: 'Event theme:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Event theme',
                            selectedField: ETextField(
                              labelText: 'Event theme:',
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
                    labelText: 'N° People:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'N° People',
                            selectedField: Column(
                              children: [
                                ETextField(
                                  labelText: 'Adults:',
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ETextField(
                                  labelText: 'Kids:',
                                ),
                              ],
                            ),
                            height: 250,
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
                    labelText: 'Drinks:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Drinks',
                            selectedField: ETextField(
                              labelText: 'Drinks:',
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
                    labelText: 'Food:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Food',
                            selectedField: ETextField(
                              labelText: 'Food:',
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
                    labelText: 'Add-Ons:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Add-Ons',
                            selectedField: ETextField(
                              labelText: 'Add-Ons:',
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
                    labelText: 'Location:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Location',
                            selectedField: ETextField(
                              labelText: 'Location:',
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
                    labelText: 'Date:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Date',
                            selectedField: ETextField(
                              labelText: 'Date:',
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
                    labelText: 'Hour:',
                    isReadOnly: true,
                    isEditAble: true,
                    onEditTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        context: context,
                        builder: (context) {
                          return howItWorkBottomSheet(
                            context,
                            title: 'Hour',
                            selectedField: ETextField(
                              labelText: 'Hour:',
                            ),
                            onSave: () {},
                          );
                        },
                        isScrollControlled: true,
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: MyButton(
                buttonText: 'get free quotations',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget howItWorkBottomSheet(
      BuildContext context, {
        String? title,
        Widget? selectedField,
        double? height = 200,
        VoidCallback? onSave,
      }) {
    return Container(
      height: height,
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
                text: '$title',
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
            buttonText: 'Apply',
          ),
        ],
      ),
    );
  }
}
