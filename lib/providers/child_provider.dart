// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/Utils/firestore_collection.dart';
import 'package:example/Utils/utils.dart';
import 'package:example/models/child_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChildProvider extends ChangeNotifier {
  ChildModel? _currentChild;

  User? get currentuser => FirebaseAuth.instance.currentUser;

  List<ChildModel> _child = [];

  List<ChildModel> get child => _child;

  ChildModel? get currentChild => _currentChild;

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
      await getChilds();
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

  // // get video for child
  // Future<void> getVideoForChild(String videoId) async {
  //   await childrenCollection(parentId: currentuser!.uid)
  //       .where('videos', arrayContains: videoId)
  //       .get();
  // }

  // add channel for child
  Future<void> addChannelForChild(
    String channelId,
    String childId,
  ) async {
    await childrenCollection(parentId: currentuser!.uid).doc(childId).update({
      'channels': FieldValue.arrayUnion([channelId]),
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

  Future<List<ChildModel>> _filterChilds(String parentId) async {
    final child = <ChildModel>[];
    final res = await childrenCollection(parentId: parentId).get();
    if (res.docs.isNotEmpty) {
      for (var data in res.docs) {
        child.add(ChildModel.fromJson(data.data() as Map<String, dynamic>));
      }
    }

    return child;
  }

  Future<void> getLoggedInChild(
      {required String parentEmail,
      required String childName,
      required String securityCode}) async {
    final res =
        await userCollection.where('email', isEqualTo: parentEmail).get();
    final childrens = await _filterChilds(res.docs.first.data()['uid']);
    if (childrens.isNotEmpty) {
      _currentChild = childrens.firstWhere((element) =>
          element.childName == childName &&
          element.securtiyCode == securityCode);

      notifyListeners();
    }
  }
}
