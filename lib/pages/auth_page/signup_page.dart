// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, must_be_immutable
import 'package:example/Utils/utils.dart';
import 'package:example/models/user_model.dart';
import 'package:example/pages/auth_page/login_page.dart';
import 'package:example/pages/home/home_page.dart';
import 'package:example/providers/auth_provider.dart';
import 'package:example/providers/file_upload_provider.dart';
import 'package:example/providers/image_picker_provider.dart';
import 'package:example/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class SignupPage extends HookWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    //final authProvider = Provider.of<AuthProvider>(context);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final usernameController = useTextEditingController();
    //final _formField = GlobalKey<FormState>();
    final showPassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          onPressed: () {
            Utils.back(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.navigateTo(context, const LoginPage());
            },
            child: const Text(
              'LOGIN',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Stack(
                  children: [
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: imageProvider.selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                imageProvider.selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () async {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            await imageProvider
                                                .pickImageFromCamera();
                                            Utils.back(context);
                                          },
                                          icon: const Icon(
                                            Icons.camera,
                                            size: 30,
                                          ),
                                          label: const Text('Camera'),
                                        ),
                                        TextButton.icon(
                                            onPressed: () async {
                                              await imageProvider
                                                  .pickImageFromGallery();
                                              Utils.back(context);
                                            },
                                            icon: const Icon(Icons.image),
                                            label: const Text('Gallery'))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.red,
                            size: 30,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: usernameController,
                  hintText: 'Enter Username:',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.left,
                  enableBorder: false,
                  //readOnly: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter Email:',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                  enableBorder: false,
                  //readOnly: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  isPassword: showPassword.value,
                  controller: passwordController,
                  hintText: 'Enter Password:',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                  enableBorder: false,
                  suffixWidget: InkWell(
                    onTap: () {
                      showPassword.value = !showPassword.value;
                    },
                    child: Icon(showPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                child: const Text('SIGN UP'),
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    Utils.showToast('Enter valid email');
                    return;
                  } else if (passwordController.text.isEmpty) {
                    Utils.showToast('Enter valid password');
                    return;
                  } else if (usernameController.text.isEmpty) {
                    Utils.showToast('Enter valid username');
                    return;
                  } else if (imageProvider.selectedImage == null) {
                    Utils.showToast('Please select an image');
                    return;
                  } else {
                    EasyLoading.show(status: 'loading...');

                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final res = await authProvider.registerWithEmailAndPassword(
                        emailController.text, passwordController.text);
                    debugPrint(
                        'signup_screen at Line 139: $res, ${res.user?.uid}');

                    final imageUploadProvider =
                        Provider.of<FileUploadProvider>(context, listen: false);
                    final imageUrl = await imageUploadProvider.fileUpload(
                        file: imageProvider.selectedImage!,
                        fileName: 'user-image-${res.user?.uid}');
                    EasyLoading.dismiss();

                    if (imageUrl != null) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .currentuser!
                          .uid;
                    }
                    if (res.user != null) {
                      await authProvider.addUserToFirestore(
                        UserModel(
                          uid: res.user!.uid,
                          email: emailController.text,
                          userName: usernameController.text,
                          createdAt: res.user!.metadata.creationTime!,
                          profileImage: imageUrl,
                        ),
                      );
                    }

                    EasyLoading.dismiss();
                    usernameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    Utils.navigateTo(context, const HomePage());
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);

                    EasyLoading.show();

                    //final res =
                    await authProvider.signInWithGoogle();
                    EasyLoading.dismiss();
                    Utils.navigateTo(context, const HomePage());
                    // if (res.user != null) {
                    //   final usermodel = UserModel(
                    //     uid: res.user!.uid,
                    //     userName: usernameController.text.toString(),
                    //     email: emailController.text.toString(),
                    //     createdAt: res.user!.metadata.creationTime!,
                    //     userImage: res.user!.photoURL,
                    //   );
                    //   authProvider.addUserToFirestore(usermodel);
                    // }

                    // }
                  },
                  child: const Text('Continue with Google')),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
