

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mygoods_flutter/models/item.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Item>> getItems(String mainCat,String subCat) async{
    List<Item> response = [];
    try{
      await _firestore.collection("items")
          .limit(10)
          .where("mainCategory", isEqualTo: mainCat)
          .where("subCategory",isEqualTo: subCat)
          .orderBy("date",descending: true)
          .get()
          .then((value) => {
        value.docs.forEach((element) {
          Item item = Item.fromJson(element.data());
          response.add(item);
        })
      });
    }catch(e){
      print(e.toString());
    }
    return response;
  }

  Future<String> getItemOwner(String userId) async{
    String response = "";
    try{
      await _firestore.collection("users")
          .doc(userId)
          .get()
          .then((value) => {
        response = value.get("username")
      });
    }catch(e){
      print(e.toString());
    }
    return response;
  }
  
}