
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ListCategoryPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments.toString()),
      ),
    );
  }
}
