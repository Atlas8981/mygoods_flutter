import 'package:flutter/material.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/SearchService.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';

class SuggestionList extends StatefulWidget {
  const SuggestionList({
    Key? key,
    required this.query,
  }) : super(key: key);
  final String query;

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  final searchService = SearchService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: searchService.querySearch(widget.query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const CustomErrorWidget();
        }
        final List<Item> suggestions = snapshot.data ?? [];
        return Container(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: suggestions.length,
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1.5,
              );
            },
            itemBuilder: (context, index) {
              return ListItemRow(
                item: suggestions[index],
              );
            },
          ),
        );
      },
    );
  }
}
