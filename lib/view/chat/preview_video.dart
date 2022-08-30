import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/constant/constant_variables.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/get_storage_data/get_storage_data.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

class PreviewVideoScreen extends StatefulWidget {
  final String? videoPath;
  final String? userId;
  final String? anotherUserId;
  final String? anotherUserName;
  final String? chatRoomId;

  const PreviewVideoScreen(
      {Key? key,
      this.videoPath,
      this.anotherUserId,
      this.anotherUserName,
      this.userId,
      this.chatRoomId})
      : super(key: key);

  @override
  _PreviewVideoScreenState createState() => _PreviewVideoScreenState();
}

class _PreviewVideoScreenState extends State<PreviewVideoScreen> {
  String videoUrl = '';
  RxDouble uploadPercentageValue = 0.0.obs;

  // String videoPath = "";
  File? _video;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    _video = File(widget.videoPath ?? "");
    _videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_videoPlayerController != null) _videoPlayerController?.dispose();
    super.dispose();
  }

  void playPause() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _videoPlayerController!.pause()
          : _videoPlayerController!.play();
      isPlaying ? opacity = 1.0 : opacity = 0.0;
    });
  }

  bool isPlaying = false;

  double opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    log('${widget.videoPath} in preview');
    return WillPopScope(
      onWillPop: () async {
        _videoPlayerController?.pause();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: myAppBar(
          onTap: () {
            _videoPlayerController?.pause();
            Get.back();
          },
          title: '',
        ),
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                ),
                AnimatedOpacity(
                  opacity: opacity,
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
                        onTap: playPause,
                        borderRadius: BorderRadius.circular(100),
                        splashColor: kPrimaryColor.withOpacity(0.1),
                        highlightColor: kPrimaryColor.withOpacity(0.1),
                        child: Center(
                          child: Image.asset(
                            isPlaying ? Assets.imagesPause : Assets.imagesPlay,
                            height: 23,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 90,
            // ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "sendButton",
          backgroundColor: kSecondaryColor,
          onPressed: () {
            uploadVideo();
          },
          label: Text(
            "Send",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  uploadVideo() async {
    _videoPlayerController?.pause();
    String fileName = Uuid().v1();
    String thumbnailFileName = Uuid().v1();
    String videoDocId = "";
    var ref = FirebaseStorage.instance
        .ref()
        .child("chatRooms/${widget.chatRoomId!}")
        .child("$fileName.mp4");
    var thumbnailRef = FirebaseStorage.instance
        .ref()
        .child("chatRooms/${widget.chatRoomId!}")
        .child("$thumbnailFileName.mp4");
    try {
      showDialog(
        context: context,
        builder: (context) {
          return loading();
        },
      );
      Directory tempDirectory = await getTemporaryDirectory();
      String path = tempDirectory.path;
      final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: widget.videoPath ?? "",
        thumbnailPath: path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 64,
        // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      await thumbnailRef.putFile(File(thumbnailFile ?? "")).then((p0) async {
        if (p0.state == TaskState.success) {
          await p0.ref.getDownloadURL().then((value) async {
            var time = DateTime.now().millisecondsSinceEpoch;
            Map<String, dynamic> messageMap = {
              "sendById": userDetailsModel.uID,
              "sendByName": userDetailsModel.fullName,
              "receivedById": widget.anotherUserId,
              "receivedByName": widget.anotherUserName,
              "message": "Video being uploaded",
              "thumbnail": value,
              "type": "video",
              'time': time,
              'isDeletedFor': [],
              'isRead': false,
              "isReceived": false,
            };
            await FirebaseFirestore.instance
                .collection(chatRoomCollection)
                .doc(widget.chatRoomId!)
                .collection(messagesCollection)
                .add(messageMap)
                .then((value) async {
              videoDocId = value.id;
              log("await UserSimplePreference.getVideoMessageDocsIdsListData(): ${await UserSimplePreference.getVideoMessageDocsIdsListData()}");
              List<String> videoMessageDocsIdsList = await UserSimplePreference.getVideoMessageDocsIdsListData() ?? [];
              videoMessageDocsIdsList.add(value.id);
              await UserSimplePreference.setVideoMessageDocsIdsListData(videoMessageDocsIdsList);
              // thumbnailFile.
              if (File(thumbnailFile!).existsSync()) {
                File(thumbnailFile).delete(recursive: true);
              }
              await FirebaseFirestore.instance
                  .collection(chatRoomCollection)
                  .doc(widget.chatRoomId!)
                  .update({
                'lastMessageAt': time,
                'lastMessage': "Video being uploaded",
                'lastMessageType': "video",
              }).catchError((e) {
                log('\n\n\n\n error in updating last message and last message time ${e.toString()}');
              });
            }).catchError((e) {
              log('\n\n\n\n error in adding video mid message ${e.toString()}');
            });
          });
        }
      });
      // chatController.addConversationMessage(widget.chatRoomId!, time, "image", messageMap, "Video being uploaded");
      Get.back();
      Get.back();
      final uploadTask = ref.putFile(File(widget.videoPath!));
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            uploadPercentageValue.value = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $uploadPercentageValue% complete.");
            break;
          case TaskState.paused:
            log("Upload is paused.");
            break;
          case TaskState.canceled:
            log("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            log("Upload resulted in error.");
            showMsg(
              msg: 'Storage Error!',
              context: context,
              bgColor: Colors.red,
            );
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            videoUrl = await taskSnapshot.ref.getDownloadURL();
            if (File(widget.videoPath!) != null &&
                (videoUrl != null || videoUrl != "")) {
              List<String> videoMessageDocsIdsList = await UserSimplePreference.getVideoMessageDocsIdsListData() ?? [];
              log("while updating the video link in db: videoDocId: ${videoDocId} and videoMessageDocsIdsList: ${videoMessageDocsIdsList}");
              if(videoMessageDocsIdsList.isNotEmpty){
                videoDocId = videoMessageDocsIdsList[0];
                videoMessageDocsIdsList.removeAt(0);
                await UserSimplePreference.setVideoMessageDocsIdsListData(videoMessageDocsIdsList);
              }
              var time = DateTime.now().millisecondsSinceEpoch;
              await FirebaseFirestore.instance
                  .collection(chatRoomCollection)
                  .doc(widget.chatRoomId!)
                  .collection(messagesCollection)
                  .doc(videoDocId)
                  .update({"message": videoUrl}).then((value) async {
                await FirebaseFirestore.instance
                    .collection(chatRoomCollection)
                    .doc(widget.chatRoomId!)
                    .update({
                  'lastMessageAt': time,
                  'lastMessage': videoUrl,
                  'lastMessageType': "video",
                }).catchError((e) {
                  log('\n\n\n\n error in updating last message and last message time ${e.toString()}');
                });
              }).catchError((e) {
                log('\n\n\n\n error in adding message ${e.toString()}');
              });
              // chatController.addConversationMessage(widget.chatRoomId!, time, "image", messageMap, videoUrl);
              videoUrl = "";
              // navigatorKey.currentState!.pop();
              // Get.back();
            }
            break;
        }
      });
    } on FirebaseException catch (e) {
      //+ Handle the storage relevant codes here in free time from:
      //+ https://firebase.google.com/docs/storage/flutter/handle-errors
      log("error in sending image is: $e");

      showMsg(
        msg: 'Storage Error!',
        context: context,
        bgColor: Colors.red,
      );
      // showErrorDialog(
      //     title: "Storage Error!",
      //     description:
      //         "Some unknown error occurred. Please connect to a reliable "
      //         "internet connection and try again. ");
      // log("error in uploading image to storage on preview screen is: ${e.code} and ${e.message}");
    }

    log('this is status 1');
    print(videoUrl);
  }
}
