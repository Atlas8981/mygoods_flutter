import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/item_database_service.dart';
import 'package:mygoods_flutter/models/image.dart' as image;
import 'package:mygoods_flutter/utils/constant.dart';

class OwnerItemDetailPage extends StatefulWidget {
  const OwnerItemDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  State<OwnerItemDetailPage> createState() => _OwnerItemDetailPageState();
}

class _OwnerItemDetailPageState extends State<OwnerItemDetailPage> {
  final carouselController = CarouselControllerImpl();

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  int currentPage = 0;

  final firestoreService = ItemDatabaseService();

  late final Item item;

  bool isSaved = false;

  Widget imagesViews(List<image.Image> images) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        scrollPhysics: BouncingScrollPhysics(),
        height: 300,
        // aspectRatio: 1 / 1,
        viewportFraction: 1,
        initialPage: 0,
        pageSnapping: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          setState(() {
            currentPage = index;
          });
        },
        scrollDirection: Axis.horizontal,
      ),
      carouselController: carouselController,
      itemCount: images.length,
      itemBuilder: (context, index, realIndex) {
        return CachedNetworkImage(
          imageUrl: images[index].imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 100),
          fadeOutDuration: Duration(milliseconds: 100),
          width: double.infinity,
          progressIndicatorBuilder: (context, url, progress) {
            if (progress.progress == null) {
              return Container();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      },
    );
  }

  Widget additionalInfoView() {
    final hasAdditionInfo = hasAdditionalInfoList.contains(item.subCategory);
    if (!hasAdditionInfo) {
      return Container();
    }
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: firestoreService.getAdditionalInfo(
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
                Text(additionalInfoText),
                Divider(
                  height: 20,
                  thickness: 1.5,
                  color: Colors.grey,
                ),
              ]);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  String? processAdditionalInfo(AdditionalInfo additionalInfo) {
    String processedData = "";
    if (additionalInfo.car != null) {
      final Car tempCar = additionalInfo.car!;
      processedData = processedData +
          "\n\n" +
          "Car Brand : " +
          tempCar.brand +
          "\nCar Model : " +
          tempCar.model +
          "\nCar Type : " +
          tempCar.category +
          "\nCar Year : " +
          tempCar.year;
    }
    if (additionalInfo.phone != null) {
      final Phone tempPhone = additionalInfo.phone!;
      processedData = processedData +
          "\n\n" +
          "Phone Brand : " +
          tempPhone.phoneBrand +
          "\nPhone Model : " +
          tempPhone.phoneModel;
    }
    if (additionalInfo.motoType != null) {
      processedData = processedData + "\n\n${additionalInfo.motoType}";
    }
    if (additionalInfo.computerParts != null) {
      processedData = processedData + "\n\n${additionalInfo.computerParts}";
    }
    if (additionalInfo.bikeType != null) {
      processedData = processedData + "\n\n${additionalInfo.bikeType}";
    }
    return processedData;
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail: ${item.itemid}"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    imagesViews(item.images),
                    Positioned(
                      bottom: 10,
                      child: DotsIndicator(
                        dotsCount: item.images.length,
                        position: currentPage.toDouble(),
                        onTap: (position) {
                          carouselController.animateToPage(position.toInt());
                        },
                      ),
                    )
                  ],
                ),
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
                        "${item.description}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Divider(
                        height: 20,
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      additionalInfoView(),
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

// enum OwnerItemMenu{
//   E
// }
