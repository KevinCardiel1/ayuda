// File: lib/firebase_options.dart
//
// Configuración de Firebase para el proyecto: floreriaajolote
// Generado manualmente con las credenciales de Firebase Console.
// https://console.firebase.google.com/project/floreriaajolote/settings/general
//
// NOTA: Para Android e iOS, descarga los archivos de configuración nativos:
//  - Android: android/app/google-services.json
//  - iOS:     ios/Runner/GoogleService-Info.plist

import 'package:firebase_core/firebase_core.dart';
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
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para esta plataforma.',
        );
    }
  }

  /// Configuración para Web y Windows
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDSkzDKib6F7hPP1vD3SCoQf-JDv8eWVhA',
    appId: '1:90325216333:web:fa1441340bd8945c200004',
    messagingSenderId: '90325216333',
    projectId: 'floreriaajolote',
    authDomain: 'floreriaajolote.firebaseapp.com',
    storageBucket: 'floreriaajolote.firebasestorage.app',
    measurementId: 'G-R8KHZWBHGE',
  );

  /// Configuración para Windows (comparte config de Web)
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDSkzDKib6F7hPP1vD3SCoQf-JDv8eWVhA',
    appId: '1:90325216333:web:fa1441340bd8945c200004',
    messagingSenderId: '90325216333',
    projectId: 'floreriaajolote',
    authDomain: 'floreriaajolote.firebaseapp.com',
    storageBucket: 'floreriaajolote.firebasestorage.app',
    measurementId: 'G-R8KHZWBHGE',
  );

  /// Configuración para Android
  /// ⚠️ Descarga google-services.json desde la consola Firebase y colócalo en:
  ///    android/app/google-services.json
  /// Luego reemplaza el appId con el valor de tu archivo google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSkzDKib6F7hPP1vD3SCoQf-JDv8eWVhA',
    appId: '1:90325216333:android:REEMPLAZA_CON_TU_ANDROID_APP_ID',
    messagingSenderId: '90325216333',
    projectId: 'floreriaajolote',
    storageBucket: 'floreriaajolote.firebasestorage.app',
  );

  /// Configuración para iOS
  /// ⚠️ Descarga GoogleService-Info.plist desde la consola Firebase y colócalo en:
  ///    ios/Runner/GoogleService-Info.plist
  /// Luego reemplaza el appId con el valor de tu archivo GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSkzDKib6F7hPP1vD3SCoQf-JDv8eWVhA',
    appId: '1:90325216333:ios:REEMPLAZA_CON_TU_IOS_APP_ID',
    messagingSenderId: '90325216333',
    projectId: 'floreriaajolote',
    storageBucket: 'floreriaajolote.firebasestorage.app',
    iosBundleId: 'com.example.floreriaAjolote',
  );
}
