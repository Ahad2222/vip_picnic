import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';

class PreviewImageScreen extends StatefulWidget {
  final String? imagePath;
  final String? userId;
  final String? anotherUserId;
  final String? anotherUserName;
  final String? chatRoomId;

  const PreviewImageScreen(
      {Key? key,
      this.imagePath,
      this.anotherUserId,
      this.anotherUserName,
      this.userId,
      this.chatRoomId})
      : super(key: key);

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  String imageUrl = '';
  RxDouble uploadPercentageValue = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    log('in preview');
    return Scaffold(
      appBar: myAppBar(
        onTap: () => Get.back(),
        title: '',
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //+added after first testing to make sure the image is centered horizontally but needs to be tested yet
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.file(
                File(widget.imagePath),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kSecondaryColor,
        onPressed: () {
          uploadImage();
        },
        label: Text(
          "Send",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  uploadImage() {
    String fileName = Uuid().v1();
    var ref = FirebaseStorage.instance
        .ref()
        .child(widget.chatRoomId)
        .child("$fileName.jpg");
    try {
      final uploadTask = ref.putFile(File(widget.imagePath));
      Get.defaultDialog(
        title: "Uploading",
        content: Obx(() {
          return Text(
            "${(uploadPercentageValue.value).toInt()} %",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
        barrierDismissible: false,
      );
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
            showErrorDialog(
                title: "Storage Error!",
                description:
                    "Some unknown error occurred. Please connect to a reliable "
                    "internet connection and try again. ");
            log("error in uploading image to storage on preview screen is: "
                "${TaskState.error.toString()}");
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            imageUrl = await taskSnapshot.ref.getDownloadURL();
            if (File(widget.imagePath) != null &&
                (imageUrl != null || imageUrl != "")) {
              var time = DateTime.now().millisecondsSinceEpoch;
              Map<String, dynamic> messageMap = {
                "sendById": authController.userModel.value.id,
                "sendByName": authController.userModel.value.name,
                "receivedById": widget.anotherUserId,
                "receivedByName": widget.anotherUserName,
                "message": imageUrl,
                "type": "image",
                'time': time,
                'isDeletedFor': [],
                'isRead': false,
                "isReceived": false,
              };
              chatController.addConversationMessage(
                  widget.chatRoomId, time, "image", messageMap, imageUrl);
              imageUrl = "";
              Get.back();
              Get.back();
              // Get.snackbar("Success", "Image was uploaded successfully");
            }
            break;
        }
      });
    } on FirebaseException catch (e) {
      //+ Handle the storage relevant codes here in free time from:
      //+ https://firebase.google.com/docs/storage/flutter/handle-errors
      showErrorDialog(
          title: "Storage Error!",
          description:
              "Some unknown error occurred. Please connect to a reliable "
              "internet connection and try again. ");
      log("error in uploading image to storage on preview screen is: ${e.code} and ${e.message}");
    }

    log('this is status 1');
    print(imageUrl);
  }
}
