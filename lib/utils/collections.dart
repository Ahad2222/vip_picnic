import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _fireStore = FirebaseFirestore.instance;

CollectionReference privateAccCol = _fireStore.collection('Private Accounts');
CollectionReference businessAccCol = _fireStore.collection('Business Accounts');
