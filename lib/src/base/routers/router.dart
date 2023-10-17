import 'package:currencytrade_manager_backend/src/base/routers/router_path.dart'
    as route_path;
import 'package:currencytrade_manager_backend/src/pages/custom_service_page.dart';
import 'package:currencytrade_manager_backend/src/pages/global_navigationbar_page.dart';
import 'package:currencytrade_manager_backend/src/pages/google_identity_check_page.dart';
import 'package:currencytrade_manager_backend/src/pages/home_page.dart';
import 'package:currencytrade_manager_backend/src/pages/login_page.dart';
import 'package:currencytrade_manager_backend/src/pages/merchant_entry_page.dart';
import 'package:currencytrade_manager_backend/src/pages/merchant_list_page.dart';
import 'package:currencytrade_manager_backend/src/pages/merchant_verify_page.dart';
import 'package:currencytrade_manager_backend/src/pages/news_show_page.dart';
import 'package:currencytrade_manager_backend/src/pages/rate_settings_page.dart';
import 'package:currencytrade_manager_backend/src/pages/sell_hall_page.dart';
import 'package:currencytrade_manager_backend/src/pages/splash_page.dart';
import 'package:currencytrade_manager_backend/src/pages/user_entry_page.dart';
import 'package:currencytrade_manager_backend/src/pages/user_list_page.dart';
import 'package:currencytrade_manager_backend/web_start_config.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
    navigatorKey: WebStartConfig().globalStateKey,
    initialLocation: route_path.rootPage,
    observers: [],
    routes: [
      GoRoute(
        path: route_path.rootPage,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: route_path.loginPage,
        builder: (context, state) => const LoginPage(),
      ),

      /// 使用 ShellRoute 共享全局唯一导航栏
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return GlobalNavigationBarPage(
            shellContext: _shellNavigatorKey.currentContext,
            child: child,
          );
        },
        routes: [
          /// Home
          GoRoute(
              path: route_path.homePage,
              builder: (context, state) => const HomePage()),

          /// google身份验证
          GoRoute(
              path: route_path.googleIdentityCheckPage,
              builder: (context, state) => GoogleIdentityCheckPage()),

          /// 新闻公告
          GoRoute(
              path: route_path.newsShowPage,
              builder: (context, state) => NewsShowPage()),

          /// 费率设置
          GoRoute(
              path: route_path.rateSettingsPage,
              builder: (context, state) => RateSettingsPage()),

          /// 商户列表
          GoRoute(
              path: route_path.merchantListPage,
              builder: (context, state) => MerchantListPage()),

          /// 商户录入
          GoRoute(
              path: route_path.merchantEntryPage,
              builder: (context, state) => MerchantEntryPage()),

          /// 商户审核
          GoRoute(
              path: route_path.merchantVerifyPage,
              builder: (context, state) => MerchantVerifyPage()),

          /// 用户录入
          GoRoute(
              path: route_path.userEntryPage,
              builder: (context, state) => UserEntryPage()),

          /// 用户列表
          GoRoute(
            path: route_path.userListPage,
            builder: (context, state) => const UserListPage(),
            routes: [
              GoRoute(
                path: "userDetail",
                builder: (context, state) => Center(
                  child: Button(
                    child: Text("用户详情"),
                    onPressed: () => context.go("${route_path.userListPage}/userDetail/userIcon"),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: "userIcon",
                    builder: (context, state) => Center(
                      child: Text("用户头像"),
                    ),
                  )
                ],
              ),
            ],
          ),

          /// 卖豆大厅
          GoRoute(
              path: route_path.sellHallPage,
              builder: (context, state) => SellHallPage()),

          /// 客服系统
          GoRoute(
              path: route_path.customServicePage,
              builder: (context, state) => CustomServicePage()),

          /*/// /// Input
          /// Buttons
          GoRoute(
            path: '/inputs/buttons',
            builder: (context, state) => DeferredWidget(
              inputs.loadLibrary,
              () => inputs.ButtonPage(),
            ),
          ),*/
        ],
      ),
    ]);
