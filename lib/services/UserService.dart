import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;

class UserService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<String?> login(String email, String password) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user != null && response.user!.uid.isNotEmpty) {
        return response.user!.displayName;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.');
      }
    }
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
        .collection("$userCollection")
        .doc("${user.userId}")
        .set(user.toJson());
  }

  Future<myUser.User?> getOwnerInfo() async {
    if (auth.currentUser == null) {
      print("User Null");
      return null;
    }
    myUser.User? response;
    try {
      await firestore
          .collection("$userCollection")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        response = myUser.User.fromJson(value.data()!);
        print(response.toString());
      });
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<myImage.Image> updateUserImage(File userImage) async {
    final imageName = "${DateTime.now()}";
    final Reference storageReference =
        storage.ref('flutter/').child("$imageName");
    await storageReference.putFile(userImage);
    final downloadedImageUrl = await storageReference.getDownloadURL();
    final myImage.Image returnImage =
        myImage.Image(imageName: imageName, imageUrl: downloadedImageUrl);
    await firestore
        .collection("$userCollection")
        .doc(auth.currentUser!.uid)
        .update({'image': returnImage.toJson()});
    return returnImage;
  }

  Future<myUser.User?> updateUserInfo(myUser.User newUserInfo) async {
    final myUser.User response = await firestore
        .collection("$userCollection")
        .doc(newUserInfo.userId)
        .update(newUserInfo.toJson())
        .then((value) {
      return newUserInfo;
    }).catchError((onError) {
      print(onError);
    });

    return response;
  }

  Future<List<Item>?> getUserItems() async {
    try {
      final List<Item> listOfItem = [];
      await firestore
          .collection("$itemCollection")
          .orderBy('date', descending: true)
          .where('userid', isEqualTo: auth.currentUser!.uid)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
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
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenForUserItemChange() {
    return firestore
        .collection("$itemCollection")
        .orderBy('date', descending: true)
        .where('userid', isEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  Future<bool> deleteUserItem(String itemId) async {
    bool isDeleted = false;

    await firestore
        .collection("$itemCollection")
        .doc(itemId)
        .delete()
        .then((value) {
      isDeleted = true;
    });
    return isDeleted;
  }

  Future<bool> checkSaveItem(String itemId) async {
    bool response = false;
    final userId = auth.currentUser!.uid;
    try {
      final value = await firestore
          .collection("$userCollection")
          .doc(userId)
          .collection("$saveItemCollection")
          .doc(itemId)
          .get();
      if (value.data() != null)
        response = true;
      else
        response = false;
    } catch (e) {
      print(e.toString());
    }
    return response;
  }

  Future<void> saveItem(String itemId) async {
    final userId = auth.currentUser!.uid;
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

  Future<void> unsaveItem(String itemId) async {
    final userId = auth.currentUser!.uid;
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

  Future<List<Item>?> getUserSavedItem() async {
    final List<String> itemIds = [];
    final List<Item> listOfItem = [];
    final userId = auth.currentUser!.uid;
    try {
      final value = await firestore
          .collection("$userCollection")
          .doc(userId)
          .collection("$saveItemCollection")
          .orderBy('date', descending: true)
          .get();

      if (value.docs.length == 0) {
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

  Future<List<Item>> getSaveItems(List<String> itemIds) async {
    final List<Item?> querySaveItems =
        await Future.wait(itemIds.map((e) => getSaveItem(e)));
    querySaveItems.removeWhere((element) => element == null);
    final List<Item> saveItems = querySaveItems.cast<Item>();
    return saveItems;
  }

  Future<Item?> getSaveItem(String itemId) async {
    final value =
        await firestore.collection("$itemCollection").doc(itemId).get();
    if (value.exists) {
      final Item saveItem = Item.fromJson(value.data()!);
      return saveItem;
    }
    return null;
  }

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
