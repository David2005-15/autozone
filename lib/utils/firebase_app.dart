import 'package:firebase_core/firebase_core.dart';

class AutozoneFirebaseApp {
  static late FirebaseApp app;

  static Future<FirebaseApp> getInstance() async {
    app = await Firebase.initializeApp(
          name: "AutoZone",
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCNRRrqf-OqTlZG633YYCm6etg7r_V_Yrc',
              appId: '1:62059107234:android:0b00e8fdbd67d55b3658fb',
              messagingSenderId: '62059107234',
              projectId: 'autozone-5d681'));

    return app;
  }
}
