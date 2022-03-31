import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/constant.dart';

class AuthenticationService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<UserCredential?> loginWithEmailPassword(
      String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<bool> isUserHaveData(String id) async {
    final response = await firestore.collection(userCollection).doc(id).get();
    if (response.exists &&
        response.data() != null &&
        response.data()!.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> signOut() async {
    //TODO:remove device token from database
    bool isSignOut = false;
    try {
      await auth.signOut().then((value) => isSignOut = true);
      return isSignOut;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.');
      }
      return isSignOut;
    }
  }
}
