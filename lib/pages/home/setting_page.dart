// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/Utils/firestore_collection.dart';
import 'package:example/Utils/update_child_dialog.dart';

import 'package:example/Utils/utils.dart';
import 'package:example/Utils/add_child_dialog.dart';
import 'package:example/models/user_model.dart';
import 'package:example/providers/auth_provider.dart';
import 'package:example/providers/child_provider.dart';
import 'package:example/providers/file_upload_provider.dart';
import 'package:example/providers/image_picker_provider.dart';
import 'package:example/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Future<void> childFuture;

  @override
  void initState() {
    super.initState();
    childFuture =
        Provider.of<ChildProvider>(context, listen: false).getChilds();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final childProvider = Provider.of<ChildProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: userCollection.doc(authProvider.currentuser!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No user found'));
              } else {
                final user = UserModel.fromJson(snapshot.data!.data()!);
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Choose Profile Photo',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () async {
                                        await imageProvider
                                            .pickImageFromCamera();
                                        Utils.back(context);
                                      },
                                      icon: const Icon(Icons.camera),
                                      label: const Text('Camera'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () async {
                                        await imageProvider
                                            .pickImageFromGallery();
                                        Utils.back(context);
                                      },
                                      icon: const Icon(Icons.image),
                                      label: const Text('Gallery'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ).then((value) async {
                          if (imageProvider.selectedImage != null) {
                            final uploadProvider =
                                Provider.of<FileUploadProvider>(context,
                                    listen: false);
                            final url = await uploadProvider.fileUpload(
                              file: imageProvider.selectedImage!,
                              fileName: 'user-image-${user.uid}',
                            );
                            if (url != null) {
                              await authProvider.updateUserImage(user.uid, url);
                              imageProvider.reset();
                            }
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.white,
                          child: CachedImage(user.profileImage,
                              isRound: true, radius: 250),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user.profileImage == null
                          ? 'Click to add photo'
                          : 'Click to change photo',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      width: 220,
                      child: Container(
                        padding: const EdgeInsets.only(top: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text(
                          user.userName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Childrens',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              AddChildDialog.showAddChildDialog(
                                  context, user.uid);
                            },
                            child: const Text('Add Child'),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: childFuture,
                      builder: (contex, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (childProvider.child.isEmpty) {
                          return const Center(child: Text('No child found'));
                        } else {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: childProvider.child.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              final child = childProvider.child[index];
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(child.imageUrl),
                                    ),
                                    Text(child.childName),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              Provider.of<ChildProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteChild(child);
                                            },
                                            icon: const Icon(Icons.delete)),
                                        IconButton(
                                            onPressed: () {
                                              UpdateChildDialog
                                                  .updateChildDialog(
                                                      context, child.uid);
                                            },
                                            icon: const Icon(Icons.edit))
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
