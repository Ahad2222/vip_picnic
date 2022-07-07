import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/curved_header.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class EventDetails extends StatelessWidget {
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
                  expandedHeight: 294,
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
                  title: MyText(
                    text: 'Picnic Kids',
                    size: 19,
                    color: kPrimaryColor,
                  ),
                  actions: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 15,
                        ),
                        height: 35,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kDarkBlueColor.withOpacity(0.50),
                        ),
                        child: Center(
                          child: MyText(
                            size: 15,
                            weight: FontWeight.w600,
                            color: kPrimaryColor,
                            text: '1/4',
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: PageView.builder(
                      itemCount: 3,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.asset(
                              Assets.imagesRoamcticePicnic,
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
                        );
                      },
                    ),
                  ),
                ),
                curvedHeader(),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                physics: BouncingScrollPhysics(),
                children: [
                  MyText(
                    text: 'What\'s included?',
                    size: 19,
                    weight: FontWeight.w600,
                  ),
                  MyText(
                    paddingTop: 10,
                    text:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo',
                    size: 14,
                    maxLines: 5,
                    overFlow: TextOverflow.ellipsis,
                    color: kSecondaryColor,
                    paddingBottom: 20,
                  ),
                  Column(
                    children: List.generate(
                      4,
                      (index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            Assets.imagesPerPeople,
                            height: 58.28,
                            width: 58.28,
                            fit: BoxFit.cover,
                          ),
                          title: MyText(
                            text: '02-04 people:',
                            size: 18,
                            color: kSecondaryColor,
                          ),
                          subtitle: MyText(
                            text: '100€ per person',
                            size: 16,
                            color: kLightPurpleColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: MyButton(
                buttonText: 'order now',
                onTap: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
