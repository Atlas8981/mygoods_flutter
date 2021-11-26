import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/SavedItemsController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/views/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/list_product_row.dart';

class SavedItemsPage extends StatelessWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Item(s)"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: GetBuilder<SavedItemsController>(
          init: SavedItemsController(),
          builder: (controller) {
            if (controller.items == null) {
              return Center(
                child: CircularProgressIndicator(),
              );

            }
            final List<Item> items = controller.items!.cast();
            if (controller.items!.length == 0) {
              return Center(
                child: Text("No Saved Item"),
              );
            }
            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListItemRow(
                    item: items[index],
                    onTap: () {
                      Get.to(() => ItemDetailPage(
                            item: items[index],
                          ));
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
