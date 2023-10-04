// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:example/Utils/utils.dart';
// import 'package:example/models/user_model.dart';

// import 'package:example/providers/auth_provider.dart';
// import 'package:example/providers/file_upload_provider.dart';
// import 'package:example/providers/image_picker_provider.dart';
// import 'package:example/widgets/cached_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SettingPage extends StatelessWidget {
//   const SettingPage({super.key});

// ignore_for_file: use_build_context_synchronously

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final imageProvider = Provider.of<ImagePickerProvider>(context);
//     final userCollection = FirebaseFirestore.instance.collection('users');
//     return Scaffold(
//         body: Column(
//       children: [
//         FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//             future: userCollection.doc(authProvider.currentuser!.uid).get(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (!snapshot.hasData) {
//                 return const Center(child: Text('No user found'));
//               } else {
//                 final user = UserModel.fromJson(snapshot.data!.data()!);
//                 return Column(
//                   //    crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         await showModalBottomSheet(
//                           context: context,
//                           builder: (context) => Container(
//                             height: 100,
//                             width: MediaQuery.of(context).size.width,
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 20,
//                             ),
//                             child: Column(
//                               children: [
//                                 const Text(
//                                   'Choose Profile Photo',
//                                   style: TextStyle(fontSize: 20),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextButton.icon(
//                                       onPressed: () async {
//                                         await imageProvider
//                                             .pickImageFromCamera();
//                                         // ignore: use_build_context_synchronously
//                                         Utils.back(context);
//                                       },
//                                       icon: const Icon(Icons.camera),
//                                       label: const Text('Camera'),
//                                     ),
//                                     TextButton.icon(
//                                         onPressed: () async {
//                                           await imageProvider
//                                               .pickImageFromGallery();
//                                           // ignore: use_build_context_synchronously
//                                           Utils.back(context);
//                                         },
//                                         icon: const Icon(Icons.image),
//                                         label: const Text('Gallery'))
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ).then((value) async {
//                           if (imageProvider.selectedImage != null) {
//                             final uploadProvider =
//                                 Provider.of<FileUploadProvider>(context,
//                                     listen: false);
//                             final url = await uploadProvider.fileUpload(
//                                 file: imageProvider.selectedImage!,
//                                 fileName: 'user-image-${user.uid}');
//                             if (url != null) {
//                               await authProvider.updateUserImage(user.uid, url);
//                               imageProvider.reset();
//                             }
//                           }
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.only(top: 15),
//                         child: CircleAvatar(
//                           radius: 75,
//                           backgroundColor: Colors.white,
//                           child: CachedImage(user.profileImage,
//                               isRound: true, radius: 250),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       user.profileImage == null
//                           ? 'Click to add photo'
//                           : 'Click to change photo',
//                       style: const TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 15,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       height: 40,
//                       width: 220,
//                       child: Container(
//                         padding: const EdgeInsets.only(top: 9),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: Colors.white),
//                         ),
//                         child: Text(
//                           user.userName,
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.normal,
//                               color: Colors.redAccent),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       alignment: Alignment.topLeft,
//                       child: const Text(
//                         'Childs',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }
//             }),
//       ],
//     ));
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/Utils/firestore_collection.dart';
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
                      child: const Text(
                        'Children',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _showAddChildDialog(context, user.uid);
                      },
                      child: const Text('Add Child'),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Future<void> _showAddChildDialog(
  //     BuildContext context, String parentUid) async {
  //   final nameController = TextEditingController();
  //   final passwordController = TextEditingController();
  //   final imageProvider =
  //       Provider.of<ImagePickerProvider>(context, listen: false);

  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Add Child'),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               GestureDetector(
  //                 onTap: () async {
  //                   await showModalBottomSheet(
  //                     context: context,
  //                     builder: (context) => Container(
  //                       height: 150,
  //                       child: Column(
  //                         children: [
  //                           ListTile(
  //                             leading: const Icon(Icons.camera),
  //                             title: const Text('Take a photo'),
  //                             onTap: () async {
  //                               await imageProvider.pickImageFromCamera();
  //                               // ignore: use_build_context_synchronously
  //                               Navigator.of(context).pop();
  //                             },
  //                           ),
  //                           ListTile(
  //                             leading: const Icon(Icons.image),
  //                             title: const Text('Choose from gallery'),
  //                             onTap: () async {
  //                               await imageProvider.pickImageFromGallery();
  //                               // ignore: use_build_context_synchronously
  //                               Navigator.of(context).pop();
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                   height: 150,
  //                   width: 150,
  //                   decoration: BoxDecoration(

  //                     color: Colors.grey[200],
  //                     border: Border.all(color: Colors.grey),
  //                   ),
  //                   child: imageProvider.selectedImage != null
  //                       ? Image.file(
  //                           imageProvider.selectedImage!,
  //                           fit: BoxFit.cover,
  //                         )
  //                       : const Icon(
  //                           Icons.camera_alt,
  //                           size: 50,
  //                           color: Colors.grey,
  //                         ),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               TextField(
  //                 controller: nameController,
  //                 decoration: const InputDecoration(labelText: 'Child Name'),
  //               ),
  //               TextField(
  //                 controller: passwordController,
  //                 obscureText: true,
  //                 decoration: const InputDecoration(labelText: 'Password'),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () async {
  //               final name = nameController.text.trim();
  //               final password = passwordController.text.trim();

  //               if (name.isNotEmpty && password.isNotEmpty) {
  //                 if (imageProvider.selectedImage != null) {
  //                   final uploadProvider =
  //                       Provider.of<FileUploadProvider>(context, listen: false);
  //                   final pictureUrl = await uploadProvider.fileUpload(
  //                     file: imageProvider.selectedImage!,
  //                     fileName: 'child-image-$name',
  //                   );

  //                   if (pictureUrl != null) {
  //                     final childrenCollection =
  //                         FirebaseFirestore.instance.collection('children');

  //                     await childrenCollection.add({
  //                       'parentUid': parentUid,
  //                       'name': name,
  //                       'pictureUrl': pictureUrl,
  //                       'password': password,
  //                     });

  //                     Utils.showToast('Child added successfully');
  //                     // ignore: use_build_context_synchronously
  //                     Navigator.of(context).pop();
  //                   } else {
  //                     Utils.showToast('Failed to upload child image');
  //                   }
  //                 } else {
  //                   Utils.showToast('Please select a child image');
  //                 }
  //               } else {
  //                 Utils.showToast('Please fill in all fields');
  //               }
  //             },
  //             child: const Text('Save'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Future<void> _showAddChildDialog(
      BuildContext context, String parentUid) async {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    final imageProvider =
        Provider.of<ImagePickerProvider>(context, listen: false);
    bool isUploading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Child'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: 150,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text('Take a photo'),
                                  onTap: () async {
                                    await imageProvider.pickImageFromCamera();
                                    Navigator.of(context).pop();
                                    setState(
                                        () {}); // Refresh the dialog content
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Choose from gallery'),
                                  onTap: () async {
                                    await imageProvider.pickImageFromGallery();
                                    Navigator.of(context).pop();
                                    setState(
                                        () {}); // Refresh the dialog content
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                        ),
                        child: isUploading
                            ? const CircularProgressIndicator()
                            : imageProvider.selectedImage != null
                                ? Image.file(
                                    imageProvider.selectedImage!,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Child Name'),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final password = passwordController.text.trim();

                    if (name.isNotEmpty && password.isNotEmpty) {
                      if (imageProvider.selectedImage != null && !isUploading) {
                        setState(() {
                          isUploading = true;
                        });

                        final uploadProvider = Provider.of<FileUploadProvider>(
                            context,
                            listen: false);
                        final pictureUrl = await uploadProvider.fileUpload(
                          file: imageProvider.selectedImage!,
                          fileName: 'child-image-$name',
                        );

                        setState(() {
                          isUploading = false;
                        });

                        if (pictureUrl != null) {
                          await childrenCollection(parentId: parentUid).add({
                            'name': name,
                            'pictureUrl': pictureUrl,
                            'password': password,
                          });

                          Utils.showToast('Child added successfully');
                          Navigator.of(context).pop();
                        } else {
                          Utils.showToast('Failed to upload child image');
                        }
                      } else {
                        Utils.showToast('Please select a child image');
                      }
                    } else {
                      Utils.showToast('Please fill in all fields');
                    }
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
