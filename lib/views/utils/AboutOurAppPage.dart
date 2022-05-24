import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutOurAppPage extends StatelessWidget {
  const AboutOurAppPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final packageInfo = snapshot.data!;
            final String version = packageInfo.version;
            // final String appName = packageInfo.appName;
            // final String packageName = packageInfo.packageName;
            // final String buildNumber = packageInfo.buildNumber;

            return Center(
              child: Text(
                "${"version".tr}: ${formatLocaleNumber(version)}",
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
