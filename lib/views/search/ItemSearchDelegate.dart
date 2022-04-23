import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/SearchService.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';
import 'package:mygoods_flutter/views/search/RecentSearchList.dart';
import 'package:mygoods_flutter/views/search/SuggestionList.dart';

class ItemSearchDelegate extends SearchDelegate<String> {
  final List<Item> items = [];
  final List<String> searchHistory = [];
  final searchService = SearchService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      (query.isEmpty)
          ? IconButton(
              onPressed: () {
                showResults(context);
              },
              icon: const Icon(Icons.search),
            )
          : IconButton(
              onPressed: () {
                query = "";
              },
              icon: const Icon(Icons.clear),
            ),
    ];
  }

  @override
  String get searchFieldLabel => 'search'.tr;

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "result");
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: searchService.querySearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const CustomErrorWidget();
        }
        final List<Item> items = snapshot.data ?? [];
        return Container(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
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
          ),
        );
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    searchService.setRecentSearch(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return (query == "" || query.isEmpty)
        ? RecentSearchList(
            onTap: (value) {
              query = value;
              showResults(context);
            },
          )
        : SuggestionList(
            query: query,
          );
  }
}
