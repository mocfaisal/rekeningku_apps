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
    apiKey: 'AIzaSyDNIOTWT4kbDKZZFi1tjvxlBHqVonhQzV8',
    appId: '1:972712325260:web:69b571e2cdd61f8747cba9',
    messagingSenderId: '972712325260',
    projectId: 'rekeningku-36cac',
    authDomain: 'rekeningku-36cac.firebaseapp.com',
    databaseURL: 'https://rekeningku-36cac-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'rekeningku-36cac.appspot.com',
    measurementId: 'G-M4Y293BX03',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7d_N_Gn0fLMvfB7oc9tfn5Grok5ZlyA4',
    appId: '1:972712325260:android:e18fc058e44fad5a47cba9',
    messagingSenderId: '972712325260',
    projectId: 'rekeningku-36cac',
    databaseURL: 'https://rekeningku-36cac-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'rekeningku-36cac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAc2xrKc0FI8_9nwhqNdM7se8y2oK8ypOc',
    appId: '1:972712325260:ios:77d917449041a44447cba9',
    messagingSenderId: '972712325260',
    projectId: 'rekeningku-36cac',
    databaseURL: 'https://rekeningku-36cac-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'rekeningku-36cac.appspot.com',
    iosBundleId: 'com.example.rekeningkuapps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAc2xrKc0FI8_9nwhqNdM7se8y2oK8ypOc',
    appId: '1:972712325260:ios:77d917449041a44447cba9',
    messagingSenderId: '972712325260',
    projectId: 'rekeningku-36cac',
    databaseURL: 'https://rekeningku-36cac-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'rekeningku-36cac.appspot.com',
    iosBundleId: 'com.example.rekeningkuapps',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDNIOTWT4kbDKZZFi1tjvxlBHqVonhQzV8',
    appId: '1:972712325260:web:d3669cb2bf97fc1347cba9',
    messagingSenderId: '972712325260',
    projectId: 'rekeningku-36cac',
    authDomain: 'rekeningku-36cac.firebaseapp.com',
    databaseURL: 'https://rekeningku-36cac-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'rekeningku-36cac.appspot.com',
    measurementId: 'G-Z0BW1XPWEJ',
  );
}