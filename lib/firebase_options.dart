// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBr-k9Q-7WWjJ61UAAH8mgisZ3WTl2uJJA',
    appId: '1:601731464802:web:7d84684a50518e66899b3b',
    messagingSenderId: '601731464802',
    projectId: 'flutter-all-platforms',
    authDomain: 'flutter-all-platforms.firebaseapp.com',
    storageBucket: 'flutter-all-platforms.appspot.com',
    measurementId: 'G-6NCPTNQ2JH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBRhbxEMKysKb1cxwcKQZJbHtmEINCsSyc',
    appId: '1:601731464802:android:3ef00909dcf30733899b3b',
    messagingSenderId: '601731464802',
    projectId: 'flutter-all-platforms',
    storageBucket: 'flutter-all-platforms.appspot.com',
  );
}
