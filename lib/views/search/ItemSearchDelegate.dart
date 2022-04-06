import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/SearchService.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';

class ItemSearchDelegate extends SearchDelegate<String> {
  final List<Item> items = [];
  final List<String> searchHistory = [];
  final searchService = SearchService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
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
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: searchService.querySearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return CustomErrorWidget();
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
                destination: ItemDetailPage(
                  item: items[index],
                ),
                useAnimation: false,
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
    onQueryTextChange();
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

  void onQueryTextChange() {}
}

class RecentSearchList extends StatefulWidget {
  const RecentSearchList({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function(String value) onTap;

  @override
  State<RecentSearchList> createState() => _RecentSearchListState();
}

class _RecentSearchListState extends State<RecentSearchList> {
  final searchService = SearchService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
      future: searchService.getRecentSearches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }
        final recentSearches = snapshot.data;
        if (snapshot.hasError ||
            recentSearches == null ||
            recentSearches.isEmpty) {
          return CustomErrorWidget();
        }

        return ListView.builder(
          itemCount: recentSearches.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                recentSearches[index],
              ),
              onTap: () {
                widget.onTap(recentSearches[index]);
              },
              trailing: IconButton(
                onPressed: () async {
                  await searchService.deleteRecentSearch(recentSearches[index]);
                  setState(() {});
                },
                icon: Icon(Icons.clear),
              ),
            );
          },
        );
      },
    );
  }
}

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
          return LoadingWidget();
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return CustomErrorWidget();
        }
        final List<Item> suggestions = snapshot.data ?? [];
        return Container(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestions[index].name),
                onTap: () {
                  searchService.setRecentSearch(widget.query);
                  Get.to(
                    () => ItemDetailPage(
                      item: suggestions[index],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
