import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

class ListItemByCategoryPage extends StatefulWidget {
  const ListItemByCategoryPage({
    Key? key,
    required this.mainCat,
    required this.subCat,
  }) : super(key: key);

  final String mainCat, subCat;

  @override
  _ListItemByCategoryPageState createState() => _ListItemByCategoryPageState();
}

class _ListItemByCategoryPageState extends State<ListItemByCategoryPage> {
  final ItemService databaseService = ItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCat),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Item>>(
          future: databaseService.getItemsByCategory(
            widget.mainCat,
            widget.subCat,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!'),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
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
              return const Text("an error has occurred");
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
