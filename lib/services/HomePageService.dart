import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mygoods_flutter/models/my_item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class HomePageService {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final itemService = ItemService();

  Future<List<MyItem>> getTrendingItems() async {
    final List<MyItem> items = [];
    final query = await firestore
        .collection(itemCollection)
        .orderBy("views", descending: true)
        .limit(10)
        .get();
    for (var element in query.docs) {
      MyItem item = MyItem.fromJson(element.data());
      items.add(item);
    }
    return items;
  }

  Future<List<MyItem>> getRecentViewItems() async {
    if(auth.currentUser == null){
      return [];
    }
    final List<String> itemIds = [];
    final List<MyItem> listOfItem = [];
    final userId = auth.currentUser!.uid;
    try {
      final value = await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(recentViewItemCollection)
          .orderBy('date', descending: true)
          .limit(10)
          .get();
      if (value.docs.isEmpty) {
        return listOfItem;
      }

      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].exists) {
          final tempItemId = value.docs[i].data()['itemID'];
          itemIds.add(tempItemId);
        }
      }
      final List<MyItem?> queryRecentItems =
          await Future.wait(itemIds.map((e) => itemService.getItemById(e)));
      queryRecentItems.removeWhere((element) => element == null);
      final List<MyItem> recentItems = queryRecentItems.cast<MyItem>();
      return recentItems;

    } on FirebaseException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return listOfItem;
  }

  Future<List<MyItem>> getAllTrendingItems() async {
    final List<MyItem> items = [];
    final query = await firestore
        .collection(itemCollection)
        .orderBy("views", descending: true)
        .get();
    for (var element in query.docs) {
      MyItem item = MyItem.fromJson(element.data());
      items.add(item);
    }
    return items;
  }

  Future<List<MyItem>> getAllRecentViewItems() async {
    if(auth.currentUser == null){
      return [];
    }
    final List<String> itemIds = [];
    final List<MyItem> listOfItem = [];
    final userId = auth.currentUser!.uid;
    try {
      final value = await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(recentViewItemCollection)
          .orderBy('date', descending: true)
          .get();
      if (value.docs.isEmpty) {
        return listOfItem;
      }

      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].exists) {
          final tempItemId = value.docs[i].data()['itemID'];
          itemIds.add(tempItemId);
        }
      }
      final List<MyItem?> queryRecentItems =
      await Future.wait(itemIds.map((e) => itemService.getItemById(e)));
      queryRecentItems.removeWhere((element) => element == null);
      final List<MyItem> recentItems = queryRecentItems.cast<MyItem>();
      return recentItems;

    } on FirebaseException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return listOfItem;
  }

  // Future<List<Item>> getPreferenceItems() async {
  //   final List<Item> items = [];
  //   final query = await firestore
  //       .collection("$itemCollection")
  //       .orderBy("views", descending: true)
  //       .limit(10)
  //       .get();
  //   query.docs.forEach((element) {
  //     Item item = Item.fromJson(element.data());
  //     items.add(item);
  //   });
  //   return items;
  // }
}
