import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/WelcomePage.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyGoods Flutter From Window @.20',
      // home: MainActivity(),
      home: WelcomePage(),
      localizationsDelegates: [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('km'),
      ],
      themeMode: ThemeMode.light,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        iconTheme: IconTheme.of(context).copyWith(
          color: Colors.black,
        ),
      ),
      darkTheme: ThemeData.dark(),
    );
  }
}
