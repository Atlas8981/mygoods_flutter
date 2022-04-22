import 'package:flutter/material.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/views/item/ListItemPage.dart';

class SavedItemsPage extends StatelessWidget {
  SavedItemsPage({
    Key? key,
  }) : super(key: key);

  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>?>(
        future: userService.getUserSavedItem(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            final items = snapshot.data ?? [];

            if (items.isNotEmpty) {
              return ListItemPage(
                title: "Saved Item",
                items: items,
              );
            }
            return CustomErrorWidget(text: "No saved items");
          }

          return const Center(
            child: Text('An error has occurred!'),
          );
        },
      ),
    );
  }
}
