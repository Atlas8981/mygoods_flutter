import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCategoryPage extends StatelessWidget {
  const ListCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments.toString()),
      ),
    );
  }
}
