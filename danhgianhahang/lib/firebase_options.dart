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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDkE0nOeXs6UaUiKjrsl-0tW-Xh_EYLRwU',
    appId: '1:679479915282:web:f6421875fba8b92336f9cb',
    messagingSenderId: '679479915282',
    projectId: 'danhgianhahang-12bb6',
    authDomain: 'danhgianhahang-12bb6.firebaseapp.com',
    storageBucket: 'danhgianhahang-12bb6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkE0nOeXs6UaUiKjrsl-0tW-Xh_EYLRwU',
    appId: '1:679479915282:android:f6421875fba8b92336f9cb',
    messagingSenderId: '679479915282',
    projectId: 'danhgianhahang-12bb6',
    storageBucket: 'danhgianhahang-12bb6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkE0nOeXs6UaUiKjrsl-0tW-Xh_EYLRwU',
    appId: '1:679479915282:ios:f6421875fba8b92336f9cb',
    messagingSenderId: '679479915282',
    projectId: 'danhgianhahang-12bb6',
    storageBucket: 'danhgianhahang-12bb6.firebasestorage.app',
    iosBundleId: 'com.example.danhgianhahang',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkE0nOeXs6UaUiKjrsl-0tW-Xh_EYLRwU',
    appId: '1:679479915282:macos:f6421875fba8b92336f9cb',
    messagingSenderId: '679479915282',
    projectId: 'danhgianhahang-12bb6',
    storageBucket: 'danhgianhahang-12bb6.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDkE0nOeXs6UaUiKjrsl-0tW-Xh_EYLRwU',
    appId: '1:679479915282:windows:f6421875fba8b92336f9cb',
    messagingSenderId: '679479915282',
    projectId: 'danhgianhahang-12bb6',
    storageBucket: 'danhgianhahang-12bb6.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDkE0nOeXs6UaUiKjrsl-0tW-Xh_EYLRwU',
    appId: '1:679479915282:linux:f6421875fba8b92336f9cb',
    messagingSenderId: '679479915282',
    projectId: 'danhgianhahang-12bb6',
    storageBucket: 'danhgianhahang-12bb6.firebasestorage.app',
  );
}
