import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:vip_picnic/controller/auth_controller/email_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/facebook_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/forgot_password_controller.dart';
import 'package:vip_picnic/controller/auth_controller/google_auth_controller.dart';
import 'package:vip_picnic/controller/auth_controller/sign_up_controller.dart';
import 'package:vip_picnic/controller/chat_controller/chat_controller.dart';
import 'package:vip_picnic/controller/event_controller/event_controller.dart';
import 'package:vip_picnic/controller/group_chat_controller/group_chat_controller.dart';
import 'package:vip_picnic/controller/home_controller/home_controller.dart';
import 'package:vip_picnic/controller/splash_screen_controller/splash_screen_controller.dart';
import 'package:vip_picnic/model/home_model/add_post_model.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';
import 'package:vip_picnic/view/choose_language/choose_language.dart';

//FIREBASE INSTANCES
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore ffstore = FirebaseFirestore.instance;
FirebaseStorage fstorage = FirebaseStorage.instance;
FirebaseMessaging fcm = FirebaseMessaging.instance;

//FIREBASE INSTANCES

//GETX CONTROLLER INSTANCES
SplashScreenController splashScreenController = SplashScreenController.instance;
EmailAuthController emailAuthController = EmailAuthController.instance;
GoogleAuthController googleAuthController = GoogleAuthController.instance;
FacebookAuthController facebookAuthController = FacebookAuthController.instance;
SignupController signupController = SignupController.instance;
ForgotPasswordController forgotPasswordController =
    ForgotPasswordController.instance;
HomeController homeController = HomeController.instance;
ChooseLanguageController languageController = ChooseLanguageController.instance;
ChatController chatController = ChatController.instance;
GroupChatController groupChatController = GroupChatController.instance;
EventController eventController = EventController.instance;
//GETX CONTROLLER INSTANCES

//MODELS INSTANCES
UserDetailsModel userDetailsModel = UserDetailsModel.instance;
AddPostModel addPostModel = AddPostModel.instance;
//MODELS INSTANCES


//Twilio
TwilioPhoneVerify? twilioPhoneVerify;