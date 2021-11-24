import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart';

final String userCollection = "users";
final String itemCollection = "items";
final String additionalCollection = "additionInfo";
final String saveItemCollection = "saveItems";

class ItemDatabaseService {
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

  Future<User?> getItemOwner(String userId) async {
    User? response;
    try {
      await firestore
          .collection("$userCollection")
          .doc(userId)
          .get()
          .then((value) => {response = User.fromJson(value.data()!)});
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getAdditionalInfo(
      Item item) async {
    try {
      return await firestore
          .collection("$itemCollection")
          .doc(item.itemid)
          .collection("$additionalCollection")
          .doc(item.subCategory)
          .get();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> checkSaveItem(String userId, String itemId) async {
    bool response = false;
    try {
      await firestore
          .collection("$userCollection")
          .doc(userId)
          .collection("$saveItemCollection")
          .doc(itemId)
          .get()
          .then((value) {
        if (value.data() != null)
          response = true;
        else
          response = false;
      });
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<void> saveItem(String userId, String itemId) async {
    try {
      return await firestore
          .collection("$userCollection")
          .doc(userId)
          .collection("$saveItemCollection")
          .doc(itemId)
          .set({
        'date': Timestamp.now(),
        'itemid': itemId,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unsaveItem(String userId, String itemId) async {
    try {
      return await firestore
          .collection("$userCollection")
          .doc(userId)
          .collection("$saveItemCollection")
          .doc(itemId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
