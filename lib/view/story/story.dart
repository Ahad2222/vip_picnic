import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

// ignore: must_be_immutable
class Story extends StatefulWidget {
  Story({
    Key? key,
    this.profileImage,
    this.name,
  }) : super(key: key);

  String? profileImage, name;

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final StoryController? controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storyItems.add(
      StoryItem.text(
        title: 'Switch APP',
        backgroundColor: kSecondaryColor,
      ),
    );
    storyItems.add(
      StoryItem.pageImage(
        controller: controller!,
        url:
            'https://images.unsplash.com/photo-1648185924254-45a46829c427?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1830&q=80',
        imageFit: BoxFit.cover,
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                Assets.imagesUpperGradient,
                width: width(context, 1.0),
                fit: BoxFit.cover,
              ),
              Image.asset(
                Assets.imagesBottomGradient,
                width: width(context, 1.0),
                fit: BoxFit.cover,
              ),
            ],
          ),
          StoryView(
            storyItems: storyItems,
            controller: controller!,
            // pass controller here too
            repeat: true,
            // should the stories be slid forever
            onStoryShow: (s) {},
            onComplete: () {},
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            }, //
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              profileTile(
                widget.profileImage!,
                widget.name,
                '13 m',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 20,
                            sigmaY: 20,
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            color: const Color(0xff323232).withOpacity(0.50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MyText(
                                  text: '🤔',
                                  size: 28,
                                ),
                                MyText(
                                  text: '👏',
                                  size: 28,
                                ),
                                MyText(
                                  text: '😲',
                                  size: 28,
                                ),
                                MyText(
                                  text: '😂',
                                  size: 28,
                                ),
                                MyText(
                                  text: '😍',
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20,
                          sigmaY: 20,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          color: const Color(0xff323232).withOpacity(0.50),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: kPrimaryColor,
                            style: const TextStyle(
                              fontSize: 15,
                              color: kPrimaryColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                color: kPrimaryColor,
                              ),
                              suffixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Assets.imagesSendIconNew,
                                    height: 24,
                                  ),
                                ],
                              ),
                              hintText: 'Send a message',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget profileTile(
    String profileImage,
    name,
    postedTime,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 55,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              profileImage,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            MyText(
              text: name,
              size: 15,
              weight: FontWeight.w500,
              color: kPrimaryColor,
            ),
            MyText(
              text: postedTime,
              size: 12,
              color: kPrimaryColor,
            ),
          ],
        ),
        trailing: Wrap(
          spacing: 15,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              // onTap: () => Get.to(
              //   () => ControlStoryActions(),
              // ),
              child: Image.asset(
                Assets.imagesMoreHoriz,
                height: 28,
                color: kPrimaryColor,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.close,
                size: 25,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
