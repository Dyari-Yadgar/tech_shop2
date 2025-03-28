
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
    databaseURL:
        'https://tech-shop-3c42a-default-rtdb.asia-southeast1.firebasedatabase.app/',
    apiKey: 'AIzaSyA6NpYyfa652E57gRU_db7BAncfNq2yz7E',
    appId: '1:705213262722:web:07e475a24c3f84f99c7d9b',
    messagingSenderId: '705213262722',
    projectId: 'tech-shop-3c42a',
    authDomain: 'tech-shop-3c42a.firebaseapp.com',
    storageBucket: 'tech-shop-3c42a.firebasestorage.app',
    measurementId: 'G-XFYPZLBKCF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    databaseURL:
        'https://tech-shop-3c42a-default-rtdb.asia-southeast1.firebasedatabase.app/',
    apiKey: 'AIzaSyBEUfC65D7uZIk6zLtvMjFPVcaSSDNol2U',
    appId: '1:705213262722:android:46147b443424ba0d9c7d9b',
    messagingSenderId: '705213262722',
    projectId: 'tech-shop-3c42a',
    storageBucket: 'tech-shop-3c42a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    databaseURL:
        'https://tech-shop-3c42a-default-rtdb.asia-southeast1.firebasedatabase.app/',
    apiKey: 'AIzaSyA4BBkVSb6LQuN41mxwQMy1u1BO3Lbusog',
    appId: '1:705213262722:ios:43d0625be55d8bd19c7d9b',
    messagingSenderId: '705213262722',
    projectId: 'tech-shop-3c42a',
    storageBucket: 'tech-shop-3c42a.firebasestorage.app',
    iosBundleId: 'com.example.techShop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    databaseURL:
        'https://tech-shop-3c42a-default-rtdb.asia-southeast1.firebasedatabase.app/',
    apiKey: 'AIzaSyA4BBkVSb6LQuN41mxwQMy1u1BO3Lbusog',
    appId: '1:705213262722:ios:43d0625be55d8bd19c7d9b',
    messagingSenderId: '705213262722',
    projectId: 'tech-shop-3c42a',
    storageBucket: 'tech-shop-3c42a.firebasestorage.app',
    iosBundleId: 'com.example.techShop',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    databaseURL:
        'https://tech-shop-3c42a-default-rtdb.asia-southeast1.firebasedatabase.app/',
    apiKey: 'AIzaSyA6NpYyfa652E57gRU_db7BAncfNq2yz7E',
    appId: '1:705213262722:web:b2c01994a2a60a2a9c7d9b',
    messagingSenderId: '705213262722',
    projectId: 'tech-shop-3c42a',
    authDomain: 'tech-shop-3c42a.firebaseapp.com',
    storageBucket: 'tech-shop-3c42a.firebasestorage.app',
    measurementId: 'G-FFY4JDEN9M',
  );
}
