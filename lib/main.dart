import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterallplatforms/login.dart';
import 'firebase_options.dart';
// import 'service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final emulatorHost = (checkPlatform() == Platform.isMobile) ? '10.0.2.2' : 'localhost';
  // await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6Lcb5qYiAAAAAHOsziL7BEC9eX6krXKVZNeOjlWi',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter All Platforms',
      home: LoginPageWidget(),
    );
  }
}
