import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/controller/home_controller/home_controller.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/utils/validators.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
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
      resizeToAvoidBottomInset: false,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SimpleTextField(
                        controller: homeController.descriptionCon,
                        validator: (value) => emptyFieldValidator(value!),
                        hintText: 'Description...',
                        initialValue: title,
                        maxLines: 6,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SimpleTextField(
                        controller: homeController.tagCon,
                        hintText: 'Tag people...',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SimpleTextField(
                        controller: homeController.locationCon,
                        hintText: 'Location (optional)...',
                      ),
                    ],
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
}
