import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
  }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final ItemService itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.subCat"),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Item>>(
          future: itemService.getItems(),
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
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListItemRow(
                        item: snapshot.data![index],
                      );
                    },
                  ),
                );
              }
              return Text("an error has occurred");
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
