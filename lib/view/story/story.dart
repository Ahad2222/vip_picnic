import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/model/story_model/story_model.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/story/edit_story.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/my_text.dart';

// ignore: must_be_immutable
class Story extends StatefulWidget {
  Story({
    Key? key,
    this.name,
    this.profileImage,
    this.storyPersonId,
    // this.name,
  }) : super(key: key);

  String? name, profileImage, storyPersonId;

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final StoryController? controller = StoryController();
  List<StoryItem> storyItems = [];
  StoryModel storyModel = StoryModel();
  bool isLoading = false;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = true;
    int twentyFourHourDifferenceMillisecondsSinceEpoch =
        DateTime.now().subtract(Duration(hours: 24)).millisecondsSinceEpoch;
    ffstore
        .collection(storyCollection)
        .where("storyPersonId", isEqualTo: widget.storyPersonId)
        .where("createdAt", isGreaterThan: twentyFourHourDifferenceMillisecondsSinceEpoch)
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      log("before the loop ${value.docs.length}");
      value.docs.forEach((element) {
        log("inside the loop");
        //+Types:
        //+ Image
        //+ Video
        //+ Caption
        //+ ImageWithCaption
        //+ VideoWithCaption
        storyModel = StoryModel.fromJson(element.data());
        if (storyModel.mediaType == "Image") {
          storyItems.add(
            StoryItem.pageImage(
              controller: controller!,
              url: storyModel.storyImage ??
                  "https://images.unsplash.com/photo-1648185924254-45a46829c427?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1830&q=80",
              imageFit: BoxFit.cover,
              duration: const Duration(seconds: 4),
            ),
          );
          log("storyItems in Image: $storyItems");
        } else if (storyModel.mediaType == "ImageWithCaption") {
          log(":in image with caption");
          storyItems.add(StoryItem.pageImage(
            controller: controller!,
            url: storyModel.storyImage ??
                "https://images.unsplash.com/photo-1648185924254-45a46829c427?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1830&q=80",
            caption: storyModel.storyText ?? "",
            imageFit: BoxFit.cover,
            duration: const Duration(seconds: 4),
          ));
          log("storyItems in ImageWithCaption: $storyItems");
        } else if (storyModel.mediaType == "Video") {
          log(":in image with caption");
          storyItems.add(
            StoryItem.pageVideo(
              storyModel.storyVideo ?? "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
              controller: controller!,
              // caption: storyModel.storyText ?? "",
              imageFit: BoxFit.cover,
              duration: Duration(seconds: storyModel.videoDuration ?? 0),
            ),
          );
          log("storyItems in Video: $storyItems");
        } else if (storyModel.mediaType == "VideoWithCaption") {
          log(":in image with caption");
          storyItems.add(
            StoryItem.pageVideo(
              storyModel.storyVideo ?? "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
              controller: controller!,
              caption: storyModel.storyText ?? "",
              imageFit: BoxFit.cover,
              duration: Duration(seconds: storyModel.videoDuration ?? 0),
            ),
          );
          log("storyItems in VideoWithCaption: $storyItems");
        } else {
          storyItems.add(
            StoryItem.text(
              title: storyModel.storyText ?? "",
              backgroundColor: kSecondaryColor,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      });
      log("after the loop");
      isLoading = false;
      setState(() {
        log("setState called");
      });
    });
    // storyItems.add(
    //   StoryItem.text(
    //     title: 'VIP PICNIC',
    //     backgroundColor: kSecondaryColor,
    //   ),
    // );
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
          !isLoading && storyItems.isNotEmpty
              ? StoryView(
                  storyItems: storyItems,
                  controller: controller!,
                  // pass controller here too
                  repeat: false,
                  // should the stories be slid forever
                  onStoryShow: (s) {
                    log("index before: $index");
                    index++;
                    log("index is: $index");
                  },
                  onComplete: () => Get.back(),
                  onVerticalSwipeComplete: (direction) {
                    if (direction == Direction.down) {
                      Navigator.pop(context);
                    }
                  }, //
                )
              : Container(
                  color: Colors.white,
                  child: Center(
                    child: MyText(
                      text: "Loading...",
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              profileTile(
                widget.profileImage!,
                widget.name,
                // '${timeago.}',
                // + Can't be done because we would have to use another streambuilder here
                //+ or can be if we can get the index of story being shown.
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20,
                          sigmaY: 20,
                        ),
                        //+commented the field for now.
                        // child: Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 10,
                        //   ),
                        //   color: const Color(0xff323232).withOpacity(0.50),
                        //   child: TextFormField(
                        //     textAlignVertical: TextAlignVertical.center,
                        //     cursorColor: kPrimaryColor,
                        //     style: const TextStyle(
                        //       fontSize: 15,
                        //       color: kPrimaryColor,
                        //     ),
                        //     decoration: InputDecoration(
                        //       contentPadding: const EdgeInsets.symmetric(
                        //         horizontal: 15,
                        //       ),
                        //       hintStyle: const TextStyle(
                        //         fontSize: 15,
                        //         color: kPrimaryColor,
                        //       ),
                        //       suffixIcon: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Image.asset(
                        //             Assets.imagesSendIconNew,
                        //             height: 24,
                        //           ),
                        //         ],
                        //       ),
                        //       hintText: 'Send a message',
                        //       border: InputBorder.none,
                        //       enabledBorder: InputBorder.none,
                        //       focusedBorder: InputBorder.none,
                        //       errorBorder: InputBorder.none,
                        //       focusedErrorBorder: InputBorder.none,
                        //     ),
                        //   ),
                        // ),
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
    //+ postedTime, //+ commented for now because this may take some extra time and effort.
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
            child: Image.network(
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
            // MyText(
            //   text: postedTime,
            //   size: 12,
            //   color: kPrimaryColor,
            // ),
          ],
        ),
        trailing: Wrap(
          spacing: 15,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (widget.storyPersonId == auth.currentUser?.uid)
              GestureDetector(
                onTap: () {
                  //+ go to page where we list the story docs
                  Get.off(() => EditStory());
                },
                child: SizedBox(
                  height: 60,
                  width: 40,
                  child: const Icon(
                    Icons.mode_edit_outline_outlined,
                    size: 20,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            GestureDetector(
              onTap: () => Get.back(),
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
