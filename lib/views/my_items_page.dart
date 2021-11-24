import 'package:flutter/material.dart';

class MyItemsPage extends StatelessWidget {
  const MyItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Item(s)"),
      ),
      body: ListView(),
    );
  }
}
