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
    apiKey: 'AIzaSyBI6uyw_oRXvydoAQE4v-1AekTKSVCamSc',
    appId: '1:535297179152:web:078cf77fe3f88ddfb9d495',
    messagingSenderId: '535297179152',
    projectId: 'moonchat-fb8c7',
    authDomain: 'moonchat-fb8c7.firebaseapp.com',
    storageBucket: 'moonchat-fb8c7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGYY0Plh7DCJ8XUQM_jR9BcaiX8dShMlk',
    appId: '1:535297179152:android:74436b7ab0ce427cb9d495',
    messagingSenderId: '535297179152',
    projectId: 'moonchat-fb8c7',
    storageBucket: 'moonchat-fb8c7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAc5oOzzb2_m4V0hGwlQ76V2QFxX6pXRUg',
    appId: '1:535297179152:ios:5a4ceaca9e0cd18cb9d495',
    messagingSenderId: '535297179152',
    projectId: 'moonchat-fb8c7',
    storageBucket: 'moonchat-fb8c7.appspot.com',
    iosClientId: '535297179152-3cim5gu1dtd6u56662hr59eb8mn1usar.apps.googleusercontent.com',
    iosBundleId: 'com.example.moonChat',
  );
}
