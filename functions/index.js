const functions = require("firebase-functions");
// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
admin.firestore().settings({ ignoreUndefinedProperties: true });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

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
        title: `You received an Image from  ${recName}`,
        body: {},
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

exports.notifyReceiverForChat = functions.firestore
  .document("/ChatRoom/{documentId}/messages/{chatDocumentId}")
  .onCreate(async (snap, context) => {
    var recId = snap.data().receivedById;
    var senId = snap.data().sendById;

    var recName = snap.data().receivedByName;
    var senName = snap.data().sendByName;

    var message = snap.data().message;
    var chatRoomId = context.params.documentId;

    var imageUrl = "No Name";
    var generalImage = "";
    var myRetToken = "Not Retrieved Yet from Accounts Collection";
    functions.logger.info(recId.toString());
    functions.logger.info("Message By the Sender is:");
    functions.logger.info(message.toString());

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
        imageUrl,
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
        imageUrl,
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
        imageUrl,
        senName,
        recName,
        chatRoomId
      );
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
        imageUrl,
        senName,
        recName,
        chatRoomId
      );
    }
  });


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

    // functions.logger.log(
      // `LikerID Profile Details: ${posterId}, ${followedName}, ${followedImageUrl},`
    // );

    //Getting Liker Profile Details
    var likerId = likesList[likesList.length - 1];
    var likerName;
    var likerImageUrl;
    var likerFcmToken;

    // functions.logger.log(
    // `LikerID Profile Details: ${likerId}, ${likerName}, ${likerImageUrl}, ${likerFcmToken},`
    // );

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

    // functions.logger.log(
      // `LikerID Profile Details: ${posterId}, ${followedName}, ${followedImageUrl},`
    // );

    //Getting Liker Profile Details
    var commenterId = commentData.commenterID;
    var commenterName;
    var commenterImageUrl;
    var commenterFcmToken;

    // functions.logger.log(
    // `LikerID Profile Details: ${commenterId}, ${commenterName}, ${commenterImageUrl}, ${commenterFcmToken},`
    // );

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
