import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail"),
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
                CarouselSlider.builder(
                  options: CarouselOptions(
                    scrollPhysics: BouncingScrollPhysics(),
                    // height: 400,
                    // aspectRatio: 9/16,
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
                    onPageChanged: (index, reason) {},
                    scrollDirection: Axis.horizontal,
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.amber),
                        child: Text(
                          'text $index',
                          style: TextStyle(fontSize: 16.0),
                        ));
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
