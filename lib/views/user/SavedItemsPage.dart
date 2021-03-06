import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/SavedItemsController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

class SavedItemsPage extends StatelessWidget {
  const SavedItemsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Item(s)"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: GetBuilder<SavedItemsController>(
          init: SavedItemsController(),
          builder: (controller) {
            if (controller.items == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<Item> items = controller.items!.cast();
            if (controller.items!.isEmpty) {
              return const Center(
                child: Text("No Saved Item"),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  );
                },
                itemBuilder: (context, index) {
                  return ListItemRow(
                    item: items[index],
                    destination: ItemDetailPage(
                      item: items[index],
                    ),
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
