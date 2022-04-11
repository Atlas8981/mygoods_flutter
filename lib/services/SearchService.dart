import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class SearchService {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final user = Get.find<UserController>().user?.value;
  final algolia = const Algolia.init(
    applicationId: 'JDHJ10O9QM',
    apiKey: 'dab2357b76fa3541e56a37e638879665',
  ).instance;

  Future<List<Item>> querySearch(String queryText) async {
    final indexRef = algolia.index("items");
    final query = indexRef.query(queryText);
    final snapshot = await query.getObjects();
    final listOfSnapshot = snapshot.hits;
    final items = listOfSnapshot.map((e) => Item.fromJson(e.data)).toList();
    return items;
  }

  Future<List<String>?> getRecentSearches() async {
    final authUser = auth.currentUser;
    try {
      List<String> recentSearches = [];
      if (user != null) {
        final querySnapshot = await firestore
            .collection(userCollection)
            .doc(user?.userId ?? "")
            .collection("recentSearch")
            .get();

        recentSearches = querySnapshot.docs.map((e) => e.id).toList();
      } else if (authUser != null) {
        final querySnapshot = await firestore
            .collection(userCollection)
            .doc(authUser.uid)
            .collection("recentSearch")
            .get();
        recentSearches = querySnapshot.docs.map((e) => e.id).toList();
      }
      return recentSearches;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
    return null;
  }

  Future<void> setRecentSearch(String query) async {
    final authUser = auth.currentUser;
    try {
      if (user != null) {
        await firestore
            .collection(userCollection)
            .doc(user?.userId)
            .collection("recentSearch")
            .doc(query)
            .set({
          'date': Timestamp.now(),
          'itemId': query,
        });
      } else if (authUser != null) {
        await firestore
            .collection(userCollection)
            .doc(authUser.uid)
            .collection("recentSearch")
            .doc(query)
            .set({
          'date': Timestamp.now(),
          'itemId': query,
        });
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  Future<void> deleteRecentSearch(String query) async {
    final authUser = auth.currentUser;
    try {
      if (user != null) {
        await firestore
            .collection(userCollection)
            .doc(user?.userId)
            .collection("recentSearch")
            .doc(query)
            .delete();
      } else if (authUser != null) {
        await firestore
            .collection(userCollection)
            .doc(authUser.uid)
            .collection("recentSearch")
            .doc()
            .delete();
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  Future<void> clearRecentSearches() async {
    final authUser = auth.currentUser;
    try {
      if (user != null) {
        final querySnapshot = await firestore
            .collection(userCollection)
            .doc(user?.userId)
            .collection("recentSearch")
            .get();
        await Future.wait(
          querySnapshot.docs.map(
            (element) {
              return element.reference.delete();
            },
          ),
        );
      } else if (authUser != null) {
        await firestore
            .collection(userCollection)
            .doc(authUser.uid)
            .collection("recentSearch")
            .doc()
            .delete();
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }
}
