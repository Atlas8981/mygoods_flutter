import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/ItemForm.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/models/image.dart' as myImageClass;
import 'package:mygoods_flutter/models/item/item.dart';
import 'package:mygoods_flutter/models/item/item_dto.dart';
import 'package:mygoods_flutter/services/UserService.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final itemFormController = Get.put(ItemFormController());

  // final imageService = ImageService();
  final userService = UserService();

  void uploadItemInformation() async {
    itemFormController.isVisible.value = true;
    final listOfImage = itemFormController.getRawImageInFile();
    final ItemDto item = ItemDto(
      date: DateTime.now(),
      subCategory: itemFormController.subCat.value,
      amount: 0,
      address: itemFormController.addressCon.text,
      description: itemFormController.descriptionCon.text,
      userid: "auth.currentUser!.uid",
      viewers: [],
      phone: itemFormController.phoneCon.text,
      price: double.parse(itemFormController.priceCon.text),
      name: itemFormController.nameCon.text,
      mainCategory: itemFormController.mainCat.value,
    );
    final paths = listOfImage.map((e) => e.path).toList();
    print("paths: $paths");
    final result = await userService.addItem(item, paths);
    print("result: $result");
    itemFormController.isVisible.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemForm(
        titleText: Text("Add Item"),
        padding: EdgeInsets.all(10),
        onConfirm: () {
          uploadItemInformation();
        },
      ),
    );
  }
}
