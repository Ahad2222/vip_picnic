import 'package:flutter/material.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/home/add_new_post.dart';
import 'package:vip_picnic/view/home/post_details.dart';
import 'package:vip_picnic/view/profile/profile.dart';
import 'package:vip_picnic/view/search_friends/search_friends.dart';
import 'package:vip_picnic/view/story/post_new_story.dart';
import 'package:vip_picnic/view/story/story.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        leadingWidth: 85,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Profile(),
                ),
              ),
              child: Container(
                height: 54,
                width: 54,
                padding: EdgeInsets.all(4),
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
            ),
          ],
        ),
        title: MyText(
          text: 'Welcome',
          size: 20,
          color: kSecondaryColor,
        ),
        bottom: PreferredSize(
          preferredSize: Size(0, 70),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: SearchBar(
              isReadOnly: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchFriends(),
                ),
              ),
              textSize: 16,
              borderColor: Colors.transparent,
              fillColor: kSecondaryColor.withOpacity(0.05),
            ),
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        children: [
          SizedBox(
            height: 80,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                addStoryButton(context),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return stories(
                      context,
                      index.isOdd
                          ? 'assets/images/baby_shower.png'
                          : 'assets/images/baby_shower.png',
                      index.isOdd ? 'Khan' : 'Stephan',
                      index,
                    );
                  },
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: 30,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return PostWidget(
                profileImage: Assets.imagesDummyProfileImage,
                name: 'Username',
                postedTime: '11 feb',
                title: 'It was a great event 😀',
                isMyPost: index.isOdd ? true : false,
                postImage: Assets.imagesPicnicKids,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          AppLinks.addNewPost,
        ),
        elevation: 5,
        highlightElevation: 1,
        splashColor: kPrimaryColor.withOpacity(0.1),
        backgroundColor: kSecondaryColor,
        child: Image.asset(
          Assets.imagesPlusIcon,
          height: 22.68,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  Widget stories(
    BuildContext context,
    String profileImage,
    name,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Story(
              profileImage: profileImage,
              name: name,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.imagesStoryBg,
                  height: 55,
                  width: 55,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    profileImage,
                    height: 47,
                    width: 47,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            MyText(
              text: name,
              size: 12,
              weight: FontWeight.w600,
              color: kSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget addStoryButton(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 7,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostNewStory(),
              ),
            ),
            child: Image.asset(
              Assets.imagesAddStory,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
          MyText(
            text: 'Add story',
            size: 12,
            weight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  PostWidget({
    Key? key,
    this.profileImage,
    this.name,
    this.postedTime,
    this.title,
    this.postImage,
    this.isMyPost = false,
  }) : super(key: key);

  String? profileImage, name, postedTime, title, postImage;

  bool? isMyPost;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Profile(
                        isMyProfile: isMyPost! ? true : false,
                      ),
                    ),
                  ),
                  child: Container(
                    height: 54,
                    width: 54,
                    padding: EdgeInsets.all(4),
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
                ),
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    MyText(
                      text: isMyPost! ? 'Your Post' : '$name',
                      size: 17,
                      weight: FontWeight.w600,
                      color: kSecondaryColor,
                      paddingBottom: 4,
                    ),
                    MyText(
                      text: '  •  $postedTime',
                      size: 15,
                      weight: FontWeight.w600,
                      color: kSecondaryColor.withOpacity(0.40),
                    ),
                  ],
                ),
                subtitle: MyText(
                  text: '$title',
                  size: 18,
                  color: kSecondaryColor,
                ),
                trailing: isMyPost!
                    ? PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: MyText(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddNewPost(
                                      editPost: true,
                                      postImage: postImage,
                                      title: title,
                                    ),
                                  ),
                                ),
                                text: 'Edit Post',
                                size: 14,
                                color: kSecondaryColor,
                              ),
                            ),
                            PopupMenuItem(
                              child: MyText(
                                text: 'Delete Post',
                                size: 14,
                                color: kSecondaryColor,
                              ),
                            ),
                          ];
                        },
                        child: Icon(
                          Icons.more_vert,
                          color: kDarkBlueColor.withOpacity(0.60),
                          size: 30,
                        ),
                      )
                    : SizedBox(),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostDetails(
                      postImage: postImage,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    postImage!,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20.0,
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: kDarkBlueColor.withOpacity(0.14),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
