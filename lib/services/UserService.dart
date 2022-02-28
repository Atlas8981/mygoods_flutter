import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:mygoods_flutter/models/my_item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/my_image.dart' as myImage;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final itemService = ItemService();

  Future<UserCredential?> loginWithEmailPassword(
      String email, String password) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return response;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.');
      }
    }
  }

  Future<bool> isUserHaveData(String id) async{
    final response = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(id)
        .get();
    if (response.exists &&
        response.data() != null &&
        response.data()!.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> signOut() async {
    bool isSignOut = false;
    try {
      await auth.signOut().then((value) => isSignOut = true);
      return isSignOut;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.');
      }
      return isSignOut;
    }
  }

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
      await firestore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        response = myUser.User.fromJson(value.data()!);
        // print(response.toString());
      });
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<myImage.MyImage> updateUserImage(
      File userImage, myUser.User user) async {
    final imageName = "${DateTime.now()}";
    final Reference storageReference =
        storage.ref('flutter/').child(imageName);
    await storageReference.putFile(userImage);
    final downloadedImageUrl = await storageReference.getDownloadURL();
    final myImage.MyImage returnImage =
        myImage.MyImage(imageName: imageName, imageUrl: downloadedImageUrl);
    await firestore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .update({'image': returnImage.toJson()});
    final tempUser = user;
    tempUser.image = returnImage;
    await createUserInChatUser(tempUser);
    return returnImage;
  }

  Future<void> createUserInChatUser(myUser.User user) async {
    await FirebaseChatCore.instance.createUserInFirestore(types.User(
      id: user.userId,
      firstName: user.firstName,
      imageUrl: user.image?.imageUrl,
      lastName: user.lastName,
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
      print(onError);
    });

    return response;
  }

  Future<List<MyItem>?> getUserItems() async {
    try {
      final List<MyItem> listOfItem = [];
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
            MyItem item = MyItem.fromJson(value.docs[i].data());
            listOfItem.add(item);
          }
        }
      });
      return listOfItem;
    } on FirebaseException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
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
      print(e.toString());
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
      print(e.toString());
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
      print(e.toString());
    }
  }

  Future<List<MyItem>?> getUserSavedItem() async {
    final List<String> itemIds = [];
    final List<MyItem> listOfItem = [];
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
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return null;
  }

  Future<List<MyItem>> getSaveItems(List<String> itemIds) async {
    final List<MyItem?> querySaveItems =
        await Future.wait(itemIds.map((e) => itemService.getItemById(e)));
    querySaveItems.removeWhere((element) => element == null);
    final List<MyItem> saveItems = querySaveItems.cast<MyItem>();
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

// Future<Item?> getSaveItem(String itemId) async {
//   final value =
//       await firestore.collection("$itemCollection").doc(itemId).get();
//   if (value.exists) {
//     final Item saveItem = Item.fromJson(value.data()!);
//     return saveItem;
//   }
//   return null;
// }

// Future<List<myImageClass.Image>> uploadFiles(List<File> _images) async {
//   var images = await Future.wait(_images.map((_image) => uploadFile(_image)));
//   return images;
// }
//
// Future<myImageClass.Image> uploadFile(File _image) async {
//   final imageName = "${DateTime.now()}";
//   final Reference storageReference =
//       storage.ref('flutter/').child("$imageName");
//   await storageReference.putFile(_image);
//   final imageUrl = await storageReference.getDownloadURL();
//   final image = myImageClass.Image(imageName: imageName, imageUrl: imageUrl);
//   return image;
// }
}
