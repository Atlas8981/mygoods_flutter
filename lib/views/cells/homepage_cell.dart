

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/product.dart';

class HomepageCell extends StatelessWidget {

  const HomepageCell(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      // height: 50,
      color: Colors.amber,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Image.network(
              product.image,
              width: double.infinity,
              height: 85,
              fit: BoxFit.cover,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Text("${product.title}",))
          ],
        ),
      )
    );
  }
}
