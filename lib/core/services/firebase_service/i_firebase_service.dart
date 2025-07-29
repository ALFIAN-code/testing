import 'package:firebase_core/firebase_core.dart';

abstract class IFirebaseService {
  Future<FirebaseOptions> getConfig();
}