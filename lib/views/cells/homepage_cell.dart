

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/product.dart';

class HomepageCell extends StatelessWidget {

  const HomepageCell(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150,
      child: Card(
        child: InkWell(
          onTap: () => {},
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Image.network(
                product.image,
                width: 125,
                height: 125,
                fit: BoxFit.cover,
              ),
              Text("${product.title}"),
              Text("USD ${product.price}"),
            ],
          ),
        ),
      ),
    );
    // return Card(
    //   child: Column(
    //     // mainAxisSize: MainAxisSize.max,
    //     children: [
    //       SizedBox(
    //         child: Image.network(
    //           product.image,
    //           width: 125,
    //           height: 125,
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //       Text("${product.title}",),
    //       Text("USD \$ ${product.price}",),
    //       // Text("USD \$ ${product.price}",),
    //
    //     ],
    //   ),
    // );
  }
}
