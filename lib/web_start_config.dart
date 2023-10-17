import 'dart:convert';

import 'package:currencytrade_manager_backend/src/model/profile.dart';
import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class WebStartConfig {
  WebStartConfig._();

  static WebStartConfig? _singleton;

  factory WebStartConfig() => _singleton ??= WebStartConfig._();

  late GlobalKey<NavigatorState> globalStateKey =
      GlobalKey<NavigatorState>(debugLabel: "globalStateKey");

  late GetStorage _storage;

  // 用户配置信息（登录信息）
  Profile profile = Profile();

  // 是否为release版
  static bool get isRelease => kReleaseMode;

  Future<void> init() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await GetStorage.init();
    // 获取用户配置信息
    _storage = GetStorage();
    var profileJson = await _storage.read("profile");
    LogUtil().d("AppStartConfig GetStorage profileJson = $profileJson");
    if (profileJson != null) {
      try {
        profile = Profile.fromJson(jsonDecode(profileJson));
      } catch (e) {
        LogUtil().e(e);
      }
    } else {
      // 默认主题索引为0，代表蓝色
      profile = Profile()
        ..token = ""
        ..isLogin = false
        ..isAuthentication = false
        ..user = User();
      await saveProfile();
    }
    // 初始化其它操作
  }

  // 持久化Profile信息
  Future<void> saveProfile() async =>
      await _storage.write("profile", jsonEncode(profile.toJson()));

  void dispose() => _singleton = null;
}
