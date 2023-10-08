// ignore_for_file: avoid_print

import 'package:example/Utils/firestore_collection.dart';
import 'package:example/models/child_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChildProvider extends ChangeNotifier {
  User? get currentuser => FirebaseAuth.instance.currentUser;

  // add child to firestore

  Future<void> addChildToFirestore(ChildModel childModel) async {
    await childrenCollection(parentId: currentuser!.uid)
        .doc(childModel.uid)
        .set(childModel.toJson());
  }

  // delete child
  Future<void> deleteChild(ChildModel child) async {
    await childrenCollection(parentId: currentuser!.uid)
        .doc(child.uid)
        .delete();
  }

  // update child
  Future<void> updateChild(childId, String newImageUrl, String newName) async {
    final childDocReference =
        childrenCollection(parentId: currentuser!.uid).doc(childId);

    try {
      await childDocReference.update({
        'imageUrl': newImageUrl,
        'childName': newName,
      });
      print('Child updated successfully');
    } catch (e) {
      print('Error updating child: $e');
    }
  }
}
