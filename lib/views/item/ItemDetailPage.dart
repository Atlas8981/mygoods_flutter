import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/ImageViews.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/SellerProfilePage.dart';
import 'package:mygoods_flutter/views/utils/ImageViewerPage.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );

  final itemService = ItemService();
  final userService = UserService();

  late final item = widget.item;

  bool isSaved = false;

  Widget additionalInfoView() {
    final hasAdditionInfo = hasAdditionalInfoList.contains(item.subCategory);
    if (!hasAdditionInfo) {
      return Container();
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: itemService.getAdditionalInfo(
          itemId: item.itemid, subCat: item.subCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data();
          if (data == null) {
            return const Center(
              child: Text("Data is null"),
            );
          }
          String additionalInfoText = "";
          final AdditionalInfo additionalInfo =
              additionalInfoFromFirestore(data);

          additionalInfoText = "Condition: ${additionalInfo.condition}";
          additionalInfoText =
              additionalInfoText + "${processAdditionalInfo(additionalInfo)}";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Additional Information",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(additionalInfoText),
              const Divider(
                height: 20,
                thickness: 1.5,
                color: Colors.grey,
              ),
            ],
          );
        }

        return const Center(
          child: Text("No Data"),
        );
      },
    );
  }

  Widget sellerInfoView() {
    return FutureBuilder<myUser.User?>(
      future: itemService.getItemOwner(item.userid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text("No Data"),
          );
        }
        final myUser.User user = snapshot.data!;
        final tag = "${user.image!.imageUrl} ${DateTime.now()}";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About this seller",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => ImageViewerPage(
                        image: user.image!.imageUrl,
                        tag: tag,
                      ),
                    );
                  },
                  child: Hero(
                    tag: tag,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: ExtendedNetworkImageProvider(
                        user.image!.imageUrl,
                        cache: true,
                        cacheRawData: true,
                        scale: 1 / 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  user.username,
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Tel: ${user.phoneNumber}"),
            const SizedBox(height: 5),
            Text("Address: ${user.address}"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  onViewSellerProfile(user);
                },
                child: Text(
                  "View Seller Profile".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget saveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Visibility(
            visible: (FirebaseAuth.instance.currentUser != null),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FutureBuilder<bool>(
                future: userService.checkSaveItem(item.itemid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return OutlinedButton(
                      onPressed: () {},
                      child: const Text("SAVE"),
                    );
                  }
                  isSaved = snapshot.data!;
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 1.5,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: onClickSaveItemButton,
                    child: Text(
                      (isSaved) ? "Saved".toUpperCase() : "Save".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onViewSellerProfile(myUser.User seller) {
    Get.to(
      () => SellerProfilePage(
        seller: seller,
      ),
    );
  }

  void onClickSaveItemButton() {
    if (isSaved) {
      unSaveItem();
    } else {
      savedItem();
    }
  }

  void savedItem() {
    userService.saveItem(item.itemid).then((value) {
      setState(() {
        isSaved = true;
      });
    });
  }

  void unSaveItem() {
    userService.unsaveItem(item.itemid).then((value) {
      setState(() {
        isSaved = false;
      });
    });
  }

  void addView() {
    itemService.addViewToItem(item.itemid, item.viewers);
  }

  void addRecentView() {
    userService.addToRecentView(item.itemid);
  }

  @override
  void initState() {
    super.initState();
    addRecentView();
    addView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Detail"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImagesView(images: item.images),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "USD: ${item.price.toString()}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Item Detail",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Views: ${item.viewers.length}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      additionalInfoView(),
                      sellerInfoView(),
                      saveButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
