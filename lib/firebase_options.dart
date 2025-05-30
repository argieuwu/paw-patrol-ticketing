// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDEuCsDO1BxNC-gVgMTyA9pRktXP_DhDh0',
    appId: '1:139211941947:web:d73861496bb6c16466941e',
    messagingSenderId: '139211941947',
    projectId: 'busbus-c4071',
    authDomain: 'busbus-c4071.firebaseapp.com',
    storageBucket: 'busbus-c4071.firebasestorage.app',
    measurementId: 'G-5GCXJ56PLY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBD0MEkALLIClLiUCJxY2YSB-V4p5DjO9I',
    appId: '1:139211941947:android:f3408539e3597b7d66941e',
    messagingSenderId: '139211941947',
    projectId: 'busbus-c4071',
    storageBucket: 'busbus-c4071.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBH5zv9LWPeMXODH9opH3HK0WvqNAPOPWY',
    appId: '1:139211941947:ios:670be4687ba2e4dc66941e',
    messagingSenderId: '139211941947',
    projectId: 'busbus-c4071',
    storageBucket: 'busbus-c4071.firebasestorage.app',
    iosBundleId: 'com.example.capstone2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBH5zv9LWPeMXODH9opH3HK0WvqNAPOPWY',
    appId: '1:139211941947:ios:670be4687ba2e4dc66941e',
    messagingSenderId: '139211941947',
    projectId: 'busbus-c4071',
    storageBucket: 'busbus-c4071.firebasestorage.app',
    iosBundleId: 'com.example.capstone2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDEuCsDO1BxNC-gVgMTyA9pRktXP_DhDh0',
    appId: '1:139211941947:web:b22dc4c47be1c0da66941e',
    messagingSenderId: '139211941947',
    projectId: 'busbus-c4071',
    authDomain: 'busbus-c4071.firebaseapp.com',
    storageBucket: 'busbus-c4071.firebasestorage.app',
    measurementId: 'G-S0NKY1EH5H',
  );
}
