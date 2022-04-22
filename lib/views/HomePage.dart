import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/HomePageController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/item/ViewAllPage.dart';
import 'package:mygoods_flutter/views/cells/HomePageCell.dart';
import 'package:mygoods_flutter/views/search/ItemSearchDelegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homePageService = HomePageService();

  final homePageController = Get.put(HomePageController());
  final functions = FirebaseFunctions.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home".tr),
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: () {
                callCloudFunction();
              },
              icon: const Icon(Icons.send),
            ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ItemSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.asset(
                  "assets/images/banner1.png",
                  fit: BoxFit.cover,
                  height: 125,
                  width: double.infinity,
                ),
              ),
              if (!kDebugMode)
                GetBuilder<HomePageController>(
                  builder: (controller) {
                    if (controller.trendingItems == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<Item> trendingItems =
                        controller.trendingItems!.cast();
                    if (trendingItems.isNotEmpty) {
                      return homePageListView(
                        "trending".tr,
                        items: trendingItems,
                        onTap: () {
                          showToast("In Development");
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              // if (!kDebugMode)
              GetBuilder<HomePageController>(
                builder: (controller) {
                  if (controller.recentViewItems == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<Item> recentViewItems =
                      controller.recentViewItems!.cast();
                  if (recentViewItems.isNotEmpty) {
                    return homePageListView(
                      "recentlyView".tr,
                      items: recentViewItems,
                      onTap: () {
                        showToast("In Development");
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> callCloudFunction() async {
    final HttpsCallable callable =
        functions.httpsCallable('sendHttpCallablePushNotification');
    try {
      final results = await callable();
      if (kDebugMode) {
        print(results);
      }
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print(e.message);
        print(e.code);
      }
    }
  }

  Widget homePageListView(
    String title, {
    required Function() onTap,
    required List<Item> items,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(
                  () => ViewAllPage(
                    title: title,
                    smallListItem: items,
                  ),
                );
              },
              child: Text("more".tr),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (items.length <= 3) ? Get.width : null,
            child: Row(
              children: items
                  .map((Item i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: HomePageCell(
                        item: i,
                        destination: ItemDetailPage(item: i),
                      ),
                    );
                  })
                  .toList()
                  .cast(),
            ),
          ),
        ),
      ],
    );
  }
}
