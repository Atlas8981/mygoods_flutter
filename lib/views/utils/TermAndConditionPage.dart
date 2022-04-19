import 'package:flutter/material.dart';

class TermAndConditionPage extends StatelessWidget {
  const TermAndConditionPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const Center(
        child: Text("Term And Condition Page"),
      ),
    );
  }
}
