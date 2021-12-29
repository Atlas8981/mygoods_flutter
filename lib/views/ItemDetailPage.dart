import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/components/ImageViews.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/utils/constant.dart';

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
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  final itemService = ItemService();
  final userService = UserService();

  late final Item item = widget.item;

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
        if (snapshot.hasData) {
          final data = snapshot.data!.data();
          if (data == null) {
            return Container();
          }
          String additionalInfoText = "";
          final AdditionalInfo additionalInfo =
              additionalInfoFromFirestore(data);

          additionalInfoText = "Condition: ${additionalInfo.condition}";
          additionalInfoText =
              additionalInfoText + "${processAdditionalInfo(additionalInfo)}";
          // print(additionalInfo.toString());

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(additionalInfoText)
              ]);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget sellerInfoView() {
    return FutureBuilder<myUser.User?>(
        future: itemService.getItemOwner(item.userid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text("Something went wrong"),
            );
          }
          final myUser.User user = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About this seller",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage:
                        CachedNetworkImageProvider(user.image!.imageUrl),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    user.username,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text("Tel: ${user.phoneNumber}"),
              SizedBox(
                height: 5,
              ),
              Text("Address: ${user.address}")
            ],
          );
        });
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

  Widget bottomTwoButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "View Seller Profile".toUpperCase(),
                  style: TextStyle(fontSize: 16, letterSpacing: 1.5),
                )),
          ),
          SizedBox(
            height: 10,
          ),
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
                        onPressed: () {}, child: Text("SAVE"));
                  }
                  isSaved = snapshot.data!;
                  // print("Future Builder $isSaved");
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.5, color: Colors.blue),
                    ),
                    onPressed: onClickSaveItemButton,
                    child: Text(
                      (isSaved) ? "Saved".toUpperCase() : "Save".toUpperCase(),
                      style: TextStyle(
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
        title: Text("Item Detail"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ImagesView(images: item.images),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  margin: EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "USD: ${item.price.toString()}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Item Detail",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Views ${item.views}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Divider(
                        height: 20,
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        item.description,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Divider(
                        height: 20,
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      additionalInfoView(),
                      Divider(
                        height: 20,
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      sellerInfoView(),
                      bottomTwoButtons(),
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
