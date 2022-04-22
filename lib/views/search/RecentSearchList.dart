import 'package:flutter/material.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';
import 'package:mygoods_flutter/services/SearchService.dart';

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
    return Column(
      children: [
        ListTile(
          title: const Text("Recent Search"),
          trailing: TextButton(
            onPressed: () async {
              await searchService.clearRecentSearches();
              setState(() {});
            },
            child: const Text("CLEAR"),
          ),
        ),
        FutureBuilder<List<String>?>(
          future: searchService.getRecentSearches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            }

            final recentSearches = snapshot.data;
            if ((snapshot.hasError ||
                recentSearches == null ||
                recentSearches.isEmpty)) {
              return const CustomErrorWidget(
                text: "No Recent Search",
              );
            }

            return ListView.builder(
              shrinkWrap: true,
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
                      await searchService
                          .deleteRecentSearch(recentSearches[index]);
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
