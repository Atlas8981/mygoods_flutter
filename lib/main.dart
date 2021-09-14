import 'package:flutter/material.dart';
import 'package:mygoods_flutter/views/bottom_navigation.dart';
import 'package:mygoods_flutter/views/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Goods',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageWithBottomNavigation(),
    );
  }
}