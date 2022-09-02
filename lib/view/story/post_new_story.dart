import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/model/story_model/story_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/home/post_video_preview_from_file.dart';
import 'package:vip_picnic/view/widget/height_width.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/my_button.dart';
import 'package:vip_picnic/view/widget/my_text.dart';
import 'package:vip_picnic/view/widget/my_textfields.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

// ignore: must_be_immutable
class PostNewStory extends StatelessWidget {
  TextEditingController descriptionController = TextEditingController();

  File? pickedImage;
  RxString pickedImagePath = "".obs;
  String storyImageUrl = "";
  List<String> imagesToUpload = [];
  RxList selectedImages = [].obs;
  // XFile? selectedVideo;
  RxList selectedVideos = [].obs;
  RxList selectedVideosThumbnails = [].obs;
  List<String> thumbnailsUrls = [];
  List<String> videoIds = [];

  int? videoDuration = 0;

  // Future pickImage(BuildContext context, ImageSource source) async {
  //   try {
  //     final img = await ImagePicker().pickImage(
  //       source: source,
  //     );
  //     if (img == null)
  //       return;
  //     else {
  //       pickedImage = File(img.path);
  //       pickedImagePath.value = img.path;
  //       Get.back();
  //       // update();
  //     }
  //   } on PlatformException catch (e) {
  //     showMsg(
  //       msg: e.message,
  //       bgColor: Colors.red,
  //       context: context,
  //     );
  //   }
  // }

  Future pickImage(BuildContext context) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      Get.back();

