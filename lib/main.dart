import 'package:animations/animations.dart';
import 'package:currencytrade_manager_backend/src/base/routers/router.dart';
import 'package:currencytrade_manager_backend/src/base/theme.dart';
import 'package:currencytrade_manager_backend/src/constant/colors.dart';
import 'package:currencytrade_manager_backend/web_start_config.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:currencytrade_manager_backend/generated/l10n.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

final rootNavKey = GlobalKey<NavigatorState>();

void main() async {
  WebStartConfig().init().then((value) => runApp(const MyApp()));
}

final _appTheme = WebTheme();

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  final sharedZAxisTransitionBuilder = const SharedAxisPageTransitionsBuilder(
    fillColor: AppColors.primaryBackground,
    transitionType: SharedAxisTransitionType.scaled,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _appTheme,
      builder: (context, child) {
        final appTheme = context.watch<WebTheme>();
        return FluentApp.router(
          onGenerateTitle: (context) => S.current.projectName,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          darkTheme: FluentThemeData(
            // typography: WebTheme.textTheme,
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            scaffoldBackgroundColor: Colors.grey[10],
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}
