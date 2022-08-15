import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/utils/validators.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

// ignore: must_be_immutable
class AddNewPost extends StatelessWidget {
  AddNewPost({
    this.editPost = false,
    this.postImage,
    this.title,
  });

  bool? editPost;
  String? postImage, title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: editPost! ? 'Edit Post' : 'New Post',
        onTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              children: [
                Container(
                  height: 220,
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kLightBlueColor,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: editPost! ? () {} : () {},
                      borderRadius: BorderRadius.circular(16),
                      child: editPost!
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                postImage!,
                                height: height(context, 1.0),
                                width: width(context, 1.0),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Obx(() {
                              return GestureDetector(
                                onTap: () => homeController.pickImages(context),
                                child: homeController.selectedImages.isNotEmpty
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              File(
                                                homeController
                                                    .selectedImages[0].path,
                                              ),
                                              height: Get.height,
                                              width: Get.width,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  homeController.removeImage(0),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 20,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Image.asset(
                                        Assets.imagesUploadPicture,
                                        height: 108.9,
                                        fit: BoxFit.cover,
                                      ),
                              );
                            }),
                    ),
                  ),
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      homeController.selectedImages.isEmpty
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              height: 100,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: homeController.selectedImages.length,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 7,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(
                                              homeController
                                                  .selectedImages[index].path,
                                            ),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () => homeController
                                                .removeImage(index),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 15,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  );
                }),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: SimpleTextField(
                    controller: homeController.descriptionCon,
                    validator: (value) => emptyFieldValidator(value!),
                    hintText: 'Description...',
                    initialValue: title,
                    maxLines: 6,
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 15,
                //   ),
                //   child: SimpleTextField(
                //     controller: homeController.tagCon,
                //     hintText: 'Tag people...',
                //     haveSuffix: true,
                //     suffix: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Container(
                //           width: 130,
                //           height: 38,
                //           child: tagPeopleBox(
                //             radius: 14.0,
                //             onTap: () {},
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                //   stream: fs
                //       .collection("Accounts")
                //       .doc(userDetailsModel.uID)
                //       .collection('iFollowed')
                //       .snapshots(),
                //   builder: (
                //     BuildContext context,
                //     AsyncSnapshot<QuerySnapshot> snapshot,
                //   ) {
                //     log("inside stream-builder");
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       log("inside stream-builder in waiting state");
                //       return Center(child: CircularProgressIndicator());
                //     } else if (snapshot.connectionState ==
                //             ConnectionState.active ||
                //         snapshot.connectionState == ConnectionState.done) {
                //       if (snapshot.hasError) {
                //         return const Text('Some unknown error occurred');
                //       } else if (snapshot.hasData) {
                //         // log("inside hasData and ${snapshot.data!.docs}");
                //         if (snapshot.data!.docs.length > 0) {
                //           return SizedBox(
                //             height: 45,
                //             child: ListView.builder(
                //               physics: BouncingScrollPhysics(),
                //               padding: EdgeInsets.symmetric(
                //                 horizontal: 7,
                //               ),
                //               scrollDirection: Axis.horizontal,
                //               itemCount: snapshot.data!.docs.length,
                //               itemBuilder: (context, index) {
                //                 UserDetailsModel obj =
                //                     UserDetailsModel.fromJson(
                //                   snapshot.data!.docs[index].data()
                //                       as Map<String, dynamic>,
                //                 );
                //                 return tagPeopleBox(
                //                   personName: obj.fullName,
                //                   id: obj.uID,
                //                 );
                //               },
                //             ),
                //           );
                //         } else {
                //           return Center(child: const Text('No Users Found'));
                //         }
                //       } else {
                //         log("in else of hasData done and: ${snapshot.connectionState} and"
                //             " snapshot.hasData: ${snapshot.hasData}");
                //         return Center(child: const Text('No Users Found'));
                //       }
                //     } else {
                //       log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                //       return Center(
                //           child: Text(
                //               'Some Error occurred while fetching the posts'));
                //     }
                //   },
                // ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: SimpleTextField(
                    controller: homeController.locationCon,
                    hintText: 'Location (optional)...',
                  ),
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
              onTap: () => homeController.uploadPost(context),
              buttonText: 'publish',
            ),
          ),
        ],
      ),
    );
  }

  Widget tagPeopleBox({
    String? id,
    String? personName,
    bool? isSelected = false,
    double? radius = 50.0,
    int? index,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 7,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: isSelected! ? kTertiaryColor : kGreyColor.withOpacity(0.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          splashColor: kPrimaryColor.withOpacity(0.1),
          highlightColor: kPrimaryColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  paddingLeft: 10,
                  paddingRight: 5,
                  text: personName,
                  size: 16,
                  color: isSelected ? kPrimaryColor : kBlackColor,
                ),
                Icon(
                  isSelected ? Icons.close : Icons.check,
                  color: isSelected ? kPrimaryColor : kBlackColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