      if (image != null) {
        selectedImages.insert(0, image);
      } else {
        return [].obs;
      }
    } on PlatformException catch (e) {
      showMsg(
        msg: e.message,
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  Future pickVideo(BuildContext context) async {
    try {
      XFile? videoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      Get.back();
      String videoPath = videoFile?.path ?? "";
      VideoPlayerController? videoPlayerController;
      videoPlayerController = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          videoDuration = videoPlayerController!.value.duration.inSeconds;
          log("videoDuration: ${videoDuration}");
        });

      if (videoFile != null) {
        Directory tempDirectory = await getTemporaryDirectory();
        String path = tempDirectory.path;
        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: videoPath,
          thumbnailPath: path,
          imageFormat: ImageFormat.WEBP,
          maxHeight: 64,
          // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          quality: 100,
        );
        selectedVideos.insert(0, videoFile);
        selectedVideosThumbnails.insert(0, thumbnailFile);
      } else {
        return [].obs;
      }
    } on PlatformException catch (e) {
      showMsg(
        msg: e.message,
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  Future<List<String>> uploadAnImage() async {
    // for (int i = 0; i < selectedImages.length; i++) {
    imagesToUpload.insert(0, (await uploadSingleImage(selectedImages[0])));
    // }
    return imagesToUpload;
  }

  Future uploadSingleImage(XFile image) async {
    Reference ref = await fstorage.ref().child(
          'storyImages/${userDetailsModel.uID}/${DateTime.now().toString()}',
        );
    await ref.putFile(File(image.path));
    return ref.getDownloadURL();
  }

  Future uploadAVideo() async {
    var thumbnailRef = await fstorage.ref().child('storyImages/${userDetailsModel.uID}/${DateTime.now().toString()}');
    String videoId = Uuid().v1();
    videoIds.insert(0, videoId);
    await thumbnailRef.putFile(File(selectedVideosThumbnails[0] ?? "")).then((p0) async {
      await p0.ref.getDownloadURL().then((value) {
        thumbnailsUrls.insert(0, value);
      });
    });
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void removeVideo(int index) {
    selectedVideos.removeAt(index);
    selectedVideosThumbnails.removeAt(index);
    // update();
  }

  Future uploadPhoto() async {
    Reference ref = await FirebaseStorage.instance.ref().child('Images/Story Images/${DateTime.now().toString()}');
    await ref.putFile(pickedImage!);
    await ref.getDownloadURL().then((value) {
      log('Story Image URL $value');
      storyImageUrl = value;
      // update();
    });
  }

  Future uploadStory(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loading();
      },
    );
    log("selectedImages: ${selectedImages}");
    log("selectedImages: ${selectedImages}");
    log("descriptionController.text.trim(): ${descriptionController.text.trim()}");
    if (selectedImages.isNotEmpty) {
      var storyId = Uuid().v1();
      try {
        await uploadAnImage();
        log('in images UPLOADED!');
        StoryModel storyModel = StoryModel(
          storyText: descriptionController.text.trim(),
          storyPersonName: userDetailsModel.fullName,
          storyPersonId: userDetailsModel.uID,
          storyPersonImage: userDetailsModel.profileImageUrl,
          storyImage: imagesToUpload[0],
          mediaType: (descriptionController.text.trim() != "") ? "ImageWithCaption" : "Image",
          createdAt: DateTime.now().millisecondsSinceEpoch,
          videoDuration: 0,
          storyVideo: "",
        );
        log('Data assigned to POST MODEL CLASS!');
        await stories.doc(storyId).set(storyModel.toJson()).then(
          (value) async {
            log('Data set to FIREBASE!');

            selectedImages = [].obs;
            imagesToUpload = [];
            thumbnailsUrls.clear();
            descriptionController.clear();
            log('CLEAR');
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          },
        );
      } on FirebaseException catch (e) {
        showMsg(
          msg: e.message,
          bgColor: Colors.red,
          context: context,
        );
      }
    } else if (selectedVideos.isNotEmpty) {
      var storyId = Uuid().v1();
      try {
        await uploadAVideo();
        log('in vid UPLOADED!');
        StoryModel storyModel = StoryModel(
          storyText: descriptionController.text.trim(),
          storyPersonName: userDetailsModel.fullName,
          storyPersonId: userDetailsModel.uID,
          storyPersonImage: userDetailsModel.profileImageUrl,
          storyImage: thumbnailsUrls[0],
          videoDuration: videoDuration ?? 0,
          mediaType: (descriptionController.text.trim() != "") ? "VideoWithCaption" : "Video",
          createdAt: DateTime.now().millisecondsSinceEpoch,
          storyVideo: "",
        );
        log('Data assigned to POST MODEL CLASS!');
        await stories.doc(storyId).set(storyModel.toJson()).then(
          (value) async {
            log('Data set to FIREBASE!');
            StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? storyDocStream;
            storyDocStream = await ffstore.collection(storyCollection).doc(storyId).snapshots().listen((event) async {
              log("inside the postDoc stream");
              bool containsUploadUrl = event.data()?.containsKey("uploadUrl") ?? false;
              if (containsUploadUrl) {
                log("inside containsUploadUrl");
                // final taskId =
                String uploadUrl = event.data()?["uploadUrl"] ?? "";
                log("inside loop where we are enqueuing uploads");
                await FlutterUploader().enqueue(
                  RawUpload(
                    url: uploadUrl, // required: url to upload to
                    path: selectedVideos[0].path, // required: list of files that you want to upload
                    method: UploadMethod.PUT, // HTTP method  (POST or PUT or PATCH)
                    // headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
                    tag: 'post video uploading', // custom tag which is returned in result/progress
                  ),
                );

                if (storyDocStream != null) {
                  log("canceling the post doc stream");
                  storyDocStream.cancel();
                }
              }
            });
            // selectedImages = [].obs;
            // imagesToUpload = [];
            // thumbnailsUrls.clear();
            // selectedVideos.clear();
            // videoIds.clear();
            // selectedVideosThumbnails.clear();
            // descriptionController.clear();
            log('CLEAR');
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          },
        );
      } on FirebaseException catch (e) {
        showMsg(
          msg: e.message,
          bgColor: Colors.red,
          context: context,
        );
      }
    } else if (descriptionController.text.trim() != "") {
      var storyId = Uuid().v1();
      try {
        log('in desc UPLOADED!');
        StoryModel storyModel = StoryModel(
          storyText: descriptionController.text.trim(),
          storyPersonName: userDetailsModel.fullName,
          storyPersonId: userDetailsModel.uID,
          storyPersonImage: userDetailsModel.profileImageUrl,
          storyImage: "",
          mediaType: "Caption",
          createdAt: DateTime.now().millisecondsSinceEpoch,
          storyVideo: "",
          videoDuration: 0,
        );
        log('Data assigned to POST MODEL CLASS!');
        await stories.doc(storyId).set(storyModel.toJson()).then(
          (value) async {
            log('Data set to FIREBASE!');
            selectedImages = [].obs;
            imagesToUpload = [];
            thumbnailsUrls.clear();
            // selectedVideos.clear();
            // videoIds.clear();
            // selectedVideosThumbnails.clear();
            descriptionController.clear();
            log('CLEAR');
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          },
        );
      } on FirebaseException catch (e) {
        showMsg(
          msg: e.message,
          bgColor: Colors.red,
          context: context,
        );
      }
    } else {
      showMsg(
        msg: 'Invalid Post!',
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(
        title: 'Post New Story',
        onTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kLightBlueColor,
                  ),
                  child: Center(
                    child: Obx(() {
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        pickImage(context);
                                      },
                                      leading: Image.asset(
                                        Assets.imagesGallery,
                                        color: kGreyColor,
                                        height: 35,
                                      ),
                                      title: MyText(
                                        text: 'Image',
                                        size: 20,
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () => pickVideo(context),
                                      // ImageSource.gallery
                                      leading: Image.asset(
                                        Assets.imagesFilm,
                                        height: 35,
                                        color: kGreyColor,
                                      ),
                                      title: MyText(
                                        text: 'Video',
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            isScrollControlled: true,
                          );
                          // showModalBottomSheet(
                          //   context: context,
                          //   builder: (context) {
                          //     return Container(
                          //       height: 180,
                          //       decoration: BoxDecoration(
                          //         color: kPrimaryColor,
                          //       ),
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //         crossAxisAlignment: CrossAxisAlignment.stretch,
                          //         children: [
                          //           ListTile(
                          //             onTap: () => pickImage(
                          //               context,
                          //               ImageSource.camera,
                          //             ),
                          //             leading: Image.asset(
                          //               Assets.imagesCamera,
                          //               color: kGreyColor,
                          //               height: 35,
                          //             ),
                          //             title: MyText(
                          //               text: 'Camera',
                          //               size: 20,
                          //             ),
                          //           ),
                          //           ListTile(
                          //             onTap: () => pickImage(
                          //               context,
                          //               ImageSource.gallery,
                          //             ),
                          //             leading: Image.asset(
                          //               Assets.imagesGallery,
                          //               height: 35,
                          //               color: kGreyColor,
                          //             ),
                          //             title: MyText(
                          //               text: 'Gallery',
                          //               size: 20,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          //   isScrollControlled: true,
                          // );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: selectedImages.isNotEmpty
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(
                                        selectedImages[0].path,
                                      ),
                                      height: Get.height,
                                      width: Get.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => removeImage(0),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : selectedVideos.isNotEmpty
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: Get.height,
                                        width: Get.width,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(
                                              selectedVideosThumbnails[0],
                                            ),
                                            height: Get.height,
                                            width: Get.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: 1.0,
                                        duration: Duration(
                                          milliseconds: 500,
                                        ),
                                        child: Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kBlackColor.withOpacity(0.5),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(() => PostVideoPreview(
                                                      videoFile: selectedVideos[0],
                                                    ));
                                              },
                                              borderRadius: BorderRadius.circular(100),
                                              splashColor: kPrimaryColor.withOpacity(0.1),
                                              highlightColor: kPrimaryColor.withOpacity(0.1),
                                              child: Center(
                                                child: Image.asset(
                                                  Assets.imagesPlay,
                                                  height: 23,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () => removeVideo(0),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 20,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Image.asset(
                                    Assets.imagesUploadPicture,
                                    height: 108.9,
                                    fit: BoxFit.cover,
                                  ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SimpleTextField(
                  hintText: 'Description...',
                  maxLines: 6,
                  controller: descriptionController,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: MyButton(
              onTap: () async {
                //+ code to add the post to firestore goes here
                uploadStory(context);
                // Get.dialog(loading(), barrierDismissible: false);
                // if (pickedImagePath.value != "" && pickedImage != null) {
                //   await uploadPhoto();
                // }
                // if (pickedImagePath.value != "" || descriptionController.text.trim() != "") {
                //   String mediaType = "";
                //   if (pickedImagePath.value != "" && descriptionController.text.trim() != "") {
                //     mediaType = "ImageWithCaption";
                //   } else if (pickedImagePath.value != "") {
                //     mediaType = "Image";
                //   } else if (descriptionController.text.trim() != "") {
                //     mediaType = "Caption";
                //   }
                //   StoryModel storyModel = StoryModel(
                //     createdAt: DateTime.now().millisecondsSinceEpoch,
                //     mediaType: mediaType,
                //     storyImage: storyImageUrl,
                //     storyPersonId: userDetailsModel.uID,
                //     storyPersonImage: userDetailsModel.profileImageUrl,
                //     storyPersonName: userDetailsModel.fullName,
                //     storyText: descriptionController.text.trim(),
                //   );
                //   await ffstore.collection(storyCollection).add(storyModel.toJson());
                //   // Navigator.pop(context);
                //   Get.back();
                //   Get.back();
                // }
              },
              buttonText: 'post',
            ),
          ),
        ],
      ),
    );
  }
}
