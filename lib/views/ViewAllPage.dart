import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';
import 'package:mygoods_flutter/views/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

class ViewAllPage extends StatelessWidget {
  ViewAllPage({
    Key? key,
    this.smallListItem,
    this.title,
  }) : super(key: key);
  final List<Item>? smallListItem;
  final String? title;

  final homePageService = HomePageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "View All Page"),
      ),
      body: FutureBuilder<List<Item>>(
        future: homePageService.getAllTrendingItems(),
        initialData: smallListItem ?? [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Item> items = snapshot.data!;
            return buildViewAllList(items);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildViewAllList(List<Item> items) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
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
}
