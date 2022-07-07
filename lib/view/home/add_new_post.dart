import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
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
                horizontal: 15,
                vertical: 10,
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
                          : Image.asset(
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
                  initialValue: title,
                  maxLines: 6,
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Tag people...',
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Location (optional)...',
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
              buttonText: 'publish',
            ),
          ),
        ],
      ),
    );
  }
}
