import 'package:avatars/avatars.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/cells/ListItemRow.dart';

import 'utils/ImageViewerPage.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({
    Key? key,
    required this.seller,
  }) : super(key: key);
  final User seller;

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              sellerProfile(),
              const SizedBox(height: 8),
              sellerItems(),
            ],
          ),
        ),
      ),
    );
  }

  final itemService = ItemService();

  Widget sellerItems() {
    return FutureBuilder<List<Item>?>(
      future: itemService.getSellerItems(widget.seller.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const CustomErrorWidget(
            text: "No Data",
          );
        }

        final items = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1.5,
            );
          },
          itemBuilder: (context, index) {
            return ListItemRow(
              item: items[index],
            );
          },
        );
      },
    );
  }

  Widget sellerProfile() {
    final seller = widget.seller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 40,
        ),
        sellerImage(seller),
        const SizedBox(height: 10),
        Text(
          "${seller.firstname} ${seller.lastname}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(seller.address),
        const SizedBox(
          height: 10,
        ),
        Text(seller.phoneNumber),
      ],
    );
  }

  Widget sellerImage(User seller) {
    if (seller.image != null && seller.image?.imageUrl != null) {
      final tag = "${seller.image?.imageUrl} ${DateTime.now()}";
      return InkWell(
        onTap: () {
          Get.to(
            () => ImageViewerPage(
              image: seller.image?.imageUrl,
              tag: tag,
            ),
          );
        },
        child: Hero(
          tag: tag,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 65,
            backgroundImage: ExtendedNetworkImageProvider(
              seller.image!.imageUrl,
              cache: true,
              cacheRawData: true,
            ),
          ),
        ),
      );
    } else {
      final String fullName = "${seller.firstname} ${seller.lastname}";
      return Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            child: Avatar(
              name: fullName,
              onTap: () {},
              value: fullName,
            ),
          ),
          Visibility(
            visible: seller.image!.imageName == "pending",
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }
  }

  profileVersion1() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.height),
            ),
          ],
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              top = constraints.biggest.height;
              return FlexibleSpaceBar(
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity:
                      top == MediaQuery.of(context).padding.top + kToolbarHeight
                          ? 1.0
                          : 0.0,
                  // opacity: 1.0,
                  child: const Text("Seller NAme"),
                ),
                background: Image.network(
                  "https://images.unsplash.com/photo-1542601098-3adb3baeb1ec?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5bb9a9747954cdd6eabe54e3688a407e&auto=format&fit=crop&w=500&q=60",
                  fit: BoxFit.cover,
                ),
                expandedTitleScale: 1,
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: dummyList(),
        ),
      ],
    );
  }

  profileVersion2() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.height),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.only(
              left: 65,
              bottom: 4,
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    dummyNetworkImage,
                  ),
                  radius: 26,
                ),
                SizedBox(width: 8),
                Text("Seller Name"),
              ],
            ),
            background: Image.network(
              "https://images.unsplash.com/photo-1542601098-3adb3baeb1ec?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5bb9a9747954cdd6eabe54e3688a407e&auto=format&fit=crop&w=500&q=60",
              fit: BoxFit.cover,
            ),
            expandedTitleScale: 1.5,
          ),
        ),
        SliverToBoxAdapter(
          child: dummyList(),
        ),
      ],
    );
  }

  Widget dummyList() {
    return ListView.builder(
      itemCount: 100,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Something $index"),
        );
      },
    );
  }
}
