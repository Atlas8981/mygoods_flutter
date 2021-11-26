import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/SavedItemsController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/views/cells/list_product_row.dart';

class SavedItemsPage extends StatelessWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Item(s)"),
      ),
      body: GetBuilder<SavedItemsController>(
        builder: (controller) {
          final List<Item> items = controller.items.cast();
          if(items.length == 0){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListItemRow(
                item: items[index],
                onTap: () {

                },
              );
            },
          );
        },
      ),

    );
  }
}
