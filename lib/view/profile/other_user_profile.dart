import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/config/routes/routes_config.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/i_followed_model/i_followed_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/my_posts.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class OtherUserProfile extends StatelessWidget {
  final UserDetailsModel? otherUserModel;
  OtherUserProfile({this.otherUserModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 570,
              centerTitle: true,
              pinned: true,
              toolbarHeight: 75,
              backgroundColor: kPrimaryColor,
              floating: false,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Image.asset(
                  Assets.imagesArrowBack,
                  height: 22.04,
                ),
              ),
              title: MyText(
                text: 'profile'.tr,
                size: 20,
                color: kSecondaryColor,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    profileImage(context),
                    MyText(
                      text: otherUserModel!.fullName,
                      size: 20,
                      weight: FontWeight.w600,
                      color: kSecondaryColor,
                      align: TextAlign.center,
                      paddingTop: 15,
                    ),
                    MyText(
                      text: '@Username',
                      color: kSecondaryColor,
                      align: TextAlign.center,
                      paddingTop: 5,
                      paddingBottom: 30,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 30.0,
                      children: [
                        eventFollowingFollower(
                          count: 20,
                          title: 'events'.tr,
                        ),
                        Container(
                          height: 15,
                          width: 1,
                          color: kSecondaryColor,
                        ),
                        eventFollowingFollower(
                          count: 563,
                          title: 'following'.tr,
                        ),
                        Container(
                          height: 15,
                          width: 1,
                          color: kSecondaryColor,
                        ),
                        eventFollowingFollower(
                          count: 15,
                          title: 'followers'.tr,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profileButtons(
                          buttonText: 'follow'.tr,
                          onTap: () async {
                            await fs.collection("Accounts").doc(auth.currentUser!.uid).update({
                              "iFollowed": FieldValue.arrayUnion([otherUserModel!.uID]),
                            });
                            await fs.collection("Accounts").doc(otherUserModel!.uID).update({
                              "TheyFollowed": FieldValue.arrayUnion([auth.currentUser!.uid]),
                            });
                            IFollowedModel iFollowedProfile = IFollowedModel(
                              followedId: otherUserModel!.uID,
                              followedName: otherUserModel!.fullName,
                              followedImage: otherUserModel!.profileImageUrl,
                              followedAt: DateTime.now().millisecondsSinceEpoch,
                            );

                            await fs
                                .collection("Accounts")
                                .doc(auth.currentUser!.uid)
                                .collection("iFollowed")
                                .doc(otherUserModel!.uID)
                                .set(iFollowedProfile.toJson());

                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        profileButtons(
                          buttonText: 'message'.tr,
                          onTap: () {},
                        ),
                      ],
                    ),
                    bioBox(
                      bio:
                          'Musician since 2018, available to new events. Love plant and planet 🌱',
                    ),
                  ],
                ),
                collapseMode: CollapseMode.none,
              ),
            ),
          ];
        },
        body: GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            mainAxisExtent: 124,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Image.asset(
              Assets.imagesDummyImg,
              height: height(context, 1.0),
              width: width(context, 1.0),
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget bioBox({
    String? bio,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kSecondaryColor.withOpacity(0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'bio'.tr,
            size: 16,
            weight: FontWeight.w600,
            color: kSecondaryColor,
            paddingBottom: 7,
          ),
          MyText(
            text: bio,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }

  Widget profileButtons({
    String? buttonText,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: kBorderColor,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          splashColor: kSecondaryColor.withOpacity(0.05),
          highlightColor: kSecondaryColor.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Center(
              child: MyText(
                text: buttonText,
                color: kSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget eventFollowingFollower({
    String? title,
    int? count,
  }) {
    return Column(
      children: [
        MyText(
          text: count,
          size: 18,
          weight: FontWeight.w600,
          color: kSecondaryColor,
        ),
        MyText(
          text: title,
          size: 12,
          color: kSecondaryColor,
        )
      ],
    );
  }

  Widget profileImage(
    BuildContext context,
  ) {
    return Center(
      child: Container(
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
            child: Image.network(
              userDetailsModel.profileImageUrl!,
              height: height(context, 1.0),
              width: width(context, 1.0),
              fit: BoxFit.cover,
              // errorBuilder: (context, exception, stackTrace) {
              //   return Image.asset(
              //     "assets/images/add_story.png",
              //     height: 25,
              //   );
              // },
            ),
          ),
        ),
      ),
    );
  }
}
