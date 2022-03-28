import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mygoods_flutter/controllers/initial_binding.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/utils/SettingPage.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  FirebaseChatCore.instance.setConfig(
    FirebaseChatCoreConfig(
      Firebase.app().name, //AppName
      "rooms", //roomCollectionName
      "chatUsers", //userCollection
    ),
  );
  runApp(MyGoods());
}

class MyGoods extends StatelessWidget {
  const MyGoods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    return GetMaterialApp(
      title: 'MyGoods Flutter From Window @.20',
      home: const MainActivity(),
      initialBinding: InitialBinding(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('km'),
      ],
      defaultTransition: Transition.cupertino,
      themeMode: determineThemeMode(storage.read("themeMode")),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade600,
        ),
        primaryColor: Colors.blue,
        iconTheme: IconTheme.of(context).copyWith(
          color: Colors.white,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedIconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        iconTheme: IconTheme.of(context).copyWith(
          color: Colors.black,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
            ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}
