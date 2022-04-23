import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mygoods_flutter/services/LocalizationSerivce.dart';
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
  String selectedLanguage = LocalizationService().getCurrentLang();

  @override
  Widget build(BuildContext context) {
    selectedThemeMode = storage.read("themeMode") ?? "System";

    return Scaffold(
      appBar: AppBar(
        title: Text("setting".tr),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              themeSetting(),
              languageSetting(),
            ],
          ),
        ),
      ),
    );
  }

  Widget languageSetting() {
    return ListTile(
      title: Text("language".tr),
      trailing: DropdownButton(
        isDense: true,
        value: selectedLanguage,
        underline: Container(),
        hint: Text(selectedLanguage),
        items: LocalizationService.langs.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: ClipRRect(
                    child: Image.asset(
                      (value == "English")
                          ? "assets/images/english_flag.jpg"
                          : "assets/images/khmer_flag.jpg",
                      width: 25,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedLanguage = value.toString();
          LocalizationService().changeLocale(value.toString());
        },
      ),
    );
  }

  Widget themeSetting() {
    return ListTile(
      title: Text("theme".tr),
      trailing: DropdownButton(
        isDense: true,
        underline: Container(),
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
                  value.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          final selectMode = value.toString();
          storage.write("themeMode", selectMode);
          Get.changeThemeMode(determineThemeMode(selectMode));
          setState(() {
            selectedThemeMode = selectMode;
          });
        },
      ),
    );
  }
}

enum AppThemMode {
  light,
  dark,
  system,
}
