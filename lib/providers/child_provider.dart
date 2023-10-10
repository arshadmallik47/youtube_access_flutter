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

  List<ChildModel> _child = [];

  List<ChildModel> get child => _child;

// add child
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
    await getChilds();
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

  // add channel for child
  Future<void> addChannelForChild(
    String channelId,
    String childId,
  ) async {
    await childrenCollection(parentId: currentuser!.uid).doc(childId).update({
      'channels': FieldValue.arrayUnion([childId]),
    });
  }

  Future<void> getChilds() async {
    _child = [];
    final res = await childrenCollection(parentId: currentuser!.uid).get();
    if (res.docs.isNotEmpty) {
      for (var data in res.docs) {
        _child.add(ChildModel.fromJson(data.data() as Map<String, dynamic>));
      }
    }

    notifyListeners();
  }
}
