import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/ItemForm.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/controllers/MyItemsController.dart';
import 'package:mygoods_flutter/models/DualImage.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/image.dart' as myImageClass;
import 'package:mygoods_flutter/services/item_database_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item? item;

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late final ItemFormController itemFormController;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<List<myImageClass.Image>> uploadFiles(List<DualImage> _images) async {
    var images = await Future.wait(_images.map((_image) => uploadFile(_image)));
    return images;
  }

  Future<myImageClass.Image> uploadFile(DualImage _image) async {
    if (_image.isNetworkImage) {
      return _image.itemImage!;
    }
    final imageName = "${DateTime.now()}";
    final Reference storageReference =
        storage.ref('flutter/').child("$imageName");
    await storageReference.putFile(File(_image.imagePath!));
    final imageUrl = await storageReference.getDownloadURL();
    final image = myImageClass.Image(imageName: imageName, imageUrl: imageUrl);
    return image;
  }

  void uploadData(List<myImageClass.Image> images) {
    final CollectionReference reference =
        firestore.collection("$itemCollection");

    final Item newItem = Item(
        date: preItem.date,
        subCategory: itemFormController.subCat.value,
        images: images,
        amount: 0,
        address: itemFormController.addressCon.text,
        description: itemFormController.descriptionCon.text,
        userid: preItem.userid,
        itemid: "${preItem.itemid}",
        viewers: preItem.viewers,
        phone: "0${itemFormController.phoneCon.text}",
        price: double.parse(itemFormController.priceCon.text),
        name: itemFormController.nameCon.text,
        mainCategory: itemFormController.mainCat.value,
        views: preItem.views);
    //
    reference.doc(preItem.itemid).update(newItem.toJson()).then((value) {
      showToast("Success");
      itemFormController.isVisible.value = false;
      itemFormController.clearData();
      Get.find<MyItemsController>().updateUserItem(newItem);
      Get.back();
    }).catchError((error) {
      itemFormController.isVisible.value = false;
      print("Failed with error: $error");
    });

  }

  Future<void> uploadItemInformation() async {
    itemFormController.isVisible.value = true;
    uploadFiles(itemFormController.tempImages.cast()).then((images) {
      uploadData(images);
    });
  }

  late final Item preItem;

  void setDataIntoView() {
    preItem = widget.item!;
    preItem.images.forEach((image) {
      itemFormController.addImage(DualImage(true, itemImage: image));
    });
    itemFormController.mainCat.value = preItem.mainCategory;
    itemFormController.subCat.value = preItem.subCategory;
    itemFormController.categoryCon.text =
        "${preItem.mainCategory}, ${preItem.subCategory}";
    itemFormController.addressCon.text = preItem.address;
    itemFormController.nameCon.text = preItem.name;
    itemFormController.priceCon.text = preItem.price.toString();
    itemFormController.phoneCon.text = preItem.phone.substring(1);
    itemFormController.descriptionCon.text = preItem.description;
    itemFormController.getAdditionalInfo(preItem.itemid, preItem.subCategory);
  }

  @override
  void initState() {
    super.initState();
    Get.delete<ItemFormController>();
    itemFormController = Get.put(ItemFormController());
    setDataIntoView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ItemForm(
      titleText: Text("Edit Item"),
      padding: EdgeInsets.all(10),
      onConfirm: () {uploadItemInformation();},
    ));
  }
}
