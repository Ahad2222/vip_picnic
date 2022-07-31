import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vip_picnic/model/user_details_model/user_details_model.dart';

FirebaseAuth fa = FirebaseAuth.instance;
FirebaseFirestore fs = FirebaseFirestore.instance;
FirebaseStorage fsg = FirebaseStorage.instance;
UserDetailsModel userDetailsModel = UserDetailsModel.instance;
