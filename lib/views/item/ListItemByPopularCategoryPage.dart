import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';
import 'package:mygoods_flutter/views/item/ListItemPage.dart';

class ListItemByPopularSubCategoryPage extends StatefulWidget {
  const ListItemByPopularSubCategoryPage({
    Key? key,
    required this.subCat,
  }) : super(key: key);

  final String subCat;

  @override
  State<ListItemByPopularSubCategoryPage> createState() =>
      _ListItemByPopularCategoryPAgeState();
}

class _ListItemByPopularCategoryPAgeState
    extends State<ListItemByPopularSubCategoryPage> {
  final itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: itemService.getItemsBySubCategory(
          widget.subCat,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            final items = snapshot.data!;
            return ListItemPage(
              title: widget.subCat,
              items: items,
            );
          }

          return const Center(
            child: Text('An error has occurred!'),
          );
        },
      ),
    );
  }
}
