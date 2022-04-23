import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/cells/BigImageCell.dart';
import 'package:mygoods_flutter/views/cells/ItemGridCell.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

class ListItemPage extends StatefulWidget {
  const ListItemPage({
    Key? key,
    this.title = "",
    required this.items,
  }) : super(key: key);
  final String title;
  final List<Item> items;

  @override
  State<ListItemPage> createState() => _ListItemByPopularCategoryPAgeState();
}

class _ListItemByPopularCategoryPAgeState extends State<ListItemPage> {
  late final items = widget.items;

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
        title: Text(widget.title),
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
        child: determineViews(),
      ),
    );
  }

  Widget determineViews() {
    switch (selectedItemViews) {
      case ItemView.list:
        return listView(items);
      case ItemView.grid:
        return gridView(items);
      case ItemView.big:
        return bigImageView(items);
    }
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        childAspectRatio: 6.25 / 10,

      ),
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemGridCell(
          item: items[index],
        );
      },
    );
  }

  Widget listView(List<Item> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
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
        );
      },
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
