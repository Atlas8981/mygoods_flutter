import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.blue,
      centered: true,
      splash: Image.asset(
        "${imageDir}appicon.png",
        height: 150,
      ),
      nextScreen: MainActivity(),
      splashTransition: SplashTransition.slideTransition,
      animationDuration: Duration(seconds: 1),
      duration: 1500,
    );
  }
}
