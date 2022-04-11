import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;

class ChatService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<List<myUser.User>> getAllAuthenticatedUsers() async {
    final List<myUser.User> listOfUser = [];
    final query = await firestore
        .collection(userCollection)
        .where("userId", isNotEqualTo: "")
        .get();
    for (var element in query.docs) {
      try {
        final user = myUser.User.fromJson(element.data());
        if (user.userId != auth.currentUser!.uid) {
          listOfUser.add(user);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
    return listOfUser;
  }
}
