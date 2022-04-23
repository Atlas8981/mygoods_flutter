import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/ItemForm.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/models/image.dart' as myImageClass;
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    Key? key,
  }) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final itemFormController = Get.put(ItemFormController());

  Future<List<myImageClass.Image>> uploadFiles(List<File> _images) async {
    var images = await Future.wait(_images.map((_image) => uploadFile(_image)));
    return images;
  }

  Future<myImageClass.Image> uploadFile(File _image) async {
    final imageName = "${DateTime.now()}";
    final Reference storageReference = storage.ref('flutter/').child(imageName);
    await storageReference.putFile(_image);
    final imageUrl = await storageReference.getDownloadURL();
    final image = myImageClass.Image(imageName: imageName, imageUrl: imageUrl);
    return image;
  }

  void uploadData(List<myImageClass.Image> images) {
    final reference = firestore.collection(itemCollection);

    final String id =
        reference.doc().path.toString().replaceAll("$itemCollection/", "");

    final Item item = Item(
      date: Timestamp.now(),
      subCategory: itemFormController.subCat.value,
      images: images,
      amount: 0,
      address: itemFormController.addressCon.text,
      description: itemFormController.descriptionCon.text,
      userid: auth.currentUser!.uid,
      itemid: id,
      viewers: [],
      phone: itemFormController.phoneCon.text,
      price: double.parse(itemFormController.priceCon.text),
      name: itemFormController.nameCon.text,
      mainCategory: itemFormController.mainCat.value,
      views: 0,
    );

    reference.doc(id).set(item.toJson()).then((value) async {
      final docRef = firestore.collection("category").doc("popularCategory");

      final docSnapshot = await docRef.get();
      final currentCategoryCount = docSnapshot.data()?[item.subCategory] as int;
      docRef.update({
        item.subCategory: currentCategoryCount + 1,
      });

      itemFormController.isVisible.value = false;
      showToast("Success");
      itemFormController.clearData();
    }).catchError((error) {
      itemFormController.isVisible.value = false;
      if (kDebugMode) {
        print("Failed with error: $error");
      }
    });
  }

  void uploadItemInformation() async {
    itemFormController.isVisible.value = true;
    final images = await uploadFiles(itemFormController.getRawImageInFile());
    uploadData(images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemForm(
        titleText: Text("sellItem".tr),
        padding: const EdgeInsets.all(10),
        onConfirm: () {
          uploadItemInformation();
        },
      ),
    );
  }
}
