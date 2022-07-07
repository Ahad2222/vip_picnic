import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';

class SearchFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 5,
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset(
              Assets.imagesArrowBack,
              height: 22.04,
            ),
          ),
        ),
        title: SearchBar(
          textSize: 16,
          borderColor: Colors.transparent,
          fillColor: kSecondaryColor.withOpacity(0.05),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return SearchTiles(
            profileImage: Assets.imagesDummyImage,
            name: 'Username',
            isFollowed: index.isOdd ? true : false,
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchTiles extends StatelessWidget {
  SearchTiles({
    Key? key,
    this.profileImage,
    this.name,
    this.isFollowed = false,
  }) : super(key: key);

  String? profileImage, name;
  bool? isFollowed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Container(
                height: 38.81,
                width: 38.81,
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
                size: 15,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: kBorderColor,
                        width: 1.0,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(4),
                        splashColor: kSecondaryColor.withOpacity(0.05),
                        highlightColor: kSecondaryColor.withOpacity(0.05),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 3,
                          ),
                          child: MyText(
                            text: isFollowed! ? 'UnFollow' : 'Follow',
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: kBorderColor.withOpacity(0.5),
            margin: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
          ),
        ],
      ),
    );
  }
}
