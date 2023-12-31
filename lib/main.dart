import 'package:example/pages/starter_page.dart';
import 'package:example/services/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => AppProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const StarterPage(),
          builder: EasyLoading.init(),
          theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: PrimaryColor,
              scaffoldBackgroundColor: PrimaryColor),
        ),
      );
}
