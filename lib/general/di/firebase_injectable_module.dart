import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages

// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:injectable/injectable.dart';

@module
abstract class FirebaseInjectableModule {
  // ignore: invalid_annotation_target
  @preResolve
  Future<FirebaseServeice> get firebaseServeice => FirebaseServeice.init();

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseStorage get firebaseDtorage => FirebaseStorage.instance;
}

class FirebaseServeice {
  static Future<FirebaseServeice> init() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCDS-Zlf5Vn2SYYNIj3iEz3_E9Pt5WiyG8",
        authDomain: "hinvex-29819.firebaseapp.com",
        projectId: "hinvex-29819",
        storageBucket: "hinvex-29819.appspot.com",
        messagingSenderId: "27841319846",
        appId: "1:27841319846:web:b79120321ae1b5e21af567",
        measurementId: "G-Z8FKZF46YF",
      ),
    );

    return FirebaseServeice();
  }
}
