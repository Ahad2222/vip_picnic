import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/main.dart';
import 'package:vip_picnic/utils/instances.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';
import 'package:vip_picnic/view/widget/snack_bar.dart';

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
    log('${widget.imagePath} in preview');
    return Scaffold(
      appBar: myAppBar(
        onTap: () => Get.back(),
        title: '',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.file(
              File(widget.imagePath!),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          SizedBox(
            height: 90,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "sendButton",
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
        .child("chatRooms/${widget.chatRoomId!}")
        .child("$fileName.jpg");
    try {
      final uploadTask = ref.putFile(File(widget.imagePath!));
      showDialog(
        context: context,
        builder: (context) {
          return loading();
        },
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
            showMsg(
              msg: 'Storage Error!',
              context: context,
              bgColor: Colors.red,
            );
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            imageUrl = await taskSnapshot.ref.getDownloadURL();
            if (File(widget.imagePath!) != null &&
                (imageUrl != null || imageUrl != "")) {
              var time = DateTime.now().millisecondsSinceEpoch;
              Map<String, dynamic> messageMap = {
                "sendById": userDetailsModel.uID,
                "sendByName": userDetailsModel.fullName,
                "sendByImage": userDetailsModel.profileImageUrl,
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
                  widget.chatRoomId!, time, "image", messageMap, imageUrl);
              imageUrl = "";
              navigatorKey.currentState!.pop();
              Get.back();
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
    print(imageUrl);
  }
}
