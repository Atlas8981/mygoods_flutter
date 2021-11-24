import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/user_service.dart';
import 'package:mygoods_flutter/views/ListProduct.dart';
import 'package:mygoods_flutter/views/cells/list_product_row.dart';
import 'package:mygoods_flutter/views/owner_item_detail_page.dart';

class MyItemsPage extends StatelessWidget {
  MyItemsPage({Key? key}) : super(key: key);

  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Item(s)"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<Item>>(
            future: userService.getUserItems(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error Occurred"),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<Item> items = snapshot.data!;
              print(items);
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListItemRow(
                    item: items[index],
                    onTap: () {
                      Get.to(OwnerItemDetailPage(
                        item: items[index],
                      ));
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
