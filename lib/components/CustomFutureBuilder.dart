import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';

class CustomFutureBuilder<T> extends StatefulWidget {
  const CustomFutureBuilder({
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
  State<CustomFutureBuilder<T>> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T> extends State<CustomFutureBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.onError ??
              CustomErrorWidget(
                text: "errorOccurred".tr,
              );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            return widget.onDataRetrieved(context, snapshot.data!);
          }

          return Text("errorOccurred".tr);
        } else {
          return widget.onLoading ?? const LoadingWidget();
        }
      },
    );
  }
}
