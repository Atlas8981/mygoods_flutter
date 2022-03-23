import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/image.dart' as image;

class ImagesView extends StatefulWidget {
  const ImagesView({Key? key, required this.images}) : super(key: key);

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
            return ExtendedImage.network(
              images[index].imageUrl,
              fit: BoxFit.cover,
              // fadeInDuration: const Duration(milliseconds: 100),
              // fadeOutDuration: const Duration(milliseconds: 100),
              width: double.infinity,
              clearMemoryCacheIfFailed: true,
              // progressIndicatorBuilder: (context, url, progress) {
              //   if (progress.progress == null) {
              //     return Container();
              //   }
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // },
              // errorWidget: (context, url, error) => const Icon(Icons.error),
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
