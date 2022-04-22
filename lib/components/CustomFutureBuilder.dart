import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  CustomFutureBuilder({
    Key? key,
    required this.future,
    this.onLoading,
    this.onError,
    required this.onDataRetrieved,
  }) : super(key: key);
  final Future<T> future;
  final Widget? onLoading;
  final Widget? onError;
  final Widget Function(BuildContext context, T result) onDataRetrieved;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onError ??
              const CustomErrorWidget(
                text: "An error has occurred!",
              );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            return onDataRetrieved(context, snapshot.data!);
          }

          return Text("errorOccurred".tr);
        } else {
          return onLoading ?? LoadingWidget();
        }
      },
    );
  }
}
