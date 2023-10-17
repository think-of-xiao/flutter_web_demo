import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:currencytrade_manager_backend/src/widgets/custom_future_builder.dart';
import 'package:currencytrade_manager_backend/src/base/routers/router_path.dart'
    as router_path;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  late Future<void> _initApp;

  @override
  void initState() {
    super.initState();
    _initApp = Future.delayed(
      const Duration(seconds: 2),
      () => Future.value("init ok"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: CustomFutureBuilder(
        future: _initApp,
        child: Center(
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: FloatingActionButton.extended(
              onPressed: () {
                context.go(router_path.loginPage);
              },
              label: Text("点击进入管理后台"),
            ),
          ),
        ),
      ),
    );
  }
}
