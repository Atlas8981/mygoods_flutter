import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/image.dart' as image;
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/additional_data_service.dart';
import 'package:mygoods_flutter/services/database_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final carouselController = CarouselControllerImpl();
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1);
  int currentPage = 0;

  final firestoreService = DatabaseService();

  final Item item = Get.arguments;

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
        // enableInfiniteScroll: true,
        // reverse: false,
        // autoPlay: true,
        // autoPlayInterval: Duration(seconds: 3),
        // autoPlayAnimationDuration: Duration(milliseconds: 800),
        // autoPlayCurve: Curves.fastOutSlowIn,
        // enlargeCenterPage: true,
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
      // items: [
      //   Container(
      //       width: MediaQuery.of(context).size.width,
      //       margin: EdgeInsets.symmetric(horizontal: 5.0),
      //       decoration: BoxDecoration(
      //           color: Colors.amber
      //       ),
      //   )
      // ]
      // [1,2,3,4,5].map((i) {
      //   return Builder(
      //     builder: (BuildContext context) {
      //       return Container(
      //           width: MediaQuery.of(context).size.width,
      //           margin: EdgeInsets.symmetric(horizontal: 5.0),
      //           decoration: BoxDecoration(
      //               color: Colors.amber
      //           ),
      //           child: Text('text $i', style: TextStyle(fontSize: 16.0),)
      //       );
      //     },
      //   );
      // }).toList(),
    );
  }

  Widget additionalInfoView() {
    final hasAdditionInfo = hasAdditionalInfoList.contains(item.subCategory);
    if(!hasAdditionInfo){
      return Container();
    }
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: firestoreService.getAdditionalInfo(Get.arguments),
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

  Widget sellerInfoView() {
    return FutureBuilder<User?>(
        future: firestoreService.getItemOwner(item.userid),
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
          final User user = snapshot.data!;
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
                        CachedNetworkImageProvider("${user.image.imageUrl}"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${user.username}",
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
    print("Saving item...");
    firestoreService
        .saveItem("$userId", item.itemid)
        .then((value) {
      setState(() {
        isSaved = true;
      });
    });
  }

  void unSaveItem() {
    print("Unsaving item...");
    firestoreService
        .unsaveItem("$userId", item.itemid)
        .then((value) {
      setState(() {
        isSaved = false;
      });
    });
  }

  final String userId = "0mBKC9q7RTZmEdGxp2QqwOm2eRf2";

  Widget bottomTwoButtons() {
    return Container(
      // color: Colors.red,
      // width: double.infinity,
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
                  style: TextStyle(fontSize: 16),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FutureBuilder<bool>(
              future: firestoreService.checkSaveItem(
                  "$userId", item.itemid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return OutlinedButton(onPressed: () {}, child: Text("SAVE"));
                }
                isSaved = snapshot.data!;
                print("Future Builder $isSaved");
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
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail: ${item.itemid}"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,

          // color: Colors.grey,
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
                        dotsCount: 2,
                        position: currentPage.toDouble(),
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
