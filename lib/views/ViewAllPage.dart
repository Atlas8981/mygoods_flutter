import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/my_item.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

class ViewAllPage extends StatelessWidget {
  ViewAllPage({
    Key? key,
    this.smallListItem,
    this.title,
  }) : super(key: key);
  final List<MyItem>? smallListItem;
  final String? title;

  final homePageService = HomePageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "View All Page"),
      ),
      body: FutureBuilder<List<MyItem>>(
        future: homePageService.getAllTrendingItems(),
        initialData: smallListItem ?? [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<MyItem> items = snapshot.data!;
            return buildViewAllList(items);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildViewAllList(List<MyItem> items) {
    // ListItemRow(item: items[]);
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListItemRow(item: items[index]);
        },
      ),
    );
  }
}
