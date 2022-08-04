import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _fireStore = FirebaseFirestore.instance;
CollectionReference accounts = _fireStore.collection('Accounts');
CollectionReference posts = _fireStore.collection('Posts');
