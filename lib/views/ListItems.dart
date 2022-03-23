import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
    required this.mainCat,
    required this.subCat,
  }) : super(key: key);

  final String mainCat, subCat;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final ItemService databaseService = ItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCat),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Item>>(
          future: databaseService.getItems(
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
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return OpenContainer(
                        closedBuilder: (context, action) =>
                            ListItemRow(item: snapshot.data![index]),
                        openBuilder: (context, action) {
                          return ItemDetailPage(
                            item: snapshot.data![index],
                          );
                        },
                        transitionType: ContainerTransitionType.fade,
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
