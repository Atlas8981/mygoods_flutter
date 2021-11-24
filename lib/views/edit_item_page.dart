import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/item_form.dart';
import 'package:mygoods_flutter/controllers/addImagesController.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/additional_data_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/AddPage.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemForm(),
    );
  }
}
