// ignore_for_file: use_build_context_synchronously

import 'package:example/Utils/utils.dart';
import 'package:example/models/child_model.dart';
import 'package:example/providers/child_provider.dart';
import 'package:example/providers/file_upload_provider.dart';
import 'package:example/providers/image_picker_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddChildDialog {
  static Future<void> showAddChildDialog(
      BuildContext context, String parentUid) async {
    final nameController = TextEditingController();
    final securityCodeController = TextEditingController();
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
                            ? const Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 4.0,
                              ))
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
                      controller: securityCodeController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Security Code'),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final securitycode = securityCodeController.text.trim();
                    if (name.isNotEmpty && securitycode.isNotEmpty) {
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
                          final childProvider = Provider.of<ChildProvider>(
                              context,
                              listen: false);
                          final String uniqueChildUid = const Uuid().v4();

                          await childProvider.addChildToFirestore(ChildModel(
                              uid: uniqueChildUid,
                              childName: name,
                              securtiyCode: securitycode,
                              imageUrl: pictureUrl,
                              videos: [],
                              channels: []));
                          await childProvider.getChilds();

                          Utils.showToast('Child added successfully');

                          imageProvider.reset();
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
              ],
            );
          },
        );
      },
    );
  }
}
