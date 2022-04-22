import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/CustomFutureBuilder.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/cells/BigImageCell.dart';
import 'package:mygoods_flutter/views/cells/ItemGridCell.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';
import 'package:mygoods_flutter/views/item/ListItemPage.dart';

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
      body: CustomFutureBuilder<List<Item>>(
        future: databaseService.getItemsByCategory(
          widget.mainCat,
          widget.subCat,
        ),
        onDataRetrieved: (context, data) {
          return ListItemPage(
            items: data,
            title: widget.subCat.tr,
          );
        },
      ),
      // body: FutureBuilder<List<Item>>(
      //   future: databaseService.getItemsByCategory(
      //     widget.mainCat,
      //     widget.subCat,
      //   ),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return const CustomErrorWidget(
      //         text: "An error has occurred!",
      //       );
      //     } else if (snapshot.hasData) {
      //       if (snapshot.data != null) {
      //         final items = snapshot.data!;
      //
      //         return ListItemPage(
      //           items: items,
      //           title: widget.subCat.tr,
      //         );
      //       }
      //       return Text("errorOccurred".tr);
      //     } else {
      //       return LoadingWidget();
      //     }
      //   },
      // ),
    );
  }
}
