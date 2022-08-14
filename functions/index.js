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
  .document("/ChatRoom/{documentId}/chats/{chatDocumentId}")
  .onCreate(async (snap, context) => {
    var recId = snap.data().receivedById;
    var senId = snap.data().sendById;

    var recName = snap.data().receivedByName;
    var senName = snap.data().sendByName;

    var message = snap.data().message;
    var chatRoomId = context.params.documentId;

    var imageUrl = "No Name";
    var generalImage = "";
    var myRetToken = "Not Retrieved Yet from Users Collection";
    functions.logger.info(recId.toString());
    functions.logger.info("Message By the Sender is:");
    functions.logger.info(message.toString());

    if (snap.data().type == "image") {
      functions.logger.info("In Chat function: type is Image");
      generalImage = snap.data().message;
      await admin
        .firestore()
        .collection("Users")
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
    } else if (snap.data().type == "text") {
      //getting image and token of receiver from the firestore through admin sdk
      functions.logger.info("In Chat function: type is text");
      await admin
        .firestore()
        .collection("Users")
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
    } else if (snap.data().type == "audio") {
      functions.logger.info("In Chat function: type is audio");
      //getting image and token of receiver from the firestore through admin sdk
      await admin
        .firestore()
        .collection("Users")
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
    } else {
      functions.logger.info("In Chat function: type is Else block");
      //getting image and token of receiver from the firestore through admin sdk
      await admin
        .firestore()
        .collection("Users")
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
