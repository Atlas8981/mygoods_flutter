import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final appThemModeValues = [
    "Light",
    "Dark",
    "System",
  ];
  String selectedThemeMode = "System";
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    selectedThemeMode = storage.read("themeMode") ?? "System";
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                title: Text("Theme"),
                trailing: DropdownButton(
                  isDense: true,
                  value: selectedThemeMode,
                  hint: Text(selectedThemeMode),
                  items: appThemModeValues.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            value,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final selectMode = value.toString();
                    storage.write("themeMode", selectMode);
                    Get.changeThemeMode(determineThemeMode(selectMode));
                    print(storage.read("themeMode"));
                    setState(() {
                      selectedThemeMode = selectMode;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum AppThemMode {
  light,
  dark,
  system,
}
