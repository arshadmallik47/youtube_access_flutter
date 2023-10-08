import 'package:example/providers/auth_provider.dart';
import 'package:example/providers/file_upload_provider.dart';
import 'package:example/providers/child_provider.dart';
import 'package:example/providers/image_picker_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => ChildProvider()),
          ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
          ChangeNotifierProvider(create: (context) => FileUploadProvider()),
        ],
        child: child,
      );
}
