import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;

class ChatService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<List<myUser.User>> getAllAuthenticatedUsers() async {
    final List<myUser.User> listOfUser = [];

    return listOfUser;
  }
}
