import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/cells/BigImageCell.dart';
import 'package:mygoods_flutter/views/cells/ItemGridCell.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';
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

  ItemView selectedItemViews = ItemView.list;
  ItemView nextSelectedItemViews = ItemView.grid;
  final List<ItemView> itemViews = [
    ItemView.list,
    ItemView.grid,
    ItemView.big,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCat),
        actions: [
          IconButton(
            onPressed: () {
              changeIcon();
            },
            icon: Icon(determineIcon()),
          ),
        ],
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
                final items = snapshot.data!;
                switch (selectedItemViews) {
                  case ItemView.list:
                    return listView(items);
                  case ItemView.grid:
                    return gridView(items);
                  case ItemView.big:
                    return bigImageView(items);
                }
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

  IconData determineIcon() {
    switch (selectedItemViews) {
      case ItemView.list:
        return Icons.grid_view;
      case ItemView.grid:
        return Icons.horizontal_split_outlined;
      case ItemView.big:
        return Icons.view_list;
    }
  }

  changeIcon() {
    setState(() {
      selectedItemViews = nextSelectedItemViews;
    });
    switch (selectedItemViews) {
      case ItemView.grid:
        nextSelectedItemViews = ItemView.big;
        break;
      case ItemView.list:
        nextSelectedItemViews = ItemView.grid;
        break;
      case ItemView.big:
        nextSelectedItemViews = ItemView.list;
        break;
    }
  }

  Widget gridView(List<Item> items) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 6.9 / 10,
      ),
      padding: EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemGridCell(
          item: items[index],
          destination: ItemDetailPage(item: items[index]),
        );
      },
    );
  }

  Widget listView(List<Item> items) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
            color: Colors.transparent,
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
  }

  Widget bigImageView(List<Item> items) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return BigImageCell(
            item: items[index],
            destination: ItemDetailPage(item: items[index]),
          );
        },
      ),
    );
  }
}

enum ItemView {
  grid,
  list,
  big,
}
