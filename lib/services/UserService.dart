import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/AuthenticationController.dart';
import 'package:mygoods_flutter/models/item/item.dart';
import 'package:mygoods_flutter/models/item/item_dto.dart';
import 'package:mygoods_flutter/models/user/user.dart' as myUser;
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/api_route.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;

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
    return null;
  }

  Future<bool> isUserHaveData(String id) async {
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

  }

  Future<myUser.User?> getOwnerInfo() async {
    return null;



  }

  Future<myImage.Image?> updateUserImage(
      File userImage, myUser.User user) async {
        return null;


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
    return null;



  }

  Future<List<Item>?> getUserItems() async {
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
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return null;
  }

  Future<List<Item>?> getSaveItems(List<String> itemIds) async {
    return null;


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

  Future<String?> addItem(ItemDto item, List<String> imagePaths) async {
    try {
      const url = "http://$domain:$port/api/v1/item";
      final uri = Uri.parse(url);

      final authCon = Get.find<AuthenticationController>();
      if (authCon.tokenRes == null) {
        return "Unauthenticated";
      }
      final request = http.MultipartRequest("POST", uri);

      request.headers.addAll({
        'Authorization': 'Bearer ${authCon.tokenRes?.value.accessToken}',
      });

      // request.files.add(await http.MultipartFile.fromPath("image", imagePaths));

      final files = await Future.wait(
        imagePaths.map(
          (e) => http.MultipartFile.fromPath(
            "images",
            e,
          ),
        ),
      );

      request.fields.addAll({
        'item': '{"name": "${item.name}",'
            '"address": "${item.address}",'
            '"categoryId":6,'
            '"description": "${item.description}",'
            '"userid": "${item.userid}",'
            '"phone": "${item.phone}",'
            '"amount": ${item.amount},'
            '"price": ${item.price}'
            '}'
      });
      // request.fields.addAll({
      //   'item': '{\n    "name": "LaptopCategory",\n    "address": "Something is address2",\n    "categoryId":6,\n    "description": "this is description",\n    "userid": "thisIsUserId",\n    "phone": "012345678",\n    "amount": 3,\n    "price": 133.0\n}'
      // });
      request.files.addAll(files);

      final response = await request.send();

      print("response.statusCode: ${response.statusCode}");
      final body = await response.stream.bytesToString();
      print("response.body: $body");
      if (response.statusCode == 200) {
        print(body);
        return body;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
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
