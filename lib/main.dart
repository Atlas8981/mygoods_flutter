import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Goods',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageWithBottomNavigation(),
    );
  }
}