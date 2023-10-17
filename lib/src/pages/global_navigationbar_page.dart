import 'package:currencytrade_manager_backend/src/base/routers/router.dart';
import 'package:currencytrade_manager_backend/src/base/theme.dart';
import 'package:currencytrade_manager_backend/generated/l10n.dart';
import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:currencytrade_manager_backend/src/base/routers/router_path.dart'
    as route_path;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GlobalNavigationBarPage extends StatefulWidget {
  final Widget child;
  final BuildContext? shellContext;

  const GlobalNavigationBarPage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  @override
  State<StatefulWidget> createState() => GlobalNavigationBarPageState();
}

class GlobalNavigationBarPageState extends State<GlobalNavigationBarPage> {
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  late final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const ValueKey(route_path.homePage),
      icon: const Icon(FluentIcons.home),
      title: const Text("首页"),
      body: const SizedBox.shrink(),
    ),
    PaneItemHeader(header: const Text('系统设置')),
    PaneItem(
      key: const ValueKey(route_path.googleIdentityCheckPage),
      icon: const Icon(FluentIcons.verified_brand),
      title: const Text('google身份验证'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey(route_path.newsShowPage),
      icon: const Icon(FluentIcons.news),
      title: const Text('新闻公告'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey(route_path.rateSettingsPage),
      icon: const Icon(FluentIcons.rate),
      title: const Text('费率设置'),
      body: const SizedBox.shrink(),
    ),
    PaneItemHeader(header: const Text('商户管理')),
    PaneItem(
      key: const ValueKey(route_path.merchantListPage),
      icon: const Icon(FluentIcons.custom_list),
      title: const Text('商户列表'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey(route_path.merchantEntryPage),
      icon: const Icon(FluentIcons.add_multiple),
      title: const Text('商户录入'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey(route_path.merchantVerifyPage),
      icon: const Icon(FluentIcons.passive_authentication),
      title: const Text('商户审核'),
      body: const SizedBox.shrink(),
    ),
    PaneItemHeader(header: const Text('用户管理')),
    PaneItem(
      key: const ValueKey(route_path.userEntryPage),
      icon: const Icon(FluentIcons.people_add),
      title: const Text('用户录入'),
      body: const SizedBox.shrink(),
    ),
    PaneItem(
      key: const ValueKey(route_path.userListPage),
      icon: const Icon(FluentIcons.contact_list),
      title: const Text('用户列表'),
      body: const SizedBox.shrink(),
    ),
    PaneItemHeader(header: const Text('交易大厅')),
    PaneItem(
      key: const ValueKey(route_path.sellHallPage),
      icon: const Icon(FluentIcons.room),
      title: const Text('卖豆大厅'),
      body: const SizedBox.shrink(),
    ),
    // TODO: Scrollbar, RatingBar
  ].map((e) {
    if (e is PaneItem) {
      return PaneItem(
        key: e.key,
        icon: e.icon,
        title: e.title,
        body: e.body,
        onTap: () {
          final path = (e.key as ValueKey).value;
          if (!GoRouterState.of(context).uri.toString().startsWith(path)) {
            context.go(path);
          }
          e.onTap?.call();
        },
      );
    }
    return e;
  }).toList();

  late final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      key: const ValueKey(route_path.customServicePage),
      icon: const Icon(FluentIcons.settings),
      title: const Text('客服系统'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (!GoRouterState.of(context)
            .uri
            .toString()
            .startsWith(route_path.customServicePage)) {
          context.go(route_path.customServicePage);
        }
      },
    ),
    // _LinkPaneItemAction(
    //   icon: const Icon(FluentIcons.open_source),
    //   title: const Text('Source code'),
    //   link: 'https://github.com/bdlukaa/fluent_ui',
    //   body: const SizedBox.shrink(),
    // ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int indexOriginal = originalItems
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) =>
            location.startsWith((item.key as ValueKey<String>).value));
    LogUtil()
        .d("tox ===== location = $location, indexOriginal = $indexOriginal");
    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) =>
              location.startsWith((element.key as ValueKey<String>).value));
      if (indexFooter == -1) {
        return 0;
      }
      return originalItems
              .where((element) => element.key != null)
              .toList()
              .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<WebTheme>();
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }

    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        leading: createLeadingView(),
        title: createTitleView(),
        actions: createActionsView(appTheme),
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        // 重新设置侧边tab栏展开宽度
        size: const NavigationPaneSize(
            openMaxWidth: kOpenNavigationPaneWidth - 100),
        selected: _calculateSelectedIndex(context),
        header: createTabsHeaderView(appTheme),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator();
          }
        }(),
        items: originalItems,
        autoSuggestBox: Builder(builder: (context) {
          return AutoSuggestBox(
            key: searchKey,
            focusNode: searchFocusNode,
            controller: searchController,
            unfocusedColor: Colors.transparent,
            items: originalItems.whereType<PaneItem>().map((item) {
              assert(item.title is Text);
              final text = (item.title as Text).data!;
              return AutoSuggestBoxItem(
                label: text,
                value: text,
                onSelected: () {
                  item.onTap?.call();
                  searchController.clear();
                  searchFocusNode.unfocus();
                  final view = NavigationView.of(context);
                  if (view.compactOverlayOpen) {
                    // todo 跟fluent示例不一样，暂使用toggleCompactOpenMode替代，后续再看下框架是否支持了
                    // view.compactOverlayOpen = false;
                    view.toggleCompactOpenMode();
                  } else if (view.minimalPaneOpen) {
                    view.minimalPaneOpen = false;
                  }
                },
              );
            }).toList(),
            trailingIcon: IgnorePointer(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(FluentIcons.search),
              ),
            ),
            placeholder: 'Search',
          );
        }),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: searchFocusNode.requestFocus,
      transitionBuilder: (child, animation) =>
          DrillInPageTransition(animation: animation, child: child),
    );
  }

  Widget createLeadingView() {
    final enabled = widget.shellContext != null && router.canPop();

    final onPressed = enabled
        ? () {
            if (router.canPop()) {
              context.pop();
              setState(() {});
            }
          }
        : null;
    return NavigationPaneTheme(
      data: NavigationPaneTheme.of(context).merge(
        NavigationPaneThemeData(
          unselectedIconColor: ButtonState.resolveWith((states) {
            if (states.isDisabled) {
              return ButtonThemeData.buttonColor(context, states);
            }
            return ButtonThemeData.uncheckedInputColor(
              FluentTheme.of(context),
              states,
            ).basedOnLuminance();
          }),
        ),
      ),
      child: Builder(
        builder: (context) {
          return PaneItem(
            icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
            title: Text("返回"),
            body: const SizedBox.shrink(),
            enabled: enabled,
          ).build(
            context,
            false,
            onPressed,
            displayMode: PaneDisplayMode.compact,
          );
        },
      ),
    );
  }

  Widget createTitleView() {
    if (kIsWeb) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(S.current.projectName),
      );
    }
    return const SizedBox.shrink();
  }

  Widget createTabsHeaderView(WebTheme appTheme) {
    final theme = FluentTheme.of(context);
    return SizedBox(
      height: kOneLineTileHeight,
      child: ShaderMask(
        shaderCallback: (rect) {
          final color = appTheme.color.defaultBrushFor(
            theme.brightness,
          );
          return LinearGradient(
            colors: [
              color,
              color,
            ],
          ).createShader(rect);
        },
        child: const FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 80.0,
          textColor: Colors.white,
          duration: Duration.zero,
        ),
      ),
    );
  }

  Widget createActionsView(WebTheme appTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: ToggleSwitch(
              content: const Text('深色模式'),
              checked: FluentTheme.of(context).brightness.isDark,
              onChanged: (v) {
                if (v) {
                  appTheme.mode = ThemeMode.dark;
                } else {
                  appTheme.mode = ThemeMode.light;
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
