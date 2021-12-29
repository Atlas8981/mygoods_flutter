import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/HomePageController.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/ViewAllPage.dart';
import 'package:mygoods_flutter/views/cells/homepage_cell.dart';

class HomePage extends StatelessWidget {
  final homePageService = HomePageService();
  final homePageController = Get.put(HomePageController());

  HomePage({Key? key}) : super(key: key);

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              child: Text("View All"),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (items.length <= 3) ? Get.width : null,
            child: Row(
              children:
                  // [
                  //   HomepageCell(items[0]),
                  // ]
                  items
                      .map((e) {
                        return HomepageCell(e);
                      })
                      .toList()
                      .cast(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                showToast("In Development");
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/images/banner1.png",
                fit: BoxFit.cover,
                height: 125,
                width: double.infinity,
              ),
              GetBuilder<HomePageController>(
                builder: (controller) {
                  if (controller.trendingItems == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<Item> trendingItems =
                      controller.trendingItems!.cast();
                  if (trendingItems.isNotEmpty) {
                    return homePageListView("Trending", items: trendingItems,
                        onTap: () {
                      showToast("In Development");
                    });
                  } else {
                    return Container();
                  }
                },
              ),
              GetBuilder<HomePageController>(
                builder: (controller) {
                  if (controller.recentViewItems == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<Item> recentViewItems =
                      controller.recentViewItems!.cast();
                  if (recentViewItems.isNotEmpty) {
                    return homePageListView("Recently View",
                        items: recentViewItems, onTap: () {
                      showToast("In Development");
                    });
                  } else {
                    return Container();
                  }
                },
              ),
              // FutureBuilder<List<Item>>(
              //   future: homePageService.getRecentViewItems(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //     final List<Item> recentItems = snapshot.data!;
              //     if (recentItems.length != 0) {
              //       return homePageListView("Recently View", items: recentItems,
              //           onTap: () {
              //         showToast("In Development");
              //       });
              //     } else {
              //       return Container();
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
