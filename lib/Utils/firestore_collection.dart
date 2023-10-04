// firestore collections constants
import 'package:cloud_firestore/cloud_firestore.dart';

final userCollection = FirebaseFirestore.instance.collection('users');

CollectionReference childrenCollection({required String parentId}) {
  return userCollection.doc(parentId).collection('child');
}
