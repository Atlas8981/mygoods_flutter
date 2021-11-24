import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/item_form.dart';
import 'package:mygoods_flutter/controllers/itemFormController.dart';
import 'package:mygoods_flutter/models/item.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({
    Key? key,
    this.item,
  }) : super(key: key);

  final Item? item;

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late final itemFormController;

  void setDataIntoView(){

  }

  @override
  void initState() {
    super.initState();
    Get.delete<ItemFormController>();
    itemFormController = Get.put(ItemFormController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ItemForm(
      titleText: Text("Edit Item"),
      padding: EdgeInsets.all(10),
      onConfirm: () {},
    ));
  }
}
