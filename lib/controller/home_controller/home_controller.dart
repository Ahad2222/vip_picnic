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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/utils/collections.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find<HomeController>();
  late final TextEditingController descriptionCon;
  late final TextEditingController tagCon;
  late final TextEditingController locationCon;
  late final TextEditingController editCommentCon;

  List<String> imagesToUpload = [];
  DateTime createdAt = DateTime.now();
  DateFormat? format;
  List<String> taggedPeople = [];
  List<String> taggedPeopleToken = [];
  int? commentCount;
  int? likeCount;
  int? shareCount;
  RxList selectedImages = [].obs;
  RxList selectedVideos = [].obs;
  RxList selectedVideosThumbnails = [].obs;
  List<String> thumbnailsUrls = [];
  List<String> videoIds = [];
  final pageController = PageController();
  RxInt currentPost = 0.obs;
  // RxBool isEditComment = false.obs;

  // void editComment() {
  //   isEditComment.value = !isEditComment.value;
  //   update();
  // }

  void getCurrentPostIndex(int index) {
    currentPost.value = index;
    update();
  }

  Future pickImages(BuildContext context) async {
    try {
      List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images != null) {
        selectedImages.addAll(images);
      } else {
        return [].obs;
      }
      update();
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
      XFile? videoFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      String videoPath = videoFile?.path ?? "";

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
        selectedVideos.add(videoFile);
        selectedVideosThumbnails.add(thumbnailFile);
      } else {
        return [].obs;
      }
      update();
    } on PlatformException catch (e) {
      showMsg(
        msg: e.message,
        bgColor: Colors.red,
        context: context,
      );
    }
  }

  // Future getVideoFromGallery() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickVideo(source: ImageSource.gallery).then((xFile) {
  //     if (xFile != null) {
  //       File videoFile = File(xFile.path);
  //       String videoPath = xFile.path;
  //       selectedVideos.add(videoFile);
  //       // showLoading();
  //       // Get.to(
  //       //   () => PreviewVideoScreen(
  //       //     videoPath: videoPath,
  //       //     anotherUserId: anotherUserID,
  //       //     anotherUserName: anotherUserName,
  //       //     chatRoomId: crm.value.chatRoomId,
  //       //     userId: userID,
  //       //   ),
  //       // );
  //       // uploadImage();
  //     }
  //   });
  // }

  Future uploadPost(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loading();
      },
    );
    if (selectedImages.isNotEmpty ||
        selectedVideos.isNotEmpty ||
        descriptionCon.text.isNotEmpty) {
      var postID = Uuid().v1();
      try {
        await uploadAllImages();
        await uploadAllVideos();
        log('Images UPLOADED!');
        addPostModel = AddPostModel(
          postID: postID,
          uID: userDetailsModel.uID,
          postBy: userDetailsModel.fullName,
          profileImage: userDetailsModel.profileImageUrl,
          postImages: imagesToUpload,
          postVideos: [],
          videoIds: videoIds,
          thumbnailsUrls: thumbnailsUrls,
          postTitle: descriptionCon.text.trim(),
          taggedPeople: taggedPeople,
          taggedPeopleToken: taggedPeopleToken,
          location: locationCon.text.trim(),
          createdAt: DateFormat.yMEd().add_jms().format(createdAt).toString(),
          createdAtMilliSeconds: DateTime.now().millisecondsSinceEpoch,
          likeIDs: [],
          likeCount: 0,
          commentCount: 0,
          shareCount: 0,
        );
        log('Data assigned to POST MODEL CLASS!');
        await posts.doc(postID).set(addPostModel.toJson()).then(
          (value) async {
            log('Data set to FIREBASE!');
            StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
                postDocStream;
            postDocStream = await ffstore
                .collection(postsCollection)
                .doc(postID)
                .snapshots()
                .listen((event) async {
              log("inside the postDoc stream");
              bool containsUploadUrl =
                  event.data()?.containsKey("uploadUrls") ?? false;
              if (containsUploadUrl) {
                log("inside containsUploadUrl");
                // final taskId =
                List<String> uploadUrls = List<String>.from(
                    event.data()?["uploadUrls"].map((x) => x));

                for (int i = 0; i < selectedVideos.length; i++) {
                  log("inside loop where we are enqueuing uploads");
                  await FlutterUploader().enqueue(
                    RawUpload(
                      url: uploadUrls[i],
                      // required: url to upload to
                      path: selectedVideos[i].path,
                      // required: list of files that you want to upload
                      method: UploadMethod.PUT,
                      // HTTP method  (POST or PUT or PATCH)
                      // headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
                      tag:
                          'post video uploading', // custom tag which is returned in result/progress
                    ),
                  );
                }

                if (postDocStream != null) {
                  log("canceling the post doc stream");
                  postDocStream.cancel();
                }
              }
            });
            selectedImages = [].obs;
            imagesToUpload = [];
            thumbnailsUrls.clear();
            // selectedVideos.clear();
            // videoIds.clear();
            selectedVideosThumbnails.clear();
            descriptionCon.clear();
            tagCon.clear();
            locationCon.clear();
            taggedPeople = [];
            log('CLEAR');
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
            update();
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

  Future<List<String>> uploadAllImages() async {
    for (int i = 0; i < selectedImages.length; i++) {
      imagesToUpload.add(
        await uploadSingleImage(selectedImages[i]),
      );
    }
    return imagesToUpload;
  }

  Future uploadSingleImage(XFile image) async {
    Reference ref = await fstorage.ref().child(
          'postImages/images/${DateTime.now().toString()}',
        );
    await ref.putFile(
      File(image.path),
    );
    return ref.getDownloadURL();
  }

  Future uploadAllVideos() async {
    for (int i = 0; i < selectedVideos.length; i++) {
      var thumbnailRef = await fstorage
          .ref()
          .child('postImages/images/${DateTime.now().toString()}');
      String videoId = Uuid().v1();
      videoIds.add(videoId);
      await thumbnailRef
          .putFile(File(selectedVideosThumbnails[i] ?? ""))
          .then((p0) async {
        await p0.ref.getDownloadURL().then((value) {
          thumbnailsUrls.add(value);
        });
      });
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    update();
  }

  void removeVideo(int index) {
    selectedVideos.removeAt(index);
    selectedVideosThumbnails.removeAt(index);
    // update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    descriptionCon = TextEditingController();
    tagCon = TextEditingController();
    locationCon = TextEditingController();
    editCommentCon = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    descriptionCon.dispose();
    tagCon.dispose();
    locationCon.dispose();
  }
}
