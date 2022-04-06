import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

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
      appBar: AppBar(
        title: Text(widget.subCat),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Item>>(
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
              return Container(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      color: Colors.transparent,
                    );
                  },
                  itemBuilder: (context, index) {
                    return ListItemRow(
                      item: snapshot.data![index],
                      destination: ItemDetailPage(
                        item: snapshot.data![index],
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(
              child: Text('An error has occurred!'),
            );
          },
        ),
      ),
    );
  }
}
