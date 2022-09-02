const functions = require("firebase-functions");
// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
const { getFirestore } = require('firebase-admin/firestore');
const { log } = require("firebase-functions/logger");
// import { getFirestore } from 'firebase-admin/firestore'; 
admin.initializeApp();
admin.firestore().settings({ ignoreUndefinedProperties: true });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

function removeItemOnce(arr, value) {
  var index = arr.indexOf(value);
  if (index > -1) {
    arr.splice(index, 1);
  }
  return arr;
}

async function TextChatsNotiSingle(
  token_o,
  msg,
  url,
  senderName,
  recName,
  chatRoomId
) {
  functions.logger.log("Single Token function is executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);

  await admin
    .messaging()
    .send({
      token: token_o,
      notification: {
        title: `${senderName}`,
        body: msg,
        //Below line has use in terminated or background state of app
        imageUrl: url,
      },
      data: {
        imageUrl: url,
        chatRoomId: chatRoomId,
        screenName: "chatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications sent to the Receiver");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });
}

async function TextGroupChatsNotiSingle(msg, senderId, senderName, chatRoomId) {

  // var senName = snap.data().sendByName;
  var groupName = "";
  var groupImage = "";
  var userList = [];
  var tokenList = [];

  functions.logger.log("Group Text multi token method executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);

  await admin
    .firestore()
    .collection("GroupChatRoom")
    .doc(chatRoomId)
    .get()
    .then(async (snapshot) => {
      userList = snapshot.data().users;
      groupName = snapshot.data().groupName;
      groupImage = snapshot.data().groupImage;


      functions.logger.log(`userList: ${userList} before deletion`);
      removeItemOnce(userList, senderId);
      functions.logger.log(`userList: ${userList} after deletion`);

      for (const index in userList) {
        await admin
          .firestore()
          .collection("Accounts").doc(userList[index])
          .get().then((snap) => {
            tokenList.push(snap.data().fcmToken);
            functions.logger.log(`list is now: ${tokenList}`);
          });
      }
    });

  await admin
    .messaging()
    .sendMulticast({
      tokens: tokenList,
      notification: {
        title: `${groupName}`,
        body: `${senderName}: ${msg}`,
        //Below line has use in terminated or background state of app
        imageUrl: groupImage,
      },
      data: {
        imageUrl: groupImage,
        groupId: chatRoomId,
        screenName: "groupChatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications for text  sent to the Group Receivers");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });
}

async function AudioChatsNotiSingle(
  token_o,
  msg,
  url,
  senderName,
  recName,
  chatRoomId) {
  functions.logger.log("Single Token function is executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);

  await admin
    .messaging()
    .send({
      token: token_o,
      notification: {
        title: `You received an Audio message from  ${recName}`,
        body: {},
        //Below line has use in terminated or background state of app
        imageUrl: url,
      },
      data: {
        imageUrl: url,
        chatRoomId: chatRoomId,
        screenName: "chatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications sent to the Receiver");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });
}

async function AudioGroupChatsNotiSingle(msg, senderId, senderName, chatRoomId) {
  functions.logger.log("Single Token function is executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);


  var groupName = "";
  var groupImage = "";
  var userList = [];
  var tokenList = [];

  await admin
    .firestore()
    .collection("GroupChatRoom")
    .doc(chatRoomId)
    .get()
    .then(async (snapshot) => {
      userList = snapshot.data().users;
      groupName = snapshot.data().groupName;
      groupImage = snapshot.data().groupImage;

      functions.logger.log(`userList: ${userList} before deletion`);
      removeItemOnce(userList, senderId);
      functions.logger.log(`userList: ${userList} after deletion`);

      for (const index in userList) {
        await admin
          .firestore()
          .collection("Accounts").doc(userList[index])
          .get().then((snap) => {
            tokenList.push(snap.data().fcmToken);
            functions.logger.log(`list is now: ${tokenList}`);
          });
      }
    });

  await admin
    .messaging()
    .sendMulticast({
      tokens: tokenList,
      notification: {
        title: `${groupName}`,
        body: `${senderName}: Audio`,
        //Below line has use in terminated or background state of app
        imageUrl: url,
      },
      data: {
        imageUrl: url,
        groupId: chatRoomId,
        screenName: "groupChatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications sent to the Receiver");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });

}

async function VideoGroupChatsNotiSingle(msg, senderId, senderName, chatRoomId) {
  functions.logger.log("Single Token function is executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);

  var groupName = "";
  var groupImage = "";
  var userList = [];
  var tokenList = [];

  await admin
    .firestore()
    .collection("GroupChatRoom")
    .doc(chatRoomId)
    .get()
    .then(async (snapshot) => {
      userList = snapshot.data().users;
      groupName = snapshot.data().groupName;
      groupImage = snapshot.data().groupImage;

      functions.logger.log(`userList: ${userList} before deletion`);
      removeItemOnce(userList, senderId);
      functions.logger.log(`userList: ${userList} after deletion`);


      for (const index in userList) {
        await admin
          .firestore()
          .collection("Accounts").doc(userList[index])
          .get().then((snap) => {
            tokenList.push(snap.data().fcmToken);
            functions.logger.log(`list is now: ${tokenList}`);
          });
      }
    });


  await admin
    .messaging()
    .sendMulticast({
      tokens: tokenList,
      notification: {
        title: `${groupName}`,
        body: `${senderName}: 🎥 Video`,

        //Below line has use in terminated or background state of app
        imageUrl: groupImage,
      },
      data: {
        imageUrl: groupImage,
        groupId: chatRoomId,
        screenName: "groupChatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications for video  sent to the Group Receivers");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });


}

async function VideoChatsNotiSingle(token_o, msg, profileImageUrl, generalImageUrl, senderName, recName, chatRoomId) {
  functions.logger.log("Single Token function is executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);

  await admin
    .messaging()
    .send({
      token: token_o,
      notification: {
        title: `${senderName}`,
        body: "🎥 Video",
        //Below line has use in terminated or background state of app
        imageUrl: generalImageUrl,
      },
      data: {
        imageUrl: profileImageUrl,
        // generalImageUrl: generalImageUrl,
        chatRoomId: chatRoomId,
        screenName: "chatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications sent to the Receiver");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });
}
//When chat is of type image,  profile image and general image will be sent
// in the payload
async function ImageChatsNotiSingle(token_o, msg, profileImageUrl, generalImageUrl, senderName, recName, chatRoomId) {
  functions.logger.log("Single Token function is executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);

  await admin
    .messaging()
    .send({
      token: token_o,
      notification: {
        title: `${senderName}`,
        body: `📷 Image`,
        //Below line has use in terminated or background state of app
        imageUrl: generalImageUrl,
      },
      data: {
        imageUrl: profileImageUrl,
        generalImageUrl: generalImageUrl,
        chatRoomId: chatRoomId,
        screenName: "chatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications sent to the Receiver");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });
}

async function ImageGroupChatsNotiSingle(generalImage, senderId, senderName, chatRoomId) {
  functions.logger.log("Single Token function is executed");
  functions.logger.log("ChatRoomID is ");
  functions.logger.log(chatRoomId);

  var groupName = "";
  var groupImage = "";
  var userList = [];
  var tokenList = [];

  await admin
    .firestore()
    .collection("GroupChatRoom")
    .doc(chatRoomId)
    .get()
    .then(async (snapshot) => {
      userList = snapshot.data().users;
      groupName = snapshot.data().groupName;
      groupImage = snapshot.data().groupImage;

      functions.logger.log(`userList: ${userList} before deletion`);
      removeItemOnce(userList, senderId);
      functions.logger.log(`userList: ${userList} after deletion`);

      for (const index in userList) {
        await admin
          .firestore()
          .collection("Accounts").doc(userList[index])
          .get().then((snap) => {
            tokenList.push(snap.data().fcmToken);
            functions.logger.log(`list is now: ${tokenList}`);
          });
      }
    });

  await admin
    .messaging()
    .sendMulticast({
      tokens: tokenList,
      notification: {
        title: `${groupName}`,
        body: `${senderName}: 📷 Image`,
        //Below line has use in terminated or background state of app
        imageUrl: groupImage,
      },
      data: {
        imageUrl: groupImage,
        generalImageUrl: generalImage,
        groupId: chatRoomId,
        screenName: "groupChatScreen",
      },
    })
    .then((value) => {
      functions.logger.log("Notifications sent to the Group Receivers");
    })
    .catch((e) => {
      functions.logger.log(e.toString());
    });

}

//+ ------------------------------------ --------notification for group chat----------------------------------------------------------------
exports.notifyReceiverForGroupChat = functions.firestore
  .document("/GroupChatRoom/{documentId}/messages/{chatDocumentId}")
  .onCreate(async (snap, context) => {
    // var recId = snap.data().receivedById;
    var senderId = snap.data().sendById;

    // var recName = snap.data().receivedByName;
    var senderName = snap.data().sendByName;
    var groupName = "";
    var groupImage = "";
    var userList = [];


    var message = snap.data().message;
    var chatRoomId = context.params.documentId;

    var generalImage = "";


    functions.logger.info("Message By the Sender is:");
    functions.logger.info(message);

    if (snap.data().type == "image") {
      functions.logger.info("In Chat function: type is Image");
      generalImage = snap.data().message;

      await ImageGroupChatsNotiSingle(generalImage, senderId, senderName, chatRoomId);

    }
    else if (snap.data().type == "text") {
      //getting image and token of receiver from the firestore through admin sdk
      functions.logger.info("In Chat function: type is text");

      await TextGroupChatsNotiSingle(message, senderId, senderName, chatRoomId);

    }
    else if (snap.data().type == "audio") {
      functions.logger.info("In Chat function: type is audio");
      //getting image and token of receiver from the firestore through admin sdk
      AudioGroupChatsNotiSingle(message, senderId, senderName, chatRoomId);

    } else if (snap.data().type == "video") {

      functions.logger.info("In Chat function: type is video");

      const bucket = admin.storage().bucket();
      functions.logger.log(`bucket is: ${bucket.name}`);
      functions.logger.log(`chatDocumentId is: ${context.params.chatDocumentId}`);

      const fileName = `${context.params.chatDocumentId}.mp4`;
      functions.logger.log(`fileName is: ${fileName}`);
      const videoFile = bucket.file(`groupChatRooms/${chatRoomId}/${fileName}`);
      const resumableUpload = await videoFile.createResumableUpload();
      functions.logger.log(`resumableUpload is: ${resumableUpload}`);
      const uploadUrl = resumableUpload[0];
      functions.logger.log(`uploadUrl is: ${uploadUrl}`);
      console.log(uploadUrl);

      admin.firestore().collection(`/GroupChatRoom/${chatRoomId}/messages`).doc(context.params.chatDocumentId).set({
        uploadUrl: uploadUrl
      }, { merge: true }).catch((e) => {
        functions.logger.log(`error in setting the uploadUrl is:${e.toString()}`);
      });

      await VideoGroupChatsNotiSingle(message, senderId, senderName, chatRoomId);
      //getting image and token of receiver from the firestore through admin sdk
      // await admin
      //   .firestore()
      //   .collection("Accounts")
      //   .doc(recId)
      //   .get()
      //   .then((snapshot) => {
      //     imageUrl = snapshot.data().profileImageUrl;
      //     myRetToken = snapshot.data().fcmToken;
      //   })
      //   .catch((e) => {
      //     functions.logger.log(e.toString());
      //   });
      // //Now sending the notification using SingleTOken function
      // await AudioChatsNotiSingle(
      //   myRetToken,
      //   message,
      //   imageUrl,
      //   senName,
      //   recName,
      //   chatRoomId
      // );
    }
    else {
      functions.logger.info("In Chat function: type is Else block");
      //getting image and token of receiver from the firestore through admin sdk

      await TextGroupChatsNotiSingle(message, senderId, senderName, chatRoomId);
    }
  });

//+------------------------------------------------------Notification for notifyReceiverForChat ------------------

exports.notifyReceiverForChat = functions.firestore
  .document("/ChatRoom/{documentId}/messages/{chatDocumentId}")
  .onCreate(async (snap, context) => {
    var recId = snap.data().receivedById;
    var senId = snap.data().sendById;

    var recName = snap.data().receivedByName;
    var senName = snap.data().sendByName;
    var sendByImage = snap.data().sendByImage;


    var message = snap.data().message;
    var chatRoomId = context.params.documentId;

    var imageUrl = "No Name";
    var generalImage = "";
    var myRetToken = "Not Retrieved Yet from Accounts Collection";
    functions.logger.info(recId);
    functions.logger.info("Message By the Sender is:");
    functions.logger.info(message);

    if (snap.data().type == "image") {
      functions.logger.info("In Chat function: type is Image");
      generalImage = snap.data().message;
      await admin
        .firestore()
        .collection("Accounts")
        .doc(recId)
        .get()
        .then((snapshot) => {
          imageUrl = snapshot.data().profileImageUrl;
          myRetToken = snapshot.data().fcmToken;
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });

      await ImageChatsNotiSingle(
        myRetToken,
        message,
        sendByImage,
        generalImage,
        senName,
        recName,
        chatRoomId
      );
    }
    else if (snap.data().type == "text") {
      //getting image and token of receiver from the firestore through admin sdk
      functions.logger.info("In Chat function: type is text");
      await admin
        .firestore()
        .collection("Accounts")
        .doc(recId)
        .get()
        .then((snapshot) => {
          imageUrl = snapshot.data().profileImageUrl;
          myRetToken = snapshot.data().fcmToken;
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });
      //Now sending the notification using SingleTOken function
      await TextChatsNotiSingle(
        myRetToken,
        message,
        sendByImage,
        senName,
        recName,
        chatRoomId
      );
    }
    else if (snap.data().type == "audio") {
      functions.logger.info("In Chat function: type is audio");
      //getting image and token of receiver from the firestore through admin sdk
      await admin
        .firestore()
        .collection("Accounts")
        .doc(recId)
        .get()
        .then((snapshot) => {
          imageUrl = snapshot.data().profileImageUrl;
          myRetToken = snapshot.data().fcmToken;
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });
      //Now sending the notification using SingleTOken function
      await AudioChatsNotiSingle(
        myRetToken,
        message,
        sendByImage,
        senName,
        recName,
        chatRoomId
      );
    } else if (snap.data().type == "video") {
      functions.logger.info("In Chat function: type is video");

      const bucket = admin.storage().bucket();
      functions.logger.log(`bucket is: ${bucket.name}`);
      functions.logger.log(`chatDocumentId is: ${context.params.chatDocumentId}`);

      const fileName = `${context.params.chatDocumentId}.mp4`;
      functions.logger.log(`fileName is: ${fileName}`);
      const videoFile = bucket.file(`chatRooms/${chatRoomId}/${fileName}`);
      const resumableUpload = await videoFile.createResumableUpload();
      functions.logger.log(`resumableUpload is: ${resumableUpload}`);
      const uploadUrl = resumableUpload[0];
      functions.logger.log(`uploadUrl is: ${uploadUrl}`);
      console.log(uploadUrl);

      await admin.firestore().collection(`/ChatRoom/${chatRoomId}/messages`).doc(context.params.chatDocumentId).set({
        uploadUrl: uploadUrl
      }, { merge: true }).catch((e) => {
        functions.logger.log(`error in setting the uploadUrl is:${e.toString()}`);
      });

      var thumbnailUrl = snap.data().thumbnail;


      await admin
        .firestore()
        .collection("Accounts")
        .doc(recId)
        .get()
        .then((snapshot) => {
          imageUrl = snapshot.data().profileImageUrl;
          myRetToken = snapshot.data().fcmToken;
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });
      //Now sending the notification using SingleTOken function
      await VideoChatsNotiSingle(
        myRetToken,
        message,
        sendByImage,
        thumbnailUrl,
        senName,
        recName,
        chatRoomId
      );
      //getting image and token of receiver from the firestore through admin sdk
      // await admin
      //   .firestore()
      //   .collection("Accounts")
      //   .doc(recId)
      //   .get()
      //   .then((snapshot) => {
      //     imageUrl = snapshot.data().profileImageUrl;
      //     myRetToken = snapshot.data().fcmToken;
      //   })
      //   .catch((e) => {
      //     functions.logger.log(e.toString());
      //   });
      // //Now sending the notification using SingleTOken function
      // await AudioChatsNotiSingle(
      //   myRetToken,
      //   message,
      //   imageUrl,
      //   senName,
      //   recName,
      //   chatRoomId
      // );
    }
    else {
      functions.logger.info("In Chat function: type is Else block");
      //getting image and token of receiver from the firestore through admin sdk
      await admin
        .firestore()
        .collection("Accounts")
        .doc(recId)
        .get()
        .then((snapshot) => {
          imageUrl = snapshot.data().profileImageUrl;
          myRetToken = snapshot.data().fcmToken;
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });
      //Now sending the notification using SingleTOken function
      await TextChatsNotiSingle(
        myRetToken,
        message,
        sendByImage,
        senName,
        recName,
        chatRoomId
      );
    }
  });



//   exports.newStorageFile = functions.storage.object().onFinalize(async (object) => {
//     const filePath = object.name;
//     functions.logger.log("filePath:")
//     functions.logger.log(filePath)
//     const extension = filePath.split('.')[filePath.split('.').length - 1];
//     if (extension != 'mp4') {
//         return console.log(`File extension: ${extension}. This is not a video. Exiting function.`);
//     }

//     const videoId = filePath.split('.')[0]
//     functions.logger.log(`Setting data in firestore doc: ${videoId}`)
//     await admin.firestore().collection(`/ChatRoom/${chatRoomId}/messages`).doc(videoId).set({
//         uploadComplete: true
//     }, { merge: true });

//     console.log('Done');
// });

//+------------------------------------------------------Notification for liking ------------------

exports.liking = functions.firestore
  .document("/Accounts/{documentId}/iFollowed/{iFollowedDoc}")
  .onCreate(async (snap, context) => {

    //IFollowedModel myProfileForFollowed = IFollowedModel(
    //followedId: userDetailsModel.uID,
    //followedName: userDetailsModel.fullName,
    //followedImage: userDetailsModel.profileImageUrl,
    //followedAt: DateTime.now().millisecondsSinceEpoch,
    // );
    //Getting Followed Profile Details
    var followedId = snap.data().followedId;
    var followedName = snap.data().followedName;
    var followedImageUrl = snap.data().followedImage;
    var followedAt = snap.data().followedAt;
    var followedFcmToken;
    // var time = snap.data().time;

    functions.logger.log(
      `LikerID Profile Details: ${followedId}, ${followedName}, ${followedImageUrl},`
    );

    //Getting Liker Profile Details
    var followerId = context.params.documentId;
    var followerName;
    var followerImageUrl;
    var followerFcmToken;

    functions.logger.log(
      `LikerID Profile Details: ${followerId}, ${followerName}, ${followerImageUrl}, ${followerFcmToken},`
    );

    await admin
      .firestore()
      .collection("Accounts")
      .doc(followedId)
      .get()
      .then(async (snapshot) => {
        followedFcmToken = snapshot.data().fcmToken;
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });


    await admin
      .firestore()
      .collection("Accounts")
      .doc(followerId)
      .get()
      .then((snapshot) => {
        followerName = snapshot.data().fullName;
        followerImageUrl = snapshot.data().profileImageUrl;
        followerFcmToken = snapshot.data().fcmToken;
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });
    functions.logger.log("FollowerID is: ");
    functions.logger.log(followerId);


    await admin
      .firestore()
      .collection("Accounts")
      .doc(followedId)
      .collection("TheyFollowed")
      .doc(followerId)
      .set({
        followerId: followerId,
        followerName: followerName,
        followerImageUrl: followerImageUrl,
        followedAt: followedAt,
      });


    //Sending notification to Followed One

    await admin
      .messaging()
      .send({
        token: followedFcmToken,
        notification: {
          title: `Followed by ${followerName}`,
          body: `Lets check their  profile.`,
          imageUrl: followerImageUrl,
        },
        data: {
          id: followerId,
          name: followerName,
          imageUrl: followerImageUrl,
          screenName: "profileScreen",
          type: "followerFollowed",
        },
      })
      .then((value) => {
        functions.logger.log(
          "Notification for Liking from liker is sent to the LikedOne"
        );
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });

    await admin
      .firestore()
      .collection("Notifications")
      .add({
        forId: followedId,
        image: followerImageUrl,
        message: `${followerName} followed you`,
        type: "follow",
        dataId: followerId,
        createdAt: followedAt,
      });
    // Map<String, dynamic> toJson() => {
    //   'forId': forId,
    //   'image': image,
    //   'message': message,
    //   'dataId': dataId,
    //   'type': type,
    //   'createdAt': createdAt,
    // };
  });
//+------------------------------------------------------Notification for postLikedNotification ------------------

exports.postLikedNotification = functions.firestore
  .document("/Posts/{documentId}")
  .onUpdate(async (change, context) => {

    const newData = change.after.data();
    const oldData = change.before.data();

    var likesList = newData.likeIDs;
    var posterId = newData.uID;
    var postId = newData.postID;


    var posterFcmToken;
    // var time = snap.data().time;

    //Getting Liker Profile Details
    var likerId = likesList[likesList.length - 1];
    var likerName;
    var likerImageUrl;
    var likerFcmToken;

    if (oldData.likeCount < newData.likeCount) {
      await admin
        .firestore()
        .collection("Accounts")
        .doc(posterId)
        .get()
        .then(async (snapshot) => {
          posterFcmToken = snapshot.data().fcmToken;
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });


      await admin
        .firestore()
        .collection("Accounts")
        .doc(likerId)
        .get()
        .then((snapshot) => {
          likerName = snapshot.data().fullName;
          likerImageUrl = snapshot.data().profileImageUrl;
          likerFcmToken = snapshot.data().fcmToken;
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });
      functions.logger.log("LikerID is: ");
      functions.logger.log(likerId);

      //Sending notification to Post Poster
      await admin
        .messaging()
        .send({
          token: posterFcmToken,
          notification: {
            title: `Post Liked`,
            body: `Your post was liked by ${likerName}`,
            imageUrl: likerImageUrl,
          },
          data: {
            id: likerId,
            postId: postId,
            name: likerName,
            imageUrl: likerImageUrl,
            screenName: "postScreen",
            type: "postLiked",
          },
        })
        .then((value) => {
          functions.logger.log(
            "Notification for Liking from liker is sent to the Poster"
          );
        })
        .catch((e) => {
          functions.logger.log(e.toString());
        });

      await admin
        .firestore()
        .collection("Notifications")
        .add({
          forId: posterId,
          image: likerImageUrl,
          message: `${likerName} liked your post`,
          type: "postLiked",
          dataId: postId,
          createdAt: Date.now(),
        });
    }
  });
//+------------------------------------------------------Notification for postCommentedNotification ------------------

exports.postCommentedNotification = functions.firestore
  .document("/Posts/{documentId}/comments/{commentId}")
  .onCreate(async (snap, context) => {

    var newData;
    const commentData = snap.data();
    var postId = commentData.postID;

    await admin
      .firestore()
      .collection("Posts")
      .doc(postId)
      .get().then(async (snapshot) => {
        newData = snapshot.data();
      });

    var posterId = newData.uID;
    var posterFcmToken;
    // var time = snap.data().time;

    //Getting Liker Profile Details
    var commenterId = commentData.commenterID;
    var commenterName;
    var commenterImageUrl;
    var commenterFcmToken;

    await admin
      .firestore()
      .collection("Accounts")
      .doc(posterId)
      .get()
      .then(async (snapshot) => {
        posterFcmToken = snapshot.data().fcmToken;
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });


    await admin
      .firestore()
      .collection("Accounts")
      .doc(commenterId)
      .get()
      .then((snapshot) => {
        commenterName = snapshot.data().fullName;
        commenterImageUrl = snapshot.data().profileImageUrl;
        commenterFcmToken = snapshot.data().fcmToken;
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });
    functions.logger.log("LikerID is: ");
    functions.logger.log(commenterId);

    //Sending notification to Post Poster

    await admin
      .messaging()
      .send({
        token: posterFcmToken,
        notification: {
          title: `Post Commented`,
          body: `${commenterName} commented on your post`,
          imageUrl: commenterImageUrl,
        },
        data: {
          id: commenterId,
          postId: postId,
          name: commenterName,
          imageUrl: commenterImageUrl,
          screenName: "postScreen",
          type: "postCommented",
        },
      })
      .then((value) => {
        functions.logger.log(
          "Notification for Liking from liker is sent to the Poster"
        );
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });

    await admin
      .firestore()
      .collection("Notifications")
      .add({
        forId: posterId,
        image: commenterImageUrl,
        message: `${commenterName} commented on your post`,
        type: "postCommented",
        dataId: postId,
        createdAt: Date.now(),
      });
  });
//+------------------------------------------------------Notification for notifyInvitedAboutGroupInvite ------------------

exports.notifyInvitedAboutGroupInvite = functions.firestore
  .document("/GroupChatInvitations/{documentId}")
  .onCreate(async (snap, context) => {

    //"groupId": groupChatModel.groupId ?? "",
    //"groupName": groupChatModel.groupName ?? "",
    //"groupImage": groupChatModel.groupImage ?? "",
    //"invitedId": selectedId.value,
    //"invitedName": userNameController.text.trim(),
    //"invitedById": userDetailsModel.uID,
    //"invitedByName": userDetailsModel.fullName,
    //"invitedAt": DateTime.now().millisecondsSinceEpoch,
    var groupId = snap.data().groupId;
    var groupName = snap.data().groupName;
    var groupImage = snap.data().groupImage;
    var invitedById = snap.data().invitedById;
    var invitedId = snap.data().invitedId;
    var invitedAt = snap.data().invitedAt;
    var invitedName = snap.data().invitedName;
    var invitedByName = snap.data().invitedByName;

    //      var message = snap.data().message;
    //      var chatRoomId = context.params.documentId;

    var imageUrl = groupImage;
    var generalImage = "";
    var myRetToken = "Not Retrieved Yet from Accounts Collection";
    functions.logger.info(invitedId.toString());
    //      functions.logger.info("Message By the Sender is:");
    //      functions.logger.info(message.toString());

    //  {
    functions.logger.info("In Chat function: type is Else block");
    //getting image and token of receiver from the firestore through admin sdk
    await admin
      .firestore()
      .collection("Accounts")
      .doc(invitedId)
      .get()
      .then((snapshot) => {
        myRetToken = snapshot.data().fcmToken;
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });
    //Now sending the notification using SingleToken function
    await admin
      .messaging()
      .send({
        token: myRetToken,
        notification: {
          title: `Group Invite`,
          body: ` ${invitedByName} invited you to join ${groupName}`,
          //Below line has use in terminated or background state of app
          imageUrl: groupImage,
        },
        data: {
          imageUrl: groupImage,
          groupId: groupId,
          screenName: "groupChatScreen",
        },
      })
      .then((value) => {
        functions.logger.log("Notifications sent to the invited person for group invite");
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });

    await admin
      .firestore()
      .collection("Notifications")
      .add({
        forId: invitedId,
        image: groupImage,
        message: `${invitedByName} invited you to ${groupName}`,
        type: "groupInvite",
        dataId: groupId,
        createdAt: invitedAt,
      });
    // }
  });


//+------------------------------------------------------Notification for Tag Posts ---------------------------------------
exports.taggedPeopleNotification = functions.firestore
  .document("/Posts/{documentId}")
  .onCreate(async (snap, context) => {

    const tagPeopleTokenList = snap.data().taggedPeopleToken;
    const posterName = snap.data().postBy;
    const postId = snap.data().postID;
    const posterImage = snap.data().profileImage;
    const posterId = snap.data().uID;
    const taggedPeopleIds = snap.data().taggedPeople;
    const videosIds = snap.data().videoIds;
    const uploadUrls = [];


    for (const index in videosIds) {

      functions.logger.info("In Chat function: type is video");
      const bucket = admin.storage().bucket();
      functions.logger.log(`bucket is: ${bucket.name}`);
      functions.logger.log(`single videoId at index: ${index} is: ${videosIds[index]}`);

      const fileName = `${videosIds[index]}.mp4`;
      functions.logger.log(`fileName is: ${fileName}`);

      const videoFile = bucket.file(`postVideos/${context.params.documentId}/${fileName}`);
      const resumableUpload = await videoFile.createResumableUpload();
      functions.logger.log(`resumableUpload is: ${resumableUpload}`);

      const uploadUrl = resumableUpload[0];
      functions.logger.log(`single uploadUrl is: ${uploadUrl}`);
      console.log(uploadUrl);
      uploadUrls.push(uploadUrl);
    }

    await admin.firestore().collection(`Posts`).doc(context.params.documentId).set({
      uploadUrls: uploadUrls
    }, { merge: true }).catch((e) => {
      functions.logger.log(`error in setting the uploadUrl is:${e.toString()}`);
    });

    //Sending notification to Post Poster
    await admin
      .messaging()
      .sendMulticast({
        tokens: tagPeopleTokenList,
        notification: {
          title: `Tagged in a post`,
          body: `${posterName} tagged you in their post`,
          imageUrl: posterImage,
        },
        data: {
          id: posterId,
          postId: postId,
          posterName: posterName,
          imageUrl: posterImage,
          screenName: "postScreen",
          type: "postTagged",
        },
      })
      .then((value) => {
        functions.logger.log(
          "Notification for tag post send to tag people "
        );
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });

    for (const index in taggedPeopleIds) {
      await admin
        .firestore()
        .collection("Notifications")
        .add({
          forId: taggedPeopleIds[index],
          image: posterImage,
          message: `${posterName} tagged you in their post`,
          type: "postTagged",
          dataId: postId,
          createdAt: Date.now(),
        });
      console.log(`A JavaScript type is: ${type}`)
    }


  });


//+------------------------------------------------------Notification for taggedPeopleNotificationOnUpdate ------------------

exports.taggedPeopleNotificationOnUpdate = functions.firestore
  .document("/Posts/{documentId}")
  .onUpdate(async (snap, context) => {

    const tagPeopleTokenList = change.after.data().taggedPeopleToken;
    const posterName = change.after.data().postBy;
    const postId = change.after.data().postID;
    const posterImage = change.after.data().profileImage;
    const posterId = change.after.data().uID;
    // const taggedPeopleIdsOlder = change.before.data().taggedPeople;
    // const taggedPeopleIdsNewer = change.after.data().taggedPeople;

    //Sending notification to Post Poster
    await admin
      .messaging()
      .sendMulticast({
        tokens: tagPeopleTokenList,
        notification: {
          title: `Tagged in a post`,
          body: `${posterName} tagged you in their post`,
          imageUrl: posterImage,
        },
        data: {
          id: posterId,
          postId: postId,
          posterName: posterName,
          imageUrl: posterImage,
          screenName: "postScreen",
          type: "postTagged",
        },
      })
      .then((value) => {
        functions.logger.log(
          "Notification for tag post send to tag people on update"
        );
      })
      .catch((e) => {
        functions.logger.log(e.toString());
      });

    // for (let i = 0; i < cars.length; i++) {
    //   await admin
    // .firestore()
    // .collection("Notifications")
    // .add({
    //   forId: taggedPeopleIds[index],
    //   image: posterImage,
    //   message: `${posterName} tagged you in their post`,
    //   type: "postTagged",
    //   dataId: postId,
    //   createdAt: Date.now(),
    // });
    //   console.log(`A JavaScript type is: ${type}`)
    // }


  });

//+------------------------------------------------------Notification for deletingCommentsOnPostDeletion --------------------

exports.deletingCommentsOnPostDeletion = functions.firestore
  .document("/Posts/{documentId}")
  .onDelete(async (snap, context) => {
    const postId = context.params.documentId;

    functions.logger.log("Post deleted and also deleting comments: " + postId);
    const fs = getFirestore();
    await fs.recursiveDelete(admin.firestore().collection(`/Posts/${postId}/comments`)).catch((e) => {
      functions.logger.log(e.toString());
    });
  });








