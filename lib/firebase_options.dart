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
    apiKey: 'AIzaSyBxKucqEPhOseSKFRaDViAmkiH2iSXSIo8',
    appId: '1:412094920301:web:e3ebf2b401f3fe2263f164',
    messagingSenderId: '412094920301',
    projectId: 'fluttertest-94a4a',
    authDomain: 'fluttertest-94a4a.firebaseapp.com',
    storageBucket: 'fluttertest-94a4a.appspot.com',
    measurementId: 'G-08SGZN9GLV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaw3HvAHKWUrOWjXhZVadvX3g7Rj1dm_U',
    appId: '1:412094920301:android:3ddd456cec3951f463f164',
    messagingSenderId: '412094920301',
    projectId: 'fluttertest-94a4a',
    storageBucket: 'fluttertest-94a4a.appspot.com',
  );
}
