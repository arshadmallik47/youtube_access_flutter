// ignore_for_file: avoid_print

import 'package:example/Utils/utils.dart';

import 'package:example/pages/home/home_page.dart';
import 'package:example/providers/auth_provider.dart';
import 'package:example/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Google Sign In
  GoogleSignIn googleAuth = GoogleSignIn();

  final _formField = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formField,
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                width: 260,
                height: 100,
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 30),
                child: Text(
                  'LOG IN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: userNameController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter Username or email:',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.left,
                  enableBorder: false,
                  // readOnly: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  isPassword: passToggle,
                  controller: passwordController,
                  hintText: 'Enter Password:',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                  enableBorder: false,
                  // readOnly: true,
                  suffixWidget: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(
                        passToggle ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Utils.navigateTo(context, ForgotPassword());
              //   },
              //   child: InkWell(
              //     onTap: () {
              //       Utils.navigateTo(
              //         context,
              //         const ForgotPassword(),
              //       );
              //     },
              //     child: const Text(
              //       'Forgot Password?',
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              ElevatedButton(
                onPressed: () async {
                  if (userNameController.text.isEmpty) {
                    Utils.showToast('Enter valid email');
                  } else if (passwordController.text.isEmpty) {
                    Utils.showToast('Enter valid password');
                  } else {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    EasyLoading.show();
                    final res = await authProvider.signInWithEmailAndPassword(
                      userNameController.text,
                      passwordController.text,
                    );
                    EasyLoading.dismiss();
                    if (res.user != null) {
                      userNameController.clear();
                      passwordController.clear();
                      // ignore: use_build_context_synchronously
                      Utils.navigateTo(context, const HomePage());
                    }
                  }
                },
                child: const Text('LOG IN'),
              ),

              const SizedBox(
                height: 40,
              ),
              // ElevatedButton(
              //     //colour: Colors.black,
              //     // title: 'Login With Google',
              //     child: const Text('LOGIN WITH GOOGLE'),
              //     onPressed: () {
              //       EasyLoading.show();
              //       googleAuth.signIn().then((result) {
              //         result?.authentication.then((googleKey) {
              //           final credential = GoogleAuthProvider.credential(
              //             accessToken: googleKey.accessToken,
              //             idToken: googleKey.idToken,
              //           );

              //           FirebaseAuth.instance
              //               .signInWithCredential(credential)
              //               .then((signedInUser) {
              //             print(signedInUser);
              //             print('${signedInUser.user}');
              //             Utils.navigateTo(context, ChildVideoPage());
              //             EasyLoading.dismiss();
              //           }).catchError((e) {
              //             print(e);
              //           });

              //           // EasyLoading.dismiss();
              //         }).catchError((e) {
              //           print(e);
              //         });
              //       }).catchError((e) {
              //         print(e);
              //       });
              //     }),
            ]),
          ),
        ),
      ));
}
