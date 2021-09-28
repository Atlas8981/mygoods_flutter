import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/productController.dart';
import 'package:mygoods_flutter/views/cells/product_tile.dart';

class AddPage extends StatelessWidget {

  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: Colors.cyanAccent,
      child: Center(child: Text("AddPage"),),
    );
  }
}