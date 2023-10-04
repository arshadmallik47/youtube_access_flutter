import 'package:example/pages/auth_page/signup_page.dart';
import 'package:example/services/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => AppProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SignupPage(),
          builder: EasyLoading.init(),
          theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: PrimaryColor,
              scaffoldBackgroundColor: PrimaryColor),
        ),
      );
}
