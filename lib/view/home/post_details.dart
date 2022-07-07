import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/curved_header.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

// ignore: must_be_immutable
class PostDetails extends StatelessWidget {
  PostDetails({
    this.postImage,
  });

  String? postImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverStack(
              children: [
                SliverAppBar(
                  centerTitle: true,
                  expandedHeight: 400,
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
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Image.asset(
                          postImage!,
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
                curvedHeader(
                  paddingTop: 410,
                ),
              ],
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 30.0,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      Image.asset(
                        Assets.imagesHeart,
                        height: 20.89,
                      ),
                      MyText(
                        text: '12',
                        size: 18,
                        color: kDarkBlueColor.withOpacity(0.60),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      Image.asset(
                        Assets.imagesComment,
                        height: 23.76,
                      ),
                      MyText(
                        text: '32',
                        size: 18,
                        color: kDarkBlueColor.withOpacity(0.60),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.0,
                    children: [
                      Image.asset(
                        Assets.imagesShare,
                        height: 25.23,
                      ),
                      MyText(
                        text: '04',
                        size: 18,
                        color: kDarkBlueColor.withOpacity(0.60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return CommentsTiles(
                    profileImage: Assets.imagesDummyImage,
                    name:
                        index == 1 ? 'Invite to an Event' : 'Invite to a Group',
                    comment: 'Good eye for details.',
                  );
                },
              ),
            ),
            commentField(),
          ],
        ),
      ),
    );
  }

  Widget commentField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: kSecondaryColor,
              cursorWidth: 1.0,
              style: TextStyle(
                fontSize: 15,
                color: kSecondaryColor,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: kSecondaryColor,
                ),
                hintText: 'Write a message...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                fillColor: kLightBlueColor,
                filled: true,
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        Assets.imagesEmoji,
                        height: 19.31,
                      ),
                    ),
                  ],
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.transparent,
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
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Image.asset(
            Assets.imagesSend,
            height: 45.16,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CommentsTiles extends StatelessWidget {
  CommentsTiles({
    Key? key,
    this.profileImage,
    this.comment,
    this.name,
  }) : super(key: key);

  String? profileImage, comment, name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 0,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () {},
              leading: Container(
                height: 44.45,
                width: 44.45,
                padding: EdgeInsets.all(3),
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
                      profileImage!,
                      height: height(context, 1.0),
                      width: width(context, 1.0),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              title: MyText(
                text: '$name',
                size: 16,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              subtitle: MyText(
                text: '$comment',
                size: 14,
                color: kSecondaryColor,
                paddingTop: 4,
              ),
              trailing: Wrap(
                spacing: 13,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      Assets.imagesComment,
                      height: 20.86,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      Assets.imagesHeart,
                      height: 18.34,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
