import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web; // Since you are only targeting web
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0Kk76uZivjGQlvblnNEtcH4KzPeIWQzY',
    authDomain: 'mindscape-cb38f.firebaseapp.com',
    projectId: 'mindscape-cb38f',
    storageBucket: 'mindscape-cb38f.appspot.com',
    messagingSenderId: '24850596493',
    appId: '1:24850596493:web:f420d388e467a2c3ab98c4',
    measurementId: 'G-V2Q7K0KD3Z',
  );
}
