import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(
                currentIndex: 0,
              ),
            ),
            (route) => route.isCurrent,
          );
        },
        title: 'Alerts',
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return NotificationTiles(
            notifyType: index == 0 ? 'follower' : 'simple',
            profileImage: Assets.imagesDummyImage,
            notifyText: index == 1 ? 'Invite to an Event' : 'Invite to a Group',
            time: index == 0 ? 'Today' : '15 March',
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class NotificationTiles extends StatelessWidget {
  NotificationTiles({
    Key? key,
    this.profileImage,
    this.time,
    this.notifyType,
    this.notifyText,
  }) : super(key: key);

  String? profileImage, time, notifyType, notifyText;

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
              onTap: () {},
              leading: notifyType == 'follower'
                  ? Container(
                      height: 48,
                      width: 48,
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
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        profileImage!,
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
              title: MyText(
                text: notifyType == 'follower' ? 'New Follower' : '$notifyText',
                size: 18,
                color: kSecondaryColor,
              ),
              subtitle: MyText(
                text: '$time',
                size: 16,
                color: kLightPurpleColorThree,
              ),
              trailing: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  Assets.imagesClose,
                  height: 25.33,
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: kBorderColor,
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
          ),
        ],
      ),
    );
  }
}
