import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImagesViewerPage extends StatefulWidget {
  const ImagesViewerPage({
    Key? key,
    required this.images,
    required this.selectedIndex,
  }) : super(key: key);

  final List<dynamic> images;
  final int selectedIndex;

  @override
  State<ImagesViewerPage> createState() => _ImagesViewerPageState();
}

class _ImagesViewerPageState extends State<ImagesViewerPage> {
  final carouselController = CarouselControllerImpl();
  late int currentPage = widget.selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      resetPageDuration: const Duration(milliseconds: 100),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: ExtendedImageSlidePageHandler(
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    height: double.maxFinite,
                    viewportFraction: 1,
                    initialPage: widget.selectedIndex,
                    pageSnapping: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                  items: [
                    ...widget.images.map((e) {
                      if (e is File) {
                        return ExtendedImage.file(
                          e,
                          mode: ExtendedImageMode.gesture,
                          scale: 0.1,
                          enableMemoryCache: true,
                          cacheRawData: true,
                          enableSlideOutPage: true,
                        );
                      } else {
                        return ExtendedImage.network(
                          e,
                          mode: ExtendedImageMode.gesture,
                          scale: 0.1,
                          enableMemoryCache: true,
                          cache: true,
                          enableSlideOutPage: true,
                        );
                      }
                    }).toList(),
                  ],
                ),
                Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 16),
                  child: Positioned(
                    bottom: 10,
                    child: DotsIndicator(
                      dotsCount: widget.images.length,
                      position: currentPage.toDouble(),
                      decorator: DotsDecorator(
                        activeColor: Colors.blue,
                      ),
                      onTap: (position) {
                        carouselController.animateToPage(position.toInt());
                      },
                    ),
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
