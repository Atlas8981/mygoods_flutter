import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';
import 'package:mygoods_flutter/views/item/ListItemPage.dart';

class ViewAllPage extends StatefulWidget {
  const ViewAllPage({
    Key? key,
    this.smallListItem,
    this.title,
  }) : super(key: key);
  final List<Item>? smallListItem;
  final String? title;

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  final homePageService = HomePageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: homePageService.getAllTrendingItems(),
        initialData: widget.smallListItem ?? [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Item> items = snapshot.data!;
            return ListItemPage(
              items: items,
              title: widget.title ?? "View All Page",
            );
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
          );
        },
      ),
    );
  }
}
