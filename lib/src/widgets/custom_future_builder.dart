import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Widget child;
  final Widget? loadingWidget;
  final Future<T> future;

  const CustomFutureBuilder(
      {super.key,
      required this.child,
      this.loadingWidget,
      required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        } else {
          if (snapshot.hasError) {
            LogUtil().e("hasError = ${snapshot.stackTrace}");
            return Center(
              child: Text(
                  "发生了一些错误: \t\r${snapshot.error.toString()} \t\r错误明细：\t\r${snapshot.stackTrace.toString()}"),
            );
          }
          // 加载真实child view
          return child;
        }
      },
      future: future,
    );
  }
}
