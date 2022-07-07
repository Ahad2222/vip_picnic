import 'package:flutter/material.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/events/event_details.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class PicnicPackages extends StatelessWidget {
  final List<Map<String, dynamic>> picnicPackages = [
    {
      'packageType': 'Picnic Kids',
      'thumbnail': Assets.imagesPicnicKids,
    },
    {
      'packageType': 'Romantic picnic',
      'thumbnail': Assets.imagesRoamcticePicnic,
    },
    {
      'packageType': 'Birthday picnic',
      'thumbnail': Assets.imagesBirthdayPicnic,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Picnic Packages',
        onTap: () => Navigator.pop(context),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        itemCount: picnicPackages.length,
        itemBuilder: (context, index) {
          var packagesData = picnicPackages[index];
          return Container(
            height: 130,
            margin: EdgeInsets.only(
              bottom: 30,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    '${packagesData['thumbnail']}',
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: '${packagesData['packageType']}',
                        size: 19,
                        color: kSecondaryColor,
                        paddingBottom: 10,
                      ),
                      Row(
                        children: [
                          MaterialButton(
                            height: 44,
                            elevation: 0,
                            highlightElevation: 0,
                            color: kSecondaryColor,
                            splashColor: kPrimaryColor.withOpacity(0.1),
                            highlightColor: kPrimaryColor.withOpacity(0.1),
                            shape: StadiumBorder(),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetails(),
                              ),
                            ),
                            child: Center(
                              child: MyText(
                                text: 'see details'.toUpperCase(),
                                size: 16,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
