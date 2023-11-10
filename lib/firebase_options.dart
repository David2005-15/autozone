// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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
    apiKey: 'AIzaSyBzpfEDnZBhvTMVhQT6d5gZTmW7pOnjeY0',
    appId: '1:62059107234:web:151f63c7799f1b873658fb',
    messagingSenderId: '62059107234',
    projectId: 'autozone-5d681',
    authDomain: 'autozone-5d681.firebaseapp.com',
    storageBucket: 'autozone-5d681.appspot.com',
    measurementId: 'G-5XWER1KK52',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNRRrqf-OqTlZG633YYCm6etg7r_V_Yrc',
    appId: '1:62059107234:android:0b00e8fdbd67d55b3658fb',
    messagingSenderId: '62059107234',
    projectId: 'autozone-5d681',
    storageBucket: 'autozone-5d681.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCg9mRssglGjldkD73rv6oCkuXWfb0XUsc',
    appId: '1:62059107234:ios:9e576bbb43819b6f3658fb',
    messagingSenderId: '62059107234',
    projectId: 'autozone-5d681',
    storageBucket: 'autozone-5d681.appspot.com',
    iosBundleId: 'com.example.autozone',
  );
}