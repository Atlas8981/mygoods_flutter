import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;

class UserService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  static final String userCollection = "users";
  static final String itemCollection = "items";
  static final String additionalCollection = "additionInfo";
  static final String saveItemCollection = "saveItems";

  Future<String?> login(String email, String password) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user != null && response.user!.uid.isNotEmpty) {
        return response.user!.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.');
      }
    }
  }

  Future<bool> signOut() async {
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

  Future<myUser.User?> getOwnerInfo() async {
    if (auth.currentUser == null) {
      // showToast("User Not Login");
      return null;
    }
    myUser.User? response;
    try {
      await firestore
          .collection("$userCollection")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => {response = myUser.User.fromJson(value.data()!)});
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<myImage.Image> updateUserImage(File userImage) async {
    final imageName = "${DateTime.now()}";
    final Reference storageReference =
        storage.ref('flutter/').child("$imageName");
    await storageReference.putFile(userImage);
    final downloadedImageUrl = await storageReference.getDownloadURL();
    final myImage.Image returnImage =
        myImage.Image(imageName: imageName, imageUrl: downloadedImageUrl);
    await firestore
        .collection("$userCollection")
        .doc(auth.currentUser!.uid)
        .update({'image': returnImage.toJson()});
    return returnImage;
  }

  Future<myUser.User?> updateUserInfo(myUser.User newUserInfo) async {
    final myUser.User response = await firestore
        .collection("$userCollection")
        .doc(newUserInfo.userId)
        .update(newUserInfo.toJson())
        .then((value) {
      return newUserInfo;
    }).catchError((onError) {
      print(onError);
      return null;
    });

    return response;
  }
}
