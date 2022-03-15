import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/AuthenticationController.dart';
import 'package:mygoods_flutter/models/item/item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/utils/api_route.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:http/http.dart' as http;

class ItemService {
  final firestore = FirebaseFirestore.instance;
  final authCon = Get.find<AuthenticationController>();

  Future<List<Item>> getItems() async {
    List<Item> response = [];
    try {
      const url =
          "http://$domain:$port/api/v1/item/?page=0&sortBy=date&catId=7";
      final uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${authCon.tokenRes!.value.accessToken}',
        },
      );
      print("response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        log(response.body);
        final List<Item> items = itemResponseFromMap(response.body);
        return items;
      }
    } catch (e) {
      print(e.toString());
    }
    return response;
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
      print(e.toString());
    }
    return response;
  }

  Future<myUser.User?> getItemOwner(String userId) async {
    myUser.User? response;

    return response;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getAdditionalInfo(
      {required String itemId, required String subCat}) async {}

  Future<void> addViewToItem(String itemId, List<String> viewers) async {}

// Future<List<Item>> getTrendingItems() async{
//   List<Item> itemList = [];
//   try {
//     await firestore
//         .collection("$itemCollection")
//         .limit(10)
//         .orderBy("views", descending: true)
//         .get()
//         .then((value) => {
//       value.docs.forEach((element) {
//         Item item = Item.fromJson(element.data());
//         itemList.add(item);
//       })
//     });
//   } catch (e) {
//     print(e.toString());
//   }
//   return itemList;
// }
}
