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
    apiKey: 'AIzaSyAKxw-HXxQsX1_eqR5T9-Q3W5w8K_EG-bw',
    appId: '1:415401777783:web:82a55ec36fa7ed68cdc472',
    messagingSenderId: '415401777783',
    projectId: 'jobfinder-f82f0',
    authDomain: 'jobfinder-f82f0.firebaseapp.com',
    storageBucket: 'jobfinder-f82f0.firebasestorage.app',
    measurementId: 'G-1R0HZKFL8X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnaDQsLYoS88d4R5ZpooljNF68xHjoX-s',
    appId: '1:415401777783:android:56954f0b0cb5c1a5cdc472',
    messagingSenderId: '415401777783',
    projectId: 'jobfinder-f82f0',
    storageBucket: 'jobfinder-f82f0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnaDQsLYoS88d4R5ZpooljNF68xHjoX-s',
    appId: '1:415401777783:ios:56954f0b0cb5c1a5cdc472',
    messagingSenderId: '415401777783',
    projectId: 'jobfinder-f82f0',
    storageBucket: 'jobfinder-f82f0.firebasestorage.app',
    iosBundleId: 'com.example.jobFinder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnaDQsLYoS88d4R5ZpooljNF68xHjoX-s',
    appId: '1:415401777783:ios:56954f0b0cb5c1a5cdc472',
    messagingSenderId: '415401777783',
    projectId: 'jobfinder-f82f0',
    storageBucket: 'jobfinder-f82f0.firebasestorage.app',
    iosBundleId: 'com.example.jobFinder',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBnaDQsLYoS88d4R5ZpooljNF68xHjoX-s',
    appId: '1:415401777783:web:82a55ec36fa7ed68cdc472',
    messagingSenderId: '415401777783',
    projectId: 'jobfinder-f82f0',
    authDomain: 'jobfinder-f82f0.firebaseapp.com',
    storageBucket: 'jobfinder-f82f0.firebasestorage.app',
    measurementId: 'G-1R0HZKFL8X',
  );
}