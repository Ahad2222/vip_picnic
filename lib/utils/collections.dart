import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip_picnic/constant/constant_variables.dart';

FirebaseFirestore _fireStore = FirebaseFirestore.instance;
CollectionReference accounts = _fireStore.collection(accountsCollection);
CollectionReference posts = _fireStore.collection('Posts');
CollectionReference stories = _fireStore.collection('Stories');
