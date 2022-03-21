

import 'package:flutter/material.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({Key? key}) : super(key: key);

  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {

  static final languages = [
    "English",
    "ខ្មែរ"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Language"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(languages[index]),
              onTap: (){

              },
            );
          },
      ),
    );
  }
}
