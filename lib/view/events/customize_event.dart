import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/addon_model/addon_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/curved_header.dart';
import 'package:vip_picnic/view/widget/custom_drop_down.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class CustomizeEvent extends StatefulWidget {
  CustomizeEvent({this.imageUrl, this.des, this.eventTheme});

  String? imageUrl;
  String? des;
  String? eventTheme;

  @override
  State<CustomizeEvent> createState() => _CustomizeEventState();
}

class _CustomizeEventState extends State<CustomizeEvent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventController.nameCon.text = userDetailsModel.fullName!;
    eventController.emailCon.text = userDetailsModel.email!;
    eventController.phoneCon.text = userDetailsModel.phone!;
    eventController.selectEventDate(eventController.eventDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) {
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
                    text: widget.eventTheme,
                    size: 19,
                    color: kPrimaryColor,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Image.network(
                          widget.imageUrl.toString(),
                          height: height(context, 1.0),
                          width: width(context, 1.0),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return loading();
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return loading();
                          },
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
                curvedHeader(paddingTop: 300),
              ],
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                physics: BouncingScrollPhysics(),
                children: [
                  heading('Customize your event'),
                  StreamBuilder<QuerySnapshot>(
                      stream: ffstore.collection(packagesCollection).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }
                        if(snapshot.hasData){
                          if((snapshot.data?.docs.length ?? 0) > 0){
                            List<String>? tempList =
                            List<String>.from(snapshot.data?.docs.map((e) => "${e["name"]} (${e["persons"].toString()} persons max)") ?? []);
                            log("tempList: $tempList");
                            eventController.vipPackages.clear();
                            eventController.vipPackages.add("Select package type");
                            eventController.selectedVipPackage.value = "Select package type";
                            eventController.vipPackages.addAll(tempList);
                          }
                        }

                        // log("snapshot data: ${snapshot.data?.docs[1].data()}");
                        // // String firstCatName = snapshot.data?.docs.first["CategoryName"];
                        // // log("firstCatName: $firstCatName");
                        // Map<String, dynamic> catListMap = snapshot.data?.docs[1].data() as Map<String, dynamic>;
                        // log("catListMap: $catListMap");
                        // List<String>? tempList = List<String>.from(catListMap["categories"].map((e) => e["CategoryName"].toString()));
                        // log("tempList: $tempList");
                        // myList.clear();
                        // myList.add("Select type");
                        // myList.addAll(tempList ?? []);
                        return Obx(() {
                          return CustomDropDown(
                            heading: 'Pack Type',
                            items: eventController.vipPackages,
                            value: eventController.selectedVipPackage.value,
                            onChanged: (value) => eventController.selectPackage(value),
                          );
                        });
                      }),

                  Obx(() {
                    return CustomDropDown(
                      heading: 'Event Type',
                      items: eventController.eventType,
                      value: eventController.selectedEventType.value,
                      onChanged: (value) => eventController.selectEventType(value),
                    );
                  }),
                  Obx(() {
                    return CustomDropDown(
                      heading: 'Number of Persons',
                      items: eventController.noOfPersons,
                      value: eventController.selectedNoOfPeoples.value,
                      onChanged: (value) => eventController.selectNoOfPeoples(value),
                    );
                  }),
                  Obx(() {
                    return CustomDropDown(
                      heading: 'Food Preference',
                      items: eventController.foodPref,
                      value: eventController.selectedFoodPref.value,
                      onChanged: (value) => eventController.selectFoodPref(value),
                    );
                  }),
                  Obx(() {
                    return CustomDropDown(
                      heading: 'Drinks Preference',
                      items: eventController.drinkPref,
                      value: eventController.selectedDrinkPref.value,
                      onChanged: (value) => eventController.selectDrinkPref(value),
                    );
                  }),
                  Obx(() {
                    return CustomDropDown(
                      heading: 'Start Time',
                      items: eventController.startTime,
                      value: eventController.selectedStartTime.value,
                      onChanged: (value) => eventController.selectStartTime(value),
                    );
                  }),
                  Obx(() {
                    return CustomDropDown(
                      heading: 'Duration',
                      items: eventController.duration,
                      value: eventController.selectedDuration.value,
                      onChanged: (value) => eventController.selectDuration(value),
                    );
                  }),
                  MyText(
                    text: 'Event Date',
                    size: 12,
                    weight: FontWeight.w600,
                    paddingBottom: 8,
                    paddingLeft: 5,
                  ),
                  Obx(() {
                    return Container(
                      height: 52,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: kBorderColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyText(
                              text: eventController.selectedEventDate.value,
                              size: 12,
                              weight: FontWeight.w500,
                              color: kGreyColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              // elevation: 4,
                              context: context,
                              builder: (_) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      child: Container(
                                        height: 300,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            MyText(
                                              paddingLeft: 15,
                                              paddingTop: 10,
                                              text: 'Select Event Date',
                                              size: 16,
                                              align: TextAlign.center,
                                              weight: FontWeight.w600,
                                            ),
                                            Expanded(
                                              child: CupertinoTheme(
                                                data: CupertinoThemeData(
                                                  textTheme: CupertinoTextThemeData(
                                                    dateTimePickerTextStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: kBlackColor,
                                                    ),
                                                  ),
                                                  scaffoldBackgroundColor: Colors.transparent,
                                                  primaryColor: Colors.red,
                                                ),
                                                child: CupertinoDatePicker(
                                                    initialDateTime: eventController.eventDate,
                                                    mode: CupertinoDatePickerMode.date,
                                                    backgroundColor: kPrimaryColor,
                                                    minimumYear: 1900,
                                                    maximumYear: DateTime.now().year,
                                                    onDateTimeChanged: (value) =>
                                                        eventController.selectEventDate(value)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 10,
                                              ),
                                              child: MyButton(
                                                onTap: () => Navigator.pop(context),
                                                buttonText: 'Done',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Image.asset(
                              Assets.imagesDatePicker,
                              height: 15.0,
                              color: kGreyColor,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    );
                  }),
                  MyText(
                    paddingTop: 15,
                    text: 'Details',
                    size: 12,
                    weight: FontWeight.w600,
                    paddingBottom: 8,
                    paddingLeft: 5,
                  ),
                  SimpleTextField(
                    hintText: 'Write details about your event in a brief',
                    maxLines: 6,
                    textSize: 12,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  heading('Addons'),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: ffstore.collection(addonsCollection).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      //log("inside stream-builder");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        log("inside stream-builder in waiting state");
                        return SizedBox();
                      } else if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('Some unknown error occurred');
                        } else if (snapshot.hasData) {
                          // log("inside hasData and ${snapshot.data!.docs}");
                          if (snapshot.data!.docs.length > 0) {
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data?.docs.length ?? 0,
                              itemBuilder: (context, index) {
                                AddonModel addonsModel =
                                    AddonModel.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                                // var eventData = events[index];
                                return AddOnsTiles(
                                  productImage: addonsModel.image ?? "",
                                  productName: addonsModel.name ?? "",
                                  price: addonsModel.price.toString(),
                                  perPrice: addonsModel.unit ?? "",
                                  // quantity: eventController.followers.value,
                                  // onIncrease: () => eventController.addAddons('Flowers'),
                                  // onDecrease: () => eventController.removeAddons('Flowers'),
                                );
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          log("in else of hasData done and: ${snapshot.connectionState} and"
                              " snapshot.hasData: ${snapshot.hasData}");
                          return SizedBox();
                        }
                      } else {
                        log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                        return SizedBox();
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Obx(() {
                  //   return AddOnsTiles(
                  //     productImage: 'https://www.vippicnic.com/img/addons/flowers.jpg',
                  //     productName: 'Flowers',
                  //     price: '120',
                  //     perPrice: 'set',
                  //     quantity: eventController.followers.value,
                  //     onIncrease: () => eventController.addAddons('Flowers'),
                  //     onDecrease: () => eventController.removeAddons('Flowers'),
                  //   );
                  // }),
                  // Obx(() {
                  //   return AddOnsTiles(
                  //     productImage: 'https://www.vippicnic.com/img/addons/champagne.PNG',
                  //     productName: 'Champagne',
                  //     price: '70',
                  //     perPrice: 'Bottle',
                  //     quantity: eventController.champagne.value,
                  //     onIncrease: () => eventController.addAddons('Champagne'),
                  //     onDecrease: () => eventController.removeAddons('Champagne'),
                  //   );
                  // }),
                  // Obx(() {
                  //   return AddOnsTiles(
                  //     productImage: 'https://www.vippicnic.com/img/addons/wine.PNG',
                  //     productName: 'Wine',
                  //     price: '45',
                  //     perPrice: 'Bottle',
                  //     quantity: eventController.wine.value,
                  //     onIncrease: () => eventController.addAddons('Wine'),
                  //     onDecrease: () => eventController.removeAddons('Wine'),
                  //   );
                  // }),
                  // Obx(() {
                  //   return AddOnsTiles(
                  //     productImage: 'https://www.vippicnic.com/img/addons/cake.PNG',
                  //     productName: 'Cake',
                  //     price: '150',
                  //     perPrice: 'Piece',
                  //     quantity: eventController.cake.value,
                  //     onIncrease: () => eventController.addAddons('Cake'),
                  //     onDecrease: () => eventController.removeAddons('Cake'),
                  //   );
                  // }),
                  // Obx(() {
                  //   return AddOnsTiles(
                  //     productImage: 'https://www.vippicnic.com/img/addons/candles.PNG',
                  //     productName: 'Candles',
                  //     price: '30',
                  //     perPrice: 'Set',
                  //     quantity: eventController.candles.value,
                  //     onIncrease: () => eventController.addAddons('Candles'),
                  //     onDecrease: () => eventController.removeAddons('Candles'),
                  //   );
                  // }),
                  SizedBox(
                    height: 10,
                  ),
                  heading('Personal Info'),
                  ETextField(
                    controller: eventController.nameCon,
                    labelText: 'Your Name:',
                    isEditAble: false,
                    textSize: 12,
                    labelSize: 14,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: ETextField(
                      controller: eventController.emailCon,
                      labelText: 'Email:',
                      isEditAble: false,
                      textSize: 12,
                      labelSize: 14,
                    ),
                  ),
                  ETextField(
                    controller: eventController.phoneCon,
                    labelText: 'Phone:',
                    isEditAble: false,
                    textSize: 12,
                    labelSize: 14,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  heading('Event Location'),
                  ETextField(
                    controller: eventController.cityCon,
                    labelText: 'City:',
                    isEditAble: false,
                    textSize: 12,
                    labelSize: 14,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: eventController.stateCon,
                    labelText: 'State:',
                    isEditAble: false,
                    textSize: 12,
                    labelSize: 14,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: eventController.zipCon,
                    labelText: 'Zip:',
                    isEditAble: false,
                    textSize: 12,
                    labelSize: 14,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ETextField(
                    controller: eventController.addressCon,
                    labelText: 'Address:',
                    isEditAble: false,
                    textSize: 12,
                    labelSize: 14,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: MyButton(
                buttonText: 'get free quotations',
                onTap: () => eventController.uploadData(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyText heading(String heading) {
    return MyText(
      text: heading,
      size: 19,
      weight: FontWeight.w600,
      paddingBottom: 20,
    );
  }

  Widget howItWorkBottomSheet(
    BuildContext context, {
    String? title,
    Widget? selectedField,
    double? height = 200,
    VoidCallback? onSave,
  }) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
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
      ),
    );
  }
}
// ETextField(
//   labelText: 'Event type:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Event type',
//           selectedField: ETextField(
//             labelText: 'Event type:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'Event theme:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Event theme',
//           selectedField: ETextField(
//             labelText: 'Event theme:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'N° People:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'N° People',
//           selectedField: Column(
//             children: [
//               ETextField(
//                 labelText: 'Adults:',
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               ETextField(
//                 labelText: 'Kids:',
//               ),
//             ],
//           ),
//           height: 250,
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'Drinks:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Drinks',
//           selectedField: ETextField(
//             labelText: 'Drinks:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'Food:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Food',
//           selectedField: ETextField(
//             labelText: 'Food:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'Add-Ons:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Add-Ons',
//           selectedField: ETextField(
//             labelText: 'Add-Ons:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'Location:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Location',
//           selectedField: ETextField(
//             labelText: 'Location:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'Date:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Date',
//           selectedField: ETextField(
//             labelText: 'Date:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 15,
// ),
// ETextField(
//   labelText: 'Hour:',
//   isReadOnly: true,
//   isEditAble: true,
//   onEditTap: () {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       context: context,
//       builder: (context) {
//         return howItWorkBottomSheet(
//           context,
//           title: 'Hour',
//           selectedField: ETextField(
//             labelText: 'Hour:',
//           ),
//           onSave: () {},
//         );
//       },
//       isScrollControlled: true,
//     );
//   },
// ),
// SizedBox(
//   height: 20,
// ),
// MyText(
//   text: 'How it works?',
//   size: 19,
//   weight: FontWeight.w600,
//   paddingBottom: 10,
// ),
// MyText(
//   paddingTop: 10,
//   text: des,
//   size: 14,
//   overFlow: TextOverflow.ellipsis,
//   color: kSecondaryColor,
//   paddingBottom: 20,
// ),
// RichText(
//   text: TextSpan(
//     style: TextStyle(
//       fontSize: 14,
//       color: kSecondaryColor,
//       decoration: TextDecoration.none,
//       fontFamily: GoogleFonts.openSans().fontFamily,
//     ),
//     children: [
//       TextSpan(
//         text: 'Book and Payment? ',
//         style: TextStyle(
//           decoration: TextDecoration.underline,
//         ),
//       ),
//       TextSpan(
//         text:
//             'Book at least 15 days in advance, with a 50% deposit (transfer) and the remainder on the day of the event.',
//       ),
//     ],
//   ),
// ),
// SizedBox(
//   height: 20,
// ),
// RichText(
//   text: TextSpan(
//     style: TextStyle(
//       fontSize: 14,
//       color: kSecondaryColor,
//       decoration: TextDecoration.none,
//       fontFamily: GoogleFonts.openSans().fontFamily,
//     ),
//     children: [
//       TextSpan(
//         text: 'Don\'t found something?',
//         style: TextStyle(
//           decoration: TextDecoration.underline,
//         ),
//       ),
//       TextSpan(
//         text:
//             ' If you want something that is not on our list, write in the "message field" and we will be happy to make your wish come true.',
//       ),
//     ],
//   ),
// ),
// SizedBox(
//   height: 20,
// ),

class AddOnsTiles extends StatelessWidget {
  AddOnsTiles({
    Key? key,
    required this.productImage,
    required this.productName,
    required this.price,
    required this.perPrice,
    // required this.quantity,
    // required this.onIncrease,
    // required this.onDecrease,
  }) : super(key: key);

  String productImage, productName, price, perPrice;

  RxInt quantity = 0.obs;
  // VoidCallback onIncrease, onDecrease;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        child: Image.network(
          '$productImage',
          height: 45,
          width: 45,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Container(
              width: 30,
              height: 30,
              child: loading(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 30,
              height: 30,
              child: loading(),
            );
          },
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      title: MyText(
        text: '$productName',
        size: 14,
        weight: FontWeight.w500,
      ),
      subtitle: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          MyText(
            text: '€ $price',
            size: 12,
            weight: FontWeight.w600,
          ),
          MyText(
            text: ' / $perPrice',
            size: 12,
          ),
        ],
      ),
      trailing: Container(
        height: 45,
        width: 80,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1.0,
                    color: kBorderColor,
                  ),
                ),
                child: Center(
                  child: Obx(() {
                    return MyText(
                      text: '$quantity',
                      //'${eventController.addonsMap.containsKey(productName) ? eventController.addonsMap[productName] : 0}',
                      size: 18,
                      weight: FontWeight.w600,
                    );
                  }),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    quantity++;
                    if (quantity == 1) {
                      eventController.addonsMap.putIfAbsent(productName, () => quantity.value);
                      log("updated addons map in if of increase: ${eventController.addonsMap}");
                    } else {
                      eventController.addonsMap.update(productName, (value) => quantity.value);
                      log("updated addons map in else of increase: ${eventController.addonsMap}");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: kTertiaryColor,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (quantity > 0) quantity--;
                    if (quantity == 0) {
                      eventController.addonsMap.remove(productName);
                      log("updated addons map in if of decrease: ${eventController.addonsMap}");
                    } else {
                      eventController.addonsMap.update(productName, (value) => value--);
                      log("updated addons map in else of decrease: ${eventController.addonsMap}");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: kTertiaryColor,
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 18,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
