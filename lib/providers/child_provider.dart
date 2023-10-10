// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/Utils/firestore_collection.dart';
import 'package:example/Utils/utils.dart';
import 'package:example/models/child_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChildProvider extends ChangeNotifier {
  User? get currentuser => FirebaseAuth.instance.currentUser;

// add child
  Future<void> addChildToFirestore(ChildModel childModel) async {
    await childrenCollection(parentId: currentuser!.uid)
        .doc(childModel.uid)
        .set(childModel.toJson());
  }

  // delete child
  Future<void> deleteChild(ChildModel childModel) async {
    await childrenCollection(parentId: currentuser!.uid)
        .doc(childModel.uid)
        .delete();
    Utils.showToast('Child deleted successfully');
  }

  // update child
  Future<void> updateChild(
      String childId, String newImageUrl, String newName) async {
    final childDocReference =
        childrenCollection(parentId: currentuser!.uid).doc(childId);

    try {
      EasyLoading.show();
      await childDocReference.update({
        'imageUrl': newImageUrl,
        'childname': newName,
      });
      EasyLoading.dismiss();
      print('Child updated successfully');
    } catch (e) {
      print('Error updating child: $e');
    }
  }

  // allow video for child
  Future<void> allowVideoForChild(
    String videoId,
    String childId,
  ) async {
    await childrenCollection(parentId: currentuser!.uid).doc(childId).update({
      'videos': FieldValue.arrayUnion([videoId]),
    });
  }

  // Future<void> allowVideoForChild(
  //   String parentId,
  //   String videoId,
  // ) async {
  //   CollectionReference childsCollection =
  //       childrenCollection(parentId: parentId);
  //   await childsCollection.add({
  //     'videos': videoId,
  //   }).then((_) {
  //     print('Video allowed for child successfully.');
  //   }).catchError((error) {
  //     print('Error allowing video for child: $error');
  //   });
  // }
}
