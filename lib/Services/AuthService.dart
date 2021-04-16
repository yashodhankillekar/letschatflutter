import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchatapp/Models/UserDetails.dart';
import 'package:flutterchatapp/Models/RegisterPayload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Stream<String> get onAuthChanged => auth.authStateChanges().map((User usr) => usr?.uid);

  Future<bool> registerNewUser(UserDetails payload, String password) {
    try {
      auth
          .createUserWithEmailAndPassword(
              email: payload.email, password: password)
          .then((value) {
        if (value.user != null) {
          payload.authDocId = value.user.uid;

          firestore
              .collection("Users")
              .doc(value.user.uid)
              .set(payload.toJson());

          return true;
        } else {
          return false;
        }
      });
    } catch (e) {}
  }

}
