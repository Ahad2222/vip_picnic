import 'package:flutter/material.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/home/home.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';

class MyPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'My Posts',
        onTap: () => Navigator.pop(context),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return PostWidget(
            profileImage: Assets.imagesDummyProfileImage,
            name: 'Username',
            postedTime: '11 feb',
            title: 'It was a great event 😀',
            isMyPost: true,
            postImage: Assets.imagesPicnicKids,
          );
        },
      ),
    );
  }
}
