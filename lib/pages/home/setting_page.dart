import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/Utils/utils.dart';
import 'package:example/models/user_model.dart';

import 'package:example/providers/auth_provider.dart';
import 'package:example/providers/file_upload_provider.dart';
import 'package:example/providers/image_picker_provider.dart';
import 'package:example/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final userCollection = FirebaseFirestore.instance.collection('users');
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
                  //    crossAxisAlignment: CrossAxisAlignment.center,
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
                                        // ignore: use_build_context_synchronously
                                        Utils.back(context);
                                      },
                                      icon: const Icon(Icons.camera),
                                      label: const Text('Camera'),
                                    ),
                                    TextButton.icon(
                                        onPressed: () async {
                                          await imageProvider
                                              .pickImageFromGallery();
                                          // ignore: use_build_context_synchronously
                                          Utils.back(context);
                                        },
                                        icon: const Icon(Icons.image),
                                        label: const Text('Gallery'))
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
                                fileName: 'user-image-${user.uid}');
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
                  ],
                );
              }
            }),
      ],
    ));
  }
}
