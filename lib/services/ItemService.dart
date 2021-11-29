import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/utils/constant.dart';

class ItemService {
  final firestore = FirebaseFirestore.instance;

  Future<List<Item>> getItems(String mainCat, String subCat) async {
    List<Item> response = [];
    try {
      await firestore
          .collection("$itemCollection")
          .limit(10)
          .where("mainCategory", isEqualTo: mainCat)
          .where("subCategory", isEqualTo: subCat)
          .orderBy("date", descending: true)
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  Item item = Item.fromJson(element.data());
                  response.add(item);
                })
              });
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<String> getItemOwnerName(String userId) async {
    String response = "";
    try {
      await firestore
          .collection("$userCollection")
          .doc(userId)
          .get()
          .then((value) => {response = value.get("username")});
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<myUser.User?> getItemOwner(String userId) async {
    myUser.User? response;
    try {
      await firestore
          .collection("$userCollection")
          .doc(userId)
          .get()
          .then((value) => {response = myUser.User.fromJson(value.data()!)});
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getAdditionalInfo(
      {required String itemId, required String subCat}) async {
    try {
      return await firestore
          .collection("$itemCollection")
          .doc(itemId)
          .collection("$additionalCollection")
          .doc(subCat)
          .get();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addViewToItem (String itemId,List<String> viewers) async {
    final auth = FirebaseAuth.instance;
    if(auth.currentUser == null){
      return;
    }
    viewers.add(auth.currentUser!.uid);
    final List<String> newViewers = viewers.toSet().toList();
    await firestore
        .collection("$itemCollection")
        .doc(itemId)
        .update({
      'viewers': newViewers
    });

  }

  Future<List<Item>> getTrendingItems() async{
    List<Item> itemList = [];
    try {
      await firestore
          .collection("$itemCollection")
          .limit(10)
          .orderBy("views", descending: true)
          .get()
          .then((value) => {
        value.docs.forEach((element) {
          Item item = Item.fromJson(element.data());
          itemList.add(item);
        })
      });
    } catch (e) {
      print(e.toString());
    }
    return itemList;
  }
}
