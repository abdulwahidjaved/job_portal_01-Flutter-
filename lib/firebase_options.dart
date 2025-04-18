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
    apiKey: 'AIzaSyA3LTZtubnK4RuJdExtc0YsjH-g8Hx1yqA',
    appId: '1:521856690520:web:b490882c9a55b35c771d2d',
    messagingSenderId: '521856690520',
    projectId: 'job-portal-2-d83a5',
    authDomain: 'job-portal-2-d83a5.firebaseapp.com',
    storageBucket: 'job-portal-2-d83a5.firebasestorage.app',
    measurementId: 'G-2ZE8D2MDP6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxfDY7KcLZATtaQT6Zv9yM-mq4R8H5Upc',
    appId: '1:521856690520:android:3535a8cfb5803241771d2d',
    messagingSenderId: '521856690520',
    projectId: 'job-portal-2-d83a5',
    storageBucket: 'job-portal-2-d83a5.firebasestorage.app',
  );

}