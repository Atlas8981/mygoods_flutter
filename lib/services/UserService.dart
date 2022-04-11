import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final itemService = ItemService();

  Future<void> registerUser(myUser.User user) async {
    return await firestore
        .collection(userCollection)
        .doc(user.userId)
        .set(user.toJson());
  }

  Future<myUser.User?> getOwnerInfo() async {
    if (auth.currentUser == null) {
      return null;
    }
    myUser.User? response;
    try {
      final docSnapshot = await firestore
          .collection(userCollection)
          .doc(auth.currentUser?.uid)
          .get();
      response = myUser.User.fromJson(docSnapshot.data()!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return response;
  }

  Future<myImage.Image> updateUserImage(
    File userImage,
    myUser.User user,
  ) async {
    //Set image name
    final imageName = "${DateTime.now()}";
    //set reference/path to the image
    final Reference storageReference = storage.ref('flutter/').child(imageName);
    await storageReference.putFile(userImage);
    //Get imageUrl
    final downloadedImageUrl = await storageReference.getDownloadURL();
    final myImage.Image returnImage = myImage.Image(
      imageName: imageName,
      imageUrl: downloadedImageUrl,
    );
    await firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .update({
      'image': returnImage.toJson(),
    });
    final tempUser = user;
    tempUser.image = returnImage;
    await createUserInChatUser(tempUser);
    return returnImage;
  }

  Future<void> createUserInChatUser(myUser.User user) async {
    await FirebaseChatCore.instance.createUserInFirestore(types.User(
      id: user.userId,
      firstName: user.firstname,
      imageUrl: user.image?.imageUrl,
      lastName: user.lastname,
    ));
  }

  Future<myUser.User?> updateUserInfo(myUser.User newUserInfo) async {
    await createUserInChatUser(newUserInfo);
    final myUser.User response = await firestore
        .collection(userCollection)
        .doc(newUserInfo.userId)
        .update(newUserInfo.toJson())
        .then((value) {
      return newUserInfo;
    }).catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });

    return response;
  }

  Future<List<Item>?> getUserItems() async {
    try {
      final List<Item> listOfItem = [];
      await firestore
          .collection(itemCollection)
          .orderBy('date', descending: true)
          .where('userid', isEqualTo: auth.currentUser!.uid)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          return listOfItem;
        }
        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i].exists) {
            Item item = Item.fromJson(value.docs[i].data());
            listOfItem.add(item);
          }
        }
      });
      return listOfItem;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    }
    return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenForUserItemChange() {
    return firestore
        .collection(itemCollection)
        .orderBy('date', descending: true)
        .where('userid', isEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  Future<bool> deleteUserItem(String itemId) async {
    bool isDeleted = false;

    await firestore
        .collection(itemCollection)
        .doc(itemId)
        .delete()
        .then((value) {
      isDeleted = true;
    });
    return isDeleted;
  }

  Future<bool> checkSaveItem(String itemId) async {
    if (auth.currentUser == null) {
      return false;
    }
    bool response = false;
    final userId = auth.currentUser!.uid;
    try {
      final value = await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(saveItemCollection)
          .doc(itemId)
          .get();
      if (value.data() != null) {
        response = true;
      } else {
        response = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return response;
  }

  Future<void> saveItem(String itemId) async {
    final userId = auth.currentUser!.uid;
    try {
      return await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(saveItemCollection)
          .doc(itemId)
          .set({
        'date': Timestamp.now(),
        'itemid': itemId,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> unsaveItem(String itemId) async {
    final userId = auth.currentUser!.uid;
    try {
      return await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(saveItemCollection)
          .doc(itemId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<Item>?> getUserSavedItem() async {
    final List<String> itemIds = [];
    final List<Item> listOfItem = [];
    final userId = auth.currentUser!.uid;
    try {
      final value = await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(saveItemCollection)
          .orderBy('date', descending: true)
          .get();

      if (value.docs.isEmpty) {
        return listOfItem;
      }

      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].exists) {
          final tempItemId = value.docs[i].data()['itemid'];
          itemIds.add(tempItemId);
        }
      }
      return await getSaveItems(itemIds);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    }
    return null;
  }

  Future<List<Item>> getSaveItems(List<String> itemIds) async {
    final List<Item?> querySaveItems =
        await Future.wait(itemIds.map((e) => itemService.getItemById(e)));
    querySaveItems.removeWhere((element) => element == null);
    final List<Item> saveItems = querySaveItems.cast<Item>();
    return saveItems;
  }

  Future<void> addToRecentView(String itemId) async {
    if (auth.currentUser == null) {
      return;
    }
    firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .collection(recentViewItemCollection)
        .doc(itemId)
        .set({
      'date': Timestamp.now(),
      'itemID': itemId,
    });
  }


}
