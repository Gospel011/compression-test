import 'dart:io';

import 'package:compression_test/home.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';

final mediaStorePlugin = MediaStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
    List<Permission> permissions = [Permission.storage];

    if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
      permissions.add(Permission.photos);
      // permissions.add(Permission.audio);
      // permissions.add(Permission.videos);
    }

    await permissions.request();
    MediaStore.appFolder = "MediaStorePlugin";
    // final status = result[Permission.photos];
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Packtide',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: "Arial_Rounded", fontWeight: FontWeight.normal),
        ),
      ),
      home: Home(),
    );
  }
}
