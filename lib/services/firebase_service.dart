import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
  static const FirebaseOptions android = FirebaseOptions(
      apiKey: 'AIzaSyAovm6ubKXsmGc4jvwBiJ89VIieizzR3W4',
      appId: '1:348795889757:android:44cfc87016856a3d3a85b4',
      messagingSenderId: '348795889757',
      projectId: 'online-food-order-f0a7c',
      storageBucket: 'online-food-order-f0a7c.firebasestorage.app',
      databaseURL:
      '');

  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: 'AIzaSyAovm6ubKXsmGc4jvwBiJ89VIieizzR3W4',
      appId: '1:348795889757:android:44cfc87016856a3d3a85b4',
      messagingSenderId: '348795889757',
      projectId: 'online-food-order-f0a7c',
      storageBucket: 'online-food-order-f0a7c.firebasestorage.app',
      iosBundleId: 'com.example.online_food_order"',
      databaseURL:
      '');
}