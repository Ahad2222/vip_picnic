import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/provider/story_provider/story_provider.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

class ControlStoryActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, StoryProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        Assets.imagesArrowBack,
                        height: 16,
                      ),
                    ),
                    MyText(
                      paddingLeft: 20,
                      text: 'Your Story',
                      size: 18,
                      color: kSecondaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/images/dummy_posts/unsplash__4ZLmHzwARY.png',
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                MyText(
                  text: 'Delete the story',
                  size: 15,
                  paddingTop: 15,
                  color: kSecondaryColor,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: MyText(
                    text: 'Turn off reactions',
                    size: 16,
                    weight: FontWeight.w500,
                    color: kSecondaryColor,
                  ),
                  trailing: Container(
                    width: 43,
                    height: 23,
                    child: FlutterSwitch(
                      value: StoryProvider.reaction!,
                      padding: 2.0,
                      toggleSize: 20.0,
                      borderRadius: 50.0,
                      activeColor: kSecondaryColor,
                      inactiveColor: Color(0xffD1D1D6),
                      onToggle: (val) => StoryProvider.turnOffReactions(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
