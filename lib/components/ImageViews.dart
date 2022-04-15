import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/image.dart' as image;
import 'package:mygoods_flutter/views/utils/ImageViewerPage.dart';

class ImagesView extends StatefulWidget {
  const ImagesView({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<image.Image> images;

  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  final carouselController = CarouselControllerImpl();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final List<image.Image> images = widget.images;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            height: 300,
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
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => ImageViewerPage(
                    image: images[index].imageUrl,
                    tag: "",
                  ),
                );
              },
              child: ExtendedImage.network(
                images[index].imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                clearMemoryCacheIfFailed: true,
                handleLoadingProgress: true,
                enableLoadState: true,
              ),
            );
          },
        ),
        Positioned(
          bottom: 10,
          child: DotsIndicator(
            dotsCount: images.length,
            position: currentPage.toDouble(),
            onTap: (position) {
              carouselController.animateToPage(position.toInt());
            },
          ),
        )
      ],
    );
  }
}
