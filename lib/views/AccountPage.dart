
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Acccount"),),
      body: SafeArea(
        child: Container(
          child: Center(child: Text("Account Page")),
        ),
      ),
    );
  }
}