
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
    apiKey: 'AIzaSyB8JnwA42aDJdgFYF8BsL9z4Ly_Ymicv-Q',
    appId: '1:455500654726:web:fa58ee8b5218bb7d41c907',
    messagingSenderId: '455500654726',
    projectId: 'chat-dating-app-flutter',
    authDomain: 'chat-dating-app-flutter.firebaseapp.com',
    storageBucket: 'chat-dating-app-flutter.firebasestorage.app',
    measurementId: 'G-3DF051D7GH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtHJlncDzVYKmA_Y6RDfvcl2rlT3y0qHc',
    appId: '1:455500654726:android:d82888d335c8f92941c907',
    messagingSenderId: '455500654726',
    projectId: 'chat-dating-app-flutter',
    storageBucket: 'chat-dating-app-flutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAatyUZgK7jIEbs2dK71ROKRs_H_8WKeIQ',
    appId: '1:455500654726:ios:b0a4412a1e3cb88041c907',
    messagingSenderId: '455500654726',
    projectId: 'chat-dating-app-flutter',
    storageBucket: 'chat-dating-app-flutter.firebasestorage.app',
    iosBundleId: 'com.example.chatDatingApp',
  );

}