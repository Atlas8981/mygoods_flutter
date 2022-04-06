import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/utils/constant.dart';

class ItemService {
  final firestore = FirebaseFirestore.instance;

  Future<List<Item>> getItemsByCategory(String mainCat, String subCat) async {
    List<Item> response = [];
    try {
      final querySnapshot = await firestore
          .collection(itemCollection)
          .limit(10)
          .where("mainCategory", isEqualTo: mainCat)
          .where("subCategory", isEqualTo: subCat)
          .orderBy("date", descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        final Item item = Item.fromJson(element.data());
        response.add(item);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return response;
  }

  Future<List<Item>> getItemsBySubCategory(String subCat) async {
    try {
      final querySnapshot = await firestore
          .collection(itemCollection)
          .limit(10)
          .where("subCategory", isEqualTo: subCat)
          .orderBy("date", descending: true)
          .get();
      final List<Item> items = [];
      for (var element in querySnapshot.docs) {
        final Item item = Item.fromJson(element.data());
        items.add(item);
      }
      return items;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return [];
  }

  Future<String> getItemOwnerName(String userId) async {
    String response = "";
    try {
      await firestore
          .collection(userCollection)
          .doc(userId)
          .get()
          .then((value) => {response = value.get("username")});
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return response;
  }

  Future<myUser.User?> getItemOwner(String userId) async {
    myUser.User? response;
    try {
      await firestore
          .collection(userCollection)
          .doc(userId)
          .get()
          .then((value) => {response = myUser.User.fromJson(value.data()!)});
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return response;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getAdditionalInfo({
    required String itemId,
    required String subCat,
  }) async {
    try {
      return await firestore
          .collection(itemCollection)
          .doc(itemId)
          .collection(additionalCollection)
          .doc(subCat)
          .get();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<void> addViewToItem(String itemId, List<String> viewers) async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return;
    }
    viewers.add(auth.currentUser!.uid);
    final List<String> newViewers = viewers.toSet().toList();
    await firestore
        .collection(itemCollection)
        .doc(itemId)
        .update({'viewers': newViewers});
  }

  Future<Item?> getItemById(String itemId) async {
    final value = await firestore.collection(itemCollection).doc(itemId).get();
    if (value.exists) {
      final Item saveItem = Item.fromJson(value.data()!);
      return saveItem;
    }
    return null;
  }

  Future<void> getPopularCategory() async {}

  void setPopularCategory() {

  }
}
